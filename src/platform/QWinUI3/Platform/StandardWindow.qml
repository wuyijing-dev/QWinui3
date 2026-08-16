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
//   // methods: applyChrome(), setPresenterKind(kind)
//   // standardWindow.applyChrome()
//   // standardWindow.setPresenterKind(kind)
//   // inherits ApplicationWindow (+ Qt Quick Controls base API)
//
// @notes
//   Low-level AppWindow host (PlatformTitleBar + WindowHelper).
//   Prefer ShellWindow family for product UI; use this for presenter/backdrop experiments.
//   effectiveBackdrop / WindowHelper.resolveBackdrop keep Linux shells opaque when Mica is requested.
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

    // CONSTANT flags only (recommendedFlags has no notify). Never bind flags to
    // paradigm/presenter/isAlwaysOnTop — that fights WindowHelper.setFlags() and
    // recreates the HWND in a CreateWindowEx failure loop on Windows.
    flags: WindowHelper.recommendedFlags

    color: Theme.bgLayer
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

    background: Rectangle {
        color: (root.effectiveBackdrop === WindowHelper.BackdropSolid
                || root.effectiveBackdrop === WindowHelper.BackdropNone)
               ? Theme.bgLayer
               : "transparent"
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

    onScreenChanged: root._syncThemeDpi()

    Component.onCompleted: {
        root._syncThemeDpi()
        if (autoInstall)
            applyChrome()
        _chromeReady = true

        if (autoInstall && presenter === WindowHelper.PresenterFullScreen) {
            Qt.callLater(function () {
                if (root)
                    WindowHelper.setPresenter(root, WindowHelper.PresenterFullScreen)
            })
        }
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
        }
    }
}
