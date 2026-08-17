import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// StandardWindow — Platform ApplicationWindow + PlatformTitleBar host.
//
//   StandardWindow {
//       id: standardWindow
//       title: qsTr("Gallery")
//       backdrop: WindowHelper.BackdropSolid
//   }
//
//   // --- API ---
//   // methods: applyChrome(), setPresenterKind(kind),
//   //          saveGeometry(), restoreGeometry(), clearSavedGeometry()
//   // standardWindow.applyChrome()
//   // standardWindow.setPresenterKind(kind)
//   // inherits ApplicationWindow (+ Qt Quick Controls base API)
//
// @notes
//   Low-level AppWindow host (PlatformTitleBar + WindowHelper).
//   Prefer ShellWindow family for product UI; use this for presenter/backdrop experiments.
//   Title-bar slots: use Extras StandardTitleChrome as header (see docs/components/TitleBar.md).
//   geometryPersistenceKey → persist size/pos/maximized (see docs/window-helper.md).
//   effectiveBackdrop / WindowHelper.resolveBackdrop keep Linux shells opaque when Mica is requested.
//   Runtime: backdrop/paradigm changes, first-show reapply, DPI → Theme + hit-test (see docs/window-chrome.md).
//   See docs/window-appwindow.md and docs/window-helper.md.

