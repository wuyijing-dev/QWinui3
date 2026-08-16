import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// TabButton — Fluent styled TabButton.
//
//   TabBar {
//       TabButton { text: qsTr("One") }
//       TabButton { text: qsTr("Two") }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls TabButton.
//   Public API is the Qt Quick Controls TabButton type; this file supplies visuals/metrics only.

T.TabButton {
    id: control

    implicitWidth: Math.max(implicitContentWidth + leftPadding + rightPadding, 64)
    implicitHeight: 36

    padding: 10
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    contentItem: Text {
        text: control.text
        font.family: control.font.family
        font.pixelSize: control.font.pixelSize
        font.weight: control.checked ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
        color: control.enabled
             ? (control.checked ? Theme.textPrimary : Theme.textSecondary)
             : Theme.textDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }

    background: Item {
        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: control.down ? Theme.fillSubtleTertiary
                 : (control.hovered && !control.checked ? Theme.fillSubtleSecondary : "transparent")
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 2
            radius: 1
            color: Theme.accent
            opacity: control.checked ? 1 : 0
            scale: control.checked ? 1 : 0.4
            transformOrigin: Item.Bottom
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }
    }
}
