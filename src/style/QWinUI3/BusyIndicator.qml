import QtQuick
import QtQuick.Shapes
import QtQuick.Templates as T
import QWinUI3.Theme

T.BusyIndicator {
    id: control

    implicitWidth: 32
    implicitHeight: 32

    contentItem: Item {
        id: ring
        implicitWidth: 32
        implicitHeight: 32
        readonly property real stroke: 3
        readonly property real radius: Math.min(width, height) / 2 - stroke
        readonly property bool _running: control.running && control.visible

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            opacity: 0.35
            ShapePath {
                strokeWidth: ring.stroke
                strokeColor: Theme.strokeDivider
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: width / 2
                startY: ring.stroke / 2
                PathAngleArc {
                    centerX: ring.width / 2
                    centerY: ring.height / 2
                    radiusX: ring.radius
                    radiusY: ring.radius
                    startAngle: -90
                    sweepAngle: 360
                }
            }
        }

        Shape {
            id: sweep
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            transformOrigin: Item.Center
            rotation: Theme.reducedMotion ? 0 : spinAngle
            opacity: Theme.reducedMotion && ring._running
                     ? pulseOpacity : 1
            property real spinAngle: 0
            property real pulseOpacity: 1

            ShapePath {
                strokeWidth: ring.stroke
                strokeColor: Theme.accent
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: width / 2
                startY: ring.stroke / 2
                PathAngleArc {
                    centerX: ring.width / 2
                    centerY: ring.height / 2
                    radiusX: ring.radius
                    radiusY: ring.radius
                    startAngle: -90
                    sweepAngle: 100
                }
            }

            NumberAnimation on spinAngle {
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 900
                running: ring._running && !Theme.reducedMotion
            }

            SequentialAnimation on pulseOpacity {
                loops: Animation.Infinite
                running: ring._running && Theme.reducedMotion
                NumberAnimation {
                    from: 0.35
                    to: 1
                    duration: 700
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    from: 1
                    to: 0.35
                    duration: 700
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}