ApplicationWindow {
    id: root

    // Window paradigm
    property int paradigm: WindowHelper.ParadigmStandard
    // Backdrop kind
    property int backdrop: WindowHelper.BackdropSolid
    // Presenter kind
    property int presenter: WindowHelper.PresenterOverlapped
    // Title bar height option
    property int preferredHeightOption: WindowHelper.TitleBarHeightTall
    // Auto-apply WindowHelper chrome on complete
    property bool autoInstall: true
    // Show caption buttons
    property bool showCaptionButtons: WindowHelper.customFrame
    // Show minimize
    property bool showMinimize: true
    // Show maximize
    property bool showMaximize: true
    // Show close
    property bool showClose: true
    // Always on top
    property bool isAlwaysOnTop: false
    // Documents frameless / custom chrome (WinUI ExtendsContentIntoTitleBar).
    property bool extendsContentIntoTitleBar: WindowHelper.customFrame
    // WindowChrome / PlatformTitleBar host
    property alias chrome: platformTitle
    property bool _chromeReady: false
    // Platform-safe backdrop (Linux coerces Mica/Acrylic → Solid so the window is not hollow).
    readonly property int effectiveBackdrop: WindowHelper.resolveBackdrop(backdrop)

    // Non-empty → save/restore frame geometry via WindowHelper (QSettings WindowGeometry/<key>).
    property string geometryPersistenceKey: ""
    readonly property bool geometryPersistenceEnabled: geometryPersistenceKey.length > 0
    // Copy OS a11y / color scheme into Theme (1.69). Same as ShellWindow — not Gallery-only.
    property bool syncThemeFromSystem: true
    property alias themeSync: themeSync

    // CONSTANT flags only (recommendedFlags has no notify). Never bind flags to
    // paradigm/presenter/isAlwaysOnTop — that fights WindowHelper.setFlags() and
    // recreates the HWND in a CreateWindowEx failure loop on Windows.
    flags: WindowHelper.recommendedFlags

    readonly property int shellPadding: 0
    readonly property real shellContentInset: WindowHelper.shellContentInset(root)

    color: WindowHelper.clientShellDecoration ? "transparent" : Theme.bgLayer
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    header: PlatformTitleBar {
        id: platformTitle
        targetWindow: root
        showCaptionButtons: root.showCaptionButtons && root.extendsContentIntoTitleBar
        showMinimize: root.showMinimize
        showMaximize: root.showMaximize
        showClose: root.showClose
        preferredHeightOption: root.preferredHeightOption
    }

    background: WindowShellDecoration {
        targetWindow: root
    }

    WindowResizeBorder {
        anchors.fill: parent
        targetWindow: root
        visible: WindowHelper.customFrame && !WindowHelper.nativeChrome
                 && root.extendsContentIntoTitleBar
                 && root.presenter !== WindowHelper.PresenterFullScreen
        enabled: visible
        z: 10000
    }

    // Apply window chrome / backdrop
    function applyChrome() {
        WindowHelper.installParadigmEx(root, paradigm, Theme.dark, root.effectiveBackdrop,
                                       presenter === WindowHelper.PresenterFullScreen
                                       ? WindowHelper.PresenterOverlapped
                                       : presenter,
                                       isAlwaysOnTop)
    }

    // Set AppWindow presenter kind
    function setPresenterKind(kind) {
        presenter = kind
        if (_chromeReady)
            WindowHelper.setPresenter(root, kind)
    }

    function _syncThemeDpi() {
        Theme.devicePixelRatio = WindowHelper.devicePixelRatioForWindow(root)
    }

    function saveGeometry() {
        if (geometryPersistenceEnabled)
            WindowHelper.saveWindowGeometry(root, geometryPersistenceKey)
    }

    function restoreGeometry() {
        if (geometryPersistenceEnabled)
            return WindowHelper.restoreWindowGeometry(root, geometryPersistenceKey)
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
        if (!_chromeReady || !geometryPersistenceEnabled)
            return
        if (visibility === Window.FullScreen || visibility === Window.Minimized)
            return
        geometrySaveTimer.restart()
    }

    onScreenChanged: root._syncThemeDpi()
    onXChanged: root._scheduleGeometrySave()
    onYChanged: root._scheduleGeometrySave()
    onWidthChanged: root._scheduleGeometrySave()
    onHeightChanged: root._scheduleGeometrySave()
    onVisibilityChanged: root._scheduleGeometrySave()

    onClosing: root.saveGeometry()

    ThemeSync {
        id: themeSync
        targetWindow: root
        enabled: root.syncThemeFromSystem
    }

    Component.onCompleted: {
        root._syncThemeDpi()
        if (autoInstall)
            applyChrome()
        _chromeReady = true

        if (geometryPersistenceEnabled) {
            Qt.callLater(function () {
                if (root) {
                    root.restoreGeometry()
                    Qt.callLater(function () {
                        if (root.chrome && root.chrome.reportHitTest)
                            root.chrome.reportHitTest()
                    })
                }
            })
        }

        if (autoInstall && presenter === WindowHelper.PresenterFullScreen) {
            Qt.callLater(function () {
                if (root)
                    WindowHelper.setPresenter(root, WindowHelper.PresenterFullScreen)
            })
        }
    }

    onBackdropChanged: {
        if (!_chromeReady || !autoInstall)
            return
        WindowHelper.setBackdrop(root, root.effectiveBackdrop)
    }

    onParadigmChanged: {
        if (!_chromeReady || !autoInstall)
            return
        applyChrome()
    }

    onPresenterChanged: {
        if (!_chromeReady || !autoInstall)
            return
        if (presenter === WindowHelper.PresenterFullScreen)
            Qt.callLater(function () { WindowHelper.setPresenter(root, presenter) })
        else
            WindowHelper.setPresenter(root, presenter)
    }

    onIsAlwaysOnTopChanged: {
        if (!_chromeReady || !autoInstall)
            return
        WindowHelper.setAlwaysOnTop(root, isAlwaysOnTop)
    }

    // Qt/DWM may clear system backdrop on first show — re-install after the HWND is live.
    onVisibleChanged: {
        if (!_chromeReady || !autoInstall || !visible)
            return
        Qt.callLater(function () {
            if (root && root.visible)
                WindowHelper.reapply(root)
        })
    }

    Connections {
        target: Theme
        function onDarkChanged() {
            WindowHelper.setDarkMode(root, Theme.dark)
        }
    }

    Connections {
        target: WindowHelper
        function onCornerPreferenceChanged() {
            WindowHelper.reapply(root)
        }
        function onScreensChanged() {
            root._syncThemeDpi()
            if (root.chrome && root.chrome.reportHitTest)
                root.chrome.reportHitTest()
        }
    }
}
