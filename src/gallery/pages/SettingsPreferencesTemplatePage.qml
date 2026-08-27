import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Preferences template.
//
// SettingsView + SettingsCard / Expander + TokenizingTextBox + MultiSelectComboBox.
// Recipe: docs/forms.md · docs/settings-persistence.md

Page {
    padding: 0

    SettingsView {
        anchors.fill: parent
        title: qsTr("Preferences template")
        subtitle: qsTr("Settings cards + expander + token / multi-select rows.")

        SettingsGroup {
            title: qsTr("Appearance")
            description: qsTr("Theme and density — toggle cards.")
            symbol: FluentIcons.Brightness

            SettingsCard {
                title: qsTr("Dark mode")
                description: qsTr("Use dark theme tokens.")
                symbol: FluentIcons.Brightness
                toggle: true
                checked: Theme.dark
                onToggled: Theme.dark = checked
            }
            SettingsCard {
                title: qsTr("Compact density")
                description: qsTr("Smaller control height for dense LoB grids.")
                toggle: true
                checked: Theme.density === "compact"
                onToggled: Theme.density = checked ? "compact" : "standard"
            }
        }

        SettingsGroup {
            title: qsTr("Notifications")
            description: qsTr("Channels and labels — expander + custom content.")
            symbol: FluentIcons.Ringer

            SettingsExpander {
                header: qsTr("Email alerts")
                description: qsTr("Master switch for transactional mail.")
                symbol: FluentIcons.Mail
                expanded: true
                toggle: true
                checked: true

                SettingsCard {
                    title: qsTr("Weekly digest")
                    description: qsTr("Summary every Monday.")
                    toggle: true
                    checked: true
                }
                SettingsCard {
                    title: qsTr("Security alerts")
                    description: qsTr("Sign-in and policy changes.")
                    toggle: true
                    checked: true
                }
            }

            SettingsCard {
                title: qsTr("Notification labels")
                description: qsTr("TokenizingTextBox inside a card — press Enter to add.")
                contentAlignment: "left"
                content: TokenizingTextBox {
                    width: Math.min(420, parent.width)
                    header: ""
                    tokens: [qsTr("Billing"), qsTr("Security")]
                    maxTokens: 6
                    tokenDelimiters: ",;"
                    placeholderText: qsTr("Add label")
                    suggestionModel: [
                        qsTr("Billing"), qsTr("Security"), qsTr("Product"),
                        qsTr("Marketing"), qsTr("System")
                    ]
                }
            }
        }

        SettingsGroup {
            title: qsTr("Teams & access")
            description: qsTr("MultiSelectComboBox row for shared workspaces.")
            symbol: FluentIcons.People

            SettingsCard {
                title: qsTr("Visible teams")
                description: qsTr("Pick teams shown in the nav rail.")
                contentAlignment: "left"
                content: MultiSelectComboBox {
                    width: Math.min(320, parent.width)
                    header: ""
                    model: [
                        { text: qsTr("Platform"), checked: true },
                        { text: qsTr("Gallery"), checked: true },
                        { text: qsTr("Support"), checked: false },
                        { text: qsTr("Research"), checked: false }
                    ]
                }
            }

            SettingsCard {
                title: qsTr("Share diagnostics")
                description: qsTr("Optional crash reports — see settings-persistence.md.")
                toggle: true
                checked: true
            }
        }
    }
}
