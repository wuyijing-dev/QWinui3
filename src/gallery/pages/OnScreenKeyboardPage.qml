import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.77). Recipe: docs/on-screen-keyboard.md
//
// App-scoped hardware keyboard → same IME/Keyman engine (not OS-wide).

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Win11 OSK — app hardware input. docs/on-screen-keyboard.md (1.77).")

    ControlExample {
        headerText: qsTr("App hardware input (1.77)")
        qmlSource: "OnScreenKeyboard { hardwareInput: true }\n// Physical keys → KeyboardEngine (in-app only)"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Focus a field and type on the physical keyboard — letters go through the same engine as the dock (pinyin / romaji / hangul / Keyman). 1–9 pick candidates; Esc cancels; PageUp/PageDown page the bar. This is in-app only: it does not inject into other processes (no SendInput). Toggle below if you need the system IME instead.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Switch {
                text: qsTr("Hardware input (app-scoped)")
                checked: osk.hardwareInput
                onToggled: osk.hardwareInput = checked
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
                text: qsTr("Active: %1 · backend “%2” · hardware %3")
                    .arg(osk.engine.layoutLabel)
                    .arg(osk.engine.backend)
                    .arg(osk.hardwareInput ? qsTr("on") : qsTr("off"))
            }
            TextField {
                id: lineField
                Layout.fillWidth: true
                placeholderText: qsTr("Type here with the physical keyboard")
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
            CheckBox { text: qsTr("Physical keys drive 中文 / 日本語 / 한국어 compose") }
            CheckBox { text: qsTr("Keyman layouts (de/fr/…) match OSK via hardware") }
            CheckBox { text: qsTr("Ctrl/Alt shortcuts still reach the app") }
            CheckBox { text: qsTr("Not OS-wide — other apps unchanged") }
            CheckBox { text: qsTr("Treat OnScreenKeyboard as experimental") }
        }
    }

    footer: OnScreenKeyboard {
        id: osk
        hardwareInput: true
    }

    Connections {
        target: osk.engine
        function onLayoutIdChanged() {
            langBox.currentIndex = osk.engine.layoutIndex
        }
    }

    Component.onCompleted: lineField.forceActiveFocus()
}
