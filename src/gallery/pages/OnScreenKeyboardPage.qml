import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.80). Recipe: docs/on-screen-keyboard.md
//
// Win11 default touch layout + app-scoped hardware input (not OS-wide).

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Win11 OSK layout · layouts / IME. docs/on-screen-keyboard.md (1.80).")

    ControlExample {
        headerText: qsTr("Win11 layout + language packs (1.80)")
        qmlSource: "OnScreenKeyboard { }\n// Esc/Tab/dual Shift · 英/中/あ · number hints"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Dock chrome follows Windows 11 touch keyboard: settings / grab / close, emoji + paste tools, Esc · letter row with number hints · Backspace, Tab · Enter, dual Shift, and &123 · Ctrl · Win · Alt · language chip · Space · mic · arrows. Globe/chip cycles Keyman + zh/ja/ko layouts. Hardware keys still route in-app (toggle below).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Switch {
                text: qsTr("Hardware input (app-scoped)")
                checked: osk.hardwareInput
                onToggled: osk.hardwareInput = checked
            }
            Switch {
                text: qsTr("Show Win11 chrome (settings / grab / close)")
                checked: osk.showChrome
                onToggled: osk.showChrome = checked
            }
            ComboBox {
                id: langBox
                Layout.fillWidth: true
                model: osk.engine.layoutLabels
                currentIndex: osk.engine.layoutIndex
                onActivated: osk.engine.layoutIndex = index
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Active: %1 · chip “%2” · backend “%3” · hardware %4")
                    .arg(osk.engine.layoutLabel)
                    .arg(osk.langBadge)
                    .arg(osk.engine.backend)
                    .arg(osk.hardwareInput ? qsTr("on") : qsTr("off"))
            }
            TextField {
                id: lineField
                Layout.fillWidth: true
                placeholderText: qsTr("Type here with the dock or physical keyboard")
                LayoutMirroring.enabled: osk.engine.rtl
                LayoutMirroring.childrenInherit: true
            }
            TextArea {
                id: areaField
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.dp(96)
                placeholderText: qsTr("Multi-line area")
                wrapMode: TextArea.Wrap
                LayoutMirroring.enabled: osk.engine.rtl
            }
            Button {
                visible: !osk.visible
                text: qsTr("Show on-screen keyboard")
                onClicked: osk.visible = true
            }
            CheckBox { text: qsTr("Layout matches Win11 default touch rows") }
            CheckBox { text: qsTr("Language chip cycles en/zh/ja/ko / Keyman packs") }
            CheckBox { text: qsTr("Physical keys drive compose when hardwareInput is on") }
            CheckBox { text: qsTr("Mic / Win stay chrome-only (no OS voice / Start)") }
            CheckBox { text: qsTr("Treat OnScreenKeyboard as experimental") }
        }
    }

    footer: OnScreenKeyboard {
        id: osk
        hardwareInput: true
        onCloseRequested: visible = false
        onSettingsRequested: langBox.forceActiveFocus()
    }

    Connections {
        target: osk.engine
        function onLayoutIdChanged() {
            langBox.currentIndex = osk.engine.layoutIndex
        }
    }

    Component.onCompleted: lineField.forceActiveFocus()
}
