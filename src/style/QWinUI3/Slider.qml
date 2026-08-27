import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Slider — Fluent styled Slider.
//
//   Slider {
//       from: 0; to: 100; value: 40; stepSize: 10
//       tickMarksVisible: true
//   }
//
// @notes
//   Style chrome. tickMarksVisible draws step ticks under the track (3.11).

T.Slider {
    id: control

    // Show step ticks along the track (uses stepSize; 3.11)
    property bool tickMarksVisible: false

    Accessible.role: Accessible.Slider
    Accessible.name: qsTr("Slider")
    Accessible.description: qsTr("%1 of %2").arg(control.value).arg(control.to)

    implicitWidth: Math.max(200, implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.sliderThumb + (tickMarksVisible ? 10 : 0),
                             implicitHandleHeight + topPadding + bottomPadding)

    padding: 8
    hoverEnabled: true
    live: true
    wheelEnabled: true

    readonly property int _tickCount: {
        if (!tickMarksVisible || stepSize <= 0)
            return 0
        var span = Math.abs(to - from)
        if (span <= 0)
            return 0
        var n = Math.floor(span / stepSize + 0.001) + 1
        return Math.min(n, 64)
    }

    handle: Item {
        x: control.leftPadding + (control.horizontal
           ? control.visualPosition * (control.availableWidth - width)
           : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
           ? (control.availableHeight - height) / 2
               - (control.tickMarksVisible ? 4 : 0)
           : control.visualPosition * (control.availableHeight - height))
        implicitWidth: Theme.sliderThumb
        implicitHeight: Theme.sliderThumb

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Theme.fillSliderThumb
            border.width: 1
            border.color: Theme.strokeControl
            scale: control.pressed ? 0.96 : (control.hovered ? 1.12 : 1)

            Behavior on scale {
                enabled: !Theme.reducedMotion && (control.hovered || control.pressed)
                NumberAnimation {
                    duration: Theme.motionMs("fast")
                    easing.type: Theme.motionEasing("standard")
                }
            }

            Rectangle {
                anchors.centerIn: parent
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
                    enabled: !Theme.reducedMotion && (control.hovered || control.pressed)
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on height {
                    enabled: !Theme.reducedMotion && (control.hovered || control.pressed)
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on color {
                    enabled: !Theme.reducedMotion && (control.hovered || control.pressed)
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
           ? (control.availableHeight - height) / 2 - (control.tickMarksVisible ? 4 : 0)
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

        // Step ticks (3.11) — horizontal only
        Repeater {
            model: control.horizontal ? control._tickCount : 0
            delegate: Rectangle {
                required property int index
                width: 2
                height: 6
                radius: 1
                color: Theme.strokeControl
                opacity: 0.55
                x: control._tickCount <= 1 ? parent.width / 2
                   : index * (parent.width / Math.max(1, control._tickCount - 1)) - width / 2
                y: parent.height + 3
            }
        }
    }
}
