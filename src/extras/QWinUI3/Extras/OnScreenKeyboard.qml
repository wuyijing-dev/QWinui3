import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// OnScreenKeyboard — Win11 touch-keyboard chrome + layouts (1.80).
//
//   OnScreenKeyboard { }
//   // Host in CatalogPage.footer / Overlay / shell footer so keys stay docked.
//
//   // --- API ---
//   // engine.backend  "pinyin" | "romaji" | "hangul" | "keyman" | "builtin"
//   // engine.hardwareInput  physical keys in this app → same engine (default on)
//   // engine.layoutId / cycleLayout / processVk
//   // langBadge  short IME chip (英 / 中 / あ / 한 / …)
//   // closeRequested / settingsRequested
//
// @notes
//   Experimental. Matches Windows 11 default touch layout (Esc/Tab/dual Shift,
//   &123 · Ctrl · Win · Alt · lang · Space · mic · arrows; top-row number hints).
//   App-scoped hardware input (not OS-wide). SIL Keyman Core (MIT) for named .kmx;
//   zh/ja/ko in-app IME. Not Qt Virtual Keyboard. Keys use MouseArea (no focus steal).

T.Control {
    id: root

    property bool symbolsMode: false
    property bool emojiMode: false
    property bool shiftLatched: false
    property bool capsLock: false
    property bool showChrome: true
    readonly property alias engine: engine
    property alias layoutId: engine.layoutId
    property alias hardwareInput: engine.hardwareInput

    signal closeRequested()
    signal settingsRequested()

    implicitWidth: 720
    implicitHeight: column.implicitHeight + Theme.dp(12)
    padding: Theme.dp(10)
    focusPolicy: Qt.NoFocus
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("On-screen keyboard")
    Accessible.description: qsTr("Win11-style touch keyboard. Language %1. Backend %2.")
        .arg(engine.layoutLabel).arg(engine.backend)

    KeyboardEngine {
        id: engine
    }

    readonly property bool shiftOn: capsLock || shiftLatched
    readonly property real keyGap: Theme.dp(5)
    readonly property real keyH: Math.max(Theme.dp(46), Theme.controlHeight)
    readonly property bool letterShift: engine.korean ? root.shiftLatched : root.shiftOn

    // Short Win11-style language chip on the bottom row.
    readonly property string langBadge: {
        const id = engine.layoutId
        if (id === "zh-Hans")
            return "中"
        if (id === "ja-JP")
            return "あ"
        if (id === "ko-KR")
            return "한"
        if (id === "ar")
            return "ع"
        if (id === "ru-RU")
            return "РУ"
        if (id.startsWith("en"))
            return "英"
        if (id.length >= 2)
            return id.substring(0, 2).toUpperCase()
        return "EN"
    }

    function unitWidthFor(row) {
        if (!row || !row.length)
            return root.letterWFallback
        let units = 0
        for (let i = 0; i < row.length; ++i)
            units += (row[i].w !== undefined ? row[i].w : 1.0)
        const gaps = Math.max(0, row.length - 1)
        const inner = Math.max(0, root.availableWidth)
        return Math.floor((inner - root.keyGap * gaps) / Math.max(units, 1))
    }

    readonly property real letterWFallback: {
        const n = 12
        const inner = Math.max(0, availableWidth)
        return Math.floor((inner - keyGap * (n - 1)) / n)
    }

    function keyWidth(row, k) {
        const u = unitWidthFor(row)
        const w = (k.w !== undefined ? k.w : 1.0)
        return u * w + root.keyGap * (w - 1)
    }

    function vkOf(ch) {
        return ch.toUpperCase().charCodeAt(0)
    }

    function keyLabel(vk) {
        const t = engine.previewVk(vk, root.letterShift)
        if (t && t.length)
            return t
        const c = String.fromCharCode(vk)
        return root.letterShift ? c : c.toLowerCase()
    }

    function punctLabel(k) {
        if (root.letterShift && k.shiftLabel)
            return k.shiftLabel
        return k.label
    }

    function punctChar(k) {
        if (root.letterShift && k.shiftCh)
            return k.shiftCh
        return k.ch
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

        // Win11 floating keyboard header: settings · grab · close
        Item {
            id: chrome
            width: parent.width
            height: root.showChrome ? Theme.dp(28) : 0
            visible: root.showChrome
            clip: true

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.dp(2)
                ChromeIconButton {
                    symbol: FluentIcons.Settings
                    accessibleName: qsTr("Keyboard settings")
                    onTapped: root.settingsRequested()
                }
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.dp(40)
                height: Theme.dp(4)
                radius: height / 2
                color: Theme.strokeControl
                Accessible.ignored: true
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                ChromeIconButton {
                    symbol: FluentIcons.ChromeClose
                    accessibleName: qsTr("Close keyboard")
                    onTapped: root.closeRequested()
                }
            }
        }

        // Win11 side tools: emoji · clipboard
        Row {
            visible: root.showChrome
            spacing: Theme.dp(4)
            height: visible ? Theme.dp(28) : 0
            ChromeIconButton {
                symbol: FluentIcons.Heart
                accessibleName: qsTr("Emoji")
                accent: root.emojiMode
                onTapped: {
                    root.emojiMode = !root.emojiMode
                    if (root.emojiMode)
                        root.symbolsMode = false
                }
            }
            ChromeIconButton {
                symbol: FluentIcons.Paste
                accessibleName: qsTr("Paste")
                onTapped: engine.pasteClipboard()
            }
        }

        ImeCandidateBar {
            width: parent.width
            engine: engine
        }

        Repeater {
            model: root.emojiMode ? root.emojiRows
                 : (root.symbolsMode ? root.symbolRows : root.letterRows)
            delegate: Row {
                id: keyRow
                required property var modelData
                required property int index
                spacing: root.keyGap
                width: parent.width

                Repeater {
                    model: keyRow.modelData
                    delegate: KeyCap {
                        required property var modelData
                        width: root.keyWidth(keyRow.modelData, modelData)
                        height: root.keyH
                        hint: modelData.hint ? modelData.hint : ""
                        iconSymbol: root.iconFor(modelData)
                        label: root.labelFor(modelData)
                        accent: root.accentFor(modelData)
                        muted: modelData.kind === "mic" || modelData.kind === "win"
                            || modelData.kind === "ctrl" || modelData.kind === "alt"
                        wideLabel: modelData.kind === "space"
                        onTapped: root.handleKey(modelData)
                    }
                }
            }
        }
    }

    function iconFor(k) {
        switch (k.kind) {
        case "backspace": return FluentIcons.Backspace
        case "enter": return FluentIcons.ReturnKey
        case "emoji": return FluentIcons.Emoji
        case "mic": return FluentIcons.Microphone
        case "left": return FluentIcons.ChevronLeft
        case "right": return FluentIcons.ChevronRight
        case "shift": return ""
        default: return k.icon ? k.icon : ""
        }
    }

    function labelFor(k) {
        switch (k.kind) {
        case "vk":
            return root.keyLabel(k.vk)
        case "shift":
            return root.capsLock ? qsTr("caps") : "⇧"
        case "globe":
        case "lang":
            return root.langBadge
        case "symbols":
            return root.symbolsMode ? qsTr("abc") : "&123"
        case "space":
            return ""
        case "esc":
            return "Esc"
        case "tab":
            return "Tab"
        case "ctrl":
            return "Ctrl"
        case "alt":
            return "Alt"
        case "win":
            return "⊞"
        case "backspace":
        case "enter":
        case "emoji":
        case "mic":
        case "left":
        case "right":
            return ""
        case "char":
            return root.punctLabel(k)
        default:
            return k.label ? k.label : ""
        }
    }

    function accentFor(k) {
        return (k.kind === "shift" && (root.shiftLatched || root.capsLock))
                || (k.kind === "symbols" && root.symbolsMode)
                || ((k.kind === "emoji" || k.kind === "heart") && root.emojiMode)
    }

    component ChromeIconButton: Item {
        id: cib
        property var symbol
        property string accessibleName: ""
        property bool accent: false
        signal tapped
        width: Theme.dp(28)
        height: Theme.dp(28)
        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: cibMa.containsPress ? Theme.fillControlTertiary
                 : cibMa.containsMouse ? Theme.fillControlSecondary
                 : "transparent"
        }
        FontIcon {
            anchors.centerIn: parent
            symbol: cib.symbol
            fontSize: Theme.fontBody
            iconColor: cib.accent ? Theme.fillAccent : Theme.textSecondary
        }
        MouseArea {
            id: cibMa
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
            onClicked: cib.tapped()
        }
        Accessible.role: Accessible.Button
        Accessible.name: cib.accessibleName
        Accessible.onPressAction: cib.tapped()
    }

    component KeyCap: Rectangle {
        id: cap
        property string label: ""
        property string hint: ""
        property var iconSymbol: ""
        property bool accent: false
        property bool muted: false
        property bool wideLabel: false
        signal tapped

        readonly property bool hasIcon: {
            if (typeof cap.iconSymbol === "string")
                return cap.iconSymbol.length > 0
            return cap.iconSymbol !== undefined && cap.iconSymbol !== null && cap.iconSymbol !== ""
        }

        radius: Theme.cornerControl
        opacity: muted ? 0.72 : 1
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

        Text {
            visible: cap.hint.length > 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: Theme.dp(4)
            text: cap.hint
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption - 1
            color: cap.accent ? Theme.textOnAccent : Theme.textSecondary
            Accessible.ignored: true
        }

        FontIcon {
            visible: cap.hasIcon
            anchors.centerIn: parent
            symbol: cap.iconSymbol
            fontSize: Theme.fontBody + 2
            iconColor: cap.accent ? Theme.textOnAccent : Theme.textPrimary
        }
        Text {
            visible: !cap.hasIcon
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
        Accessible.name: {
            if (cap.hint.length)
                return qsTr("%1 (hint %2)").arg(cap.label.length ? cap.label : qsTr("Key")).arg(cap.hint)
            if (cap.label.length)
                return cap.label
            return qsTr("Key")
        }
        Accessible.onPressAction: cap.tapped()
    }

    // Windows 11 default touch keyboard (letters).
    readonly property var letterRows: [
        [
            { kind: "esc", w: 1.15 },
            { kind: "vk", vk: 81, hint: "1" }, { kind: "vk", vk: 87, hint: "2" },
            { kind: "vk", vk: 69, hint: "3" }, { kind: "vk", vk: 82, hint: "4" },
            { kind: "vk", vk: 84, hint: "5" }, { kind: "vk", vk: 89, hint: "6" },
            { kind: "vk", vk: 85, hint: "7" }, { kind: "vk", vk: 73, hint: "8" },
            { kind: "vk", vk: 79, hint: "9" }, { kind: "vk", vk: 80, hint: "0" },
            { kind: "backspace", w: 1.35 }
        ],
        [
            { kind: "tab", w: 1.25 },
            { kind: "vk", vk: 65 }, { kind: "vk", vk: 83 }, { kind: "vk", vk: 68 },
            { kind: "vk", vk: 70 }, { kind: "vk", vk: 71 }, { kind: "vk", vk: 72 },
            { kind: "vk", vk: 74 }, { kind: "vk", vk: 75 }, { kind: "vk", vk: 76 },
            { kind: "char", ch: ";", shiftCh: ":", label: ";", shiftLabel: ":", w: 1.0 },
            { kind: "enter", w: 1.45 }
        ],
        [
            { kind: "shift", w: 1.45 },
            { kind: "vk", vk: 90 }, { kind: "vk", vk: 88 }, { kind: "vk", vk: 67 },
            { kind: "vk", vk: 86 }, { kind: "vk", vk: 66 }, { kind: "vk", vk: 78 },
            { kind: "vk", vk: 77 },
            { kind: "char", ch: ",", shiftCh: ";", label: ",", shiftLabel: ";" },
            { kind: "char", ch: ".", shiftCh: ":", label: ".", shiftLabel: ":" },
            { kind: "char", ch: "?", shiftCh: "!", label: "?", shiftLabel: "!" },
            { kind: "shift", w: 1.45 }
        ],
        [
            { kind: "symbols", label: "&123", w: 1.25 },
            { kind: "ctrl", w: 1.0 },
            { kind: "win", w: 1.0 },
            { kind: "alt", w: 1.0 },
            { kind: "lang", w: 1.15 },
            { kind: "space", w: 4.2 },
            { kind: "mic", w: 1.0 },
            { kind: "left", w: 1.0 },
            { kind: "right", w: 1.0 }
        ]
    ]

    readonly property var symbolRows: [
        [
            { kind: "esc", w: 1.15 },
            { kind: "vk", vk: 49 }, { kind: "vk", vk: 50 }, { kind: "vk", vk: 51 },
            { kind: "vk", vk: 52 }, { kind: "vk", vk: 53 }, { kind: "vk", vk: 54 },
            { kind: "vk", vk: 55 }, { kind: "vk", vk: 56 }, { kind: "vk", vk: 57 },
            { kind: "vk", vk: 48 },
            { kind: "backspace", w: 1.35 }
        ],
        [
            { kind: "tab", w: 1.25 },
            { kind: "char", ch: "@", label: "@" }, { kind: "char", ch: "#", label: "#" },
            { kind: "char", ch: "$", label: "$" }, { kind: "char", ch: "%", label: "%" },
            { kind: "char", ch: "&", label: "&" }, { kind: "char", ch: "-", label: "-" },
            { kind: "char", ch: "+", label: "+" }, { kind: "char", ch: "(", label: "(" },
            { kind: "char", ch: ")", label: ")" }, { kind: "char", ch: "/", label: "/" },
            { kind: "enter", w: 1.45 }
        ],
        [
            { kind: "char", ch: "*", label: "*", w: 1.2 },
            { kind: "char", ch: "\"", label: "\"" }, { kind: "char", ch: "'", label: "'" },
            { kind: "char", ch: ":", label: ":" }, { kind: "char", ch: ";", label: ";" },
            { kind: "char", ch: "!", label: "!" }, { kind: "char", ch: "?", label: "?" },
            { kind: "char", ch: "_", label: "_" }, { kind: "char", ch: "=", label: "=" },
            { kind: "backspace", w: 1.35 }
        ],
        [
            { kind: "symbols", label: qsTr("abc"), w: 1.25 },
            { kind: "ctrl", w: 1.0 },
            { kind: "win", w: 1.0 },
            { kind: "alt", w: 1.0 },
            { kind: "lang", w: 1.15 },
            { kind: "space", w: 4.2 },
            { kind: "mic", w: 1.0 },
            { kind: "left", w: 1.0 },
            { kind: "right", w: 1.0 }
        ]
    ]

    readonly property var emojiRows: [
        [
            { kind: "char", ch: "😀", label: "😀" }, { kind: "char", ch: "😁", label: "😁" },
            { kind: "char", ch: "😂", label: "😂" }, { kind: "char", ch: "🤣", label: "🤣" },
            { kind: "char", ch: "😊", label: "😊" }, { kind: "char", ch: "😍", label: "😍" },
            { kind: "char", ch: "🤩", label: "🤩" }, { kind: "char", ch: "😘", label: "😘" },
            { kind: "char", ch: "🤔", label: "🤔" }, { kind: "char", ch: "😎", label: "😎" },
            { kind: "backspace", w: 1.2 }
        ],
        [
            { kind: "char", ch: "🥳", label: "🥳" }, { kind: "char", ch: "😴", label: "😴" },
            { kind: "char", ch: "🙄", label: "🙄" }, { kind: "char", ch: "😱", label: "😱" },
            { kind: "char", ch: "😢", label: "😢" }, { kind: "char", ch: "😡", label: "😡" },
            { kind: "char", ch: "👍", label: "👍" }, { kind: "char", ch: "👎", label: "👎" },
            { kind: "char", ch: "🙏", label: "🙏" }, { kind: "char", ch: "💪", label: "💪" },
            { kind: "enter", w: 1.2 }
        ],
        [
            { kind: "char", ch: "🔥", label: "🔥" }, { kind: "char", ch: "✨", label: "✨" },
            { kind: "char", ch: "🎉", label: "🎉" }, { kind: "char", ch: "💯", label: "💯" },
            { kind: "char", ch: "✅", label: "✅" }, { kind: "char", ch: "❌", label: "❌" },
            { kind: "char", ch: "⭐", label: "⭐" }, { kind: "char", ch: "👀", label: "👀" },
            { kind: "char", ch: "❤️", label: "❤️" }, { kind: "char", ch: "🤝", label: "🤝" }
        ],
        [
            { kind: "symbols", label: qsTr("abc"), w: 1.25 },
            { kind: "ctrl", w: 1.0 },
            { kind: "win", w: 1.0 },
            { kind: "alt", w: 1.0 },
            { kind: "lang", w: 1.15 },
            { kind: "space", w: 4.2 },
            { kind: "emoji", w: 1.0 },
            { kind: "left", w: 1.0 },
            { kind: "right", w: 1.0 }
        ]
    ]

    function handleKey(k) {
        switch (k.kind) {
        case "vk":
            tapVk(k.vk)
            break
        case "char":
            engine.commitText(punctChar(k))
            if (root.shiftLatched && !root.capsLock)
                root.shiftLatched = false
            break
        case "space":
            if (engine.composing) {
                engine.confirmCompose()
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
        case "tab":
            engine.tabKey()
            break
        case "esc":
            engine.navigateKey(Qt.Key_Escape)
            break
        case "left":
            engine.navigateKey(Qt.Key_Left)
            break
        case "right":
            engine.navigateKey(Qt.Key_Right)
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
        case "lang":
            engine.cycleLayout()
            break
        case "mic":
            // Voice typing is OS-owned; in-app OSK keeps the chrome only.
            break
        case "ctrl":
        case "alt":
        case "win":
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
