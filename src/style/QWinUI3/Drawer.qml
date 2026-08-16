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

    // Full-edge span (see Qt Drawer docs — height/width are not assigned by QQuickDrawer).
    Binding {
        target: control
        property: "height"
        when: (control.edge === Qt.LeftEdge || control.edge === Qt.RightEdge)
              && T.Overlay.overlay && T.Overlay.overlay.height > 0
        value: T.Overlay.overlay.height
    }
    Binding {
        target: control
        property: "width"
        when: (control.edge === Qt.TopEdge || control.edge === Qt.BottomEdge)
              && T.Overlay.overlay && T.Overlay.overlay.width > 0
        value: T.Overlay.overlay.width
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
        Accessible.role: Accessible.Pane
        Accessible.name: qsTr("Drawer")
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
