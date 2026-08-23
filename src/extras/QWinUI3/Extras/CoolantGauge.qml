import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// CoolantGauge — Automotive C–H coolant temperature.
//
//   CoolantGauge { value: 92; unit: "°C" }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental. Prefer ThermometerGauge for a stem-and-bulb lab scale.

T.Control {
    id: root
    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("Coolant")
    Accessible.description: Math.round(animatedValue) + unit

    property real value: 90
    property real minimum: 50
    property real maximum: 130
    property string title: ""
    property string unit: "°C"
    property real coldNorm: 0.28
    property real hotNorm: 0.82
    property real startAngle: -200
    property real sweepTotal: 220
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 148
    implicitHeight: title.length ? 168 : 148
    padding: 8

    property real animatedValue: value
    Behavior on animatedValue {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionSlow); easing.type: Theme.easingStandard }
    }
    onValueChanged: animatedValue = value
    Component.onCompleted: animatedValue = value

    readonly property real animatedNorm: {
        var span = maximum - minimum
        return span <= 0 ? 0 : Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }
    readonly property color fillColor: {
        if (animatedNorm >= hotNorm)
            return Theme.systemCritical
        if (animatedNorm <= coldNorm)
            return Theme.accent
        return Theme.systemSuccess
    }

    function setValue(v) { value = Math.max(minimum, Math.min(maximum, v)) }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            spacing: 2
            Text {
                visible: root.title.length > 0
                text: root.title
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Item {
                id: face
                Layout.fillWidth: true
                Layout.fillHeight: true
                readonly property real pivotY: height * 0.62
                Canvas {
                    id: canvas
                    anchors.fill: parent
                    antialiasing: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var cx = width / 2
                var cy = height * 0.62
                var r = Math.min(width, height) * 0.4
                var start = root.startAngle * Math.PI / 180
                var sweep = root.sweepTotal * Math.PI / 180
                ctx.lineCap = "butt"
                ctx.lineWidth = 10
                ctx.strokeStyle = Theme.accent
                ctx.beginPath()
                ctx.arc(cx, cy, r, start, start + sweep * root.coldNorm)
                ctx.stroke()
                ctx.strokeStyle = Theme.systemSuccess
                ctx.beginPath()
                ctx.arc(cx, cy, r, start + sweep * root.coldNorm, start + sweep * root.hotNorm)
                ctx.stroke()
                ctx.strokeStyle = Theme.systemCritical
                ctx.beginPath()
                ctx.arc(cx, cy, r, start + sweep * root.hotNorm, start + sweep)
                ctx.stroke()
                var needle = start + root.animatedNorm * sweep
                ctx.strokeStyle = Theme.textPrimary
                ctx.lineWidth = 2.5
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(needle) * (r - 12), cy + Math.sin(needle) * (r - 12))
                ctx.stroke()
                ctx.fillStyle = Theme.textSecondary
                ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                ctx.textAlign = "center"
                ctx.fillText("C", cx + Math.cos(start) * (r + 12), cy + Math.sin(start) * (r + 12))
                ctx.fillText("H", cx + Math.cos(start + sweep) * (r + 12), cy + Math.sin(start + sweep) * (r + 12))
            }
                }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: Math.round(root.animatedValue) + root.unit
                font.weight: Theme.fontWeightSemiBold
                color: root.fillColor
            }
            }
        }

        GaugeDragLayer {
            coordSpace: face
            enabled: root.isInteractive && root.enabled
            onDragged: function (x, y) {
                var span = root.maximum - root.minimum
                var cur = span <= 0 ? 0 : (root.value - root.minimum) / span
                var n = GaugeUtils.normFromAngle(x, y, face.width / 2, face.pivotY, root.startAngle, root.sweepTotal, cur)
                root.setValue(GaugeUtils.valueFromNorm(n, root.minimum, root.maximum))
                root.valueEdited(root.value)
                canvas.requestPaint()
            }
        }
    }
    onAnimatedValueChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    background: Item {}
}
