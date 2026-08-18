import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QWinUI3.Theme

// SwipeDelegate — Fluent styled SwipeDelegate.
//
//   ListView {
//       model: 3
//       delegate: SwipeDelegate {
//           text: "Row " + index
//           swipe.right: Label { text: qsTr("Delete"); padding: 12 }
//       }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls SwipeDelegate.
//   Public API is the Qt Quick Controls SwipeDelegate type; this file supplies visuals/metrics only.

T.SwipeDelegate {
    id: control

    // 0 = idle, +1 = revealing swipe.left (swipe right), -1 = revealing swipe.right (swipe left)
    property int _swipeSide: 0

    Accessible.role: Accessible.ListItem
    Accessible.name: control.text
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.navItemHeight,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 12
    spacing: 12
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    clip: true
    icon.width: 16
    icon.height: 16
    icon.color: Theme.textPrimary

    swipe.transition: Transition {
        NumberAnimation {
            duration: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }

    swipe.onPositionChanged: {
        var pos = control.swipe.position
        if (Math.abs(pos) < 0.04) {
            control._swipeSide = 0
            if (control.swipe.leftItem)
                control.swipe.leftItem.visible = true
            if (control.swipe.rightItem)
                control.swipe.rightItem.visible = true
            return
        }
        if (control._swipeSide === 0)
            control._swipeSide = pos > 0 ? 1 : -1

        if (control.swipe.leftItem)
            control.swipe.leftItem.visible = pos > 0.02 && control._swipeSide >= 0
        if (control.swipe.rightItem)
            control.swipe.rightItem.visible = pos < -0.02 && control._swipeSide <= 0
    }

    Connections {
        target: control.swipe
        function onCompleteChanged() {
            if (!control.swipe.complete) {
                control._swipeSide = 0
                if (control.swipe.leftItem)
                    control.swipe.leftItem.visible = true
                if (control.swipe.rightItem)
                    control.swipe.rightItem.visible = true
            }
        }
    }

    contentItem: Item {
        implicitWidth: label.implicitWidth
        implicitHeight: label.implicitHeight
        clip: true

        IconLabel {
            id: label
            anchors.fill: parent
            spacing: control.spacing
            mirrored: control.mirrored
            display: control.display
            alignment: Qt.AlignLeft | Qt.AlignVCenter
            icon: control.icon
            text: control.text
            font: control.font
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        }
    }

    background: Rectangle {
        implicitHeight: Theme.navItemHeight
        clip: true
        color: control.down ? Theme.fillSubtleTertiary
             : (control.hovered ? Theme.fillSubtleSecondary : Theme.bgCard)
        radius: Theme.cornerControl
        border.width: 1
        border.color: Theme.strokeCard
        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
        }
    }
}
