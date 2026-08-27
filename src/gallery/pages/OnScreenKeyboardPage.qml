import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Osk

// Gallery — OnScreenKeyboard. Recipe: docs/on-screen-keyboard.md
//
// Floating Win11 OSK window + optional Windows system-wide SendInput.

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Floating window · dock · shared engine. Voice/handwriting: docs/on-screen-keyboard-voice-handwriting.md")

    OnScreenKeyboardWindow {
        id: floatOsk
        // Keep in sync with the switch; floating defaults ON on Windows.
        systemWide: systemWideSwitch.checked
        keyboardSize: osk.keyboardSize
    }

    ControlExample {
        headerText: qsTr("Floating window + system-wide")
        qmlSource: "OnScreenKeyboardWindow {\n    systemWide: true\n}\n// WS_EX_NOACTIVATE · SendInput (Windows)"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use Open floating keyboard (not the dock). On Windows, System-wide is on by default: click Notepad / Chrome first, then tap the floating keys. Dock stays in-app. taps / settings / candidate bar / long-press flyout must not steal focus (WS_EX_NOACTIVATE + MA_NOACTIVATE). Elevated / UIPI / UWP / some games may ignore SendInput. Linux floating stays in-app.")
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
                        if (systemWideSwitch.checked)
                            osk.flashBanner(qsTr("Focus another app, then tap the floating keyboard."))
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
                checked: osk.supportsSystemWide
                onToggled: {
                    floatOsk.systemWide = checked
                    if (checked)
                        osk.flashBanner(qsTr("System-wide on — focus another app, then tap the floating OSK."))
                    else
                        osk.flashBanner(qsTr("System-wide off — floating OSK only fills in-app fields."))
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: osk.supportsSystemWide
                      ? qsTr("Floating defaults to system-wide on Windows. Dock stays in-app. Turn the switch off to disable SendInput.")
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
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Consumer copy: examples/osk-dock · examples/floating-osk — not this Gallery page.")
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "cmake --build build --config Release --target qwinui3_example_osk_dock"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "cmake --build build --config Release --target qwinui3_example_osk_dock"
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAnywhere
                    text: "cmake --build build --config Release --target qwinui3_example_floating_osk"
                    font.pixelSize: Theme.fontCaption
                }
                CopyButton {
                    textToCopy: "cmake --build build --config Release --target qwinui3_example_floating_osk"
                }
            }
        }
    }

    footer: OnScreenKeyboard {
        id: osk
        hardwareInput: true
        systemWide: false
        candidateBarPlacement: "floating"
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
