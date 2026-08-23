import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ErrorBarChart — Mean (or value) with ± error whiskers.
//
//   ErrorBarChart {
//       points: [
//           { label: qsTr("A"), value: 42, error: 4 },
//           { label: qsTr("B"), value: 31, low: 26, high: 38 }
//       ]
//   }
//
// @notes
//   Experimental. Prefer BoxPlotChart when the full distribution is available.

T.Control {
    id: root
    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Error-bar chart")

    property var points: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 320
    implicitHeight: title.length ? 220 : 200
    padding: 8
    readonly property bool isEmpty: !(points && points.length)

    contentItem: ColumnLayout {
        spacing: 6
        Text {
            visible: root.title.length > 0
            text: root.title
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Text {
                anchors.centerIn: parent
                visible: root.isEmpty
                text: root.emptyText
                color: Theme.textSecondary
            }
            Canvas {
                id: canvas
                anchors.fill: parent
                visible: !root.isEmpty
                antialiasing: true
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var list = root.points
                    var n = list ? list.length : 0
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var lo = Number.POSITIVE_INFINITY
                    var hi = Number.NEGATIVE_INFINITY
                    var rows = []
                    for (var i = 0; i < n; ++i) {
                        var v = ChartUtils.asNumber(list[i].value)
                        var err = ChartUtils.asNumber(list[i].error)
                        var low = list[i].low !== undefined ? ChartUtils.asNumber(list[i].low) : v - err
                        var high = list[i].high !== undefined ? ChartUtils.asNumber(list[i].high) : v + err
                        rows.push({ v: v, low: low, high: high, label: list[i].label || String(i + 1), color: list[i].color || Theme.accent })
                        lo = Math.min(lo, low)
                        hi = Math.max(hi, high)
                    }
                    if (hi <= lo)
                        hi = lo + 1
                    var padL = 8
                    var padR = 8
                    var padT = 10
                    var padB = 18
                    var plotW = width - padL - padR
                    var plotH = height - padT - padB
                    var slot = plotW / n
                    function yOf(val) {
                        return padT + plotH - ((val - lo) / (hi - lo)) * plotH
                    }
                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 1
                    for (var g = 0; g <= 3; ++g) {
                        var gy = padT + plotH * g / 3
                        ctx.beginPath()
                        ctx.moveTo(padL, gy)
                        ctx.lineTo(padL + plotW, gy)
                        ctx.stroke()
                    }
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "top"
                    for (i = 0; i < n; ++i) {
                        var r = rows[i]
                        var cx = padL + i * slot + slot * 0.5
                        var col = root.hoverIndex === i ? Theme.accent : r.color
                        ctx.strokeStyle = col
                        ctx.fillStyle = col
                        ctx.lineWidth = 1.5
                        ctx.beginPath()
                        ctx.moveTo(cx, yOf(r.high))
                        ctx.lineTo(cx, yOf(r.low))
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.moveTo(cx - 6, yOf(r.high))
                        ctx.lineTo(cx + 6, yOf(r.high))
                        ctx.moveTo(cx - 6, yOf(r.low))
                        ctx.lineTo(cx + 6, yOf(r.low))
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.arc(cx, yOf(r.v), 4.5, 0, Math.PI * 2)
                        ctx.fill()
                        ctx.fillStyle = Theme.textSecondary
                        ctx.fillText(String(r.label), cx, padT + plotH + 2)
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root.points.length
                    var idx = Math.floor(mouse.x / Math.max(1, width / n))
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
                    canvas.requestPaint()
                }
                onExited: { root.hoverIndex = -1; canvas.requestPaint() }
            }
        }
    }
    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}
