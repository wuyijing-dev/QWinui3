import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("ColorPicker")
                subtitle: qsTr("Spectrum, RGB/HSV/HEX, CopyButton for hex, and WinUI visibility toggles.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("ColorPicker Properties")
                qmlSource: "ColorPicker {\n    selectedColor: \"#005FB8\"\n}"
                ColorPicker {
                    id: picker
                    Layout.preferredWidth: 312
                    selectedColor: Theme.accent
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Selection")
                qmlSource: "selectedColor"
                RowLayout {
                    spacing: Theme.spacingLoose
                    Rectangle {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        radius: Theme.cornerControl
                        color: picker.selectedColor
                        border.width: 1
                        border.color: Theme.strokeControl
                    }
                    Label {
                        text: String(picker.selectedColor).toUpperCase()
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
