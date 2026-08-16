import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Drawer — Fluent styled Drawer.
//
//   Drawer {
//       id: drawer
//       edge: Qt.LeftEdge
//       Label { anchors.centerIn: parent; text: qsTr("Menu") }
//   }
//   drawer.open()
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Drawer.
//   Enter/exit must animate `position` (SmoothedAnimation) — do not drive x/y/opacity
//   or the panel background fails to size and content floats over the window.

T.Drawer {
    id: control

    parent: T.Overlay.overlay

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    // Hairline inset on the open edge (WinUI / Basic style)
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

    // Animate Drawer.position (0→1). Custom x/y/opacity transitions break the panel.
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
        // Solid surface — acrylic token is too close to white and can look “empty”.
        color: Theme.bgCard
        implicitWidth: 320
        implicitHeight: 320

        // Edge stroke toward the window content
        Rectangle {
            readonly property bool horizontal: control.edge === Qt.LeftEdge
                                              || control.edge === Qt.RightEdge
            width: horizontal ? 1 : parent.width
            height: horizontal ? parent.height : 1
            color: Theme.strokeDivider
            x: control.edge === Qt.LeftEdge ? parent.width - 1 : 0
            y: control.edge === Qt.TopEdge ? parent.height - 1 : 0
        }

        // Soft elevation via a second face (avoid MultiEffect clipping issues on full-height drawers)
        Rectangle {
            z: -1
            anchors.fill: parent
            anchors.leftMargin: control.edge === Qt.LeftEdge ? 0 : -2
            anchors.rightMargin: control.edge === Qt.RightEdge ? 0 : -2
            anchors.topMargin: control.edge === Qt.TopEdge ? 0 : -2
            anchors.bottomMargin: control.edge === Qt.BottomEdge ? 0 : -2
            color: Theme.dark ? "#40000000" : "#18000000"
            visible: control.position > 0
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
