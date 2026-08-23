import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QWinUI3.Theme

// SwitchDelegate — Fluent styled SwitchDelegate.
//
//   ListView {
//       model: 3
//       delegate: SwitchDelegate {
//           text: "Flag " + index
//           width: ListView.view.width
//       }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls SwitchDelegate.
//   Public API is the Qt Quick Controls SwitchDelegate type; this file supplies visuals/metrics only.

T.SwitchDelegate {
    id: control


    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text
    Accessible.checkable: true
    Accessible.checked: control.checked
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.navItemHeight,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: 10
    leftPadding: 12
    rightPadding: 12
    spacing: 12
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    icon.width: 16
    icon.height: 16
    icon.color: Theme.textPrimary

    indicator: Item {
        implicitWidth: Theme.switchWidth
        implicitHeight: Theme.switchHeight
        // Same side as Check/Radio delegates: leading edge, vertically centered.
        x: control.mirrored ? control.width - width - control.rightPadding
                            : control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            border.width: control.checked ? 0 : 1
            border.color: Theme.strokeControlStrong
            color: {
                if (control.checked)
                    return control.enabled ? Theme.accent : (Theme.dark ? "#28FFFFFF" : "#37000000")
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.hovered)
                    return Theme.fillSubtleSecondary
                return Theme.dark ? "#19000000" : "#06000000"
            }
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                x: control.visualPosition * (parent.width - width)
                anchors.verticalCenter: parent.verticalCenter
                width: control.down ? 12 : 14
                height: width
                radius: width / 2
                color: control.checked
                       ? (Theme.dark ? "#000000" : "#FFFFFF")
                       : Theme.textSecondary
                scale: control.hovered && !control.down ? 1.05 : 1

                Behavior on x {
                    enabled: !control.down && !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on width {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }
        }
    }

    contentItem: IconLabel {
        // Reserve space on the same side as the indicator (leading).
        leftPadding: control.mirrored ? 0
                     : (control.indicator ? control.indicator.width + control.spacing : 0)
        rightPadding: control.mirrored
                      ? (control.indicator ? control.indicator.width + control.spacing : 0)
                      : 0
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        icon: control.icon
        text: control.text
        font: control.font
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    }

    background: Item {
        implicitHeight: Theme.navItemHeight
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            radius: Theme.cornerControl
            color: control.down ? Theme.fillSubtleTertiary
                 : (control.hovered ? Theme.fillSubtleSecondary : "transparent")
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
        FocusStroke {
            anchors.fill: parent
            anchors.margins: 2
            show: control.visualFocus
        }
    }
}
