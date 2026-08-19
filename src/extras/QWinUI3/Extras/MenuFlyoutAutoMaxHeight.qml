import QtQuick
import QWinUI3.Extras

// MenuFlyoutAutoMaxHeight — menu max-height computed from host overlay size.
//
// @notes
//   Use this when you want the menu to clamp to “a sensible portion” of the screen,
//   instead of a fixed 480px.

MenuFlyoutPresenter {
    id: root

    // Clamp menu height to a portion of host overlay height.
    property real maxHeightRatio: 0.65
    property real minPresenterContentMaxHeight: 240
    property real maxPresenterContentMaxHeight: 480

    function _hostHeight() {
        var ov = root.overlay
        if (!ov && root.Window && root.Window.window && root.Window.window.Overlay)
            ov = root.Window.window.Overlay.overlay
        if (!ov && root.parent)
            ov = root.parent
        return ov && ov.height ? ov.height : 640
    }

    onIsOpenChanged: {
        if (!root.isOpen)
            return
        if (!root.autoMaxHeight)
            return

        var h = _hostHeight()
        var candidate = h * root.maxHeightRatio
        root.presenterContentMaxHeight = Math.max(root.minPresenterContentMaxHeight,
                                                Math.min(candidate, root.maxPresenterContentMaxHeight))
    }
}

