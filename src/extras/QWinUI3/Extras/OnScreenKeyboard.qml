import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// OnScreenKeyboard — Windows 11 touch keyboard parity (1.82).
//
//   OnScreenKeyboard { }
//   OnScreenKeyboardWindow { systemWide: true }  // floating + optional desktop inject
//
//   // --- API ---
//   // keyboardSize  "default" | "small" | "wide"
//   // systemWide    Windows SendInput into focused apps (opt-in; default off)
//   // dragHostWindow  grab bar calls startSystemMove on the host Window
//   // engine.layoutId / cycleLayout / hardwareInput
//
// @notes
//   Experimental. Win11 touch behavior. Floating host: OnScreenKeyboardWindow.
//   systemWide is Windows-only; Linux stays in-app. Not Qt Virtual Keyboard.

T.Control {
    id: root

    property bool symbolsMode: false
    property bool emojiMode: false
    property bool shiftLatched: false
    property bool capsLock: false
    property bool showChrome: true
    property bool dragHostWindow: false
    // Win11 keyboard size (Settings → Typing → Touch keyboard). Not Win10 "full" classic.
    property string keyboardSize: "default" // default | small | wide
    property bool settingsOpen: false
    property bool clipboardOpen: false
    property int emojiCategory: 0
    property string statusBanner: ""

    readonly property alias engine: engine
    property alias layoutId: engine.layoutId
    property alias hardwareInput: engine.hardwareInput
    property alias systemWide: engine.systemWide
    readonly property bool supportsSystemWide: engine.supportsSystemWide

    signal closeRequested()
    signal settingsRequested()

    implicitWidth: keyboardSize === "wide" ? 880 : (keyboardSize === "small" ? 560 : 720)
    implicitHeight: column.implicitHeight + Theme.dp(12)
    padding: keyboardSize === "small" ? Theme.dp(6) : Theme.dp(10)
    focusPolicy: Qt.NoFocus
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("On-screen keyboard")
    Accessible.description: qsTr("Windows 11 touch keyboard. Language %1. Backend %2.")
        .arg(engine.layoutLabel).arg(engine.backend)

    KeyboardEngine {
        id: engine
    }

    readonly property bool shiftOn: capsLock || shiftLatched
    readonly property real keyGap: keyboardSize === "small" ? Theme.dp(4) : Theme.dp(6)
    readonly property real keyH: {
        if (keyboardSize === "small")
            return Math.max(Theme.dp(36), Theme.controlHeight - Theme.dp(8))
        if (keyboardSize === "wide")
            return Math.max(Theme.dp(52), Theme.controlHeight + Theme.dp(4))
        return Math.max(Theme.dp(48), Theme.controlHeight)
    }
    // Win11 keys are noticeably rounder than Win10 / Theme.cornerControl (4).
    readonly property real keyRadius: keyboardSize === "small" ? Theme.dp(6) : Theme.dp(8)
    readonly property bool letterShift: engine.korean ? root.shiftLatched : root.shiftOn

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

    readonly property var emojiCategoryModel: [
        {
            title: qsTr("Smileys"),
            glyphs: ["😀", "😁", "😂", "🤣", "😊", "😍", "🤩", "😘", "🤔", "😎",
                     "🥳", "😴", "🙄", "😱", "😢", "😡", "😇", "🙃", "😅", "🤯"]
        },
        {
            title: qsTr("Gestures"),
            glyphs: ["👍", "👎", "🙏", "💪", "👏", "🤝", "✌️", "🤞", "👀", "💬",
                     "👋", "🤟", "☝️", "👇", "👈", "👉", "🫡", "🫶", "💯", "✅"]
        },
        {
            title: qsTr("Symbols"),
            glyphs: ["🔥", "✨", "🎉", "⭐", "❤️", "💔", "❌", "⚠️", "📌", "📎",
                     "🎵", "💡", "🔔", "🕒", "📅", "🔒", "🔑", "💰", "🎁", "🏠"]
        }
    ]

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

    function commitHint(k) {
        if (!k || !k.hint)
            return
        engine.commitText(String(k.hint))
        if (root.shiftLatched && !root.capsLock)
            root.shiftLatched = false
    }

    function commitAlt(ch) {
        if (!ch || !ch.length)
            return
        engine.commitText(ch)
        if (root.shiftLatched && !root.capsLock)
            root.shiftLatched = false
        altPopup.close()
    }

    function flashBanner(text) {
        statusBanner = text
        bannerClear.restart()
    }

    Timer {
        id: bannerClear
        interval: 2400
        onTriggered: root.statusBanner = ""
    }

    function openAltFlyout(item, alts) {
        if (!alts || !alts.length || !item)
            return
        const win = Window.window
        const overlay = (win && win.Overlay && win.Overlay.overlay)
                        ? win.Overlay.overlay
                        : Overlay.overlay
        if (!overlay)
            return
        altPopup.alts = alts
        altPopup.parent = overlay
        const p = item.mapToItem(overlay, 0, 0)
        altPopup.x = Math.max(Theme.dp(8), Math.min(p.x + item.width / 2 - altPopup.implicitWidth / 2,
                                                    overlay.width - altPopup.implicitWidth - Theme.dp(8)))
        altPopup.y = Math.max(Theme.dp(8), p.y - altPopup.implicitHeight - Theme.dp(8))
        altPopup.open()
    }

    function altsFor(k) {
        if (!k)
            return []
        if (k.alts)
            return k.alts
        if (k.kind === "char" && k.shiftCh && k.ch !== k.shiftCh)
            return [k.ch, k.shiftCh]
        return []
    }

    background: Rectangle {
        // Win11 acrylic-ish panel (softer than Win10 solid grey dock).
        color: Theme.bgAcrylic
        radius: Theme.dp(12)
        border.width: Theme.strokeHairline
        border.color: Theme.strokeCard
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius - 1
            color: Theme.dark ? "#18FFFFFF" : "#22FFFFFF"
            Accessible.ignored: true
        }
    }

    contentItem: Column {
        id: column
        width: root.availableWidth
        spacing: root.keyGap

        Item {
            id: chrome
            width: parent.width
            height: root.showChrome ? Theme.dp(28) : 0
            visible: root.showChrome

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.dp(2)
                ChromeIconButton {
                    symbol: FluentIcons.Settings
                    accessibleName: qsTr("Keyboard settings")
                    accent: root.settingsOpen
                    onTapped: {
                        root.settingsOpen = !root.settingsOpen
                        root.clipboardOpen = false
                        root.settingsRequested()
                    }
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
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -Theme.dp(8)
                    enabled: root.dragHostWindow
                    cursorShape: Qt.SizeAllCursor
                    onPressed: {
                        if (Window.window)
                            Window.window.startSystemMove()
                    }
                }
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

        Row {
            visible: root.showChrome
            spacing: Theme.dp(4)
            height: visible ? Theme.dp(28) : 0
            ChromeIconButton {
                symbol: FluentIcons.Emoji
                accessibleName: qsTr("Emoji")
                accent: root.emojiMode
                onTapped: {
                    root.emojiMode = !root.emojiMode
                    if (root.emojiMode) {
                        root.symbolsMode = false
                        root.settingsOpen = false
                        root.clipboardOpen = false
                    }
                }
            }
            ChromeIconButton {
                symbol: FluentIcons.Paste
                accessibleName: qsTr("Clipboard")
                accent: root.clipboardOpen
                onTapped: {
                    root.clipboardOpen = !root.clipboardOpen
                    root.settingsOpen = false
                    if (root.clipboardOpen)
                        root.emojiMode = false
                }
            }
        }

        // Win11 settings sheet: size modes (not Win10 full classic keyboard).
        Rectangle {
            width: parent.width
            visible: root.settingsOpen
            height: visible ? settingsCol.implicitHeight + Theme.dp(12) : 0
            radius: root.keyRadius
            color: Theme.fillSubtle
            border.width: Theme.strokeHairline
            border.color: Theme.strokeCard
            Column {
                id: settingsCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Theme.dp(8)
                spacing: Theme.dp(6)
                Text {
                    text: qsTr("Keyboard size")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
                Row {
                    spacing: Theme.dp(6)
                    SizeChip { sizeId: "small"; label: qsTr("Small") }
                    SizeChip { sizeId: "default"; label: qsTr("Default") }
                    SizeChip { sizeId: "wide"; label: qsTr("Large") }
                }
                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("Windows 11 touch layout — not the Win10 classic full keyboard. Long-press letter hints for digits; long-press punctuation for alternatives.")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
            }
        }

        // Win11 clipboard strip (current clip — full history is OS-owned).
        Rectangle {
            width: parent.width
            visible: root.clipboardOpen
            height: visible ? clipCol.implicitHeight + Theme.dp(12) : 0
            radius: root.keyRadius
            color: Theme.fillSubtle
            border.width: Theme.strokeHairline
            border.color: Theme.strokeCard
            Column {
                id: clipCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Theme.dp(8)
                spacing: Theme.dp(6)
                Text {
                    text: qsTr("Clipboard")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
                Text {
                    width: parent.width
                    wrapMode: Text.WrapAnywhere
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    text: {
                        const t = engine.clipboardText()
                        return t.length ? t : qsTr("(empty)")
                    }
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    color: Theme.textPrimary
                }
                Row {
                    spacing: Theme.dp(6)
                    KeyCap {
                        width: Theme.dp(88)
                        height: Theme.dp(32)
                        label: qsTr("Paste")
                        onTapped: {
                            engine.pasteClipboard()
                            root.clipboardOpen = false
                        }
                    }
                    KeyCap {
                        width: Theme.dp(88)
                        height: Theme.dp(32)
                        label: qsTr("Close")
                        onTapped: root.clipboardOpen = false
                    }
                }
            }
        }

        Text {
            width: parent.width
            visible: root.statusBanner.length > 0
            text: root.statusBanner
            wrapMode: Text.WordWrap
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            horizontalAlignment: Text.AlignHCenter
        }

        ImeCandidateBar {
            width: parent.width
            engine: engine
        }

        // Emoji category chips (Win11-style tabs — not a flat Win10 grid only).
        Row {
            visible: root.emojiMode
            spacing: Theme.dp(4)
            width: parent.width
            Repeater {
                model: root.emojiCategoryModel
                delegate: SizeChip {
                    required property int index
                    required property var modelData
                    sizeId: String(index)
                    label: modelData.title
                    checkedOverride: root.emojiCategory === index
                    onPicked: root.emojiCategory = index
                }
            }
        }

        Repeater {
            model: root.emojiMode ? root.emojiGridRows
                 : (root.symbolsMode ? root.symbolRows : root.letterRows)
            delegate: Row {
                id: keyRow
                required property var modelData
                spacing: root.keyGap
                width: parent.width

                Repeater {
                    model: keyRow.modelData
                    delegate: KeyCap {
                        id: keyDelegate
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
                        onLongPressed: {
                            if (modelData.hint) {
                                root.commitHint(modelData)
                                return
                            }
                            const alts = root.altsFor(modelData)
                            if (alts.length)
                                root.openAltFlyout(keyDelegate, alts)
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: altPopup
        property var alts: []
        padding: Theme.dp(6)
        modal: false
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        Component.onCompleted: {
            // Qt 6.8+: keep the flyout in-process (Popup.Item) so it does not
            // create a HWND that steals focus from the target app (1.83).
            if ("popupType" in altPopup)
                altPopup.popupType = 0
        }
        background: Rectangle {
            radius: root.keyRadius
            color: Theme.bgAcrylic
            border.width: Theme.strokeHairline
            border.color: Theme.strokeCard
        }
        contentItem: Row {
            spacing: root.keyGap
            Repeater {
                model: altPopup.alts
                delegate: KeyCap {
                    required property var modelData
                    width: Math.max(Theme.dp(40), root.keyH)
                    height: root.keyH
                    label: String(modelData)
                    onTapped: root.commitAlt(String(modelData))
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
            return root.capsLock ? "⇪" : "⇧"
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
                || (k.kind === "emoji" && root.emojiMode)
    }

    component SizeChip: Rectangle {
        id: chip
        property string sizeId: ""
        property string label: ""
        property bool checkedOverride: false
        signal picked(string id)
        readonly property bool checked: checkedOverride
                                        || (sizeId === "small" || sizeId === "default" || sizeId === "wide"
                                            ? root.keyboardSize === sizeId : false)
        width: chipLabel.implicitWidth + Theme.dp(16)
        height: Theme.dp(28)
        radius: height / 2
        color: checked ? Theme.fillAccent : Theme.fillControl
        border.width: Theme.strokeHairline
        border.color: Theme.strokeControl
        Text {
            id: chipLabel
            anchors.centerIn: parent
            text: chip.label
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: chip.checked ? Theme.textOnAccent : Theme.textPrimary
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (chip.sizeId === "small" || chip.sizeId === "default" || chip.sizeId === "wide")
                    root.keyboardSize = chip.sizeId
                chip.picked(chip.sizeId)
            }
        }
        Accessible.role: Accessible.Button
        Accessible.name: chip.label
        Accessible.checkable: true
        Accessible.checked: chip.checked
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
            radius: root.keyRadius
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

    component KeyCap: Item {
        id: cap
        property string label: ""
        property string hint: ""
        property var iconSymbol: ""
        property bool accent: false
        property bool muted: false
        property bool wideLabel: false
        signal tapped
        signal longPressed

        readonly property bool hasIcon: {
            if (typeof cap.iconSymbol === "string")
                return cap.iconSymbol.length > 0
            return cap.iconSymbol !== undefined && cap.iconSymbol !== null && cap.iconSymbol !== ""
        }

        scale: ma.containsPress && !Theme.reducedMotion ? 0.96 : 1
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
        opacity: muted ? 0.72 : 1

        Rectangle {
            anchors.fill: parent
            radius: root.keyRadius
            color: {
                if (cap.accent)
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
            // Soft raise — Win11 keys sit slightly above the acrylic tray.
            Rectangle {
                anchors.fill: parent
                anchors.topMargin: height - Theme.dp(2)
                radius: parent.radius
                color: Theme.dark ? "#22000000" : "#14000000"
                visible: !ma.containsPress
                Accessible.ignored: true
            }
        }

        Text {
            visible: cap.hint.length > 0
            z: 1
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: Theme.dp(4)
            text: cap.hint
            font.family: Theme.fontFamily
            font.pixelSize: Math.max(9, Theme.fontCaption - 1)
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
            pressAndHoldInterval: 380
            property bool held: false
            onPressed: held = false
            onPressAndHold: {
                held = true
                cap.longPressed()
            }
            onClicked: {
                if (!held)
                    cap.tapped()
            }
        }
        Accessible.role: Accessible.Button
        Accessible.name: {
            if (cap.hint.length)
                return qsTr("%1 — hold for %2").arg(cap.label.length ? cap.label : qsTr("Key")).arg(cap.hint)
            if (cap.label.length)
                return cap.label
            return qsTr("Key")
        }
        Accessible.onPressAction: cap.tapped()
    }

    // Windows 11 default touch keyboard (letters) — not Win10 classic with always-on number row.
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
            { kind: "char", ch: ";", shiftCh: ":", label: ";", shiftLabel: ":",
              alts: [";", ":", "；", "：" ], w: 1.0 },
            { kind: "enter", w: 1.45 }
        ],
        [
            { kind: "shift", w: 1.45 },
            { kind: "vk", vk: 90 }, { kind: "vk", vk: 88 }, { kind: "vk", vk: 67 },
            { kind: "vk", vk: 86 }, { kind: "vk", vk: 66 }, { kind: "vk", vk: 78 },
            { kind: "vk", vk: 77 },
            { kind: "char", ch: ",", shiftCh: ";", label: ",", shiftLabel: ";",
              alts: [",", ";", "、", "，"] },
            { kind: "char", ch: ".", shiftCh: ":", label: ".", shiftLabel: ":",
              alts: [".", ":", "。", "…"] },
            { kind: "char", ch: "?", shiftCh: "!", label: "?", shiftLabel: "!",
              alts: ["?", "!", "¿", "¡"] },
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
            { kind: "char", ch: "@", label: "@", alts: ["@", "©", "®"] },
            { kind: "char", ch: "#", label: "#", alts: ["#", "№"] },
            { kind: "char", ch: "$", label: "$", alts: ["$", "€", "£", "¥"] },
            { kind: "char", ch: "%", label: "%" },
            { kind: "char", ch: "&", label: "&" },
            { kind: "char", ch: "-", label: "-", alts: ["-", "—", "–", "_"] },
            { kind: "char", ch: "+", label: "+" },
            { kind: "char", ch: "(", label: "(", alts: ["(", "[", "{", "<"] },
            { kind: "char", ch: ")", label: ")", alts: [")", "]", "}", ">"] },
            { kind: "char", ch: "/", label: "/", alts: ["/", "\\", "|"] },
            { kind: "enter", w: 1.45 }
        ],
        [
            { kind: "char", ch: "*", label: "*", w: 1.2 },
            { kind: "char", ch: "\"", label: "\"", alts: ["\"", "“", "”"] },
            { kind: "char", ch: "'", label: "'", alts: ["'", "‘", "’"] },
            { kind: "char", ch: ":", label: ":" },
            { kind: "char", ch: ";", label: ";" },
            { kind: "char", ch: "!", label: "!" },
            { kind: "char", ch: "?", label: "?" },
            { kind: "char", ch: "_", label: "_" },
            { kind: "char", ch: "=", label: "=", alts: ["=", "≠", "≈"] },
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

    readonly property var emojiGridRows: {
        const cat = emojiCategoryModel[Math.max(0, Math.min(emojiCategory, emojiCategoryModel.length - 1))]
        const g = cat.glyphs
        const rows = []
        for (let r = 0; r < 2; ++r) {
            const row = []
            for (let c = 0; c < 10; ++c) {
                const i = r * 10 + c
                if (i < g.length)
                    row.push({ kind: "char", ch: g[i], label: g[i] })
            }
            if (r === 0)
                row.push({ kind: "backspace", w: 1.2 })
            else
                row.push({ kind: "enter", w: 1.2 })
            rows.push(row)
        }
        rows.push([
            { kind: "symbols", label: qsTr("abc"), w: 1.25 },
            { kind: "ctrl", w: 1.0 },
            { kind: "win", w: 1.0 },
            { kind: "alt", w: 1.0 },
            { kind: "lang", w: 1.15 },
            { kind: "space", w: 4.2 },
            { kind: "emoji", w: 1.0 },
            { kind: "left", w: 1.0 },
            { kind: "right", w: 1.0 }
        ])
        return rows
    }

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
            flashBanner(qsTr("Voice typing stays with the OS — this in-app keyboard cannot start dictation."))
            break
        case "ctrl":
        case "alt":
            flashBanner(qsTr("Ctrl / Alt are shown for Win11 layout parity; chords use the physical keyboard."))
            break
        case "win":
            flashBanner(qsTr("Windows key is chrome-only in-app (no Start menu)."))
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
