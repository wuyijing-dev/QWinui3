import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// First app in an hour (2.52) — smallest NavigationWindow shell; no Settings footer.
// Smaller than gallery-shell (no ThemePrefs page, no translations). Recipe: docs/first-app-252.md.

NavigationWindow {
    id: window
    width: 960
    height: 640
    visible: true
    title: qsTr("First app")
    subtitle: qsTr("examples/first-app · 2.52")
    symbol: FluentIcons.Home
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "FirstAppMain"

    hostContent: false
    pageModule: "QWinUI3.Examples.FirstApp"
    pageTransition: "slide"
    paneDisplayMode: "auto"
    paneHeaderText: qsTr("MyApp")
    currentKey: "home"

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
