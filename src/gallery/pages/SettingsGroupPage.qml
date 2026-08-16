import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SettingsGroup / SettingsView / SettingsCard.toggle.

Page {
    padding: 0

    SettingsView {
        anchors.fill: parent
        title: qsTr("SettingsGroup")
        subtitle: qsTr("SettingsView pads the page; SettingsCard fills width and can host a built-in Switch via toggle.")

        SettingsGroup {
            title: qsTr("Appearance")
            description: qsTr("Theme tokens and motion preferences.")
            symbol: FluentIcons.Brightness

            SettingsCard {
                title: qsTr("Dark mode")
                description: qsTr("Use a dark appearance.")
                symbol: FluentIcons.Brightness
                toggle: true
                checked: Theme.dark
                onToggled: Theme.dark = checked
            }
            SettingsCard {
                title: qsTr("Reduced motion")
                description: qsTr("Short-circuit Theme.duration() animations.")
                symbol: FluentIcons.QuietHours
                toggle: true
                checked: Theme.reducedMotion
                onToggled: Theme.reducedMotion = checked
            }
        }

        SettingsGroup {
            title: qsTr("Account summary")
            description: qsTr("Read-only DetailRow examples inside a group.")
            symbol: FluentIcons.Contact

            DetailRow {
                label: qsTr("Name")
                value: qsTr("Alex Chen")
                symbol: FluentIcons.Contact
            }
            DetailRow {
                label: qsTr("Email")
                value: qsTr("alex@example.com")
                symbol: FluentIcons.Mail
            }
            DetailRow {
                label: qsTr("Plan")
                value: qsTr("Pro")
                symbol: FluentIcons.Shop
                trailing: Chip { text: qsTr("Active") }
            }
        }
    }
}
