import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SettingsCard.

CatalogPage {
    title: qsTr("SettingsCard")
    subtitle: qsTr("Vs WinUI Toolkit: empty headers collapse; contentAlignment center for media.")

    ControlExample {
        headerText: qsTr("Toggle settings")
        qmlSource: "SettingsCard {\n    toggle: true\n    checked: …\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: cardStatus
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
            SettingsCard {
                title: qsTr("Notifications")
                description: qsTr("Show toast notifications for updates.")
                symbol: FluentIcons.Notification
                toggle: true
                checked: true
            }
            SettingsCard {
                title: qsTr("Elevated surface")
                description: qsTr("appearance: elevated")
                symbol: FluentIcons.Brightness
                appearance: "elevated"
                toggle: true
            }
            SettingsCard {
                title: qsTr("Outline surface")
                description: qsTr("appearance: outline")
                symbol: FluentIcons.Checkbox
                appearance: "outline"
                interactive: true
            }
            SettingsCard {
                title: qsTr("Accent surface")
                description: qsTr("appearance: accent")
                symbol: FluentIcons.Color
                appearance: "accent"
                interactive: true
            }
            SettingsToggleCard {
                title: qsTr("Dark mode")
                description: qsTr("SettingsToggleCard alias for SettingsCard { toggle: true }.")
                symbol: FluentIcons.Brightness
                checked: Theme.dark
                onToggled: Theme.dark = checked
            }
            SettingsCard {
                title: qsTr("Quiet hours")
                description: qsTr("Mute alerts during scheduled times.")
                symbol: FluentIcons.QuietHours
                content: Label {
                    text: qsTr("Weekdays 10:00 PM – 7:00 AM")
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                }
                toggle: true
            }
            SettingsCard {
                title: qsTr("Theme")
                description: qsTr("Choose light or dark appearance.")
                action: ComboBox {
                    model: [qsTr("System"), qsTr("Light"), qsTr("Dark")]
                    implicitWidth: 140
                }
            }
            SettingsCard {
                header: qsTr("About")
                description: qsTr("Version 1.0.0 — tap or press Enter for details")
                symbol: FluentIcons.Info
                isClickEnabled: true
                actionIcon: FluentIcons.OpenInNewWindow
                onClicked: cardStatus.text = qsTr("About clicked")
            }
            SettingsCard {
                header: qsTr("Storage")
                description: qsTr("Vertical content alignment (Toolkit).")
                contentAlignment: "vertical"
                content: ProgressBar {
                    width: 280
                    value: 0.62
                }
                action: Button {
                    text: qsTr("Manage")
                    flat: true
                }
            }
            SettingsCard {
                header: qsTr("Account")
                description: qsTr("Left-aligned content (contentAlignment: left).")
                contentAlignment: "left"
                content: Label {
                    text: qsTr("alex@contoso.com")
                    color: Theme.textSecondary
                }
                action: Button {
                    text: qsTr("Sign out")
                    flat: true
                }
            }
            SettingsCard {
                header: qsTr("Rounded card")
                description: qsTr("cornerRadius overrides Theme.cornerCard.")
                symbol: FluentIcons.Color
                cornerRadius: 20
                toggle: true
                checked: true
            }
            SettingsCard {
                contentAlignment: "center"
                content: ColumnLayout {
                    spacing: Theme.spacing
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: FluentIcons.Photo
                        font: Theme.iconFontFor(40)
                        color: Theme.accent
                    }
                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Centered illustration (no empty header row)")
                        color: Theme.textSecondary
                    }
                }
            }
        }
    }
}

