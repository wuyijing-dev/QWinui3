import QtQuick
import QWinUI3.Extras

// RightClickAnchorHelper — compute global anchor point for right-click menus.
//
// @notes
//   This is a tiny helper aimed at grid/list delegates where apps repeatedly
//   need mapToGlobal() plumbing.

QtObject {
    id: root

    // Returns global point for a mouse event within targetItem coordinates.
    function globalPointForMouse(targetItem, mouse) {
        if (!targetItem || !mouse)
            return Qt.point(0, 0)
        return targetItem.mapToGlobal(mouse.x, mouse.y)
    }

    // Open a MenuFlyout at cursor global coordinates.
    function popupFlyoutAt(menu, targetItem, mouse, overlay) {
        if (!menu || !targetItem || !mouse)
            return false
        var ov = overlay
        if (!ov) {
            var win = targetItem.window || null
            if (win && win.Overlay && win.Overlay.overlay)
                ov = win.Overlay.overlay
        }
        var p = globalPointForMouse(targetItem, mouse)
        menu.popupAtGlobal(ov, p.x, p.y)
        return true
    }
}

