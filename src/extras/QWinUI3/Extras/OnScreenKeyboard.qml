import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// OnScreenKeyboard — Win11-style in-app touch keyboard (1.76).
//
//   OnScreenKeyboard { }
//   // Host in CatalogPage.footer / Overlay / shell footer so keys stay docked.
//
//   // --- API ---
//   // engine.backend  "pinyin" | "romaji" | "hangul" | "keyman" | "builtin"
//   // engine.layoutId / cycleLayout / processVk
//
// @notes
//   Experimental. SIL Keyman Core (MIT) for named .kmx packs; zh pinyin prefix
//   phrases (MIT tables); ja romaji→kana only (no MIT kanji source); ko 2-beolsik
//   with compound peel + Space word-break. Not Qt Virtual Keyboard / QT_IM_MODULE.
//   Keys use MouseArea (no focus steal). Emoji layer has no engine.

T.Control {
    id: root

    property bool symbolsMode: false
    property bool emojiMode: false
    property bool shiftLatched: false
    property bool capsLock: false
    readonly property alias engine: engine
    property alias layoutId: engine.layoutId

    implicitWidth: 640
    implicitHeight: column.implicitHeight + Theme.dp(16)
    padding: Theme.dp(8)
    focusPolicy: Qt.NoFocus
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("On-screen keyboard")
    Accessible.description: qsTr("Win11-style touch keyboard. Language %1. Backend %2.")
        .arg(engine.layoutLabel).arg(engine.backend)

    KeyboardEngine {
        id: engine
    }

    readonly property bool shiftOn: capsLock || shiftLatched
    readonly property real keyGap: Theme.dp(6)
    readonly property real keyH: Math.max(Theme.dp(44), Theme.controlHeight)
    readonly property int letterCount: 10
    readonly property real letterW: {
        const n = letterCount
        const inner = Math.max(0, availableWidth - Theme.dp(16))
        return Math.floor((inner - keyGap * (n - 1)) / n)
    }

    function vkOf(ch) {
        return ch.toUpperCase().charCodeAt(0)
    }

    readonly property bool letterShift: engine.korean ? root.shiftLatched : root.shiftOn

    function keyLabel(vk) {
        const t = engine.previewVk(vk, root.letterShift)
        if (t && t.length)
            return t
        const c = String.fromCharCode(vk)
        return root.letterShift ? c : c.toLowerCase()
    }

    function tapVk(vk) {
        engine.processVk(vk, root.letterShift)
        if (root.shiftLatched && !root.capsLock)
            root.shiftLatched = false
    }

    function tapShift() {
        if (capsLock) {
            capsLock = false
            shiftLatched = false
            return
        }
        if (shiftLatched) {
            capsLock = true
            shiftLatched = false
            return
        }
        shiftLatched = true
    }

    background: Rectangle {
        color: Theme.bgAcrylic
        radius: Theme.cornerOverlay
        border.width: Theme.strokeHairline
        border.color: Theme.strokeCard
    }

    contentItem: Column {
        id: column
        width: root.availableWidth
        spacing: root.keyGap

        Text {
            width: parent.width
            text: qsTr("%1 · %2").arg(engine.layoutLabel).arg(engine.backend)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            horizontalAlignment: Text.AlignHCenter
            Accessible.ignored: true
        }

        ImeCandidateBar {
            width: parent.width
            engine: engine
        }

        Repeater {
            model: root.emojiMode ? root.emojiRows : (root.symbolsMode ? root.symbolRows : root.letterRows)
            delegate: Row {
                required property var modelData
                spacing: root.keyGap
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: modelData
                    delegate: KeyCap {
                        required property var modelData
                        width: modelData.w ? root.letterW * modelData.w + root.keyGap * (modelData.w - 1)
                                           : root.letterW
                        height: root.keyH
                        globe: modelData.kind === "globe"
                        emojiGlyph: modelData.kind === "emoji"
                        label: {
                            const k = modelData
                            if (k.kind === "vk")
                                return root.keyLabel(k.vk)
                            if (k.kind === "shift")
                                return root.capsLock ? qsTr("caps") : qsTr("shift")
                            if (k.kind === "globe")
                                return qsTr("lang")
                            if (k.kind === "emoji")
                                return qsTr("emoji")
                            return k.label
                        }
                        accent: (modelData.kind === "shift" && (root.shiftLatched || root.capsLock))
                                || (modelData.kind === "symbols" && root.symbolsMode)
                                || (modelData.kind === "emoji" && root.emojiMode)
                        wideLabel: modelData.kind === "space"
                        onTapped: root.handleKey(modelData)
                    }
                }
            }
        }
    }

    component KeyCap: Rectangle {
        id: cap
        property string label: ""
        property bool accent: false
        property bool wideLabel: false
        property bool globe: false
        property bool emojiGlyph: false
        signal tapped

        radius: Theme.cornerControl
        color: {
            if (accent)
                return ma.containsPress ? Theme.fillAccentTertiary
                     : ma.containsMouse ? Theme.fillAccentSecondary
                     : Theme.fillAccent
            return ma.containsPress ? Theme.fillControlTertiary
                 : ma.containsMouse ? Theme.fillControlSecondary
                 : Theme.fillControl
        }
        border.width: Theme.strokeHairline
        border.color: Theme.strokeControl
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }

        FontIcon {
            visible: cap.globe || cap.emojiGlyph
            anchors.centerIn: parent
            symbol: cap.globe ? FluentIcons.Globe : FluentIcons.Emoji
            fontSize: Theme.fontBody
            iconColor: cap.accent ? Theme.textOnAccent : Theme.textPrimary
        }
        Text {
            visible: !cap.globe && !cap.emojiGlyph
            anchors.centerIn: parent
            text: cap.label
            font.family: Theme.fontFamily
            font.pixelSize: cap.wideLabel ? Theme.fontCaption : Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: cap.accent ? Theme.textOnAccent : Theme.textPrimary
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
            onClicked: cap.tapped()
        }
        Accessible.role: Accessible.Button
            Accessible.name: cap.globe ? qsTr("Language")
                             : cap.emojiGlyph ? qsTr("Emoji")
                             : (cap.label.length ? cap.label : qsTr("Key"))
        Accessible.onPressAction: cap.tapped()
    }

    readonly property var letterRows: [
        [
            { kind: "vk", vk: 81 }, { kind: "vk", vk: 87 }, { kind: "vk", vk: 69 },
            { kind: "vk", vk: 82 }, { kind: "vk", vk: 84 }, { kind: "vk", vk: 89 },
            { kind: "vk", vk: 85 }, { kind: "vk", vk: 73 }, { kind: "vk", vk: 79 },
            { kind: "vk", vk: 80 }
        ],
        [
            { kind: "vk", vk: 65 }, { kind: "vk", vk: 83 }, { kind: "vk", vk: 68 },
            { kind: "vk", vk: 70 }, { kind: "vk", vk: 71 }, { kind: "vk", vk: 72 },
            { kind: "vk", vk: 74 }, { kind: "vk", vk: 75 }, { kind: "vk", vk: 76 }
        ],
        [
            { kind: "shift", label: qsTr("shift"), w: 1.4 },
            { kind: "vk", vk: 90 }, { kind: "vk", vk: 88 }, { kind: "vk", vk: 67 },
            { kind: "vk", vk: 86 }, { kind: "vk", vk: 66 }, { kind: "vk", vk: 78 },
            { kind: "vk", vk: 77 },
            { kind: "backspace", label: qsTr("back"), w: 1.4 }
        ],
        [
            { kind: "globe", w: 1.0 },
            { kind: "emoji", w: 1.0 },
            { kind: "symbols", label: "&123", w: 1.2 },
            { kind: "space", label: qsTr("space"), w: 4.2 },
            { kind: "char", ch: ".", label: "." },
            { kind: "enter", label: qsTr("enter"), w: 1.6 }
        ]
    ]

    readonly property var symbolRows: [
        [
            { kind: "vk", vk: 49 }, { kind: "vk", vk: 50 }, { kind: "vk", vk: 51 },
            { kind: "vk", vk: 52 }, { kind: "vk", vk: 53 }, { kind: "vk", vk: 54 },
            { kind: "vk", vk: 55 }, { kind: "vk", vk: 56 }, { kind: "vk", vk: 57 },
            { kind: "vk", vk: 48 }
        ],
        [
            { kind: "char", ch: "@", label: "@" }, { kind: "char", ch: "#", label: "#" },
            { kind: "char", ch: "$", label: "$" }, { kind: "char", ch: "%", label: "%" },
            { kind: "char", ch: "&", label: "&" }, { kind: "char", ch: "-", label: "-" },
            { kind: "char", ch: "+", label: "+" }, { kind: "char", ch: "(", label: "(" },
            { kind: "char", ch: ")", label: ")" }
        ],
        [
            { kind: "char", ch: "*", label: "*" }, { kind: "char", ch: "\"", label: "\"" },
            { kind: "char", ch: "'", label: "'" }, { kind: "char", ch: ":", label: ":" },
            { kind: "char", ch: ";", label: ";" }, { kind: "char", ch: "!", label: "!" },
            { kind: "char", ch: "?", label: "?" },
            { kind: "backspace", label: qsTr("back"), w: 1.4 }
        ],
        [
            { kind: "globe", w: 1.0 },
            { kind: "emoji", w: 1.0 },
            { kind: "symbols", label: qsTr("abc"), w: 1.2 },
            { kind: "space", label: qsTr("space"), w: 4.2 },
            { kind: "char", ch: ".", label: "." },
            { kind: "enter", label: qsTr("enter"), w: 1.6 }
        ]
    ]

    readonly property var emojiRows: [
        [
            { kind: "char", ch: "😀", label: "😀" }, { kind: "char", ch: "😁", label: "😁" },
            { kind: "char", ch: "😂", label: "😂" }, { kind: "char", ch: "🤣", label: "🤣" },
            { kind: "char", ch: "😊", label: "😊" }, { kind: "char", ch: "😍", label: "😍" },
            { kind: "char", ch: "🤩", label: "🤩" }, { kind: "char", ch: "😘", label: "😘" },
            { kind: "char", ch: "🤔", label: "🤔" }, { kind: "char", ch: "😎", label: "😎" }
        ],
        [
            { kind: "char", ch: "🥳", label: "🥳" }, { kind: "char", ch: "😴", label: "😴" },
            { kind: "char", ch: "🙄", label: "🙄" }, { kind: "char", ch: "😱", label: "😱" },
            { kind: "char", ch: "😢", label: "😢" }, { kind: "char", ch: "😡", label: "😡" },
            { kind: "char", ch: "👍", label: "👍" }, { kind: "char", ch: "👎", label: "👎" },
            { kind: "char", ch: "🙏", label: "🙏" }, { kind: "char", ch: "💪", label: "💪" }
        ],
        [
            { kind: "char", ch: "🔥", label: "🔥" }, { kind: "char", ch: "✨", label: "✨" },
            { kind: "char", ch: "🎉", label: "🎉" }, { kind: "char", ch: "💯", label: "💯" },
            { kind: "char", ch: "✅", label: "✅" }, { kind: "char", ch: "❌", label: "❌" },
            { kind: "char", ch: "⭐", label: "⭐" }, { kind: "char", ch: "👀", label: "👀" },
            { kind: "char", ch: "❤️", label: "❤️" }, { kind: "char", ch: "🤝", label: "🤝" }
        ],
        [
            { kind: "globe", w: 1.0 },
            { kind: "emoji", w: 1.0 },
            { kind: "symbols", label: qsTr("abc"), w: 1.2 },
            { kind: "space", label: qsTr("space"), w: 4.2 },
            { kind: "char", ch: ".", label: "." },
            { kind: "enter", label: qsTr("enter"), w: 1.6 }
        ]
    ]

    function handleKey(k) {
        switch (k.kind) {
        case "vk":
            tapVk(k.vk)
            break
        case "char":
            engine.commitText(k.ch)
            break
        case "space":
            if (engine.composing) {
                engine.confirmCompose()
                // Korean IME: Space commits the syllable and inserts a word break.
                if (engine.korean)
                    engine.commitText(" ")
            } else {
                engine.commitText(" ")
            }
            break
        case "backspace":
            engine.backspace()
            break
        case "enter":
            engine.enterKey()
            break
        case "shift":
            tapShift()
            break
        case "symbols":
            symbolsMode = !symbolsMode
            if (symbolsMode)
                emojiMode = false
            break
        case "emoji":
            emojiMode = !emojiMode
            if (emojiMode)
                symbolsMode = false
            break
        case "globe":
            engine.cycleLayout()
            break
        }
    }

    onWindowChanged: {
        if (Window.window)
            engine.watch(Window.window)
    }
    Component.onCompleted: {
        if (Window.window)
            engine.watch(Window.window)
    }
}
