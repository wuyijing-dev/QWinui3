import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// Fluent primary application window — WinUI Window + AppWindow host.
// Body content uses ApplicationWindow's default content area; put chrome in `header`
// (or assign children to `chrome` via parent:) — do not steal the default property.
ApplicationWindow {
    id: root

    property int paradigm: WindowHelper.ParadigmStandard
    property int backdrop: WindowHelper.BackdropSolid
    property int presenter: WindowHelper.PresenterOverlapped
    property int preferredHeightOption: WindowHelper.TitleBarHeightTall
    property bool autoInstall: true
    property bool showCaptionButtons: WindowHelper.customFrame
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showClose: true
    property bool isAlwaysOnTop: false
    // Documents frameless / custom chrome (WinUI ExtendsContentIntoTitleBar).
    property bool extendsContentIntoTitleBar: WindowHelper.customFrame
    property alias chrome: platformTitle
    property bool _chromeReady: false

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
        color: (root.backdrop === WindowHelper.BackdropSolid
                || root.backdrop === WindowHelper.BackdropNone)
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

    function applyChrome() {
        WindowHelper.installParadigmEx(root, paradigm, Theme.dark, backdrop,
                                       presenter === WindowHelper.PresenterFullScreen
                                       ? WindowHelper.PresenterOverlapped
                                       : presenter,
                                       isAlwaysOnTop)
    }

    function setPresenterKind(kind) {
        presenter = kind
        if (_chromeReady)
            WindowHelper.setPresenter(root, kind)
    }

    Component.onCompleted: {
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
    }
}
