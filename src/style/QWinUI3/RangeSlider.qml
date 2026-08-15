import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// RangeSlider — Fluent styled RangeSlider.
//
//   RangeSlider { from: 0; to: 100; first.value: 20; second.value: 80 }

T.RangeSlider {
    id: control

    implicitWidth: Math.max(200, first.handle.implicitWidth + second.handle.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.sliderThumb, first.handle.implicitHeight + topPadding + bottomPadding)

    padding: 8
    hoverEnabled: true

    first.handle: Item {
        x: control.leftPadding + control.first.visualPosition * (control.availableWidth - width)
        y: control.topPadding + (control.availableHeight - height) / 2
        implicitWidth: Theme.sliderThumb
        implicitHeight: Theme.sliderThumb

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Theme.dark ? "#2D2D2D" : "#FFFFFF"
            border.width: 1
            border.color: Theme.strokeControl
            scale: control.first.pressed ? 0.96 : 1
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                anchors.centerIn: parent
                readonly property real diameter: !control.enabled ? 10
                    : control.first.pressed ? 8
                    : control.first.hovered ? 14 : 10
                width: diameter
                height: diameter
                radius: diameter / 2
                color: control.enabled ? Theme.accent : Theme.textDisabled
                Behavior on width {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on height {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: width / 2
        }
    }

    second.handle: Item {
        x: control.leftPadding + control.second.visualPosition * (control.availableWidth - width)
        y: control.topPadding + (control.availableHeight - height) / 2
        implicitWidth: Theme.sliderThumb
        implicitHeight: Theme.sliderThumb

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Theme.dark ? "#2D2D2D" : "#FFFFFF"
            border.width: 1
            border.color: Theme.strokeControl
            scale: control.second.pressed ? 0.96 : 1
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                anchors.centerIn: parent
                readonly property real diameter: !control.enabled ? 10
                    : control.second.pressed ? 8
                    : control.second.hovered ? 14 : 10
                width: diameter
                height: diameter
                radius: diameter / 2
                color: control.enabled ? Theme.accent : Theme.textDisabled
                Behavior on width {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on height {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }

        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: width / 2
        }
    }

    background: Item {
        x: control.leftPadding + Theme.sliderThumb / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        width: control.availableWidth - Theme.sliderThumb
        height: Theme.sliderThickness

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: Theme.dark ? "#15FFFFFF" : "#0F000000"
        }
        Rectangle {
            x: control.first.visualPosition * parent.width
            width: Math.max(0, (control.second.visualPosition - control.first.visualPosition) * parent.width)
            height: parent.height
            radius: height / 2
            color: control.enabled ? Theme.accent : Theme.textDisabled
        }
    }
}
