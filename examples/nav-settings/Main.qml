import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

StandardWindow {
    id: window
    width: 1100
    height: 720
    visible: true
    title: qsTr("Nav + Settings example")
    backdrop: WindowHelper.BackdropSolid

    NavigationView {
        id: nav
        anchors.fill: parent
        headerText: qsTr("NavSettings")
        footerText: qsTr("Settings")
        footerIcon: FluentIcons.Settings
        footerComponent: "SettingsPage"
        pageModule: "QWinUI3.Examples.NavSettings"
        currentKey: "home"
        model: [
            {
                type: "item",
                key: "home",
                title: qsTr("Home"),
                icon: FluentIcons.Home,
                component: "HomePage"
            },
            {
                type: "item",
                key: "about",
                title: qsTr("About"),
                icon: FluentIcons.Info,
                component: "AboutPage"
            }
        ]
    }
}
