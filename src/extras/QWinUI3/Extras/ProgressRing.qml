import QtQuick
import QtQuick.Shapes
import QtQuick.Templates as T
import QWinUI3.Theme

// ProgressRing — Circular progress / busy ring.
//
//   ProgressRing {
//       id: ring
//       indeterminate: true
//       // value: 0.4 when determinate
//   }
//   // --- API ---
//   // ring.value / indeterminate

T.Control {
    id: root

    // Current value
    property real value: 0
    // Show indeterminate animation when true
    property bool indeterminate: false
    // WinUI-style: Active sweeps; Paused holds a partial arc without spinning
    property bool isActive: true
    // Stroke thickness in px
    property real strokeWidth: 3
    // Primary fill / progress color
    property color fillColor: Theme.accent
    // Track / remaining color
    property color trackColor: Theme.strokeDivider
    // Show numeric value label
    property bool showValue: false
    // Optional value caption
    property string valueLabel: ""
    // Diameter or box size in px
    property real size: 32

    implicitWidth: size
    implicitHeight: size
    padding: 0
    Accessible.role: Accessible.ProgressBar
    Accessible.name: qsTr("Progress")
    Accessible.description: indeterminate
                             ? (isActive ? qsTr("Indeterminate") : qsTr("Paused"))
                             : formattedValue

    // True while indeterminate ring spins
    readonly property bool spinning: indeterminate && isActive && visible && !Theme.reducedMotion
    // Determinate arc sweep degrees
    readonly property real progressSweep: {
        if (indeterminate)
            return isActive ? 100 : 60
        return Math.max(0, Math.min(360, value * 360))
    }
    // Formatted value string
    readonly property string formattedValue: {
        if (valueLabel.length)
            return valueLabel
        return Math.round(Math.max(0, Math.min(1, value)) * 100) + "%"
    }

    contentItem: Item {
        id: ring
        // Corner radius
        readonly property real radius: Math.max(0, Math.min(width, height) / 2 - root.strokeWidth)

        Shape {
            id: trackShape
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.trackColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: trackShape.width / 2
                startY: root.strokeWidth / 2
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
            id: progress
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            transformOrigin: Item.Center
            rotation: root.spinning ? progress.spinAngle : 0
            scale: root.visible ? 1 : 0.85

            // Indeterminate spin angle
            property real spinAngle: 0
            // Animated sweep angle for gauges
            property real animatedSweep: root.progressSweep

            Behavior on animatedSweep {
                enabled: !Theme.reducedMotion && !root.indeterminate
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
                }
            }

            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.enabled ? root.fillColor : Theme.textDisabled
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: progress.width / 2
                startY: root.strokeWidth / 2
                PathAngleArc {
                    centerX: ring.width / 2
                    centerY: ring.height / 2
                    radiusX: ring.radius
                    radiusY: ring.radius
                    startAngle: -90
                    sweepAngle: progress.animatedSweep
                }
            }

            NumberAnimation on spinAngle {
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: Theme.duration(900)
                running: root.spinning
                easing.type: Easing.Linear
            }
        }

        Text {
            anchors.centerIn: parent
            visible: root.showValue && !root.indeterminate
            text: root.formattedValue
            font.family: Theme.fontFamily
            font.pixelSize: Math.max(9, Math.min(width, height) * 0.28)
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
        }
    }

    onProgressSweepChanged: {
        if (Theme.reducedMotion || indeterminate)
            progress.animatedSweep = progressSweep
    }
    Component.onCompleted: progress.animatedSweep = progressSweep
}
