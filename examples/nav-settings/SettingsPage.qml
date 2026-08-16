import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme
import QWinUI3.Extras

SettingsView {
    title: qsTr("Settings")

    SettingsGroup {
        title: qsTr("Appearance")
        description: qsTr("Theme tokens and density.")
        symbol: FluentIcons.Brightness

        SettingsCard {
            title: qsTr("Dark mode")
            description: qsTr("Light or dark Theme tokens.")
            symbol: FluentIcons.Color
            toggle: true
            checked: Theme.dark
            onToggled: Theme.dark = checked
        }

        SettingsCard {
            title: qsTr("Reduced motion")
            description: qsTr("Short-circuit Theme.duration() animations.")
            symbol: FluentIcons.Processing
            toggle: true
            checked: Theme.reducedMotion
            onToggled: Theme.reducedMotion = checked
        }

        SettingsCard {
            title: qsTr("Density")
            description: qsTr("Compact control metrics (Theme.density).")
            symbol: FluentIcons.Document
            action: ComboBox {
                model: [qsTr("Standard"), qsTr("Compact")]
                currentIndex: Theme.density === "compact" ? 1 : 0
                onActivated: function (index) {
                    Theme.density = index === 1 ? "compact" : "standard"
                }
            }
        }
    }

    SettingsGroup {
        title: qsTr("Session")
        description: qsTr("Summary rows for the current profile.")
        symbol: FluentIcons.Contact

        DetailRow {
            label: qsTr("User")
            value: qsTr("Local gallery")
            symbol: FluentIcons.Contact
        }
        DetailRow {
            label: qsTr("Theme")
            value: Theme.dark ? qsTr("Dark") : qsTr("Light")
            symbol: FluentIcons.Brightness
        }
    }
}
