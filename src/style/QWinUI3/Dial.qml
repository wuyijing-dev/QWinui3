import QtQuick
import QtQuick.Shapes
import QtQuick.Templates as T
import QWinUI3.Theme

T.Dial {
    id: control

    // Dial angles: 0° at 12 o'clock, increasing clockwise (Qt convention).
    startAngle: -140
    endAngle: 140

    implicitWidth: 120
    implicitHeight: 120
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true

    // PathAngleArc uses 0° at 3 o'clock — convert from Dial angles.
    readonly property real _arcStart: startAngle - 90
    readonly property real _arcSweep: endAngle - startAngle

    background: Item {
        width: control.width
        height: control.height

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: control.hovered ? Theme.fillSubtle : (Theme.dark ? "#0FFFFFFF" : "#FFFFFF")
            border.width: 1
            border.color: Theme.strokeControl
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Shape {
            id: dialShape
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            readonly property real stroke: 4
            readonly property real r: Math.max(0, Math.min(width, height) / 2 - 12)

            // Track (horseshoe — gap at bottom)
            ShapePath {
                strokeWidth: dialShape.stroke
                strokeColor: Theme.strokeDivider
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: dialShape.width / 2
                startY: dialShape.height / 2 - dialShape.r
                PathAngleArc {
                    centerX: dialShape.width / 2
                    centerY: dialShape.height / 2
                    radiusX: dialShape.r
                    radiusY: dialShape.r
                    startAngle: control._arcStart
                    sweepAngle: control._arcSweep
                }
            }

            // Value arc
            ShapePath {
                strokeWidth: dialShape.stroke
                strokeColor: control.enabled ? Theme.accent : Theme.textDisabled
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: dialShape.width / 2
                startY: dialShape.height / 2 - dialShape.r
                PathAngleArc {
                    centerX: dialShape.width / 2
                    centerY: dialShape.height / 2
                    radiusX: dialShape.r
                    radiusY: dialShape.r
                    startAngle: control._arcStart
                    sweepAngle: control._arcSweep * control.position
                }
            }
        }
    }

    handle: Rectangle {
        id: handleItem
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: control.enabled ? Theme.accent : Theme.textDisabled
        border.width: 2
        border.color: Theme.dark ? "#1C1C1C" : "#FFFFFF"
        scale: control.pressed ? 0.9 : (control.hovered ? 1.08 : 1)

        // Match Qt styles: rest at 12 o'clock, rotate by Dial.angle.
        x: control.background.width / 2 - width / 2
        y: control.background.height / 2 - height / 2
        transform: [
            Translate {
                y: -(Math.min(control.background.width, control.background.height) / 2 - 18)
            },
            Rotation {
                angle: control.angle
                origin.x: handleItem.width / 2
                origin.y: handleItem.height / 2
            }
        ]

        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 4
            height: 4
            radius: 2
            color: Theme.dark ? "#000000" : "#FFFFFF"
            opacity: 0.55
        }
    }
}
