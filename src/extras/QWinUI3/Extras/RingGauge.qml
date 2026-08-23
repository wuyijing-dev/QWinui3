import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// RingGauge — Closed-ring dashboard gauge with center value and thresholds.
//
//   RingGauge {
//       id: ring
//       value: 72; minimum: 0; maximum: 100
//       unit: "%"
//       title: qsTr("CPU")
//       target: 80
//       cautionThreshold: 0.7
//       criticalThreshold: 0.9
//       isInteractive: true
//   }
//
//   // --- API ---
//   // signals: onValueEdited
//   // methods: clampSnap(v), setValue(v), setValueFromNorm(n), normFromPoint(px, py, cx, cy), nudge(delta)
//   // ring.setValue(v); ring.nudge(1); ring.severity
//
// @notes
//   Full (or near-full) progress ring with center readout; distinct from ArcGauge (open) and RadialGauge (needle).
//   Optional target tick; severity 0/1/2 from thresholds; wheel/keys when interactive; setValue clamps+snaps.

T.Control {
    id: root

    // Current value
    property real value: 0
    // Minimum value
    property real minimum: 0
    // Maximum value
    property real maximum: 100
    // Value step (e.g. 0.5 for half stars)
    property real stepSize: 0
    // Primary title text
    property string title: ""
    // Value unit label (%, rpm, …)
    property string unit: ""
    // Caption under / beside the value
    property string caption: ""
    // Digits after decimal for value text
    property int valuePrecision: 0
    // Optional printf-style format for the center value (2.65). Empty → precision + unit.
    // Use "%1" for the number and "%2" for the unit, e.g. "%1%2" or "%1 %2".
    property string valueFormat: ""
    // Stroke thickness in px
    property real strokeWidth: 12
    // Primary fill / progress color
    property color fillColor: Theme.accent
    // Track / remaining color
    property color trackColor: Theme.strokeDivider
    // Show background track ring
    property bool showTrack: true
    // Soft glow under the progress arc
    property bool showGlow: true
    // Arc start angle in degrees (PathAngleArc: 0° at 3 o'clock)
    property real startAngle: -90
    // Total sweep angle in degrees (use <360 for a small visual gap)
    property real sweepTotal: 350
    // Target value (NaN to hide); drawn as a tick on the ring
    property real target: NaN
    // Show target marker when target is finite
    property bool showTarget: true
    // Value where caution zone starts (normalized 0..1)
    property real cautionThreshold: -1
    // Value where critical zone starts
    property real criticalThreshold: -1
    // Invert caution/critical threshold logic
    property bool invertThresholds: false
    // Show numeric value label
    property bool showValue: true
    // Show drag thumb (defaults on when interactive)
    property bool showThumb: true
    // Alias of interactive
    property bool isInteractive: false
    // Enable hover / click interaction
    property alias interactive: root.isInteractive
    // Extra drag hit padding outside the face (px)
    property real interactionPadding: 24
    // Optional inner-ring value (NaN to hide)
    property real value2: NaN
    // Inner-ring fill color
    property color fillColor2: Theme.systemCaution
    // Inner-ring stroke thickness
    property real strokeWidthInner: 8

    // Emitted when user commits a value
    signal valueEdited(real value)

    implicitWidth: 148
    implicitHeight: title.length || caption.length ? 168 : 148
    padding: 8
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Ring gauge")
    Accessible.description: formattedValue

    // Normalized 0..1 (live value, not animated)
    readonly property real normalized: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (value - minimum) / span))
    }
    // Value as 0..100 percentage
    readonly property real percentage: animatedNorm * 100
    // 0 = ok, 1 = caution, 2 = critical
    readonly property int severity: {
        var n = invertThresholds ? (1 - animatedNorm) : animatedNorm
        if (criticalThreshold >= 0 && n >= criticalThreshold)
            return 2
        if (cautionThreshold >= 0 && n >= cautionThreshold)
            return 1
        return 0
    }
    // Resolved fill color
    readonly property color effectiveFillColor: {
        if (severity === 2)
            return Theme.systemCritical
        if (severity === 1)
            return Theme.systemCaution
        return fillColor
    }
    readonly property bool hasTarget: showTarget && isFinite(target)
    readonly property real targetNorm: {
        if (!hasTarget)
            return 0
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (target - minimum) / span))
    }

    // Formatted value string
    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        if (valueFormat.length)
            return valueFormat.arg(t).arg(unit)
        return t + (unit.length ? unit : "")
    }

    // Animated display value
    property real animatedValue: value
    Behavior on animatedValue {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingStandard
        }
    }
    onValueChanged: animatedValue = value
    Component.onCompleted: {
        animatedValue = value
        if (isFinite(value2))
            animatedValue2 = value2
    }

    readonly property bool hasValue2: isFinite(value2)
    property real animatedValue2: 0
    Behavior on animatedValue2 {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingStandard
        }
    }
    onValue2Changed: {
        if (isFinite(value2))
            animatedValue2 = value2
    }

    readonly property real animatedNorm2: {
        var span = maximum - minimum
        if (span <= 0 || !hasValue2)
            return 0
        return Math.max(0, Math.min(1, (animatedValue2 - minimum) / span))
    }

    // Animated 0..1 normalized value
    readonly property real animatedNorm: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }

    // Clamp and snap a value to the valid range
    function clampSnap(v) {
        var lo = Math.min(minimum, maximum)
        var hi = Math.max(minimum, maximum)
        var x = Math.max(lo, Math.min(hi, Number(v) || 0))
        if (stepSize > 0) {
            var steps = Math.round((x - lo) / stepSize)
            x = Math.max(lo, Math.min(hi, lo + steps * stepSize))
        }
        return x
    }

    // Set value (clamped / snapped)
    function setValue(v) { value = clampSnap(v) }

    // Set value from a normalized 0..1 input
    function setValueFromNorm(n) {
        setValue(minimum + Math.max(0, Math.min(1, n)) * (maximum - minimum))
    }

    // Nudge value by delta (respects stepSize when set)
    function nudge(delta) {
        var d = Number(delta) || 0
        if (stepSize > 0 && Math.abs(d) < stepSize)
            d = d < 0 ? -stepSize : stepSize
        setValue(value + d)
        valueEdited(value)
    }

    // Normalize a pointer position to 0..1 along the ring sweep
    function normFromPoint(px, py, cx, cy) {
        return GaugeUtils.normFromAngle(px, py, cx, cy, root.startAngle, root.sweepTotal,
                                        root.normalized)
    }

    function _stepAmount() {
        return stepSize > 0 ? stepSize : (maximum - minimum) * 0.05
    }

    Keys.onLeftPressed: if (isInteractive) nudge(-_stepAmount())
    Keys.onRightPressed: if (isInteractive) nudge(_stepAmount())
    Keys.onDownPressed: if (isInteractive) nudge(-_stepAmount())
    Keys.onUpPressed: if (isInteractive) nudge(_stepAmount())

    WheelHandler {
        enabled: root.isInteractive && root.enabled
        onWheel: function (event) {
            var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
            if (dir === 0)
                return
            root.nudge(dir > 0 ? root._stepAmount() : -root._stepAmount())
            event.accepted = true
        }
    }

    contentItem: Item {
        id: face
        readonly property real cx: width / 2
        readonly property real cy: height / 2
        readonly property real radius: Math.min(width, height) * 0.42 - root.strokeWidth * 0.5
        readonly property real innerRadius: Math.max(8, radius - root.strokeWidth * 0.5 - root.strokeWidthInner * 0.5 - 6)

        // Soft glow under progress
        Shape {
            anchors.fill: parent
            visible: root.showGlow && !Theme.reducedMotion && root.animatedNorm > 0.01
            opacity: 0.35
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth + 6
                strokeColor: root.effectiveFillColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.radius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.radius
                PathAngleArc {
                    centerX: face.cx
                    centerY: face.cy
                    radiusX: face.radius
                    radiusY: face.radius
                    startAngle: root.startAngle
                    sweepAngle: root.animatedNorm * root.sweepTotal
                }
            }
        }

        Shape {
            anchors.fill: parent
            visible: root.showTrack
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.trackColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.radius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.radius
                PathAngleArc {
                    centerX: face.cx
                    centerY: face.cy
                    radiusX: face.radius
                    radiusY: face.radius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepTotal
                }
            }
        }

        Shape {
            id: fillShape
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            property real sweep: root.animatedNorm * root.sweepTotal
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.enabled ? root.effectiveFillColor : Theme.textDisabled
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.radius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.radius
                PathAngleArc {
                    centerX: face.cx
                    centerY: face.cy
                    radiusX: face.radius
                    radiusY: face.radius
                    startAngle: root.startAngle
                    sweepAngle: fillShape.sweep
                }
            }
        }

        Shape {
            anchors.fill: parent
            visible: root.showTrack && root.hasValue2
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidthInner
                strokeColor: root.trackColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.innerRadius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.innerRadius
                PathAngleArc {
                    centerX: face.cx
                    centerY: face.cy
                    radiusX: face.innerRadius
                    radiusY: face.innerRadius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepTotal
                }
            }
        }

        Shape {
            id: fillShape2
            anchors.fill: parent
            visible: root.hasValue2
            preferredRendererType: Shape.CurveRenderer
            property real sweep: root.animatedNorm2 * root.sweepTotal
            ShapePath {
                strokeWidth: root.strokeWidthInner
                strokeColor: root.enabled ? root.fillColor2 : Theme.textDisabled
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.innerRadius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.innerRadius
                PathAngleArc {
                    centerX: face.cx
                    centerY: face.cy
                    radiusX: face.innerRadius
                    radiusY: face.innerRadius
                    startAngle: root.startAngle
                    sweepAngle: fillShape2.sweep
                }
            }
        }

        // Target marker
        Rectangle {
            visible: root.hasTarget
            width: 3
            height: root.strokeWidth + 8
            radius: 1.5
            color: Theme.textPrimary
            opacity: 0.85
            readonly property real ang: (root.startAngle + root.targetNorm * root.sweepTotal) * Math.PI / 180
            x: face.cx + Math.cos(ang) * face.radius - width / 2
            y: face.cy + Math.sin(ang) * face.radius - height / 2
            rotation: (root.startAngle + root.targetNorm * root.sweepTotal) + 90
            transformOrigin: Item.Center
        }

        Rectangle {
            width: Math.max(root.strokeWidth + 10, 28)
            height: width
            radius: width / 2
            visible: root.showThumb && root.isInteractive
            color: Theme.bgCard
            border.width: 2
            border.color: root.activeFocus && root.isInteractive
                          ? Theme.focusOuter
                          : (root.enabled ? root.effectiveFillColor : Theme.textDisabled)
            scale: drag.pressed && !Theme.reducedMotion ? 1.1 : 1
            readonly property real ang: (root.startAngle + root.animatedNorm * root.sweepTotal) * Math.PI / 180
            x: face.cx + Math.cos(ang) * face.radius - width / 2
            y: face.cy + Math.sin(ang) * face.radius - height / 2
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 2
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.title.length > 0
                text: root.title
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.showValue
                text: root.formattedValue
                font.pixelSize: Theme.fontTitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.caption.length > 0
                text: root.caption
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }

        MouseArea {
            id: drag
            anchors.fill: parent
            enabled: root.isInteractive && root.enabled
            preventStealing: true
            cursorShape: Qt.PointingHandCursor
            function apply(mx, my) {
                var p = mapToItem(face, mx, my)
                root.setValueFromNorm(root.normFromPoint(p.x, p.y, face.cx, face.cy))
                root.valueEdited(root.value)
            }
            onPressed: function (mouse) { apply(mouse.x, mouse.y) }
            onPositionChanged: function (mouse) {
                if (pressed)
                    apply(mouse.x, mouse.y)
            }
        }
    }

    background: Item {}
}
