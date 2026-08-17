import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

SettingsView {
    title: qsTr("Settings")
    subtitle: qsTr("ThemeAppearanceSettings — same kit cards as Gallery. docs/theme-overrides.md (1.69).")

    ThemeAppearanceSettings {
        persist: false
        prefsCategory: "GalleryShellTheme"
    }

    SettingsGroup {
        title: qsTr("Shell")
        description: qsTr("Geometry restores via geometryPersistenceKey \"GalleryShellMain\" (separate from ThemePrefs).")
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
            label: qsTr("ThemePrefs category")
            value: "GalleryShellTheme"
            symbol: FluentIcons.Permissions
        }
    }
}
