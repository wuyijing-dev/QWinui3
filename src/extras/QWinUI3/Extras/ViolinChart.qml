import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ViolinChart — Density violin from sample groups.
//
//   ViolinChart {
//       groups: [{ label: qsTr("A"), values: samples }]
//   }
//
// @notes
//   Experimental. ChartUtils.violinWidths. Prefer BoxPlotChart for five-number summaries.

T.Control {
    id: root
    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Violin chart")

    property var groups: []
    property int binCount: 12
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 320
    implicitHeight: title.length ? 240 : 220
    padding: 8

    readonly property bool isEmpty: !(groups && groups.length)
    readonly property var _profiles: {
        var list = groups && groups.length ? groups : []
        var out = []
        for (var i = 0; i < list.length; ++i) {
            var g = list[i]
            var vals = g.values || g
            out.push({
                label: g.label || String(i + 1),
                color: g.color || ChartUtils.palette(Theme, i),
                bins: ChartUtils.violinWidths(vals, binCount),
                stats: ChartUtils.boxPlotStats(vals)
            })
        }
        return out
    }

    contentItem: ColumnLayout {
        spacing: 6
        Text {
            visible: root.title.length > 0
            text: root.title
            font.family: Theme.fontFamily
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
                    var list = root._profiles
                    var n = list.length
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var lo = Number.POSITIVE_INFINITY
                    var hi = Number.NEGATIVE_INFINITY
                    for (var i = 0; i < n; ++i) {
                        lo = Math.min(lo, list[i].stats.min)
                        hi = Math.max(hi, list[i].stats.max)
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
                    function yOf(v) {
                        return padT + plotH - ((v - lo) / (hi - lo)) * plotH
                    }
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "top"
                    for (i = 0; i < n; ++i) {
                        var p = list[i]
                        var cx = padL + i * slot + slot * 0.5
                        var half = slot * 0.36
                        var col = root.hoverIndex === i ? Theme.accent : p.color
                        ctx.beginPath()
                        var bins = p.bins
                        for (var b = 0; b < bins.length; ++b) {
                            var mid = (ChartUtils.asNumber(bins[b].from) + ChartUtils.asNumber(bins[b].to)) * 0.5
                            var xw = half * ChartUtils.asNumber(bins[b].width)
                            if (b === 0)
                                ctx.moveTo(cx + xw, yOf(mid))
                            else
                                ctx.lineTo(cx + xw, yOf(mid))
                        }
                        for (b = bins.length - 1; b >= 0; --b) {
                            mid = (ChartUtils.asNumber(bins[b].from) + ChartUtils.asNumber(bins[b].to)) * 0.5
                            xw = half * ChartUtils.asNumber(bins[b].width)
                            ctx.lineTo(cx - xw, yOf(mid))
                        }
                        ctx.closePath()
                        ctx.fillStyle = ChartUtils.withAlpha(col, 0.35)
                        ctx.fill()
                        ctx.strokeStyle = col
                        ctx.stroke()
                        ctx.strokeStyle = Theme.textPrimary
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(cx - 6, yOf(p.stats.median))
                        ctx.lineTo(cx + 6, yOf(p.stats.median))
                        ctx.stroke()
                        ctx.lineWidth = 1
                        ctx.fillStyle = Theme.textSecondary
                        ctx.fillText(String(p.label), cx, padT + plotH + 2)
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root._profiles.length
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
