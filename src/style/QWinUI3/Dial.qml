import QtQuick
import QtQuick.Shapes
import QtQuick.Templates as T
import QWinUI3.Theme

// Dial — Fluent Dial with WinUI arc track and accent thumb.
//
//   Dial {
//       id: dial
//       from: 0; to: 100; value: 35
//       onMoved: apply(dial.value)
//   }
//   // --- API ---
//   // dial.from / to / value / moved() / wrapped
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Dial.
//   Public API is the Qt Quick Controls Dial type; this file supplies visuals/metrics only.

T.Dial {
    id: control

    // Dial angles: 0° at 12 o'clock, increasing clockwise (Qt convention).
    startAngle: -140
    endAngle: 140

    // Title text
    property string title: ""
    // Value unit label (%, rpm, …)
    property string unit: ""
    // Show numeric value label
    property bool showValue: true
    // Digits after decimal for value text
    property int valuePrecision: 0
    // Number of ticks
    property int tickCount: 11
    // Show tick marks
    property bool showTicks: true

    implicitWidth: 120
    implicitHeight: title.length || showValue ? 148 : 120
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: true
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Dial")
    Accessible.description: formattedValue

    // Formatted value string
    readonly property string formattedValue: {
        var n = Number(value)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        return t + (unit.length ? unit : "")
    }

    // PathAngleArc uses 0° at 3 o'clock — convert from Dial angles.
    readonly property real _arcStart: startAngle - 90
    readonly property real _arcSweep: endAngle - startAngle
    readonly property real _norm: from === to ? 0
            : Math.max(0, Math.min(1, (value - from) / (to - from)))

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
            // Stroke width for dial arc
            readonly property real stroke: 4
            // Radius
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

        Repeater {
            model: control.showTicks ? control.tickCount : 0
            Rectangle {
                required property int index
                width: 2
                height: 5
                radius: 1
                color: Theme.textSecondary
                opacity: 0.4
                // Normalized 0..1 parameter
                readonly property real t: index / Math.max(1, control.tickCount - 1)
                // Angle in degrees
                readonly property real angDeg: control.startAngle + t * (control.endAngle - control.startAngle)
                // Angle in degrees
                readonly property real ang: (angDeg - 90) * Math.PI / 180
                // Resolved radius
                readonly property real rr: dialShape.r + 6
                x: dialShape.width / 2 + Math.cos(ang) * rr - width / 2
                y: dialShape.height / 2 + Math.sin(ang) * rr - height / 2
                rotation: angDeg
            }
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            spacing: 2
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: control.title.length > 0
                text: control.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: control.showValue
                text: control.formattedValue
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
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
