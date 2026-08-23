import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// RadialGauge — Toolkit-style circular needle gauge (CommunityToolkit.WinUI.Controls.RadialGauge).
//
//   RadialGauge {
//       id: radial
//       value: 120; minimum: 0; maximum: 240
//       minAngle: -150; maxAngle: 150
//       isInteractive: true
//       stepSize: 5
//       tickSpacing: 20
//       scaleWidth: 12
//       needleLength: 0.72
//       valueStringFormat: "N0"
//       unit: "rpm"
//   }
//
//   // --- API ---
//   // signals: onValueEdited
//   // methods: setValue(v), setValueFromNorm(n), setAngleRange(minA, maxA), nudge(delta), normFromPoint(px, py)
//   // radial.valueAngle / radial.severity / radial.nudge(1)
//
// @notes
//   Aligned with Community Toolkit RadialGauge: MinAngle/MaxAngle, ScaleWidth, NeedleLength/Width,
//   TickSpacing/Length/Width/Padding, ScalePadding, ValueStringFormat, Trail/Scale/Needle brushes.
//   startAngle/sweepTotal remain as aliases of the angle range. Wheel/keys when isInteractive.

T.Control {
    id: root

    // --- Value (Toolkit) ---
    // Current value
    property real value: 0
    // Minimum value
    property real minimum: 0
    // Maximum value
    property real maximum: 100
    // Rounding interval for Value (Toolkit StepSize)
    property real stepSize: 0
    // Value string format: "N0", "N1", "F1", or empty to use valuePrecision
    property string valueStringFormat: ""
    // Digits after decimal when valueStringFormat is empty
    property int valuePrecision: 0
    // Displayed unit measure (Toolkit Unit)
    property string unit: ""
    // Primary title text
    property string title: ""
    // Caption under / beside the value
    property string caption: ""
    // Show numeric value label
    property bool showValue: true

    // --- Angles (Toolkit MinAngle / MaxAngle; PathAngleArc: 0° at 3 o'clock) ---
    // Start angle of the scale (Toolkit MinAngle)
    property real minAngle: -210
    // End angle of the scale (Toolkit MaxAngle)
    property real maxAngle: 30
    // Back-compat alias of minAngle
    property alias startAngle: root.minAngle
    // Sweep angle (= maxAngle − minAngle); assigning updates maxAngle
    property real sweepTotal: maxAngle - minAngle
    onSweepTotalChanged: {
        var expected = maxAngle - minAngle
        if (Math.abs(sweepTotal - expected) > 0.001)
            maxAngle = minAngle + sweepTotal
    }

    // --- Scale / trail (Toolkit ScaleWidth, brushes) ---
    // Width of the scale arc in px (Toolkit ScaleWidth)
    property real scaleWidth: 10
    // Back-compat alias of scaleWidth
    property alias strokeWidth: root.scaleWidth
    // Inset of the scale from the outer radius, in px (Toolkit ScalePadding)
    property real scalePadding: 2
    // Scale / remaining track color (Toolkit ScaleBrush)
    property color scaleBrush: Theme.strokeDivider
    property alias trackColor: root.scaleBrush
    // Trail / progress color (Toolkit TrailBrush)
    property color trailBrush: Theme.accent
    property alias fillColor: root.trailBrush
    // Soft glow under the trail
    property bool showGlow: true

    // --- Needle (Toolkit NeedleLength / NeedleWidth / NeedleBrush) ---
    // Show needle indicator
    property bool showNeedle: true
    // Needle length as fraction of radius (0..1); Toolkit uses % — pass 0.6 for 60
    property real needleLength: 0.72
    // Needle width in px
    property real needleWidth: 3
    // Needle color
    property color needleBrush: Theme.textPrimary
    // Second needle (setpoint vs actual)
    property real value2: NaN
    property bool showSecondNeedle: isFinite(value2)
    property color needleBrush2: Theme.systemCaution
    property real needleLength2: 0.58
    property real needleWidth2: 2

    // --- Ticks (Toolkit TickSpacing / TickLength / TickWidth / TickPadding / ScaleTickWidth) ---
    // Tick spacing in value units (0 = use tickCount evenly)
    property real tickSpacing: 0
    // Legacy evenly spaced tick count when tickSpacing <= 0
    property int tickCount: 8
    // Outer tick length in px
    property real tickLength: 6
    // Outer tick width in px
    property real tickWidth: 2
    // Distance from scale to outer ticks in px
    property real tickPadding: 4
    // Width of ticks carved into the scale (0 = hide scale ticks)
    property real scaleTickWidth: 0
    // Outer tick color (Toolkit TickBrush)
    property color tickBrush: Theme.textSecondary
    // Scale-tick color (Toolkit ScaleTickBrush)
    property color scaleTickBrush: Theme.bgLayer
    // Show outer ticks
    property bool showTicks: true

    // --- Thresholds (QWinUI3 extension) ---
    property real cautionThreshold: -1
    property real criticalThreshold: -1
    property bool invertThresholds: false

    // --- Interaction (Toolkit IsInteractive) ---
    property bool isInteractive: false
    property alias interactive: root.isInteractive
    // Extra drag hit padding outside the face (px)
    property real interactionPadding: 24

    signal valueEdited(real value)

    implicitWidth: 160
    implicitHeight: title.length ? 184 : 160
    padding: 8
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Radial gauge")
    Accessible.description: formattedValue

    // Toolkit ValueAngle — current needle angle between minAngle and maxAngle
    readonly property real valueAngle: minAngle + animatedNorm * (maxAngle - minAngle)
    readonly property real value2Angle: {
        var span = maximum - minimum
        if (span <= 0 || !isFinite(value2))
            return minAngle
        var n = Math.max(0, Math.min(1, (value2 - minimum) / span))
        return minAngle + n * (maxAngle - minAngle)
    }
    readonly property real normalizedMinAngle: minAngle
    readonly property real normalizedMaxAngle: maxAngle

    readonly property real normalized: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (value - minimum) / span))
    }
    readonly property real percentage: animatedNorm * 100
    readonly property int severity: {
        var n = invertThresholds ? (1 - animatedNorm) : animatedNorm
        if (criticalThreshold >= 0 && n >= criticalThreshold)
            return 2
        if (cautionThreshold >= 0 && n >= cautionThreshold)
            return 1
        return 0
    }
    readonly property color effectiveFillColor: {
        if (severity === 2)
            return Theme.systemCritical
        if (severity === 1)
            return Theme.systemCaution
        return trailBrush
    }

    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t
        if (valueStringFormat.length) {
            var fmt = valueStringFormat.toUpperCase()
            if (fmt === "N0" || fmt === "F0")
                t = String(Math.round(n))
            else if (fmt === "N1" || fmt === "F1")
                t = n.toFixed(1)
            else if (fmt === "N2" || fmt === "F2")
                t = n.toFixed(2)
            else
                t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        } else {
            t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        }
        return t + (unit.length ? (" " + unit) : "")
    }

    readonly property var _tickNorms: {
        var out = []
        var span = maximum - minimum
        if (span <= 0)
            return out
        if (tickSpacing > 0) {
            var v = minimum
            // Align to spacing grid
            var first = Math.ceil(minimum / tickSpacing) * tickSpacing
            if (first < minimum)
                first += tickSpacing
            for (v = first; v <= maximum + 1e-6; v += tickSpacing)
                out.push((v - minimum) / span)
            if (out.length === 0 || out[0] > 1e-6)
                out.unshift(0)
            if (out[out.length - 1] < 1 - 1e-6)
                out.push(1)
        } else {
            var n = Math.max(2, tickCount)
            for (var i = 0; i < n; ++i)
                out.push(i / (n - 1))
        }
        return out
    }

    property real animatedValue: value
    Behavior on animatedValue {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingStandard
        }
    }
    onValueChanged: animatedValue = value
    Component.onCompleted: animatedValue = value

    readonly property real animatedNorm: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }

    function setAngleRange(minA, maxA) {
        minAngle = minA
        maxAngle = maxA
    }

    function setValue(v) {
        var lo = Math.min(minimum, maximum)
        var hi = Math.max(minimum, maximum)
        var x = Math.max(lo, Math.min(hi, Number(v) || 0))
        if (stepSize > 0) {
            var steps = Math.round((x - lo) / stepSize)
            x = Math.max(lo, Math.min(hi, lo + steps * stepSize))
        }
        value = x
    }

    function setValueFromNorm(n) {
        setValue(minimum + Math.max(0, Math.min(1, n)) * (maximum - minimum))
    }

    // Set value from Toolkit-style ValueAngle
    function setValueAngle(angle) {
        var span = maxAngle - minAngle
        if (Math.abs(span) < 1e-6)
            return
        setValueFromNorm((angle - minAngle) / span)
    }

    function nudge(delta) {
        var d = Number(delta) || 0
        if (stepSize > 0 && Math.abs(d) < stepSize)
            d = d < 0 ? -stepSize : stepSize
        setValue(value + d)
        valueEdited(value)
    }

    function _stepAmount() {
        return stepSize > 0 ? stepSize : (maximum - minimum) * 0.05
    }

    function normFromPoint(px, py) {
        var cx = gaugeFace.width / 2
        var cy = gaugeFace.height / 2
        var span = root.maximum - root.minimum
        var cur = span <= 0 ? 0 : (root.value - root.minimum) / span
        return GaugeUtils.normFromAngle(px, py, cx, cy, root.minAngle, root.sweepTotal, cur)
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
        id: gaugeFace
        readonly property real outerR: Math.min(width, height) / 2 - 2
        readonly property real radius: outerR - root.scalePadding - root.scaleWidth * 0.5

        Rectangle {
            anchors.centerIn: parent
            visible: root.showGlow
            width: gaugeFace.radius * 1.15
            height: width
            radius: width / 2
            color: ChartUtils.withAlpha(root.effectiveFillColor, Theme.dark ? 0.12 : 0.08)
            scale: 0.85 + root.animatedNorm * 0.15
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionSlow)
                    easing.type: Theme.easingStandard
                }
            }
        }

        // Scale (track)
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.scaleWidth
                strokeColor: root.scaleBrush
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: gaugeFace.width / 2 + Math.cos(root.minAngle * Math.PI / 180) * gaugeFace.radius
                startY: gaugeFace.height / 2 + Math.sin(root.minAngle * Math.PI / 180) * gaugeFace.radius
                PathAngleArc {
                    centerX: gaugeFace.width / 2
                    centerY: gaugeFace.height / 2
                    radiusX: gaugeFace.radius
                    radiusY: gaugeFace.radius
                    startAngle: root.minAngle
                    sweepAngle: root.maxAngle - root.minAngle
                }
            }
        }

        // Trail (progress)
        Shape {
            id: fillArc
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            property real sweep: root.animatedNorm * (root.maxAngle - root.minAngle)
            ShapePath {
                strokeWidth: root.scaleWidth
                strokeColor: root.enabled ? root.effectiveFillColor : Theme.textDisabled
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: gaugeFace.width / 2 + Math.cos(root.minAngle * Math.PI / 180) * gaugeFace.radius
                startY: gaugeFace.height / 2 + Math.sin(root.minAngle * Math.PI / 180) * gaugeFace.radius
                PathAngleArc {
                    centerX: gaugeFace.width / 2
                    centerY: gaugeFace.height / 2
                    radiusX: gaugeFace.radius
                    radiusY: gaugeFace.radius
                    startAngle: root.minAngle
                    sweepAngle: fillArc.sweep
                }
            }
        }

        // Scale ticks (notches on the arc)
        Repeater {
            model: root.scaleTickWidth > 0 ? root._tickNorms : []
            delegate: Rectangle {
                required property int index
                required property real modelData
                width: root.scaleTickWidth
                height: root.scaleWidth * 0.85
                radius: 1
                color: root.scaleTickBrush
                readonly property real angDeg: root.minAngle + modelData * (root.maxAngle - root.minAngle)
                readonly property real ang: angDeg * Math.PI / 180
                x: gaugeFace.width / 2 + Math.cos(ang) * gaugeFace.radius - width / 2
                y: gaugeFace.height / 2 + Math.sin(ang) * gaugeFace.radius - height / 2
                rotation: angDeg + 90
            }
        }

        // Outer ticks
        Repeater {
            model: root.showTicks ? root._tickNorms : []
            delegate: Rectangle {
                required property int index
                required property real modelData
                width: root.tickWidth
                height: root.tickLength
                radius: 1
                color: root.tickBrush
                opacity: 0.7
                readonly property real angDeg: root.minAngle + modelData * (root.maxAngle - root.minAngle)
                readonly property real ang: angDeg * Math.PI / 180
                readonly property real rr: gaugeFace.radius + root.scaleWidth * 0.5 + root.tickPadding + root.tickLength * 0.5
                x: gaugeFace.width / 2 + Math.cos(ang) * rr - width / 2
                y: gaugeFace.height / 2 + Math.sin(ang) * rr - height / 2
                rotation: angDeg + 90
            }
        }

        // Needle
        Item {
            visible: root.showNeedle
            anchors.fill: parent
            rotation: root.valueAngle + 90
            transformOrigin: Item.Center
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                width: root.needleWidth
                height: gaugeFace.radius * Math.max(0, Math.min(1.2,
                        root.needleLength > 1 ? root.needleLength / 100 : root.needleLength))
                radius: width / 2
                color: root.needleBrush
                opacity: 0.9
            }
        }

        Item {
            visible: root.showNeedle && root.showSecondNeedle
            anchors.fill: parent
            rotation: root.value2Angle + 90
            transformOrigin: Item.Center
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                width: root.needleWidth2
                height: gaugeFace.radius * Math.max(0, Math.min(1.2,
                        root.needleLength2 > 1 ? root.needleLength2 / 100 : root.needleLength2))
                radius: width / 2
                color: root.needleBrush2
                opacity: 0.85
            }
        }

        Rectangle {
            visible: root.showNeedle
            anchors.centerIn: parent
            width: Math.max(10, root.needleWidth * 3)
            height: width
            radius: width / 2
            z: 2
            color: Theme.bgCard
            border.width: 2
            border.color: root.effectiveFillColor
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: Math.abs(root.maxAngle - root.minAngle) < 360
                                          ? gaugeFace.radius * 0.22 : 0
            spacing: 2
            visible: root.showValue
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.title.length > 0
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.formattedValue
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontSubtitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.caption.length > 0
                text: root.caption
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.caption.length === 0 && root.unit.length === 0
                text: qsTr("%1 / %2").arg(Math.round(root.minimum)).arg(Math.round(root.maximum))
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.isInteractive && root.enabled
            preventStealing: true
            cursorShape: Qt.PointingHandCursor
            function apply(mx, my) {
                var p = mapToItem(gaugeFace, mx, my)
                root.setValueFromNorm(root.normFromPoint(p.x, p.y))
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
