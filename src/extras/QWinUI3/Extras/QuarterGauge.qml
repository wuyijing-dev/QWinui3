import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// QuarterGauge — 90° dashboard quadrant meter.
//
//   QuarterGauge { value: 72; unit: "%" }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental. Prefer RadialGauge when a full needle scale is needed.

T.Control {
    id: root
    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("Quarter gauge")
    Accessible.description: Math.round(animatedValue) + unit

    property real value: 0
    property real minimum: 0
    property real maximum: 100
    property string title: ""
    property string unit: ""
    property color fillColor: Theme.accent
    property real startAngle: 180
    property real sweepTotal: 90
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 160
    implicitHeight: title.length ? 160 : 140
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

    contentItem: ColumnLayout {
        spacing: 2
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
                var cx = width * 0.18
                var cy = height * 0.82
                var r = Math.min(width, height) * 0.78
                var start = root.startAngle * Math.PI / 180
                var sweep = root.sweepTotal * Math.PI / 180
                ctx.lineCap = "round"
                ctx.strokeStyle = Theme.strokeDivider
                ctx.lineWidth = 14
                ctx.beginPath()
                ctx.arc(cx, cy, r * 0.72, start, start + sweep)
                ctx.stroke()
                ctx.strokeStyle = root.fillColor
                ctx.beginPath()
                ctx.arc(cx, cy, r * 0.72, start, start + sweep * root.animatedNorm)
                ctx.stroke()
                var nrm = start + sweep * root.animatedNorm
                ctx.strokeStyle = Theme.textPrimary
                ctx.lineWidth = 3
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(nrm) * r * 0.62, cy + Math.sin(nrm) * r * 0.62)
                ctx.stroke()
                ctx.fillStyle = Theme.textPrimary
                ctx.font = Theme.fontBody + "px \"" + Theme.fontFamilyDisplay + "\""
                ctx.textAlign = "left"
                ctx.fillText(Math.round(root.animatedValue) + root.unit, cx + 12, cy - 8)
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.isInteractive
                onPressed: function (mouse) { positionChanged(mouse) }
                onPositionChanged: function (mouse) {
                    if (!pressed)
                        return
                    var cx = width * 0.18
                    var cy = height * 0.82
                    var ang = Math.atan2(mouse.y - cy, mouse.x - cx) * 180 / Math.PI
                    var rel = ang - root.startAngle
                    while (rel < 0)
                        rel += 360
                    root.setValue(root.minimum + Math.max(0, Math.min(1, rel / root.sweepTotal)) * (root.maximum - root.minimum))
                    root.valueEdited(root.value)
                    canvas.requestPaint()
                }
            }
        }
    }
    onAnimatedValueChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    background: Item {}
}
