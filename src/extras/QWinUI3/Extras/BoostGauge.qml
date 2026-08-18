import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// BoostGauge — Turbo vacuum / boost with zero at center-left of the scale.
//
//   BoostGauge { value: 0.6; minimum: -1; maximum: 1.5; unit: "bar" }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental. Prefer RadialGauge when boost is just another linear scale.

T.Control {
    id: root
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Boost")
    Accessible.description: (Math.round(animatedValue * 10) / 10) + " " + unit

    property real value: 0
    property real minimum: -1
    property real maximum: 1.5
    property string title: ""
    property string unit: "bar"
    property real startAngle: -210
    property real sweepTotal: 240
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 168
    implicitHeight: title.length ? 188 : 168
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
    readonly property real zeroNorm: {
        var span = maximum - minimum
        return span <= 0 ? 0 : Math.max(0, Math.min(1, (0 - minimum) / span))
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
                readonly property real pivotY: height * 0.58
                Canvas {
                    id: canvas
                    anchors.fill: parent
                    antialiasing: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var cx = width / 2
                var cy = height * 0.58
                var r = Math.min(width, height) * 0.4
                var start = root.startAngle * Math.PI / 180
                var sweep = root.sweepTotal * Math.PI / 180
                ctx.lineWidth = 10
                ctx.lineCap = "butt"
                ctx.strokeStyle = Theme.textSecondary
                ctx.beginPath()
                ctx.arc(cx, cy, r, start, start + sweep * root.zeroNorm)
                ctx.stroke()
                ctx.strokeStyle = Theme.accent
                ctx.beginPath()
                ctx.arc(cx, cy, r, start + sweep * root.zeroNorm, start + sweep * 0.78)
                ctx.stroke()
                ctx.strokeStyle = Theme.systemCritical
                ctx.beginPath()
                ctx.arc(cx, cy, r, start + sweep * 0.78, start + sweep)
                ctx.stroke()
                var needle = start + root.animatedNorm * sweep
                ctx.strokeStyle = Theme.textPrimary
                ctx.lineWidth = 3
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(needle) * (r - 14), cy + Math.sin(needle) * (r - 14))
                ctx.stroke()
                ctx.fillStyle = Theme.textPrimary
                ctx.beginPath()
                ctx.arc(cx, cy, 5, 0, Math.PI * 2)
                ctx.fill()
            }
                }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: (root.animatedValue >= 0 ? "+" : "") + (Math.round(root.animatedValue * 10) / 10) + " " + root.unit
                font.weight: Theme.fontWeightSemiBold
                color: root.animatedNorm >= 0.78 ? Theme.systemCritical : Theme.textPrimary
            }
            }
        }

        GaugeDragLayer {
            coordSpace: face
            enabled: root.isInteractive && root.enabled
            onDragged: function (x, y) {
                var n = GaugeUtils.normFromAngle(x, y, face.width / 2, face.pivotY, root.startAngle, root.sweepTotal)
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
