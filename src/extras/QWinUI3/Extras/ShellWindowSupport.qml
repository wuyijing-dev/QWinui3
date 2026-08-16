import QtQuick
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// ShellWindowSupport — Shared install/presenter glue for ShellWindow.
//
//   ShellWindowSupport {
//       id: shellWindowSupport
//       targetWindow: root; autoInstall: true
//   }
//
//   // --- API ---
//   // methods: applyChrome(), applyPresenter(), applyAlwaysOnTop(), centerOnScreen(),
//   //          saveGeometry(), restoreGeometry(), clearSavedGeometry()
//   // Reacts to paradigm / backdrop / presenter / isAlwaysOnTop changes.
//
// @notes
//   installParadigmEx for Standard/Dialog/Tool + presenter + always-on-top.
//   FullScreen presenter is applied after install so the HWND exists first.
//   geometryPersistenceKey → QSettings WindowGeometry/<key> via WindowHelper.

Item {
    id: root

    Accessible.ignored: true

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
    // Non-empty → save/restore target window geometry (QSettings WindowGeometry/<key>).
    property string geometryPersistenceKey: ""
    readonly property bool geometryPersistenceEnabled: geometryPersistenceKey.length > 0

    property bool _ready: false
    property bool _applying: false

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

    // Apply window chrome / backdrop / paradigm flags
    function applyChrome() {
        if (!targetWindow || _applying)
            return
        _applying = true
        const bd = WindowHelper.resolveBackdrop(backdrop)
        WindowHelper.installParadigmEx(targetWindow, paradigm, Theme.dark, bd,
                                       presenter === WindowHelper.PresenterFullScreen
                                       ? WindowHelper.PresenterOverlapped
                                       : presenter,
                                       isAlwaysOnTop)
        if (presenter === WindowHelper.PresenterFullScreen)
            WindowHelper.setPresenter(targetWindow, WindowHelper.PresenterFullScreen)
        else
            WindowHelper.setPresenter(targetWindow, presenter)
        WindowHelper.setAlwaysOnTop(targetWindow, isAlwaysOnTop)
        _applying = false
    }

    // Apply presenter only (Overlapped / FullScreen / CompactOverlay)
    function applyPresenter() {
        if (!targetWindow || _applying)
            return
        if (presenter === WindowHelper.PresenterFullScreen)
            Qt.callLater(function () {
                if (root.targetWindow)
                    WindowHelper.setPresenter(root.targetWindow, root.presenter)
            })
        else
            WindowHelper.setPresenter(targetWindow, presenter)
    }

    // Apply always-on-top flag
    function applyAlwaysOnTop() {
        if (!targetWindow || _applying)
            return
        WindowHelper.setAlwaysOnTop(targetWindow, isAlwaysOnTop)
    }

    // Center the target window on the current screen
    function centerOnScreen() {
        if (targetWindow)
            WindowHelper.centerOnScreen(targetWindow)
    }

    // Push this window's screen DPR into Theme (hairlines / diagnostics).
    function syncThemeDpi() {
        if (!targetWindow)
            return
        Theme.devicePixelRatio = WindowHelper.devicePixelRatioForWindow(targetWindow)
    }

    function saveGeometry() {
        if (geometryPersistenceEnabled && targetWindow)
            WindowHelper.saveWindowGeometry(targetWindow, geometryPersistenceKey)
    }

    function restoreGeometry() {
        if (geometryPersistenceEnabled && targetWindow)
            return WindowHelper.restoreWindowGeometry(targetWindow, geometryPersistenceKey)
        return false
    }

    function clearSavedGeometry() {
        if (geometryPersistenceEnabled)
            WindowHelper.clearWindowGeometry(geometryPersistenceKey)
    }

    Timer {
        id: geometrySaveTimer
        interval: 400
        repeat: false
        onTriggered: root.saveGeometry()
    }

    function _scheduleGeometrySave() {
        if (!_ready || !geometryPersistenceEnabled || !targetWindow)
            return
        const vis = targetWindow.visibility
        if (vis === Window.FullScreen || vis === Window.Minimized)
            return
        geometrySaveTimer.restart()
    }

    Component.onCompleted: {
        syncThemeDpi()
        if (autoInstall)
            applyChrome()
        _ready = true
        if (geometryPersistenceEnabled) {
            Qt.callLater(function () {
                if (root.targetWindow)
                    root.restoreGeometry()
            })
        }
        if (autoInstall && presenter === WindowHelper.PresenterFullScreen) {
            Qt.callLater(function () {
                if (root.targetWindow)
                    WindowHelper.setPresenter(root.targetWindow, WindowHelper.PresenterFullScreen)
            })
        }
    }

    onParadigmChanged: {
        if (_ready && autoInstall)
            applyChrome()
    }
    onBackdropChanged: {
        if (_ready && autoInstall && targetWindow)
            WindowHelper.setBackdrop(targetWindow, WindowHelper.resolveBackdrop(backdrop))
    }
    onPresenterChanged: {
        if (!_ready || !autoInstall || !targetWindow)
            return
        applyPresenter()
    }
    onIsAlwaysOnTopChanged: {
        if (!_ready || !autoInstall || !targetWindow)
            return
        applyAlwaysOnTop()
    }
    onTargetWindowChanged: syncThemeDpi()

    Connections {
        target: root.targetWindow
        enabled: root.targetWindow !== null
        function onScreenChanged() { root.syncThemeDpi() }
        function onXChanged() { root._scheduleGeometrySave() }
        function onYChanged() { root._scheduleGeometrySave() }
        function onWidthChanged() { root._scheduleGeometrySave() }
        function onHeightChanged() { root._scheduleGeometrySave() }
        function onVisibilityChanged() { root._scheduleGeometrySave() }
        function onClosing() { root.saveGeometry() }
        function onVisibleChanged() {
            if (!root._ready || !root.autoInstall || !root.targetWindow || !root.targetWindow.visible)
                return
            // First show / restore: Qt may have overwritten DWM attributes.
            Qt.callLater(function () {
                if (root.targetWindow && root.targetWindow.visible)
                    WindowHelper.reapply(root.targetWindow)
            })
        }
    }

    Connections {
        target: Theme
        // React to Theme.dark changes
        function onDarkChanged() {
            if (root.targetWindow)
                WindowHelper.setDarkMode(root.targetWindow, Theme.dark)
        }
    }

    Connections {
        target: WindowHelper
        // React to corner preference changes
        function onCornerPreferenceChanged() {
            if (root.targetWindow)
                WindowHelper.reapply(root.targetWindow)
        }
        function onScreensChanged() {
            root.syncThemeDpi()
        }
    }
}
