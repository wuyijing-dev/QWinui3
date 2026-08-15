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
                title: qsTr("Switch")
                subtitle: qsTr("Use a Switch to present users with two mutually exclusive options.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple Switch")
                qmlSource: "Switch { text: \"Off\" }\nSwitch { text: \"On\"; checked: true }\nSwitch { text: \"Disabled\"; enabled: false }\nSwitch { text: \"Disabled on\"; checked: true; enabled: false }"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    Switch { text: qsTr("Off") }
                    Switch { text: qsTr("On"); checked: true }
                    Switch { text: qsTr("Disabled"); enabled: false }
                    Switch { text: qsTr("Disabled on"); checked: true; enabled: false }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
