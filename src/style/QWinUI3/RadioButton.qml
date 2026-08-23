import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// RadioButton — Fluent styled RadioButton.
//
//   RadioButton {
//       id: radio
//       text: qsTr("Option A")
//       checked: true
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls RadioButton.
//   Public API is the Qt Quick Controls RadioButton type; this file supplies visuals/metrics only.

T.RadioButton {
    id: control


    Accessible.role: Accessible.RadioButton
    Accessible.name: control.text
    Accessible.checkable: true
    Accessible.checked: control.checked
    Accessible.onToggleAction: if (control.enabled) control.click()
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    spacing: Theme.spacing
    padding: 0
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    PointerCursor { shape: Qt.PointingHandCursor }

    indicator: Item {
        implicitWidth: Theme.radioSize
        implicitHeight: Theme.radioSize
        x: control.leftPadding
        y: parent.height / 2 - height / 2

        Rectangle {
            id: outer
            anchors.fill: parent
            radius: width / 2
            color: {
                if (control.checked) {
                    if (!control.enabled)
                        return Theme.dark ? "#28FFFFFF" : "#37000000"
                    if (control.down)
                        return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.2) : Qt.rgba(1, 1, 1, 0.2))
                    if (control.hovered)
                        return Qt.tint(Theme.accent, Theme.dark ? Qt.rgba(0, 0, 0, 0.1) : Qt.rgba(1, 1, 1, 0.1))
                    return Theme.accent
                }
                if (!control.enabled)
                    return Theme.fillControlDisabled
                if (control.down)
                    return Theme.fillControlTertiary
                if (control.hovered)
                    return Theme.fillControlSecondary
                return Theme.bgControlRest
            }
            border.width: control.checked ? 0 : 1
            border.color: {
                if (control.checked)
                    return "transparent"
                if (!control.enabled)
                    return Theme.strokeControl
                if (control.hovered)
                    return Theme.accent
                return Theme.strokeControlStrong
            }
            scale: control.down ? 0.9 : 1

            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on border.width {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 10
            height: 10
            radius: 5
            scale: {
                if (!control.checked)
                    return 0
                if (control.down)
                    return 0.8
                if (control.hovered)
                    return 1.15
                return 1
            }
            opacity: control.checked ? 1 : 0
            visible: opacity > 0.01 || scale > 0.01

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: Theme.dark ? "#12FFFFFF" : "#0F000000"
                }
                GradientStop {
                    position: 0.95
                    color: Theme.dark ? "#18FFFFFF" : "#29000000"
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 2
                height: parent.height - 2
                radius: height / 2
                color: Theme.dark ? "#000000" : "#FFFFFF"
            }

            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on opacity {
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
            frameRadius: width / 2
        }
    }

    contentItem: Text {
        leftPadding: control.indicator.width + control.spacing
        text: control.text
        font: control.font
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        verticalAlignment: Text.AlignVCenter
    }
}
