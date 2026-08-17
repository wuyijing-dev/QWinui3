import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.81). Recipe: docs/on-screen-keyboard.md
//
// Windows 11 touch parity (not Win10 classic): long-press, size modes, clipboard strip.

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Win11 touch parity — not Win10 classic. docs/on-screen-keyboard.md (1.81).")

    ControlExample {
        headerText: qsTr("Windows 11 touch behavior (1.81)")
        qmlSource: "OnScreenKeyboard {\n    keyboardSize: \"default\"\n}\n// Long-press hints · size modes · clipboard"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("This dock follows Windows 11 Touch Keyboard — not the Win10 classic full keyboard. Long-press top-row letters for digits; long-press punctuation for alternatives. Settings gear picks Small / Default / Large. Clipboard tool opens a paste strip. Emoji uses category chips. Mic / Win stay chrome-only.")
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
                text: qsTr("Show Win11 chrome")
                checked: osk.showChrome
                onToggled: osk.showChrome = checked
            }
            RowLayout {
                Layout.fillWidth: true
                Label { text: qsTr("Size"); color: Theme.textSecondary }
                ComboBox {
                    Layout.fillWidth: true
                    model: [qsTr("Small"), qsTr("Default"), qsTr("Large")]
                    currentIndex: osk.keyboardSize === "small" ? 0
                                : (osk.keyboardSize === "wide" ? 2 : 1)
                    onActivated: {
                        osk.keyboardSize = index === 0 ? "small"
                                          : (index === 2 ? "wide" : "default")
                    }
                }
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
                text: qsTr("Active: %1 · chip “%2” · size %3 · backend “%4”")
                    .arg(osk.engine.layoutLabel)
                    .arg(osk.langBadge)
                    .arg(osk.keyboardSize)
                    .arg(osk.engine.backend)
            }
            TextField {
                id: lineField
                Layout.fillWidth: true
                placeholderText: qsTr("Try long-press q→1, or hold “?” for alternatives")
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
            CheckBox { text: qsTr("Long-press letter hints insert digits (Win11)") }
            CheckBox { text: qsTr("Long-press punctuation opens alt flyout") }
            CheckBox { text: qsTr("Size modes Small/Default/Large — not Win10 classic") }
            CheckBox { text: qsTr("Clipboard strip + emoji categories") }
            CheckBox { text: qsTr("Treat OnScreenKeyboard as experimental") }
        }
    }

    footer: OnScreenKeyboard {
        id: osk
        hardwareInput: true
        onCloseRequested: visible = false
        onSettingsRequested: osk.settingsOpen = true
    }

    Connections {
        target: osk.engine
        function onLayoutIdChanged() {
            langBox.currentIndex = osk.engine.layoutIndex
        }
    }

    Component.onCompleted: lineField.forceActiveFocus()
}
