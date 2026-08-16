import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// MenuFlyout — Elevated Menu with showAt / isOpen helpers.
//
//   MenuFlyout {
//       id: menuFlyout
//       MenuFlyoutItem { text: qsTr("Copy"); symbol: FluentIcons.Copy }
//   }
//
//   // --- API ---
//   // methods: openMenu(), closeMenu(), showAt(targetItem, offsetX, offsetY), hide()
//   // menuFlyout.openMenu()
//   // menuFlyout.closeMenu()
//   // menuFlyout.showAt(targetItem, offsetX, offsetY)
//   // menuFlyout.hide()
//   // inherits Menu (+ Qt Quick Controls base API)
//
// @notes
//   Menu-styled Flyout; host MenuFlyoutItem / Separator / Header children.
//   contentMaxHeight (WinUI MenuFlyoutPresenter.MaxHeight) enables scroll when content is taller.
//   shouldConstrainToRootBounds clamps into the window overlay (default true).
//   title comes from Menu (FINAL) — set title: for Accessible.name.

Menu {
    id: root

    // Popup / flyout placement
    property int placement: Qt.AlignBottom
    // Preferred flyout placement
    property alias preferredPlacement: root.placement
    // Close on outside click / Esc
    property bool isLightDismissEnabled: true
    // Open / visible state
    property bool isOpen: false
    // Accessible / chrome name uses inherited Menu.title (FINAL — do not redeclare)
    // WinUI MaxHeight — 0 = natural height; >0 clamps and scrolls
    // (cannot redeclare Popup.maxHeight which is FINAL)
    property real contentMaxHeight: 0
    // WinUI ShouldConstrainToRootBounds — clamp popup into window overlay
    property bool shouldConstrainToRootBounds: true

    padding: 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    // Clamp height so the styled ListView becomes interactive / scrollable.
    Binding on height {
        when: root.contentMaxHeight > 0
        value: {
            var natural = root.contentItem
                          ? (root.contentItem.implicitHeight + root.topPadding + root.bottomPadding)
                          : root.implicitHeight
            return Math.min(Math.max(natural, 40), root.contentMaxHeight)
        }
    }

    closePolicy: isLightDismissEnabled
                 ? (Popup.CloseOnEscape | Popup.CloseOnPressOutside)
                 : Popup.CloseOnEscape

    onIsOpenChanged: {
        if (isOpen)
            open()
        else if (visible)
            close()
    }
    onOpened: isOpen = true
    onClosed: isOpen = false

    // Open the menu
    function openMenu() { isOpen = true }
    // Dismiss the menu
    function closeMenu() { isOpen = false }

    transformOrigin: {
        switch (placement) {
        case Qt.AlignTop: return Item.Bottom
        case Qt.AlignLeft: return Item.Right
        case Qt.AlignRight: return Item.Left
        default: return Item.Top
        }
    }

    // Show anchored at the given point or item
    function showAt(targetItem, offsetX, offsetY) {
        if (!targetItem) {
            isOpen = true
            return
        }
        var ox = offsetX === undefined ? 0 : offsetX
        var oy = offsetY === undefined ? 0 : offsetY
        var px = ox
        var py = oy
        switch (placement) {
        case Qt.AlignTop:
            py = -implicitHeight + oy
            break
        case Qt.AlignRight:
            px = targetItem.width + 4 + ox
            py = oy
            break
        case Qt.AlignLeft:
            px = -implicitWidth - 4 + ox
            py = oy
            break
        default:
            py = targetItem.height + 4 + oy
            break
        }
        popup(targetItem, px, py)
        isOpen = true
        if (shouldConstrainToRootBounds)
            Qt.callLater(root._constrainToRootBounds)
    }

    function _constrainToRootBounds() {
        if (!shouldConstrainToRootBounds || !visible)
            return
        var win = root.Window.window
        var host = (win && win.Overlay && win.Overlay.overlay) ? win.Overlay.overlay : root.parent
        if (!host)
            return
        var margin = 8
        var p = root.mapToItem(host, 0, 0)
        var w = root.width
        var h = root.height
        var nx = Math.max(margin, Math.min(p.x, host.width - w - margin))
        var ny = Math.max(margin, Math.min(p.y, host.height - h - margin))
        root.x += (nx - p.x)
        root.y += (ny - p.y)
    }

    // Hide the control
    function hide() {
        isOpen = false
    }

    background: ElevatedChrome {
        implicitWidth: 180
        Accessible.role: Accessible.PopupMenu
        Accessible.name: root.title.length ? root.title : qsTr("Menu")
        implicitHeight: 40
        color: Theme.bgCardElevated
        radius: Theme.cornerOverlay
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 8
        shadowOpacity: Theme.dark ? 0.34 : 0.18
        shadowBlur: 1.0
        blurMax: 32
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            property: "scale"
            from: 0.96; to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1; to: 0
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
        NumberAnimation {
            property: "scale"
            from: 1; to: 0.96
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingExit
        }
    }
}
