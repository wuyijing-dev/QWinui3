import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Drawer — Fluent styled Drawer.
//
//   Drawer {
//       id: drawer
//       edge: Qt.LeftEdge
//       width: Theme.dp(320)
//       title: qsTr("Menu")
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
//   Overlay size / DPI changes re-assert full-edge span.
//   title draws a pane caption; showHandle paints an edge grabber.
//   Accessible is on the background Item (Popup is not an Item).

T.Drawer {
    id: control

    parent: T.Overlay.overlay

    // Optional pane title drawn above content
    property string title: ""
    // Edge grabber affordance
    property bool showHandle: true

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    topPadding: Theme.spacingSection
                + (control.title.length ? 28 : 0)
                + (control.showHandle && control.edge === Qt.BottomEdge ? 10 : 0)
    leftPadding: Theme.spacingSection
                 + (control.showHandle && control.edge === Qt.RightEdge ? 10 : 0)
    rightPadding: Theme.spacingSection
                  + (control.showHandle && control.edge === Qt.LeftEdge ? 10 : 0)
    bottomPadding: Theme.spacingSection
                   + (control.showHandle && control.edge === Qt.TopEdge ? 10 : 0)

    modal: true
    dim: true
    interactive: true
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside

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

    Connections {
        target: control._windowOverlay
        enabled: control._windowOverlay !== null
        function onWidthChanged() { control._ensureWindowOverlayParent() }
        function onHeightChanged() { control._ensureWindowOverlayParent() }
    }

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
        implicitWidth: Theme.dp(320)
        implicitHeight: Theme.dp(480)
        radius: 0
        Accessible.role: Accessible.Pane
        Accessible.name: control.title.length ? control.title : qsTr("Drawer")

        Rectangle {
            readonly property bool horizontal: control.edge === Qt.LeftEdge
                                              || control.edge === Qt.RightEdge
            width: horizontal ? Theme.strokeHairline : parent.width
            height: horizontal ? parent.height : Theme.strokeHairline
            color: Theme.strokeDivider
            x: control.edge === Qt.LeftEdge ? parent.width - width : 0
            y: control.edge === Qt.TopEdge ? parent.height - height : 0
        }

        Text {
            visible: control.title.length > 0
            text: control.title
            font.pixelSize: Theme.fontSubtitle
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            elide: Text.ElideRight
            x: Theme.spacingSection
            y: Theme.spacingSection
            width: parent.width - Theme.spacingSection * 2
        }

        Rectangle {
            visible: control.showHandle
            radius: 2
            color: Theme.strokeControl
            width: (control.edge === Qt.LeftEdge || control.edge === Qt.RightEdge) ? 4 : 36
            height: (control.edge === Qt.LeftEdge || control.edge === Qt.RightEdge) ? 36 : 4
            x: {
                if (control.edge === Qt.LeftEdge)
                    return parent.width - width - 6
                if (control.edge === Qt.RightEdge)
                    return 6
                return (parent.width - width) / 2
            }
            y: {
                if (control.edge === Qt.TopEdge)
                    return parent.height - height - 6
                if (control.edge === Qt.BottomEdge)
                    return 6
                return (parent.height - height) / 2
            }
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
