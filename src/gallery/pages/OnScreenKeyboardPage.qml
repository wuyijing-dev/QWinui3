import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.82). Recipe: docs/on-screen-keyboard.md
//
// Floating Win11 OSK window + optional Windows system-wide SendInput.

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Floating window · optional desktop inject (Windows). docs/on-screen-keyboard.md (1.82).")

    OnScreenKeyboardWindow {
        id: floatOsk
        systemWide: systemWideSwitch.checked
        keyboardSize: osk.keyboardSize
    }

    ControlExample {
        headerText: qsTr("Floating window + system-wide (1.82)")
        qmlSource: "OnScreenKeyboardWindow {\n    systemWide: true\n}\n// WS_EX_NOACTIVATE · SendInput (Windows)"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Open a separate always-on-top keyboard like Win11 Touch Keyboard. With System-wide input (Windows), key taps inject into whichever desktop app is focused — the OSK uses no-activate so it does not steal focus. Compose stays on the candidate bar; commits go via SendInput. Linux stays in-app only.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                Button {
                    text: qsTr("Open floating keyboard")
                    onClicked: {
                        floatOsk.layoutId = osk.layoutId
                        floatOsk.keyboardSize = osk.keyboardSize
                        floatOsk.systemWide = systemWideSwitch.checked
                        floatOsk.openFloating()
                    }
                }
                Button {
                    text: qsTr("Close floating")
                    enabled: floatOsk.visible
                    onClicked: floatOsk.closeFloating()
                }
            }
            Switch {
                id: systemWideSwitch
                text: qsTr("System-wide input (Windows SendInput)")
                enabled: osk.supportsSystemWide
                checked: false
                onToggled: {
                    floatOsk.systemWide = checked
                    if (checked)
                        osk.flashBanner(qsTr("System-wide is on — focus another app, then tap keys on the floating OSK."))
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: osk.supportsSystemWide
                      ? qsTr("Supports system-wide: yes (Windows). Opt-in only; injects into the focused window.")
                      : qsTr("Supports system-wide: no on this OS — floating window still works for in-app fields.")
            }
            Switch {
                text: qsTr("Hardware input on dock (app-scoped)")
                checked: osk.hardwareInput
                onToggled: osk.hardwareInput = checked
            }
            Switch {
                text: qsTr("Show Win11 chrome on dock")
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
                        floatOsk.keyboardSize = osk.keyboardSize
                    }
                }
            }
            ComboBox {
                id: langBox
                Layout.fillWidth: true
                model: osk.engine.layoutLabels
                currentIndex: osk.engine.layoutIndex
                onActivated: {
                    osk.engine.layoutIndex = index
                    floatOsk.layoutId = osk.layoutId
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Dock: %1 · chip “%2” · floating %3 · systemWide %4")
                    .arg(osk.engine.layoutLabel)
                    .arg(osk.langBadge)
                    .arg(floatOsk.visible ? qsTr("open") : qsTr("closed"))
                    .arg(systemWideSwitch.checked ? qsTr("on") : qsTr("off"))
            }
            TextField {
                id: lineField
                Layout.fillWidth: true
                placeholderText: qsTr("In-app field (dock) — or focus Notepad with system-wide floating OSK")
                LayoutMirroring.enabled: osk.engine.rtl
                LayoutMirroring.childrenInherit: true
            }
            TextArea {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.dp(96)
                placeholderText: qsTr("Multi-line area")
                wrapMode: TextArea.Wrap
                LayoutMirroring.enabled: osk.engine.rtl
            }
            Button {
                visible: !osk.visible
                text: qsTr("Show dock keyboard")
                onClicked: osk.visible = true
            }
            CheckBox { text: qsTr("Floating window matches Win11 separate OSK") }
            CheckBox { text: qsTr("No-activate — clicks do not steal focus") }
            CheckBox { text: qsTr("System-wide SendInput opt-in (Windows)") }
            CheckBox { text: qsTr("Treat OnScreenKeyboard as experimental") }
        }
    }

    footer: OnScreenKeyboard {
        id: osk
        hardwareInput: true
        systemWide: false
        onCloseRequested: visible = false
        onSettingsRequested: osk.settingsOpen = true
    }

    Connections {
        target: osk.engine
        function onLayoutIdChanged() {
            langBox.currentIndex = osk.engine.layoutIndex
            floatOsk.layoutId = osk.layoutId
        }
    }

    Component.onCompleted: lineField.forceActiveFocus()
}
