import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SettingsGroup.
//
// Section title + SettingsCard stack (and DetailRow summaries).

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
                title: qsTr("SettingsGroup")
                subtitle: qsTr("Group settings cards under a section header with optional description.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
                headerText: qsTr("Appearance & account")
                qmlSource: "SettingsGroup {\n    title: qsTr(\"Appearance\")\n    SettingsCard { … }\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingSection

                    SettingsGroup {
                        Layout.fillWidth: true
                        title: qsTr("Appearance")
                        description: qsTr("Theme tokens and motion preferences.")
                        symbol: FluentIcons.Brightness

                        SettingsCard {
                            Layout.fillWidth: true
                            title: qsTr("Dark mode")
                            description: qsTr("Use a dark appearance.")
                            symbol: FluentIcons.Brightness
                            action: Switch {
                                checked: Theme.dark
                                onToggled: Theme.dark = checked
                            }
                        }
                        SettingsCard {
                            Layout.fillWidth: true
                            title: qsTr("Reduced motion")
                            description: qsTr("Short-circuit Theme.duration() animations.")
                            symbol: FluentIcons.QuietHours
                            action: Switch {
                                checked: Theme.reducedMotion
                                onToggled: Theme.reducedMotion = checked
                            }
                        }
                    }

                    SettingsGroup {
                        Layout.fillWidth: true
                        title: qsTr("Account summary")
                        description: qsTr("Read-only DetailRow examples inside a group.")
                        symbol: FluentIcons.Contact

                        DetailRow {
                            Layout.fillWidth: true
                            label: qsTr("Name")
                            value: qsTr("Alex Chen")
                            symbol: FluentIcons.Contact
                        }
                        DetailRow {
                            Layout.fillWidth: true
                            label: qsTr("Email")
                            value: qsTr("alex@example.com")
                            symbol: FluentIcons.Mail
                        }
                        DetailRow {
                            Layout.fillWidth: true
                            label: qsTr("Plan")
                            value: qsTr("Pro")
                            symbol: FluentIcons.Shop
                            trailing: Chip {
                                text: qsTr("Active")
                            }
                        }
                    }
                }
            }
        }
    }
}
