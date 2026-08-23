import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// PressureGauge — Industrial needle with green / caution / red zones.
//
//   PressureGauge {
//       value: 6.2
//       maximum: 10
//       unit: "bar"
//   }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental zoned needle. Prefer RadialGauge for a generic scale.

T.Control {
    id: root
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Pressure")
    Accessible.description: Math.round(animatedValue * 10) / 10 + " " + unit

    property real value: 0
    property real minimum: 0
    property real maximum: 10
    property string title: ""
    property string unit: "bar"
    property real startAngle: -210
    property real sweepTotal: 240
    property real cautionNorm: 0.7
    property real criticalNorm: 0.88
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 176
    implicitHeight: title.length ? 196 : 176
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
                readonly property real pivotY: height * 0.56
                Canvas {
                    id: canvas
                    anchors.fill: parent
                    antialiasing: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var cx = width / 2
                var cy = height * 0.56
                var r = Math.min(width, height) * 0.4
                var start = root.startAngle * Math.PI / 180
                var sweep = root.sweepTotal * Math.PI / 180
                function arc(fromN, toN, col, lw) {
                    ctx.strokeStyle = col
                    ctx.lineWidth = lw
                    ctx.lineCap = "butt"
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, start + fromN * sweep, start + toN * sweep)
                    ctx.stroke()
                }
                arc(0, root.cautionNorm, Theme.systemSuccess, 10)
                arc(root.cautionNorm, root.criticalNorm, Theme.systemCaution, 10)
                arc(root.criticalNorm, 1, Theme.systemCritical, 10)
                ctx.strokeStyle = Theme.textSecondary
                ctx.lineWidth = 1.5
                ctx.fillStyle = Theme.textSecondary
                ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                var ticks = 10
                for (var t = 0; t <= ticks; ++t) {
                    var nrm = t / ticks
                    var ang = start + nrm * sweep
                    ctx.beginPath()
                    ctx.moveTo(cx + Math.cos(ang) * (r - 8), cy + Math.sin(ang) * (r - 8))
                    ctx.lineTo(cx + Math.cos(ang) * (r + 3), cy + Math.sin(ang) * (r + 3))
                    ctx.stroke()
                    var lab = ChartUtils.formatNumber(root.minimum + nrm * (root.maximum - root.minimum), 0)
                    ctx.fillText(lab, cx + Math.cos(ang) * (r - 20), cy + Math.sin(ang) * (r - 20))
                }
                var needle = start + root.animatedNorm * sweep
                ctx.strokeStyle = Theme.textPrimary
                ctx.lineWidth = 3
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(needle) * (r - 16), cy + Math.sin(needle) * (r - 16))
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
                text: (Math.round(root.animatedValue * 10) / 10) + " " + root.unit
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
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
