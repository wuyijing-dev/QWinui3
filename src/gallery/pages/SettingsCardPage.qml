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
                title: qsTr("SettingsCard")
                subtitle: qsTr("Settings row with header, description, trailing action. Interactive cards emit clicked.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Toggle settings")
                qmlSource: "SettingsCard {\n    interactive: true\n    onClicked: …\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label {
                        id: cardStatus
                        text: qsTr("Ready")
                        color: Theme.textSecondary
                    }
                    SettingsCard {
                        Layout.fillWidth: true
                        title: qsTr("Notifications")
                        description: qsTr("Show toast notifications for updates.")
                        headerIcon: "\uEA8F"
                        action: Switch { checked: true }
                    }
                    SettingsCard {
                        Layout.fillWidth: true
                        title: qsTr("Theme")
                        description: qsTr("Choose light or dark appearance.")
                        action: ComboBox {
                            model: [qsTr("System"), qsTr("Light"), qsTr("Dark")]
                            implicitWidth: 140
                        }
                    }
                    SettingsCard {
                        Layout.fillWidth: true
                        interactive: true
                        title: qsTr("About")
                        description: qsTr("Version 1.0.0 — tap for details")
                        headerIcon: "\uE946"
                        onClicked: cardStatus.text = qsTr("About clicked")
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
