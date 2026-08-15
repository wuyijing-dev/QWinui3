import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// RadialGauge — Circular gauge with needle and zones.
//
//   RadialGauge {
//       id: radialGauge
//      value: 72; minimum: 0; maximum: 100
//   }
//
//   // --- API ---
//   // signals: onValueEdited
//   // methods: setValue(v), setValueFromNorm(n), normFromPoint(px, py)
//   // radialGauge.setValue(v)
//   // radialGauge.setValueFromNorm(n)
//   // radialGauge.normFromPoint(px, py)

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
    // Stroke thickness in px
    property real strokeWidth: 10
    // Show numeric value label
    property bool showValue: true
    // Value unit label (%, rpm, …)
    property string unit: ""
    // Primary title text
    property string title: ""
    // Caption under / beside the value
    property string caption: ""
    // Digits after decimal for value text
    property int valuePrecision: 0
    // Major tick count
    property int tickCount: 8
    // Track / remaining color
    property color trackColor: Theme.strokeDivider
    // Primary fill / progress color
    property color fillColor: Theme.accent
    // Show needle indicator
    property bool showNeedle: true
    // Arc start angle in degrees
    property real startAngle: -210
    // Total sweep angle in degrees
    property real sweepTotal: 240
    // Value where caution zone starts
    property real cautionThreshold: -1
    // Value where critical zone starts
    property real criticalThreshold: -1
    // Invert caution/critical threshold logic
    property bool invertThresholds: false
    // Alias of interactive
    property bool isInteractive: false
    // Enable hover / click interaction
    property alias interactive: root.isInteractive

    // Emitted when user commits a value
    signal valueEdited(real value)

    implicitWidth: 148
    implicitHeight: title.length ? 176 : 148
    padding: 8
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Gauge")
    Accessible.description: {
        var parts = []
        if (caption.length)
            parts.push(caption)
        parts.push(formattedValue)
        return parts.join(" — ")
    }

    // Value as 0..100 percentage
    readonly property real percentage: animatedNorm * 100
    // Resolved fill color
    readonly property color effectiveFillColor: {
        var n = invertThresholds ? (1 - animatedNorm) : animatedNorm
        if (criticalThreshold >= 0 && n >= criticalThreshold)
            return Theme.systemCritical
        if (cautionThreshold >= 0 && n >= cautionThreshold)
            return Theme.systemCaution
        return fillColor
    }

    // Normalized 0..1 value
    readonly property real normalized: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (value - minimum) / span))
    }

    // Formatted value string
    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        return t + (unit.length ? unit : "")
    }

    // Set value (clamped / snapped)
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

    // Set value from a normalized 0..1 input
    function setValueFromNorm(n) {
        setValue(minimum + Math.max(0, Math.min(1, n)) * (maximum - minimum))
    }

    // Normalize a pointer position to 0..1
    function normFromPoint(px, py) {
        var cx = gaugeFace.width / 2
        var cy = gaugeFace.height / 2
        var deg = Math.atan2(py - cy, px - cx) * 180 / Math.PI
        var a = deg
        while (a < root.startAngle)
            a += 360
        while (a > root.startAngle + root.sweepTotal + 180)
            a -= 360
        return Math.max(0, Math.min(1, (a - root.startAngle) / Math.max(1e-6, root.sweepTotal)))
    }

    Keys.onLeftPressed: if (isInteractive) {
        setValue(value - (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }
    Keys.onRightPressed: if (isInteractive) {
        setValue(value + (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
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
    Component.onCompleted: animatedValue = value

    // Animated 0..1 normalized value
    readonly property real animatedNorm: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }

    contentItem: Item {
        id: gaugeFace
        // Corner radius
        readonly property real radius: Math.min(width, height) / 2 - root.strokeWidth - 2

        // Soft glow under progress
        Rectangle {
            anchors.centerIn: parent
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

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.trackColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: gaugeFace.width / 2 + Math.cos(root.startAngle * Math.PI / 180) * gaugeFace.radius
                startY: gaugeFace.height / 2 + Math.sin(root.startAngle * Math.PI / 180) * gaugeFace.radius
                PathAngleArc {
                    centerX: gaugeFace.width / 2
                    centerY: gaugeFace.height / 2
                    radiusX: gaugeFace.radius
                    radiusY: gaugeFace.radius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepTotal
                }
            }
        }

        Shape {
            id: fillArc
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            // Sweep angle in degrees
            property real sweep: root.animatedNorm * root.sweepTotal
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.enabled ? root.effectiveFillColor : Theme.textDisabled
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: gaugeFace.width / 2 + Math.cos(root.startAngle * Math.PI / 180) * gaugeFace.radius
                startY: gaugeFace.height / 2 + Math.sin(root.startAngle * Math.PI / 180) * gaugeFace.radius
                PathAngleArc {
                    centerX: gaugeFace.width / 2
                    centerY: gaugeFace.height / 2
                    radiusX: gaugeFace.radius
                    radiusY: gaugeFace.radius
                    startAngle: root.startAngle
                    sweepAngle: fillArc.sweep
                }
            }
        }

        Repeater {
            model: root.tickCount
            Rectangle {
                required property int index
                width: 2
                height: root.strokeWidth * 0.4
                radius: 1
                color: Theme.textSecondary
                opacity: 0.45
                // Angle in degrees
                property real angDeg: root.startAngle + (index / Math.max(1, root.tickCount - 1)) * root.sweepTotal
                // Angle in degrees
                property real ang: angDeg * Math.PI / 180
                // Resolved radius
                property real rr: gaugeFace.radius
                x: gaugeFace.width / 2 + Math.cos(ang) * rr - width / 2
                y: gaugeFace.height / 2 + Math.sin(ang) * rr - height / 2
                rotation: angDeg + 90
            }
        }

        // Needle
        Item {
            visible: root.showNeedle
            anchors.fill: parent
            rotation: root.startAngle + 90 + root.animatedNorm * root.sweepTotal
            transformOrigin: Item.Center
            Behavior on rotation {
                enabled: false // driven by animatedNorm already
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                width: 3
                height: gaugeFace.radius * 0.72
                radius: 1.5
                color: Theme.textPrimary
                opacity: 0.85
            }
            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 10
                radius: 5
                color: Theme.bgCard
                border.width: 2
                border.color: root.effectiveFillColor
            }
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.sweepTotal < 360 ? gaugeFace.radius * 0.22 : 0
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
            cursorShape: Qt.PointingHandCursor
            function apply(mx, my) {
                root.setValueFromNorm(root.normFromPoint(mx, my))
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
