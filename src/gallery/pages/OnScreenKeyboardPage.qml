import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.70). Recipe: docs/on-screen-keyboard.md
//
// Win11 dock + builtin en-US inject. Not Qt Virtual Keyboard.

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Win11-style OSK — MIT engine path, our chrome. docs/on-screen-keyboard.md (1.70).")

    ControlExample {
        headerText: qsTr("Type with the dock (1.70)")
        qmlSource: "OnScreenKeyboard { }\n// Footer dock; keys do not steal TextField focus"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Tap a field below, then use the keyboard docked under this page. Shift twice = Caps. &123 = symbols. Qt Virtual Keyboard is not used (QT_IM_MODULE stays unset). Extra layouts / Chinese IME are 1.71…1.73.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            TextField {
                id: lineField
                Layout.fillWidth: true
                placeholderText: qsTr("Single-line field")
            }
            TextArea {
                id: areaField
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.dp(96)
                placeholderText: qsTr("Multi-line area")
                wrapMode: TextArea.Wrap
            }
            CheckBox { text: qsTr("Treat OnScreenKeyboard as experimental (not freeze-covered)") }
        }
    }

    footer: OnScreenKeyboard {
        id: osk
    }

    Component.onCompleted: lineField.forceActiveFocus()
}
