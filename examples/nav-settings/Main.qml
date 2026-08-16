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
        footerIcon: "\uE713"
        footerComponent: "SettingsPage"
        pageModule: "QWinUI3.Examples.NavSettings"
        currentKey: "home"
        model: [
            {
                type: "item",
                key: "home",
                title: qsTr("Home"),
                icon: "\uE80F",
                component: "HomePage"
            },
            {
                type: "item",
                key: "about",
                title: qsTr("About"),
                icon: "\uE946",
                component: "AboutPage"
            }
        ]
    }
}
