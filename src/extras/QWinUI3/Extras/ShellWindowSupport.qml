import QtQuick
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// Shared WindowHelper install + resize border for independent shell ApplicationWindows.
// Not a window type — compose into BlankWindow / NavigationWindow / MenuStatusWindow.
Item {
    id: root

    property var targetWindow: null
    property int paradigm: WindowHelper.ParadigmStandard
    property int backdrop: WindowHelper.BackdropSolid
    property int presenter: WindowHelper.PresenterOverlapped
    property bool isAlwaysOnTop: false
    property bool autoInstall: true
    property bool extendsContentIntoTitleBar: WindowHelper.customFrame

    property bool _ready: false

    anchors.fill: parent
    z: 10000

    WindowResizeBorder {
        anchors.fill: parent
        targetWindow: root.targetWindow
        visible: WindowHelper.customFrame && !WindowHelper.nativeChrome
                 && root.extendsContentIntoTitleBar
                 && root.presenter !== WindowHelper.PresenterFullScreen
                 && root.targetWindow
        enabled: visible
    }

    function applyChrome() {
        if (!targetWindow)
            return
        WindowHelper.installParadigmEx(targetWindow, paradigm, Theme.dark, backdrop,
                                       presenter === WindowHelper.PresenterFullScreen
                                       ? WindowHelper.PresenterOverlapped
                                       : presenter,
                                       isAlwaysOnTop)
    }

    Component.onCompleted: {
        if (autoInstall)
            applyChrome()
        _ready = true
        if (autoInstall && presenter === WindowHelper.PresenterFullScreen) {
            Qt.callLater(function () {
                if (root.targetWindow)
                    WindowHelper.setPresenter(root.targetWindow, WindowHelper.PresenterFullScreen)
            })
        }
    }

    onPresenterChanged: {
        if (!_ready || !autoInstall || !targetWindow)
            return
        if (presenter === WindowHelper.PresenterFullScreen)
            Qt.callLater(function () { WindowHelper.setPresenter(targetWindow, presenter) })
        else
            WindowHelper.setPresenter(targetWindow, presenter)
    }

    onIsAlwaysOnTopChanged: {
        if (!_ready || !autoInstall || !targetWindow)
            return
        WindowHelper.setAlwaysOnTop(targetWindow, isAlwaysOnTop)
    }

    Connections {
        target: Theme
        function onDarkChanged() {
            if (root.targetWindow)
                WindowHelper.setDarkMode(root.targetWindow, Theme.dark)
        }
    }

    Connections {
        target: WindowHelper
        function onCornerPreferenceChanged() {
            if (root.targetWindow)
                WindowHelper.reapply(root.targetWindow)
        }
    }
}
