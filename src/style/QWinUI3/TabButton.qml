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


    Accessible.role: Accessible.PageTab
    Accessible.name: control.text
    Accessible.checkable: true
    Accessible.checked: control.checked
    implicitWidth: Math.max(implicitContentWidth + leftPadding + rightPadding, 64)
    implicitHeight: 36

    padding: 10
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    PointerCursor { shape: Qt.PointingHandCursor }

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
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }
    }

    background: Item {
        scale: control.down && !Theme.reducedMotion ? 0.98 : 1
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: control.down ? Theme.fillSubtleTertiary
                 : (control.hovered && !control.checked ? Theme.fillSubtleSecondary : "transparent")
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.motionMs("fast")
                    easing.type: Theme.motionEasing("standard")
                }
            }
        }
        Rectangle {
            id: underline
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: control.checked ? parent.width - 8 : Math.min(parent.width * 0.4, 24)
            height: 2
            radius: 1
            color: Theme.accent
            opacity: control.checked || control.hovered ? (control.checked ? 1 : 0.35) : 0

            Behavior on width {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.motionMs("normal")
                    easing.type: Theme.motionEasing("enter")
                }
            }
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.motionMs("normal")
                    easing.type: Theme.motionEasing("standard")
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
