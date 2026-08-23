import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

NavigationWindow {
    id: window
    width: 960
    height: 640
    visible: true
    title: qsTr("My app")
    subtitle: qsTr("qwinui3 init")
    symbol: FluentIcons.Home
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MyAppMain"

    hostContent: false
    pageModule: "MyApp"
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
