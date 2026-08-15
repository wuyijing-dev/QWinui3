import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// DelayButton — Fluent styled DelayButton.
//
//   DelayButton { text: qsTr("Hold") }

T.DelayButton {
    id: control

    implicitWidth: Math.max(Theme.controlMinWidth,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Theme.controlHeight

    topPadding: Theme.paddingControlV
    bottomPadding: Theme.paddingControlV
    leftPadding: Theme.paddingControlH
    rightPadding: Theme.paddingControlH
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    delay: 1000

    transition: Transition {
        NumberAnimation {
            duration: control.delay * (control.pressed ? 1 : 0.3)
        }
    }

    contentItem: Item {
        Text {
            anchors.centerIn: parent
            text: control.text
            font: control.font
            color: control.enabled ? Theme.textPrimary : Theme.textDisabled
            scale: control.down && !Theme.reducedMotion ? 0.98 : 1
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }

    background: Rectangle {
        id: bg
        radius: Theme.cornerControl
        color: {
            if (!control.enabled)
                return Theme.fillControlDisabled
            if (control.down)
                return Theme.fillControlTertiary
            if (control.hovered)
                return Theme.fillControlSecondary
            return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
        }
        border.width: 1
        border.color: Theme.strokeControl

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }

        // Rounded host: Rectangle.clip is axis-aligned only, so the fill itself
        // must carry the same radius (and stay inside the border).
        Rectangle {
            id: progressFill
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 1
            width: Math.max(0, (parent.width - anchors.margins * 2) * control.progress)
            radius: Math.max(0, bg.radius - 1)
            color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.38)

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 1
                anchors.bottomMargin: 1
                width: 2
                radius: 1
                color: Theme.accent
                opacity: control.progress > 0.02 && control.progress < 1 ? 0.9 : 0
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
        }
    }
}
