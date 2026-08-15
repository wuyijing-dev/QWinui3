import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QWinUI3.Theme

T.SwipeDelegate {
    id: control

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
        SmoothedAnimation {
            velocity: 3
            easing.type: Theme.easingStandard
        }
    }

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        icon: control.icon
        text: control.text
        font: control.font
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    }

    background: Rectangle {
        implicitHeight: Theme.navItemHeight
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
