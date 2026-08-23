import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TachometerGauge — RPM-style needle with a redline band.
//
//   TachometerGauge {
//       value: 4200
//       maximum: 8000
//       redline: 6500
//       unit: "rpm"
//   }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental. Prefer RadialGauge for a general needle scale; this type adds a redline arc.

T.Control {
    id: root

    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Tachometer")

    property real value: 0
    property real minimum: 0
    property real maximum: 8000
    property real redline: 6500
    property string title: ""
    property string unit: "rpm"
    property color fillColor: Theme.accent
    property color redlineColor: Theme.systemCritical
    property real startAngle: -210
    property real sweepTotal: 240
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 180
    implicitHeight: title.length ? 200 : 180
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
    readonly property real redlineNorm: {
        var span = maximum - minimum
        return span <= 0 ? 1 : Math.max(0, Math.min(1, (redline - minimum) / span))
    }

    function setValue(v) {
        value = Math.max(minimum, Math.min(maximum, v))
    }

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
                    var r = Math.min(width, height) * 0.42
                    var start = root.startAngle * Math.PI / 180
                    var sweep = root.sweepTotal * Math.PI / 180

                    function pt(ang, rad) {
                        return { x: cx + Math.cos(ang) * rad, y: cy + Math.sin(ang) * rad }
                    }

                    ctx.lineCap = "round"
                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 10
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, start, start + sweep)
                    ctx.stroke()

                    var redStart = start + root.redlineNorm * sweep
                    ctx.strokeStyle = root.redlineColor
                    ctx.lineWidth = 10
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, redStart, start + sweep)
                    ctx.stroke()

                    var ticks = 8
                    ctx.strokeStyle = Theme.textSecondary
                    ctx.fillStyle = Theme.textSecondary
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "middle"
                    ctx.lineWidth = 1.5
                    for (var t = 0; t <= ticks; ++t) {
                        var nrm = t / ticks
                        var ang = start + nrm * sweep
                        var p0 = pt(ang, r - 8)
                        var p1 = pt(ang, r + 4)
                        ctx.beginPath()
                        ctx.moveTo(p0.x, p0.y)
                        ctx.lineTo(p1.x, p1.y)
                        ctx.stroke()
                        var lab = Math.round(root.minimum + nrm * (root.maximum - root.minimum))
                        var pl = pt(ang, r - 22)
                        ctx.fillText(String(lab), pl.x, pl.y)
                    }

                    var needleAng = start + root.animatedNorm * sweep
                    var tip = pt(needleAng, r - 16)
                    ctx.strokeStyle = root.fillColor
                    ctx.fillStyle = root.fillColor
                    ctx.lineWidth = 3
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(tip.x, tip.y)
                    ctx.stroke()
                    ctx.beginPath()
                    ctx.arc(cx, cy, 6, 0, Math.PI * 2)
                    ctx.fill()
                }
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: Math.round(root.animatedValue) + " " + root.unit
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: root.animatedNorm >= root.redlineNorm ? root.redlineColor : Theme.textPrimary
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
