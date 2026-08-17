import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// OnScreenKeyboard — Win11-style in-app touch keyboard (1.70).
//
//   OnScreenKeyboard { }
//   // Host in CatalogPage.footer / Overlay / shell footer so keys stay docked.
//
//   // --- API ---
//   // engine.backend  "builtin" (en-US). Keyman Core (.kmx) is 1.71+.
//   // engine.commitText / backspace / enterKey
//
// @notes
//   Experimental. MIT Keyman Core is the layout engine for 1.71+; 1.70 injects
//   via KeyboardEngine (not Qt Virtual Keyboard / QT_IM_MODULE). Recipe:
//   docs/on-screen-keyboard.md. Keys use MouseArea (no focus steal).

T.Control {
    id: root

    property bool symbolsMode: false
    property bool shiftLatched: false
    property bool capsLock: false
    readonly property alias engine: engine

    implicitWidth: 640
    implicitHeight: column.implicitHeight + Theme.dp(16)
    padding: Theme.dp(8)
    focusPolicy: Qt.NoFocus
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("On-screen keyboard")
    Accessible.description: qsTr("Win11-style touch keyboard")

    KeyboardEngine {
        id: engine
    }

    readonly property real keyGap: Theme.dp(6)
    readonly property real keyH: Math.max(Theme.dp(44), Theme.controlHeight)
    readonly property real letterW: {
        const n = 10
        const inner = Math.max(0, availableWidth - Theme.dp(16))
        return Math.floor((inner - keyGap * (n - 1)) / n)
    }

    function displayLetter(ch) {
        const upper = capsLock || shiftLatched
        return upper ? ch.toUpperCase() : ch
    }

    function tapLetter(ch) {
        engine.commitText(displayLetter(ch))
        if (shiftLatched && !capsLock)
            shiftLatched = false
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
            text: engine.hasTarget
                  ? qsTr("en-US · %1").arg(engine.backend)
                  : qsTr("Tap a text field, then type here · %1").arg(engine.backend)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            horizontalAlignment: Text.AlignHCenter
            Accessible.ignored: true
        }

        Repeater {
            model: root.symbolsMode ? root.symbolRows : root.letterRows
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
                        label: {
                            const k = modelData
                            if (k.kind === "letter")
                                return root.displayLetter(k.ch)
                            if (k.kind === "shift")
                                return root.capsLock ? qsTr("caps") : qsTr("shift")
                            return k.label
                        }
                        accent: (modelData.kind === "shift" && (root.shiftLatched || root.capsLock))
                                || (modelData.kind === "symbols" && root.symbolsMode)
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

        Text {
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
        Accessible.name: cap.label.length ? cap.label : qsTr("Key")
        Accessible.onPressAction: cap.tapped()
    }

    readonly property var letterRows: [
        [
            { kind: "letter", ch: "q" }, { kind: "letter", ch: "w" }, { kind: "letter", ch: "e" },
            { kind: "letter", ch: "r" }, { kind: "letter", ch: "t" }, { kind: "letter", ch: "y" },
            { kind: "letter", ch: "u" }, { kind: "letter", ch: "i" }, { kind: "letter", ch: "o" },
            { kind: "letter", ch: "p" }
        ],
        [
            { kind: "letter", ch: "a" }, { kind: "letter", ch: "s" }, { kind: "letter", ch: "d" },
            { kind: "letter", ch: "f" }, { kind: "letter", ch: "g" }, { kind: "letter", ch: "h" },
            { kind: "letter", ch: "j" }, { kind: "letter", ch: "k" }, { kind: "letter", ch: "l" }
        ],
        [
            { kind: "shift", label: qsTr("shift"), w: 1.4 },
            { kind: "letter", ch: "z" }, { kind: "letter", ch: "x" }, { kind: "letter", ch: "c" },
            { kind: "letter", ch: "v" }, { kind: "letter", ch: "b" }, { kind: "letter", ch: "n" },
            { kind: "letter", ch: "m" },
            { kind: "backspace", label: qsTr("back"), w: 1.4 }
        ],
        [
            { kind: "symbols", label: "&123", w: 1.4 },
            { kind: "char", ch: ",", label: "," },
            { kind: "space", label: qsTr("space"), w: 4.4 },
            { kind: "char", ch: ".", label: "." },
            { kind: "enter", label: qsTr("enter"), w: 1.6 }
        ]
    ]

    readonly property var symbolRows: [
        [
            { kind: "char", ch: "1", label: "1" }, { kind: "char", ch: "2", label: "2" },
            { kind: "char", ch: "3", label: "3" }, { kind: "char", ch: "4", label: "4" },
            { kind: "char", ch: "5", label: "5" }, { kind: "char", ch: "6", label: "6" },
            { kind: "char", ch: "7", label: "7" }, { kind: "char", ch: "8", label: "8" },
            { kind: "char", ch: "9", label: "9" }, { kind: "char", ch: "0", label: "0" }
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
            { kind: "symbols", label: qsTr("abc"), w: 1.4 },
            { kind: "char", ch: ",", label: "," },
            { kind: "space", label: qsTr("space"), w: 4.4 },
            { kind: "char", ch: ".", label: "." },
            { kind: "enter", label: qsTr("enter"), w: 1.6 }
        ]
    ]

    function handleKey(k) {
        switch (k.kind) {
        case "letter":
            tapLetter(k.ch)
            break
        case "char":
            engine.commitText(k.ch)
            break
        case "space":
            engine.commitText(" ")
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
