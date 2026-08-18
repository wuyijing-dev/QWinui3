import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// FuelGauge — Empty/full arc with E–F marks.
//
//   FuelGauge { value: 0.28 }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental. Prefer RingGauge for a generic closed KPI ring.

T.Control {
    id: root
    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("Fuel")
    Accessible.description: Math.round(animatedNorm * 100) + "%"

    property real value: 0
    property real minimum: 0
    property real maximum: 1
    property string title: ""
    property real startAngle: -200
    property real sweepTotal: 220
    property real cautionThreshold: 0.25
    property real criticalThreshold: 0.12
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
    readonly property color fillColor: {
        if (animatedNorm <= criticalThreshold)
            return Theme.systemCritical
        if (animatedNorm <= cautionThreshold)
            return Theme.systemCaution
        return Theme.accent
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
                var cx = width / 2
                var cy = height * 0.62
                var r = Math.min(width, height) * 0.42
                var start = root.startAngle * Math.PI / 180
                var sweep = root.sweepTotal * Math.PI / 180
                ctx.lineCap = "round"
                ctx.strokeStyle = Theme.strokeDivider
                ctx.lineWidth = 12
                ctx.beginPath()
                ctx.arc(cx, cy, r, start, start + sweep)
                ctx.stroke()
                ctx.strokeStyle = root.fillColor
                ctx.beginPath()
                ctx.arc(cx, cy, r, start, start + sweep * root.animatedNorm)
                ctx.stroke()
                var needle = start + sweep * root.animatedNorm
                ctx.strokeStyle = Theme.textPrimary
                ctx.lineWidth = 2.5
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(needle) * (r - 14), cy + Math.sin(needle) * (r - 14))
                ctx.stroke()
                ctx.fillStyle = Theme.textSecondary
                ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                ctx.textAlign = "center"
                ctx.fillText("E", cx + Math.cos(start) * (r + 14), cy + Math.sin(start) * (r + 14))
                ctx.fillText("F", cx + Math.cos(start + sweep) * (r + 14), cy + Math.sin(start + sweep) * (r + 14))
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: Math.round(root.animatedNorm * 100) + "%"
                font.weight: Theme.fontWeightSemiBold
                color: root.fillColor
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.isInteractive
                onPressed: function (mouse) { positionChanged(mouse) }
                onPositionChanged: function (mouse) {
                    if (!pressed)
                        return
                    var cx = width / 2
                    var cy = height * 0.62
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
