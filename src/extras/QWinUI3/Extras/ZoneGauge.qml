import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// ZoneGauge — Gauge with colored zones.
//
//   ZoneGauge {
//       id: zoneGauge
//       value: 55; minimum: 0; maximum: 100
//   }
//
//   // --- API ---
//   // signals: onValueEdited
//   // methods: zoneColor(z, index), clampSnap(v), setValue(v), setValueFromNorm(n), normFromPoint(px, py)
//   // zoneGauge.zoneColor(z, index)
//   // zoneGauge.clampSnap(v)
//   // zoneGauge.setValue(v)
//   // zoneGauge.setValueFromNorm(n)
//
// @notes
//   Gauge with explicit colored zones; activeZoneIndex/Color/Label track the needle.
//   Toolkit-aligned aliases: minAngle/maxAngle, scaleWidth, needleLength/Width, valueStringFormat.

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
    // Stroke thickness in px (Toolkit ScaleWidth)
    property real strokeWidth: 14
    property alias scaleWidth: root.strokeWidth
    // Show needle indicator
    property bool showNeedle: true
    // Needle length as fraction of radius (or 0–100 Toolkit percent)
    property real needleLength: 0.7
    property real needleWidth: 3
    property color needleBrush: Theme.textPrimary
    // Show numeric value label
    property bool showValue: true
    // Toolkit-style format: "N0", "N1", …
    property string valueStringFormat: ""
    // Show tick marks
    property bool showTicks: true
    // Major tick count
    property int tickCount: 9
    // Tick spacing in value units (0 = use tickCount)
    property real tickSpacing: 0
    // Arc start / end (Toolkit MinAngle / MaxAngle)
    property real startAngle: -210
    property real sweepTotal: 240
    property alias minAngle: root.startAngle
    property real maxAngle: startAngle + sweepTotal
    onMaxAngleChanged: {
        var expected = startAngle + sweepTotal
        if (Math.abs(maxAngle - expected) > 0.001)
            sweepTotal = maxAngle - startAngle
    }
    // Alias of interactive
    property bool isInteractive: false
    // Enable hover / click interaction
    property alias interactive: root.isInteractive
    // Extra drag hit padding outside the face (px)
    property real interactionPadding: 24
    // Colored gauge zones
    property var zones: [
        { from: 0, to: 0.55, color: "" },
        { from: 0.55, to: 0.8, color: "" },
        { from: 0.8, to: 1.0, color: "" }
    ]

    // Emitted when user commits a value
    signal valueEdited(real value)

    implicitWidth: 156
    implicitHeight: title.length ? 180 : 156
    padding: 8
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Zone gauge")
    Accessible.description: {
        var z = activeZoneLabel
        return z.length ? (formattedValue + " — " + z) : formattedValue
    }

    // Value as 0..100 percentage
    readonly property real percentage: animatedNorm * 100
    // Index of the active gauge zone
    readonly property int activeZoneIndex: {
        var n = animatedNorm
        var zs = zones || []
        for (var i = 0; i < zs.length; ++i) {
            var a = Number(zs[i].from) || 0
            var b = Number(zs[i].to) || 1
            if (n >= a && n <= b)
                return i
        }
        return Math.max(0, zs.length - 1)
    }
    // Label of the active gauge zone
    readonly property string activeZoneLabel: {
        var zs = zones || []
        var i = activeZoneIndex
        if (i < 0 || i >= zs.length)
            return ""
        return zs[i].label || ""
    }
    // Color of the active gauge zone
    readonly property color activeZoneColor: zoneColor(
        (zones && zones[activeZoneIndex]) ? zones[activeZoneIndex] : null,
        activeZoneIndex)

    // Formatted value string
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

    // Toolkit ValueAngle
    readonly property real valueAngle: startAngle + animatedNorm * sweepTotal

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

    // Zone color
    function zoneColor(z, index) {
        if (z && z.color !== undefined && String(z.color).length)
            return z.color
        switch (index) {
        case 0: return Theme.systemSuccess
        case 1: return Theme.systemCaution
        default: return Theme.systemCritical
        }
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

    // Set value
    function setValue(v) { value = clampSnap(v) }

    // Set value from norm
    function setValueFromNorm(n) {
        setValue(minimum + Math.max(0, Math.min(1, n)) * (maximum - minimum))
    }

    // Normalize a pointer position to 0..1
    function normFromPoint(px, py) {
        var cx = face.width / 2
        var cy = face.height / 2
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

    WheelHandler {
        enabled: root.isInteractive && root.enabled
        onWheel: function (event) {
            var step = root.stepSize > 0 ? root.stepSize : (root.maximum - root.minimum) * 0.05
            var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
            if (dir === 0)
                return
            root.setValue(root.value + (dir > 0 ? step : -step))
            root.valueEdited(root.value)
            event.accepted = true
        }
    }

    contentItem: Item {
        id: face
        // Corner radius
        readonly property real radius: Math.min(width, height) / 2 - root.strokeWidth - 2

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: Theme.strokeDivider
                fillColor: "transparent"
                capStyle: ShapePath.FlatCap
                startX: face.width / 2 + Math.cos(root.startAngle * Math.PI / 180) * face.radius
                startY: face.height / 2 + Math.sin(root.startAngle * Math.PI / 180) * face.radius
                PathAngleArc {
                    centerX: face.width / 2
                    centerY: face.height / 2
                    radiusX: face.radius
                    radiusY: face.radius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepTotal
                }
            }
        }

        Repeater {
            model: root.zones
            Shape {
                id: zoneShape
                required property var modelData
                required property int index
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer
                // Zone / arc start Z
                readonly property real zFrom: Math.max(0, Math.min(1, Number(modelData.from) || 0))
                // Zone / arc end Z
                readonly property real zTo: Math.max(zFrom, Math.min(1, Number(modelData.to) || 1))
                // Zone / arc start angle
                readonly property real zStart: root.startAngle + zFrom * root.sweepTotal
                // Zone / arc sweep angle
                readonly property real zSweep: (zTo - zFrom) * root.sweepTotal
                opacity: root.activeZoneIndex === index ? 1 : 0.72
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                ShapePath {
                    strokeWidth: root.strokeWidth - 2
                    strokeColor: root.zoneColor(modelData, index)
                    fillColor: "transparent"
                    capStyle: ShapePath.FlatCap
                    startX: face.width / 2 + Math.cos(zoneShape.zStart * Math.PI / 180) * face.radius
                    startY: face.height / 2 + Math.sin(zoneShape.zStart * Math.PI / 180) * face.radius
                    PathAngleArc {
                        centerX: face.width / 2
                        centerY: face.height / 2
                        radiusX: face.radius
                        radiusY: face.radius
                        startAngle: zoneShape.zStart
                        sweepAngle: zoneShape.zSweep
                    }
                }
            }
        }

        Repeater {
            model: root.showTicks ? root.tickCount : 0
            Rectangle {
                required property int index
                width: 2
                height: root.strokeWidth * 0.45
                radius: 1
                color: Theme.textSecondary
                opacity: 0.5
                // Angle in degrees
                property real angDeg: root.startAngle + (index / Math.max(1, root.tickCount - 1)) * root.sweepTotal
                // Angle in degrees
                property real ang: angDeg * Math.PI / 180
                x: face.width / 2 + Math.cos(ang) * face.radius - width / 2
                y: face.height / 2 + Math.sin(ang) * face.radius - height / 2
                rotation: angDeg + 90
            }
        }

        Item {
            visible: root.showNeedle
            anchors.fill: parent
            rotation: root.startAngle + 90 + root.animatedNorm * root.sweepTotal
            transformOrigin: Item.Center
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                width: root.needleWidth
                height: face.radius * Math.max(0, Math.min(1.2,
                        root.needleLength > 1 ? root.needleLength / 100 : root.needleLength))
                radius: width / 2
                color: root.needleBrush
                opacity: 0.9
            }
            Rectangle {
                anchors.centerIn: parent
                width: 12
                height: 12
                radius: 6
                color: Theme.bgCard
                border.width: 2
                border.color: root.activeZoneColor
            }
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.sweepTotal < 360 ? face.radius * 0.28 : 0
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
                font.pixelSize: Theme.fontSubtitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.activeZoneLabel.length > 0 || root.caption.length > 0
                text: root.activeZoneLabel.length ? root.activeZoneLabel : root.caption
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: root.activeZoneLabel.length ? root.activeZoneColor : Theme.textSecondary
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.isInteractive && root.enabled
            preventStealing: true
            cursorShape: Qt.PointingHandCursor
            function apply(mx, my) {
                var p = mapToItem(face, mx, my)
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
