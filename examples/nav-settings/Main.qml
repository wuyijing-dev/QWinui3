import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery-aligned shell: StandardWindow + PlatformTitleBar/TitleBar + NavigationView.
// BackdropSolid keeps Windows DWM and Linux CSD predictable (see docs/window-chrome.md).

StandardWindow {
    id: window
    width: 1100
    height: 720
    visible: true
    title: qsTr("Nav + Settings example")
    backdrop: WindowHelper.BackdropSolid

    header: PlatformTitleBar {
        id: platformTitle
        targetWindow: window
        showCaptionButtons: window.showCaptionButtons
        showMinimize: window.showMinimize
        showMaximize: window.showMaximize
        showClose: window.showClose
        preferredHeightOption: window.preferredHeightOption

        TitleBar {
            anchors.fill: parent
            embedded: true
            dragWindow: window
            useSystemMove: true
            title: window.title
            subtitle: qsTr("NavigationView + Settings")
            symbol: FluentIcons.GlobalNavButton
            isPaneToggleButtonVisible: true
            isBackButtonVisible: false
            onPaneToggleRequested: nav.paneOpen = !nav.paneOpen
            onWidthChanged: platformTitle.reportHitTest()
            onHeightChanged: platformTitle.reportHitTest()
        }
    }

    Component.onCompleted: Qt.callLater(function () { platformTitle.reportHitTest() })

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
                symbol: FluentIcons.Home,
                component: "HomePage"
            },
            {
                type: "item",
                key: "about",
                title: qsTr("About"),
                symbol: FluentIcons.Info,
                component: "AboutPage"
            }
        ]
    }
}
