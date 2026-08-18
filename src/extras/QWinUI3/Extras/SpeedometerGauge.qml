import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// SpeedometerGauge — Vehicle speed needle (km/h or mph).
//
//   SpeedometerGauge {
//       value: 86
//       maximum: 240
//       unit: "km/h"
//   }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental automotive speedo. Prefer RadialGauge for a generic needle scale.

T.Control {
    id: root
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Speedometer")
    Accessible.description: Math.round(animatedValue) + " " + unit

    property real value: 0
    property real minimum: 0
    property real maximum: 240
    property int majorTick: 20
    property string title: ""
    property string unit: "km/h"
    property color fillColor: Theme.accent
    property real startAngle: -210
    property real sweepTotal: 240
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 220
    implicitHeight: title.length ? 240 : 220
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
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var cx = width / 2
                    var cy = height * 0.56
                    var r = Math.min(width, height) * 0.42
                    var start = root.startAngle * Math.PI / 180
                    var sweep = root.sweepTotal * Math.PI / 180
                    var span = root.maximum - root.minimum
                    var majors = Math.max(1, Math.round(span / Math.max(1, root.majorTick)))
                    ctx.lineCap = "round"
                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 12
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, start, start + sweep)
                    ctx.stroke()
                    ctx.strokeStyle = Theme.textSecondary
                    ctx.fillStyle = Theme.textSecondary
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "middle"
                    for (var t = 0; t <= majors; ++t) {
                        var nrm = t / majors
                        var ang = start + nrm * sweep
                        ctx.lineWidth = t % 2 === 0 ? 2 : 1
                        ctx.beginPath()
                        ctx.moveTo(cx + Math.cos(ang) * (r - 8), cy + Math.sin(ang) * (r - 8))
                        ctx.lineTo(cx + Math.cos(ang) * (r + 4), cy + Math.sin(ang) * (r + 4))
                        ctx.stroke()
                        if (t % 2 === 0) {
                            var lab = Math.round(root.minimum + nrm * span)
                            ctx.fillText(String(lab), cx + Math.cos(ang) * (r - 22), cy + Math.sin(ang) * (r - 22))
                        }
                    }
                    var needle = start + root.animatedNorm * sweep
                    ctx.strokeStyle = root.fillColor
                    ctx.fillStyle = root.fillColor
                    ctx.lineWidth = 3
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + Math.cos(needle) * (r - 16), cy + Math.sin(needle) * (r - 16))
                    ctx.stroke()
                    ctx.beginPath()
                    ctx.arc(cx, cy, 6, 0, Math.PI * 2)
                    ctx.fill()
                }
            }
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                spacing: 0
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: String(Math.round(root.animatedValue))
                    font.family: Theme.fontFamilyDisplay
                    font.pixelSize: Theme.fontTitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.unit
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.isInteractive
                cursorShape: Qt.PointingHandCursor
                onPressed: function (mouse) { positionChanged(mouse) }
                onPositionChanged: function (mouse) {
                    if (!pressed)
                        return
                    var cx = width / 2
                    var cy = height * 0.56
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
