import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

SettingsView {
    title: qsTr("Settings")

    SettingsGroup {
        title: qsTr("Appearance")
        description: qsTr("Theme tokens used by the shell.")
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
            description: qsTr("Disables glyph micro-motion and short-circuits Theme.duration().")
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
        title: qsTr("Shell")
        description: qsTr("Geometry restores via geometryPersistenceKey \"GalleryShellMain\".")
        symbol: FluentIcons.DockLeft

        DetailRow {
            label: qsTr("Window")
            value: qsTr("NavigationWindow")
            symbol: FluentIcons.DockLeft
        }
        DetailRow {
            label: qsTr("Persistence")
            value: "GalleryShellMain"
            symbol: FluentIcons.Save
        }
    }
}
