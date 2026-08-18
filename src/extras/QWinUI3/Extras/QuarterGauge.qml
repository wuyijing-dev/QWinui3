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

    implicitWidth: 168
    implicitHeight: title.length ? 148 : 128
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

    readonly property string formattedValue: Math.round(animatedValue) + unit

    function setValue(v) { value = Math.max(minimum, Math.min(maximum, v)) }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            spacing: 4

            Text {
                visible: root.title.length > 0
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }

            Item {
                id: face
                Layout.fillWidth: true
                Layout.preferredHeight: 112

                readonly property real margin: 4
                readonly property real labelReserve: 48
                readonly property real radius: Math.max(28, Math.min(
                    width - margin - labelReserve,
                    (height - margin) / 1.707
                ))
                readonly property real cx: margin + radius
                readonly property real cy: height - margin - radius

                Canvas {
                    id: canvas
                    anchors.fill: parent
                    antialiasing: true
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        var cx = face.cx
                        var cy = face.cy
                        var r = face.radius
                        var trackR = r * 0.72
                        var start = root.startAngle * Math.PI / 180
                        var sweep = root.sweepTotal * Math.PI / 180
                        ctx.lineCap = "round"
                        ctx.strokeStyle = Theme.strokeDivider
                        ctx.lineWidth = 12
                        ctx.beginPath()
                        ctx.arc(cx, cy, trackR, start, start + sweep)
                        ctx.stroke()
                        ctx.strokeStyle = root.fillColor
                        ctx.beginPath()
                        ctx.arc(cx, cy, trackR, start, start + sweep * root.animatedNorm)
                        ctx.stroke()
                        var nrm = start + sweep * root.animatedNorm
                        ctx.strokeStyle = Theme.textPrimary
                        ctx.lineWidth = 3
                        ctx.beginPath()
                        ctx.moveTo(cx, cy)
                        ctx.lineTo(cx + Math.cos(nrm) * r * 0.64, cy + Math.sin(nrm) * r * 0.64)
                        ctx.stroke()
                        ctx.fillStyle = Theme.textPrimary
                        ctx.beginPath()
                        ctx.arc(cx, cy, 4, 0, Math.PI * 2)
                        ctx.fill()
                    }
                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                    Connections {
                        target: root
                        function onAnimatedValueChanged() { canvas.requestPaint() }
                        function onFillColorChanged() { canvas.requestPaint() }
                    }
                    Connections {
                        target: face
                        function onRadiusChanged() { canvas.requestPaint() }
                    }
                }

                Text {
                    text: root.formattedValue
                    font.family: Theme.fontFamilyDisplay
                    font.pixelSize: Theme.fontTitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: face.cx + 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -face.radius * 0.12
                }
            }
        }

        GaugeDragLayer {
            coordSpace: face
            enabled: root.isInteractive && root.enabled
            onDragged: function (x, y) {
                var n = GaugeUtils.normFromAngle(x, y, face.cx, face.cy, root.startAngle, root.sweepTotal)
                root.setValue(GaugeUtils.valueFromNorm(n, root.minimum, root.maximum))
                root.valueEdited(root.value)
                canvas.requestPaint()
            }
        }
    }

    background: Item {}
}
