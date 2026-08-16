import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QWinUI3.Theme

// RadioDelegate — Fluent styled RadioDelegate.
//
//   ListView {
//       model: 3
//       delegate: RadioDelegate {
//           text: "Choice " + index
//           width: ListView.view.width
//       }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls RadioDelegate.
//   Public API is the Qt Quick Controls RadioDelegate type; this file supplies visuals/metrics only.

T.RadioDelegate {
    id: control


    Accessible.role: Accessible.RadioButton
    Accessible.name: control.text
    Accessible.checkable: true
    Accessible.checked: control.checked
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.navItemHeight,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 10
    leftPadding: 12
    rightPadding: 12
    spacing: 12
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    icon.width: 16
    icon.height: 16
    icon.color: Theme.textPrimary

    indicator: Item {
        implicitWidth: Theme.radioSize
        implicitHeight: Theme.radioSize
        x: control.mirrored ? control.width - width - control.rightPadding
                            : control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: {
                if (control.checked)
                    return control.enabled ? Theme.accent : (Theme.dark ? "#28FFFFFF" : "#37000000")
                if (control.hovered)
                    return Theme.fillControlSecondary
                return Theme.dark ? "#0FFFFFFF" : "#FFFFFF"
            }
            border.width: control.checked ? 0 : 1
            border.color: Theme.strokeControlStrong
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 10
                radius: 5
                color: Theme.dark ? "#000000" : "#FFFFFF"
                scale: control.checked ? 1 : 0
                opacity: control.checked ? 1 : 0
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingEnter
                    }
                }
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }
        }
    }

    contentItem: IconLabel {
        leftPadding: control.mirrored ? 0 : (control.indicator ? control.indicator.width + control.spacing : 0)
        rightPadding: control.mirrored ? (control.indicator ? control.indicator.width + control.spacing : 0) : 0
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
                 : (control.hovered || control.checked ? Theme.fillSubtleSecondary : "transparent")
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
