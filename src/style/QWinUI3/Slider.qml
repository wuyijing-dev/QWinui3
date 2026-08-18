import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Slider — Fluent styled Slider.
//
//   Slider {
//       id: slider
//       from: 0; to: 100; value: 40
//       onMoved: apply(slider.value)
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Slider.
//   Public API is the Qt Quick Controls Slider type; this file supplies visuals/metrics only.

T.Slider {
    id: control


    Accessible.role: Accessible.Slider
    Accessible.name: qsTr("Slider")
    Accessible.description: qsTr("%1 of %2").arg(control.value).arg(control.to)
    implicitWidth: Math.max(200, implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.sliderThumb, implicitHandleHeight + topPadding + bottomPadding)

    padding: 8
    hoverEnabled: true
    live: true
    wheelEnabled: true

    handle: Item {
        x: control.leftPadding + (control.horizontal
           ? control.visualPosition * (control.availableWidth - width)
           : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
           ? (control.availableHeight - height) / 2
           : control.visualPosition * (control.availableHeight - height))
        implicitWidth: Theme.sliderThumb
        implicitHeight: Theme.sliderThumb

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Theme.fillSliderThumb
            border.width: 1
            border.color: Theme.strokeControl
            scale: control.pressed ? 0.96 : 1

            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Rectangle {
                anchors.centerIn: parent
                // Diameter in px
                readonly property real diameter: !control.enabled ? 10
                    : control.pressed ? 8
                    : control.hovered ? 14 : 10
                width: diameter
                height: diameter
                radius: diameter / 2
                color: {
                    if (!control.enabled)
                        return Theme.textDisabled
                    if (control.hovered && !control.pressed)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.902)
                    if (control.pressed)
                        return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.8)
                    return Theme.accent
                }

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
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
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
        x: control.leftPadding + (control.horizontal ? Theme.sliderThumb / 2 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
           ? (control.availableHeight - height) / 2
           : Theme.sliderThumb / 2)
        width: control.horizontal ? control.availableWidth - Theme.sliderThumb : Theme.sliderThickness
        height: control.horizontal ? Theme.sliderThickness : control.availableHeight - Theme.sliderThumb
        implicitWidth: 200
        implicitHeight: Theme.sliderThickness

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: Theme.dark ? "#15FFFFFF" : "#0F000000"
        }

        Rectangle {
            width: control.horizontal ? parent.width * control.position : parent.width
            height: control.horizontal ? parent.height : parent.height * control.position
            anchors.left: control.horizontal ? parent.left : undefined
            anchors.bottom: control.horizontal ? undefined : parent.bottom
            radius: height / 2
            color: control.enabled ? Theme.accent : Theme.textDisabled

            Behavior on width {
                enabled: control.horizontal && !control.pressed && !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on height {
                enabled: !control.horizontal && !control.pressed && !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }
}
