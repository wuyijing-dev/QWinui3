import QtQuick
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// ShellWindowSupport — Shared install/presenter glue for ShellWindow.
//
//   ShellWindowSupport { targetWindow: root; autoInstall: true }

Item {
    id: root

    // Window this chrome is attached to
    property var targetWindow: null
    // WindowHelper.Paradigm* kind
    property int paradigm: WindowHelper.ParadigmStandard
    // WindowHelper.Backdrop* material
    property int backdrop: WindowHelper.BackdropSolid
    // WindowHelper.Presenter* kind
    property int presenter: WindowHelper.PresenterOverlapped
    // Keep window above others
    property bool isAlwaysOnTop: false
    // Auto-apply WindowHelper chrome on complete
    property bool autoInstall: true
    // Custom frame / extend content
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

    // Apply Chrome
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
        // On Dark Changed
        function onDarkChanged() {
            if (root.targetWindow)
                WindowHelper.setDarkMode(root.targetWindow, Theme.dark)
        }
    }

    Connections {
        target: WindowHelper
        // On Corner Preference Changed
        function onCornerPreferenceChanged() {
            if (root.targetWindow)
                WindowHelper.reapply(root.targetWindow)
        }
    }
}
