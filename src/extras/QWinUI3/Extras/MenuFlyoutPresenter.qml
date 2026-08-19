import QtQuick
import QWinUI3.Extras

// MenuFlyoutPresenter — product-friendly wrapper for MenuFlyout.
//
// @notes
//   - Ensures contentMaxHeight is set (default 480) so long menus scroll.
//   - Provides snapshotModel.freeze() hook on open.
//   - Exposes convenience popupAtGlobal(overlay, globalX, globalY).

MenuFlyout {
    id: root

    // Optional overlay host for popupAtGlobal.
    property Item overlay: null

    // Default clamp height for typical product menus.
    // (MenuFlyout height binding uses this property when > 0.)
    property real presenterContentMaxHeight: 480

    // When true, apply presenterContentMaxHeight during open.
    property bool autoMaxHeight: true

    // Optional snapshot model: calls snapshotModel.freeze() when menu opens.
    property var snapshotModel: null

    // Frozen snapshot rows for apps that care (emitted from snapshotModel.freeze()).
    signal snapshotFrozen(var frozenRows)

    // Keep MenuFlyout's own contentMaxHeight bound to our clamp.
    onIsOpenChanged: {
        if (isOpen && root.autoMaxHeight) {
            root.contentMaxHeight = root.presenterContentMaxHeight
        }
    }

    // Convenience: popup using overlay resolved from root.overlay or parent window overlay.
    function popupAtGlobal(xGlobal, yGlobal) {
        var ov = root.overlay
        if (!ov && root.Window && root.Window.window && root.Window.window.Overlay)
            ov = root.Window.window.Overlay.overlay
        if (!ov)
            ov = root.parent
        return root.popupAtGlobal(ov, xGlobal, yGlobal)
    }

    // Bridge open event to snapshot freeze.
    onOpened: {
        if (!root.snapshotModel)
            return
        if (typeof root.snapshotModel.freeze === "function") {
            var frozen = root.snapshotModel.freeze()
            root.snapshotFrozen(frozen)
        }
    }
}

