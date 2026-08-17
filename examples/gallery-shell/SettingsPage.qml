import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import QWinUI3.Theme
import QWinUI3.Extras

SettingsView {
    title: qsTr("Settings")

    Settings {
        id: prefs
        category: "GalleryShellPrefs"
        property bool dark: false
        property bool reducedMotion: false
        property string density: "standard"
    }

    Component.onCompleted: {
        Theme.dark = prefs.dark
        Theme.reducedMotion = prefs.reducedMotion
        if (prefs.density === "compact" || prefs.density === "standard")
            Theme.density = prefs.density
    }

    SettingsGroup {
        title: qsTr("Appearance")
        description: qsTr("Persisted via Settings (docs/settings-persistence.md).")
        symbol: FluentIcons.Brightness

        SettingsCard {
            title: qsTr("Dark mode")
            description: qsTr("Light or dark Theme tokens.")
            symbol: FluentIcons.Color
            toggle: true
            checked: Theme.dark
            onToggled: {
                Theme.dark = checked
                prefs.dark = checked
            }
        }

        SettingsCard {
            title: qsTr("Reduced motion")
            description: qsTr("Disables glyph micro-motion and short-circuits Theme.duration().")
            symbol: FluentIcons.Processing
            toggle: true
            checked: Theme.reducedMotion
            onToggled: {
                Theme.reducedMotion = checked
                prefs.reducedMotion = checked
            }
        }

        SettingsCard {
            title: qsTr("Density")
            description: qsTr("Compact control metrics (Theme.density).")
            symbol: FluentIcons.Document
            action: ComboBox {
                model: [qsTr("Standard"), qsTr("Compact")]
                currentIndex: Theme.density === "compact" ? 1 : 0
                onActivated: function (index) {
                    var d = index === 1 ? "compact" : "standard"
                    Theme.density = d
                    prefs.density = d
                }
            }
        }
    }

    SettingsGroup {
        title: qsTr("Shell")
        description: qsTr("Geometry restores via geometryPersistenceKey \"GalleryShellMain\" (separate from prefs).")
        symbol: FluentIcons.DockLeft

        DetailRow {
            label: qsTr("Window")
            value: qsTr("NavigationWindow")
            symbol: FluentIcons.DockLeft
        }
        DetailRow {
            label: qsTr("Geometry key")
            value: "GalleryShellMain"
            symbol: FluentIcons.Save
        }
        DetailRow {
            label: qsTr("Prefs category")
            value: "GalleryShellPrefs"
            symbol: FluentIcons.Permissions
        }
    }
}
