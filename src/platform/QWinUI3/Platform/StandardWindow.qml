import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// Fluent primary application window paradigm (WinUI AppWindow-style host).
// Body content uses ApplicationWindow's default content area; put chrome in `header`
// (or assign children to `chrome` via parent:) — do not steal the default property.
ApplicationWindow {
    id: root

    property int paradigm: WindowHelper.ParadigmStandard
    property int backdrop: WindowHelper.BackdropSolid
    property bool autoInstall: true
    property bool showCaptionButtons: WindowHelper.customFrame
    property bool showMinimize: true
    property bool showMaximize: true
    property alias chrome: platformTitle

    flags: WindowHelper.flagsForParadigm(paradigm)
    color: Theme.bgLayer
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    header: PlatformTitleBar {
        id: platformTitle
        targetWindow: root
        showCaptionButtons: root.showCaptionButtons
        showMinimize: root.showMinimize
        showMaximize: root.showMaximize
    }

    background: Rectangle {
        // Solid opaque fill avoids unnecessary alpha compositing when backdrop is solid.
        color: (root.backdrop === WindowHelper.BackdropSolid
                || root.backdrop === WindowHelper.BackdropNone)
               ? Theme.bgLayer
               : "transparent"
    }

    WindowResizeBorder {
        anchors.fill: parent
        targetWindow: root
        visible: WindowHelper.customFrame && !WindowHelper.nativeChrome
        enabled: visible
        z: 10000
    }

    function applyChrome() {
        WindowHelper.installParadigm(root, paradigm, Theme.dark, backdrop)
    }

    Component.onCompleted: {
        if (autoInstall)
            applyChrome()
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
