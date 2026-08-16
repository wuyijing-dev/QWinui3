import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Settings cards example — SettingsView host (no per-card Layout.fillWidth / margin glue).

StandardWindow {
    id: window
    width: 720
    height: 780
    visible: true
    title: qsTr("Settings cards example")
    backdrop: WindowHelper.BackdropSolid

    property bool notificationsEnabled: true
    property bool marketingEmail: false
    property string accountName: qsTr("Alex Chen")

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
        }
    }

    SettingsView {
        anchors.fill: parent
        title: qsTr("Settings")
        subtitle: qsTr("Account, appearance, and notification rows with SettingsCard.toggle.")

        SettingsGroup {
            title: qsTr("Account")
            symbol: FluentIcons.Contact

            SettingsCard {
                title: window.accountName
                description: qsTr("Signed in locally for this example.")
                symbol: FluentIcons.Contact
                action: Button {
                    flat: true
                    text: qsTr("Manage")
                }
            }
        }

        SettingsGroup {
            title: qsTr("Appearance")
            symbol: FluentIcons.Brightness

            SettingsCard {
                title: qsTr("App theme")
                description: qsTr("Toggle Theme.dark")
                symbol: FluentIcons.Color
                toggle: true
                checked: Theme.dark
                onToggled: Theme.dark = checked
            }

            SettingsCard {
                title: qsTr("Accent pack")
                description: qsTr("Theme.accentPack presets")
                symbol: FluentIcons.Color
                action: ComboBox {
                    model: [qsTr("Blue"), qsTr("Purple"), qsTr("Green"), qsTr("Orange")]
                    currentIndex: {
                        switch (Theme.accentPack) {
                        case "purple": return 1
                        case "green": return 2
                        case "orange": return 3
                        default: return 0
                        }
                    }
                    onActivated: function (index) {
                        var packs = ["blue", "purple", "green", "orange"]
                        Theme.accentPack = packs[index]
                    }
                }
            }
        }

        SettingsGroup {
            title: qsTr("Notifications")
            symbol: FluentIcons.Notification

            SettingsExpander {
                title: qsTr("Notification preferences")
                description: qsTr("Expand for email and toast options.")
                symbol: FluentIcons.Notification

                SettingsCard {
                    title: qsTr("Enable notifications")
                    description: qsTr("Master switch for this sample.")
                    toggle: true
                    checked: window.notificationsEnabled
                    onToggled: window.notificationsEnabled = checked
                }
                SettingsCard {
                    title: qsTr("Marketing email")
                    description: qsTr("Optional promotional mail.")
                    enabled: window.notificationsEnabled
                    toggle: true
                    toggleEnabled: window.notificationsEnabled
                    checked: window.marketingEmail
                    onToggled: window.marketingEmail = checked
                }
            }
        }
    }
}
