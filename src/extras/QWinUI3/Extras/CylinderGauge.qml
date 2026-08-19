import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// CylinderGauge — Isometric cylinder level.
//
//   CylinderGauge { value: 62; unit: "%" }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental. Prefer TankGauge for a 2D reservoir.

T.Control {
    id: root
    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("Cylinder")
    Accessible.description: Math.round(animatedValue) + unit

    property real value: 0
    property real minimum: 0
    property real maximum: 100
    property string title: ""
    property string unit: "%"
    property color fillColor: Theme.accent
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 120
    implicitHeight: title.length ? 180 : 160
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
            spacing: 4
            Text {
                visible: root.title.length > 0
                text: root.title
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Canvas {
                id: canvas
                Layout.fillWidth: true
                Layout.fillHeight: true
                antialiasing: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var w = width
                var h = height
                var cx = w / 2
                var bw = Math.min(w * 0.55, 56)
                var top = 14
                var bot = h - 10
                var eh = 12
                function ellipse(cy, fill, stroke) {
                    ctx.save()
                    ctx.translate(cx, cy)
                    ctx.scale(1, eh / Math.max(1, bw))
                    ctx.beginPath()
                    ctx.arc(0, 0, bw / 2, 0, Math.PI * 2)
                    if (fill) {
                        ctx.fillStyle = fill
                        ctx.fill()
                    }
                    if (stroke) {
                        ctx.strokeStyle = stroke
                        ctx.stroke()
                    }
                    ctx.restore()
                }
                ctx.strokeStyle = Theme.strokeControl
                ctx.lineWidth = 1.5
                ctx.beginPath()
                ctx.moveTo(cx - bw / 2, top)
                ctx.lineTo(cx - bw / 2, bot)
                ctx.moveTo(cx + bw / 2, top)
                ctx.lineTo(cx + bw / 2, bot)
                ctx.stroke()
                ellipse(bot, ChartUtils.withAlpha(Theme.strokeDivider, 0.35), Theme.strokeControl)
                var fillTop = bot - (bot - top) * root.animatedNorm
                ctx.fillStyle = ChartUtils.withAlpha(root.fillColor, 0.55)
                ctx.fillRect(cx - bw / 2, fillTop, bw, bot - fillTop)
                ellipse(bot, ChartUtils.withAlpha(root.fillColor, 0.45), null)
                ellipse(fillTop, root.fillColor, Theme.strokeControl)
                ellipse(top, "transparent", Theme.strokeControl)
            }
            }
            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                text: Math.round(root.animatedValue) + root.unit
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }

        GaugeDragLayer {
            coordSpace: canvas
            enabled: root.isInteractive && root.enabled
            onDragged: function (x, y) {
                var nrm = 1 - Math.max(0, Math.min(1, (y - 14) / Math.max(1, canvas.height - 24)))
                root.setValue(GaugeUtils.valueFromNorm(nrm, root.minimum, root.maximum))
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
