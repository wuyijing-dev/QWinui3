import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// ArcGauge — Open-arc dashboard gauge with center value and thresholds.
//
//   ArcGauge { value: 64; minimum: 0; maximum: 100 }

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
    // Stroke thickness in px
    property real strokeWidth: 12
    // Primary fill / progress color
    property color fillColor: Theme.accent
    // Track / remaining color
    property color trackColor: Theme.strokeDivider
    // Arc start angle in degrees
    property real startAngle: -180
    // Total sweep angle in degrees
    property real sweepTotal: 180
    // Value where caution zone starts
    property real cautionThreshold: -1
    // Value where critical zone starts
    property real criticalThreshold: -1
    // Invert caution/critical threshold logic
    property bool invertThresholds: false
    // Show numeric value label
    property bool showValue: true
    // Show min/max labels
    property bool showMinMax: false
    // Alias of interactive
    property bool isInteractive: false
    // Enable hover / click interaction
    property alias interactive: root.isInteractive

    // Emitted when user commits a value
    signal valueEdited(real value)

    implicitWidth: 160
    implicitHeight: title.length || caption.length || showMinMax ? 140 : 108
    padding: 8
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Arc gauge")
    Accessible.description: formattedValue

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

    // Formatted value string
    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
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
    Component.onCompleted: animatedValue = value

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

    // Normalize a pointer position to 0..1
    function normFromPoint(px, py, cx, cy) {
        var dx = px - cx
        var dy = py - cy
        var deg = Math.atan2(dy, dx) * 180 / Math.PI
        // Normalize into [startAngle, startAngle+sweep]
        var a = deg
        while (a < root.startAngle)
            a += 360
        while (a > root.startAngle + root.sweepTotal + 180)
            a -= 360
        var n = (a - root.startAngle) / Math.max(1e-6, root.sweepTotal)
        return Math.max(0, Math.min(1, n))
    }

    Keys.onLeftPressed: if (isInteractive) {
        setValue(value - (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }
    Keys.onRightPressed: if (isInteractive) {
        setValue(value + (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }

    contentItem: Item {
        id: face
        // Center X
        readonly property real cx: width / 2
        // Center Y
        readonly property real cy: height * 0.92
        // Corner radius
        readonly property real radius: Math.min(width * 0.48, height * 0.85) - root.strokeWidth

        Shape {
            anchors.fill: parent
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
            // Sweep angle in degrees
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

        Rectangle {
            width: root.strokeWidth + 4
            height: width
            radius: width / 2
            color: Theme.bgCard
            border.width: root.activeFocus && root.isInteractive ? 2 : 2
            border.color: root.activeFocus && root.isInteractive
                          ? Theme.focusOuter
                          : (root.enabled ? root.effectiveFillColor : Theme.textDisabled)
            scale: drag.pressed && !Theme.reducedMotion ? 1.1 : 1
            // Angle in degrees
            readonly property real ang: (root.startAngle + root.animatedNorm * root.sweepTotal) * Math.PI / 180
            x: face.cx + Math.cos(ang) * face.radius - width / 2
            y: face.cy + Math.sin(ang) * face.radius - height / 2
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            spacing: 2
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
                visible: root.showValue
                text: root.formattedValue
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontTitle
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
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.showMinMax
                spacing: 16
                Text {
                    text: Math.round(root.minimum)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
                Text {
                    text: Math.round(root.maximum)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
            }
        }

        MouseArea {
            id: drag
            anchors.fill: parent
            enabled: root.isInteractive && root.enabled
            cursorShape: Qt.PointingHandCursor
            function apply(mx, my) {
                root.setValueFromNorm(root.normFromPoint(mx, my, face.cx, face.cy))
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
