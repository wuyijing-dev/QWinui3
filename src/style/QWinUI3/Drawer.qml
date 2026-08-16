import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Drawer — Fluent styled Drawer.
//
//   Drawer {
//       id: drawer
//       edge: Qt.LeftEdge
//       width: 320
//       Label { text: qsTr("Menu") }
//   }
//   drawer.open()
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Drawer.
//   Qt Drawer only slides via `position` — it does not auto-set height/width to the
//   window edge. Side drawers bind height to Overlay; top/bottom bind width.
//   Enter/exit must use SmoothedAnimation on `position` (not x/y/opacity).
//   Parent must stay on the window Overlay: page-local overlay slots (e.g. Gallery
//   CatalogPage) reparent children and would otherwise clip the drawer to the pane.

T.Drawer {
    id: control

    parent: T.Overlay.overlay

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    topPadding: control.edge === Qt.BottomEdge ? 1 : Theme.spacingSection
    leftPadding: control.edge === Qt.RightEdge ? 1 : Theme.spacingSection
    rightPadding: control.edge === Qt.LeftEdge ? 1 : Theme.spacingSection
    bottomPadding: control.edge === Qt.TopEdge ? 1 : Theme.spacingSection

    modal: true
    dim: true
    interactive: true
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    // Window overlay attached to this drawer (null until the control is in a Window).
    readonly property Item _windowOverlay: T.Overlay.overlay

    // Full-edge span. Value reads control._windowOverlay so Overlay is not attached to Binding.
    Binding {
        target: control
        property: "height"
        when: (control.edge === Qt.LeftEdge || control.edge === Qt.RightEdge)
              && control._windowOverlay && control._windowOverlay.height > 0
        value: control._windowOverlay.height
    }
    Binding {
        target: control
        property: "width"
        when: (control.edge === Qt.TopEdge || control.edge === Qt.BottomEdge)
              && control._windowOverlay && control._windowOverlay.width > 0
        value: control._windowOverlay.width
    }

    // Keep parent on the window Overlay if a host slot (CatalogPage.overlay) reparents us.
    function _ensureWindowOverlayParent() {
        var o = control._windowOverlay
        if (o && control.parent !== o)
            control.parent = o
    }

    Component.onCompleted: control._ensureWindowOverlayParent()
    onAboutToShow: control._ensureWindowOverlayParent()
    on_WindowOverlayChanged: control._ensureWindowOverlayParent()

    enter: Transition {
        SmoothedAnimation {
            velocity: 5
        }
    }
    exit: Transition {
        SmoothedAnimation {
            velocity: 5
        }
    }

    background: Rectangle {
        color: Theme.bgCard
        implicitWidth: 320
        implicitHeight: 480
        radius: 0

        Rectangle {
            readonly property bool horizontal: control.edge === Qt.LeftEdge
                                              || control.edge === Qt.RightEdge
            width: horizontal ? 1 : parent.width
            height: horizontal ? parent.height : 1
            color: Theme.strokeDivider
            x: control.edge === Qt.LeftEdge ? parent.width - 1 : 0
            y: control.edge === Qt.TopEdge ? parent.height - 1 : 0
        }
    }

    T.Overlay.modal: Rectangle {
        color: Theme.bgSmoke
        Behavior on opacity {
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }

    T.Overlay.modeless: Rectangle {
        color: Theme.dark ? "#33000000" : "#1A000000"
        Behavior on opacity {
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
