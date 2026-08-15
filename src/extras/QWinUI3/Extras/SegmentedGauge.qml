import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// SegmentedGauge — Segmented progress / capacity gauge.
//
//   SegmentedGauge { value: 3; maximum: 5 }

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
    // Number of gauge segments
    property int segmentCount: 12
    // Gap between segments in degrees
    property real gapDegrees: 6
    // Stroke thickness in px
    property real strokeWidth: 10
    // Primary title text
    property string title: ""
    // Value unit label (%, rpm, …)
    property string unit: ""
    // Caption under / beside the value
    property string caption: ""
    // Digits after decimal for value text
    property int valuePrecision: 0
    // Show numeric value label
    property bool showValue: true
    // Primary fill / progress color
    property color fillColor: Theme.accent
    // Track / remaining color
    property color trackColor: Theme.strokeDivider
    // Value where caution zone starts
    property real cautionThreshold: -1
    // Value where critical zone starts
    property real criticalThreshold: -1
    // Invert caution/critical threshold logic
    property bool invertThresholds: false
    // Arc start angle in degrees
    property real startAngle: -90
    // discrete | partial — partial fills the leading segment proportionally
    property string fillMode: "discrete"
    // Alias of interactive
    property bool isInteractive: false
    // Enable hover / click interaction
    property alias interactive: root.isInteractive

    // Emitted when user commits a value
    signal valueEdited(real value)
    // Emitted when a segment is clicked
    signal segmentClicked(int index)

    implicitWidth: 140
    implicitHeight: 140
    padding: 8
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Segmented gauge")
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

    // Filled Exact
    readonly property real filledExact: animatedNorm * Math.max(1, segmentCount)
    // Filled Segments
    readonly property int filledSegments: Math.floor(filledExact + (fillMode === "partial" ? 0 : 0.5))
    // Partial Amount
    readonly property real partialAmount: {
        if (fillMode !== "partial")
            return 0
        return filledExact - Math.floor(filledExact)
    }

    // Clamp Snap
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

    function setValue(v) { value = clampSnap(v) }

    function setSegment(index) {
        var n = Math.max(1, segmentCount)
        var i = Math.max(0, Math.min(n, Number(index) || 0))
        setValue(minimum + (i / n) * (maximum - minimum))
        segmentClicked(i)
        valueEdited(value)
    }

    Keys.onLeftPressed: if (isInteractive) {
        setValue(value - (stepSize > 0 ? stepSize : (maximum - minimum) / Math.max(1, segmentCount)))
        valueEdited(value)
    }
    Keys.onRightPressed: if (isInteractive) {
        setValue(value + (stepSize > 0 ? stepSize : (maximum - minimum) / Math.max(1, segmentCount)))
        valueEdited(value)
    }

    contentItem: Item {
        id: face
        // Corner radius
        readonly property real radius: Math.min(width, height) / 2 - root.strokeWidth - 2
        // Seg Sweep
        readonly property real segSweep: {
            var n = Math.max(1, root.segmentCount)
            var totalGap = root.gapDegrees * n
            return Math.max(2, (360 - totalGap) / n)
        }

        Repeater {
            model: root.segmentCount
            Shape {
                id: seg
                required property int index
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer
                // Fully Filled
                readonly property bool fullyFilled: {
                    if (root.fillMode === "partial")
                        return index < Math.floor(root.filledExact)
                    return index < root.filledSegments
                }
                // Is Partial
                readonly property bool isPartial: root.fillMode === "partial"
                        && index === Math.floor(root.filledExact)
                        && root.partialAmount > 0.01
                // Segment start value
                readonly property real segStart: root.startAngle
                        + index * (face.segSweep + root.gapDegrees)
                // Draw Sweep
                readonly property real drawSweep: isPartial
                        ? face.segSweep * root.partialAmount
                        : face.segSweep
                opacity: fullyFilled || isPartial ? 1 : 0.35
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                ShapePath {
                    strokeWidth: root.strokeWidth
                    strokeColor: (seg.fullyFilled || seg.isPartial)
                                 ? (root.enabled ? root.effectiveFillColor : Theme.textDisabled)
                                 : root.trackColor
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    startX: face.width / 2 + Math.cos(seg.segStart * Math.PI / 180) * face.radius
                    startY: face.height / 2 + Math.sin(seg.segStart * Math.PI / 180) * face.radius
                    PathAngleArc {
                        centerX: face.width / 2
                        centerY: face.height / 2
                        radiusX: face.radius
                        radiusY: face.radius
                        startAngle: seg.segStart
                        sweepAngle: seg.drawSweep
                    }
                }
            }
        }

        // Track underlay for empty part of partial segment
        Repeater {
            model: root.fillMode === "partial" ? root.segmentCount : 0
            Shape {
                id: under
                required property int index
                visible: index === Math.floor(root.filledExact) && root.partialAmount > 0.01
                         && root.partialAmount < 0.99
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer
                z: -1
                // Segment start value
                readonly property real segStart: root.startAngle
                        + index * (face.segSweep + root.gapDegrees)
                ShapePath {
                    strokeWidth: root.strokeWidth
                    strokeColor: root.trackColor
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    startX: face.width / 2 + Math.cos(under.segStart * Math.PI / 180) * face.radius
                    startY: face.height / 2 + Math.sin(under.segStart * Math.PI / 180) * face.radius
                    PathAngleArc {
                        centerX: face.width / 2
                        centerY: face.height / 2
                        radiusX: face.radius
                        radiusY: face.radius
                        startAngle: under.segStart
                        sweepAngle: face.segSweep
                    }
                }
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 2
            z: 1
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
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.isInteractive && root.enabled
            cursorShape: Qt.PointingHandCursor
            onClicked: function (mouse) {
                var dx = mouse.x - width / 2
                var dy = mouse.y - height / 2
                var deg = Math.atan2(dy, dx) * 180 / Math.PI
                var a = deg - root.startAngle
                while (a < 0)
                    a += 360
                while (a >= 360)
                    a -= 360
                var slot = face.segSweep + root.gapDegrees
                var idx = Math.floor(a / slot) + 1
                root.setSegment(Math.max(0, Math.min(root.segmentCount, idx)))
            }
        }
    }

    background: Item {}
}
