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
                title: qsTr("RadioButton")
                subtitle: qsTr("Use RadioButtons to let users select one option from two or more choices.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A group of RadioButtons")
                qmlSource: "ButtonGroup { id: group }\nRadioButton {\n    text: \"Option A\"\n    checked: true\n    ButtonGroup.group: group\n}\nRadioButton {\n    text: \"Option B\"\n    ButtonGroup.group: group\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    ButtonGroup { id: group }

                    RadioButton { text: qsTr("Option A"); checked: true; ButtonGroup.group: group }
                    RadioButton { text: qsTr("Option B"); ButtonGroup.group: group }
                    RadioButton { text: qsTr("Option C"); ButtonGroup.group: group }
                    RadioButton { text: qsTr("Disabled"); enabled: false }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
