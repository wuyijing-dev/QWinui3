import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

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
                title: qsTr("CheckBox")
                subtitle: qsTr("A control that a user can select or clear.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A 2-state CheckBox")
                qmlSource: "CheckBox { text: \"Unchecked\" }\nCheckBox { text: \"Checked\"; checked: true }\nCheckBox { text: \"Disabled\"; enabled: false }\nCheckBox { text: \"Disabled checked\"; checked: true; enabled: false }"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    CheckBox { text: qsTr("Unchecked") }
                    CheckBox { text: qsTr("Checked"); checked: true }
                    CheckBox { text: qsTr("Disabled"); enabled: false }
                    CheckBox { text: qsTr("Disabled checked"); checked: true; enabled: false }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A 3-state CheckBox")
                qmlSource: "CheckBox {\n    text: \"Indeterminate\"\n    checkState: Qt.PartiallyChecked\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    CheckBox { text: qsTr("Indeterminate"); checkState: Qt.PartiallyChecked }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
