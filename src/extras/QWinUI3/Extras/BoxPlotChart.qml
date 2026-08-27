import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// BoxPlotChart — Tukey box-and-whisker groups.
//
//   BoxPlotChart {
//       groups: [
//           { label: qsTr("A"), values: [12, 14, 15, 18, 22] },
//           { label: qsTr("B"), min: 8, q1: 11, median: 14, q3: 17, max: 21 }
//       ]
//   }
//
// @notes
//   Experimental. Pass values[] for auto stats (ChartUtils.boxPlotStats) or precomputed min/q1/median/q3/max.
//   Not part of the stable six.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Box plot")

    // Group descriptors { label?, values? | min,q1,median,q3,max, color? }
    property var groups: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 320
    implicitHeight: title.length ? 220 : 200
    padding: 8

    readonly property var _stats: {
        var list = groups && groups.length ? groups : []
        var out = []
        for (var i = 0; i < list.length; ++i) {
            var g = list[i]
            var st = (g.values && ChartUtils.valueCount(g.values) > 0)
                     ? ChartUtils.boxPlotStats(g.values)
                     : {
                           min: ChartUtils.asNumber(g.min),
                           q1: ChartUtils.asNumber(g.q1),
                           median: ChartUtils.asNumber(g.median),
                           q3: ChartUtils.asNumber(g.q3),
                           max: ChartUtils.asNumber(g.max),
                           n: 1
                       }
            st.label = g.label || String(i + 1)
            st.color = g.color || ChartUtils.palette(Theme, i)
            out.push(st)
        }
        return out
    }
    readonly property bool isEmpty: _stats.length === 0

    Timer {
        id: redrawCoalesce
        interval: ChartUtils.redrawCoalesceMs
        repeat: false
        onTriggered: canvas.requestPaint()
    }

    function requestRedraw() { redrawCoalesce.restart() }

    onGroupsChanged: requestRedraw()
    onHoverIndexChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()

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
                    var list = root._stats
                    var n = list.length
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var lo = Number.POSITIVE_INFINITY
                    var hi = Number.NEGATIVE_INFINITY
                    for (var i = 0; i < n; ++i) {
                        lo = Math.min(lo, list[i].min)
                        hi = Math.max(hi, list[i].max)
                    }
                    if (hi <= lo)
                        hi = lo + 1
                    var padL = 8
                    var padR = 8
                    var padT = 8
                    var padB = 18
                    var plotW = width - padL - padR
                    var plotH = height - padT - padB
                    var slot = plotW / n
                    var bw = Math.max(8, slot * 0.38)

                    function yOf(v) {
                        return padT + plotH - ((v - lo) / (hi - lo)) * plotH
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
                        var st = list[i]
                        var cx = padL + i * slot + slot * 0.5
                        var col = root.hoverIndex === i ? Theme.accent : st.color
                        ctx.strokeStyle = col
                        ctx.fillStyle = ChartUtils.withAlpha(col, 0.22)
                        ctx.lineWidth = 1.5
                        ctx.beginPath()
                        ctx.moveTo(cx, yOf(st.max))
                        ctx.lineTo(cx, yOf(st.min))
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.moveTo(cx - bw * 0.35, yOf(st.max))
                        ctx.lineTo(cx + bw * 0.35, yOf(st.max))
                        ctx.moveTo(cx - bw * 0.35, yOf(st.min))
                        ctx.lineTo(cx + bw * 0.35, yOf(st.min))
                        ctx.stroke()
                        var boxT = yOf(st.q3)
                        var boxB = yOf(st.q1)
                        ctx.fillRect(cx - bw * 0.5, boxT, bw, Math.max(2, boxB - boxT))
                        ctx.strokeRect(cx - bw * 0.5, boxT, bw, Math.max(2, boxB - boxT))
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(cx - bw * 0.5, yOf(st.median))
                        ctx.lineTo(cx + bw * 0.5, yOf(st.median))
                        ctx.stroke()
                        ctx.fillStyle = Theme.textSecondary
                        ctx.lineWidth = 1
                        ctx.fillText(String(st.label), cx, padT + plotH + 2)
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root._stats.length
                    var idx = Math.floor(mouse.x / Math.max(1, width / n))
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
                    root.requestRedraw()
                }
                onExited: {
                    root.hoverIndex = -1
                    root.requestRedraw()
                }
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
