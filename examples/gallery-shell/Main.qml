import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Thin extractable Gallery shell (1.50) — NavigationWindow + pageModule + Settings.
// Copy this folder; see README for keep vs delete. Recipe: docs/window-shells.md · docs/navigation.md.

NavigationWindow {
    id: window
    width: 1100
    height: 720
    visible: true
    title: qsTr("Gallery shell")
    subtitle: qsTr("examples/gallery-shell · 1.50")
    symbol: FluentIcons.Home
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "GalleryShellMain"

    // StackView pages (Gallery pattern) — not the hostContent slot
    hostContent: false
    pageModule: "QWinUI3.Examples.GalleryShell"
    pageTransition: "slide"
    paneDisplayMode: "auto"
    paneHeaderText: qsTr("MyApp")
    currentKey: "home"

    footerText: qsTr("Settings")
    footerSymbol: FluentIcons.Settings
    footerComponent: "SettingsPage"

    property ThemePrefs themePrefs: ThemePrefs {
        category: "GalleryShellTheme"
        autoLoad: true
        autoSave: true
    }

    navModel: [
        {
            type: "item",
            key: "home",
            title: qsTr("Home"),
            symbol: FluentIcons.Home,
            component: "HomePage"
        }
    ]
}
