import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// BandChart — High/low envelope with an optional mid line.
//
//   BandChart {
//       high: [42, 48, 45]
//       low: [30, 28, 32]
//       mid: [36, 38, 37]
//   }
//
// @notes
//   Experimental range band. Prefer LineChart.showArea for a single filled series.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Band chart")

    property var high: []
    property var low: []
    property var mid: []
    property var xAxisLabels: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property color bandColor: Theme.accent
    property color midColor: Theme.systemCaution
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 320
    implicitHeight: title.length ? 220 : 200
    padding: 8

    readonly property int _count: Math.max(ChartUtils.valueCount(high), ChartUtils.valueCount(low), ChartUtils.valueCount(mid))
    readonly property bool isEmpty: _count === 0

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
                property real plotL: 4
                property real plotW: 1
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var n = root._count
                    if (width < 8 || height < 8 || n < 2)
                        return
                    var hiVals = []
                    var loVals = []
                    var midVals = []
                    var lo = Number.POSITIVE_INFINITY
                    var hi = Number.NEGATIVE_INFINITY
                    for (var i = 0; i < n; ++i) {
                        var hv = ChartUtils.valueAt(root.high, i, ChartUtils.valueAt(root.mid, i, 0))
                        var lv = ChartUtils.valueAt(root.low, i, hv)
                        var mv = ChartUtils.valueAt(root.mid, i, (hv + lv) * 0.5)
                        hiVals.push(hv)
                        loVals.push(lv)
                        midVals.push(mv)
                        hi = Math.max(hi, hv, mv)
                        lo = Math.min(lo, lv, mv)
                    }
                    if (hi <= lo)
                        hi = lo + 1
                    var padL = 4
                    var padR = 4
                    var padT = 8
                    var padB = (root.xAxisLabels && root.xAxisLabels.length) ? 18 : 6
                    var plotW = width - padL - padR
                    var plotH = height - padT - padB
                    canvas.plotL = padL
                    canvas.plotW = plotW

                    function X(i) { return padL + (i / (n - 1)) * plotW }
                    function Y(v) { return padT + plotH - ((v - lo) / (hi - lo)) * plotH }

                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 1
                    for (var g = 0; g <= 4; ++g) {
                        var gy = padT + plotH * g / 4
                        ctx.beginPath()
                        ctx.moveTo(padL, gy)
                        ctx.lineTo(padL + plotW, gy)
                        ctx.stroke()
                    }

                    ctx.beginPath()
                    ctx.moveTo(X(0), Y(hiVals[0]))
                    for (i = 1; i < n; ++i)
                        ctx.lineTo(X(i), Y(hiVals[i]))
                    for (i = n - 1; i >= 0; --i)
                        ctx.lineTo(X(i), Y(loVals[i]))
                    ctx.closePath()
                    ctx.fillStyle = ChartUtils.withAlpha(root.bandColor, Theme.dark ? 0.28 : 0.18)
                    ctx.fill()

                    ctx.strokeStyle = ChartUtils.withAlpha(root.bandColor, 0.7)
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(X(0), Y(hiVals[0]))
                    for (i = 1; i < n; ++i)
                        ctx.lineTo(X(i), Y(hiVals[i]))
                    ctx.stroke()
                    ctx.beginPath()
                    ctx.moveTo(X(0), Y(loVals[0]))
                    for (i = 1; i < n; ++i)
                        ctx.lineTo(X(i), Y(loVals[i]))
                    ctx.stroke()

                    ctx.strokeStyle = root.midColor
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    ctx.moveTo(X(0), Y(midVals[0]))
                    for (i = 1; i < n; ++i)
                        ctx.lineTo(X(i), Y(midVals[i]))
                    ctx.stroke()

                    if (root.hoverIndex >= 0 && root.hoverIndex < n) {
                        var hx = X(root.hoverIndex)
                        ctx.strokeStyle = Theme.textSecondary
                        ctx.beginPath()
                        ctx.moveTo(hx, padT)
                        ctx.lineTo(hx, padT + plotH)
                        ctx.stroke()
                    }

                    if (root.xAxisLabels && root.xAxisLabels.length) {
                        ctx.fillStyle = Theme.textSecondary
                        ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                        ctx.textAlign = "center"
                        ctx.textBaseline = "top"
                        var labs = root.xAxisLabels
                        var ln = labs.length
                        for (i = 0; i < ln; ++i) {
                            var lab = labs[i]
                            if (lab === undefined)
                                continue
                            var lx = ln === 1 ? padL + plotW * 0.5 : padL + (i / (ln - 1)) * plotW
                            ctx.fillText(String(lab), lx, padT + plotH + 2)
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
                    var n = root._count
                    var t = (mouse.x - canvas.plotL) / Math.max(1, canvas.plotW)
                    var idx = Math.round(Math.max(0, Math.min(1, t)) * (n - 1))
                    root.hoverIndex = idx
                    canvas.requestPaint()
                }
                onExited: {
                    root.hoverIndex = -1
                    canvas.requestPaint()
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
