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
                title: qsTr("SettingsExpander")
                subtitle: qsTr("An expandable settings group with title and description.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Nested settings")
                qmlSource: "SettingsExpander {\n    title: \"Privacy\"\n    SettingsCard { … }\n}"
                SettingsExpander {
                    Layout.fillWidth: true
                    title: qsTr("Privacy")
                    description: qsTr("Control how your data is used.")
                    headerIcon: "\uE72E"
                    expanded: true
                    ColumnLayout {
                        width: parent.width
                        spacing: Theme.spacing
                        SettingsCard {
                            Layout.fillWidth: true
                            title: qsTr("Diagnostics")
                            description: qsTr("Send optional diagnostic data.")
                            action: Switch { checked: true }
                        }
                        SettingsCard {
                            Layout.fillWidth: true
                            title: qsTr("Advertising ID")
                            description: qsTr("Let apps use advertising ID.")
                            action: Switch {}
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
