import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// CandlestickChart — OHLC candlesticks for professional price series.
//
//   CandlestickChart {
//       candles: [
//           { o: 100, h: 112, l: 96, c: 108 },
//           { o: 108, h: 110, l: 101, c: 103 }
//       ]
//   }
//
// @notes
//   Experimental Canvas OHLC. Not part of the stable six. ChartSeries is Y-only — pass objects.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Candlestick chart")

    // OHLC objects { o, h, l, c, label? }
    property var candles: []
    // Primary title text
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1
    property color upColor: Theme.systemSuccess
    property color downColor: Theme.systemCritical
    // Draw volume bars when candles include v or volume
    property bool showVolume: true

    implicitWidth: 360
    implicitHeight: title.length ? 240 : 220
    padding: 8

    readonly property bool isEmpty: !(candles && candles.length)

    Timer {
        id: redrawCoalesce
        interval: ChartUtils.redrawCoalesceMs
        repeat: false
        onTriggered: canvas.requestPaint()
    }

    function requestRedraw() { redrawCoalesce.restart() }

    onCandlesChanged: requestRedraw()
    onUpColorChanged: requestRedraw()
    onDownColorChanged: requestRedraw()
    onShowVolumeChanged: requestRedraw()
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
                    var list = root.candles
                    var n = list ? list.length : 0
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var lo = Number.POSITIVE_INFINITY
                    var hi = Number.NEGATIVE_INFINITY
                    var maxVol = 0
                    var hasVol = false
                    for (var i = 0; i < n; ++i) {
                        lo = Math.min(lo, ChartUtils.asNumber(list[i].l, list[i].c))
                        hi = Math.max(hi, ChartUtils.asNumber(list[i].h, list[i].c))
                        var vol = ChartUtils.asNumber(list[i].v !== undefined ? list[i].v : list[i].volume, 0)
                        if (vol > 0)
                            hasVol = true
                        maxVol = Math.max(maxVol, vol)
                    }
                    if (hi <= lo)
                        hi = lo + 1
                    var padL = 8
                    var padR = 8
                    var padT = 8
                    var volH = (root.showVolume && hasVol) ? Math.max(22, height * 0.22) : 0
                    var padB = 16 + volH
                    var plotW = width - padL - padR
                    var plotH = height - padT - padB
                    var slot = plotW / n
                    var bodyW = Math.max(3, slot * 0.45)

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

                    for (i = 0; i < n; ++i) {
                        var o = ChartUtils.asNumber(list[i].o)
                        var h = ChartUtils.asNumber(list[i].h, o)
                        var l = ChartUtils.asNumber(list[i].l, o)
                        var c = ChartUtils.asNumber(list[i].c, o)
                        var up = c >= o
                        var col = up ? root.upColor : root.downColor
                        if (root.hoverIndex === i)
                            col = Theme.accent
                        var cx = padL + i * slot + slot * 0.5
                        ctx.strokeStyle = col
                        ctx.lineWidth = 1.5
                        ctx.beginPath()
                        ctx.moveTo(cx, yOf(h))
                        ctx.lineTo(cx, yOf(l))
                        ctx.stroke()
                        var top = yOf(Math.max(o, c))
                        var bot = yOf(Math.min(o, c))
                        var bh = Math.max(1, bot - top)
                        ctx.fillStyle = ChartUtils.withAlpha(col, up ? 0.95 : 0.9)
                        ctx.fillRect(cx - bodyW / 2, top, bodyW, bh)
                    }

                    if (volH > 0 && maxVol > 0) {
                        var volTop = padT + plotH + 8
                        for (i = 0; i < n; ++i) {
                            vol = ChartUtils.asNumber(list[i].v !== undefined ? list[i].v : list[i].volume, 0)
                            var vh = (vol / maxVol) * (volH - 4)
                            o = ChartUtils.asNumber(list[i].o)
                            c = ChartUtils.asNumber(list[i].c, o)
                            col = c >= o ? root.upColor : root.downColor
                            ctx.fillStyle = ChartUtils.withAlpha(col, 0.45)
                            cx = padL + i * slot + slot * 0.5
                            ctx.fillRect(cx - bodyW / 2, volTop + volH - 4 - vh, bodyW, Math.max(1, vh))
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root.candles.length
                    var padL = 8
                    var padR = 8
                    var plotW = width - padL - padR
                    var idx = Math.floor((mouse.x - padL) / (plotW / n))
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
