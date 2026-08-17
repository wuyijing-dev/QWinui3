import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery-aligned shell: StandardWindow + PlatformTitleBar/TitleBar + NavigationView.
// Patterns: docs/navigation.md (1.27). BackdropSolid — docs/window-chrome.md.

StandardWindow {
    id: window
    width: 1100
    height: 720
    visible: true
    title: qsTr("Nav + Settings example")
    backdrop: WindowHelper.BackdropSolid

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

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
            subtitle: qsTr("NavigationView · docs/navigation.md")
            symbol: FluentIcons.GlobalNavButton
            isPaneToggleButtonVisible: true
            isBackButtonVisible: nav.canGoBack
            isBackButtonEnabled: nav.canGoBack
            onPaneToggleRequested: nav.paneOpen = !nav.paneOpen
            onBackRequested: nav.navigateBack()
            onWidthChanged: platformTitle.reportHitTest()
            onHeightChanged: platformTitle.reportHitTest()
        }
    }

    Component.onCompleted: Qt.callLater(function () { platformTitle.reportHitTest() })

    WindowShellContentClip {
        anchors.fill: parent
        targetWindow: window

        NavigationView {
            id: nav
            anchors.fill: parent
            headerText: qsTr("NavSettings")
            footerText: qsTr("Settings")
            footerSymbol: FluentIcons.Settings
            footerComponent: "SettingsPage"
            pageModule: "QWinUI3.Examples.NavSettings"
            currentKey: "home"
            paneDisplayMode: "auto"
            pageTransition: "slide"
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
}
