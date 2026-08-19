import QtQuick
import QWinUI3.Extras

// ContextMenuAtItem — helper to open a MenuFlyout from item + mouse.
//
// @notes
//   Right-click often comes from a MouseArea inside a grid/list delegate.
//   This helper uses item.mapToGlobal(mouse.x, mouse.y) to get global coordinates.

QtObject {
    id: root

    // MenuFlyout to open.
    property var menu: null

    // Optional overlay host; default uses menu.popupAtGlobal() overlay resolution.
    property Item overlay: null

    function showAtItem(targetItem, mouse) {
        if (!root.menu || !targetItem || !mouse)
            return false

        var ov = root.overlay
        if (root.overlay)
            root.menu.overlay = ov

        var p = targetItem.mapToGlobal(mouse.x, mouse.y)
        var ovResolved = ov
        if (!ovResolved) {
            var win = targetItem.window || null
            if (win && win.Overlay && win.Overlay.overlay)
                ovResolved = win.Overlay.overlay
            else if (root.menu.Window && root.menu.Window.window && root.menu.Window.window.Overlay)
                ovResolved = root.menu.Window.window.Overlay.overlay
        }

        root.menu.popupAtGlobal(ovResolved, p.x, p.y)
        return true
    }
}

