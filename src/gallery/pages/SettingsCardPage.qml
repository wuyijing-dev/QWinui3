import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SettingsCard.
//
// Settings row with symbol, Fluent ChevronRight when interactive. API: docs/components/SettingsCard.md

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
                subtitle: qsTr("Settings row with symbol, Fluent ChevronRight when interactive.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Toggle settings")
                qmlSource: "SettingsCard {\n    content: …\n    action: Switch { }\n}"
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
                        symbol: FluentIcons.Notification
                        action: Switch { checked: true }
                    }
                    SettingsCard {
                        Layout.fillWidth: true
                        title: qsTr("Quiet hours")
                        description: qsTr("Mute alerts during scheduled times.")
                        symbol: FluentIcons.QuietHours
                        content: Label {
                            text: qsTr("Weekdays 10:00 PM – 7:00 AM")
                            color: Theme.textSecondary
                            font.pixelSize: Theme.fontCaption
                        }
                        action: Switch {}
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
                        description: qsTr("Version 1.0.0 — tap or press Enter for details")
                        symbol: FluentIcons.Info
                        onClicked: cardStatus.text = qsTr("About clicked")
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
