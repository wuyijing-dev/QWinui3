import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// HistogramChart — Frequency bins from a numeric series.
//
//   HistogramChart {
//       values: samples
//       binCount: 12
//   }
//
// @notes
//   Experimental. Uses ChartUtils.histogramBins then draws as columns.
//   Prefer BarChart when bins are already computed.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Histogram")

    // Raw samples
    property var values: []
    // Number of bins
    property int binCount: 10
    // Primary title text
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1
    property color fillColor: Theme.accent

    implicitWidth: 320
    implicitHeight: title.length ? 220 : 200
    padding: 8

    readonly property var _bins: ChartUtils.histogramBins(values, binCount)
    readonly property bool isEmpty: ChartUtils.valueCount(values) === 0

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
                    var bins = root._bins || []
                    var n = bins.length
                    if (width < 8 || height < 8 || n === 0)
                        return
                    var maxC = 1
                    for (var i = 0; i < n; ++i) {
                        if (bins[i])
                            maxC = Math.max(maxC, ChartUtils.asNumber(bins[i].count))
                    }
                    var padT = 8
                    var padB = 18
                    var padL = 4
                    var padR = 4
                    var plotH = height - padT - padB
                    var plotW = width - padL - padR
                    var slot = plotW / n
                    var gap = slot * 0.12
                    var bw = Math.max(1, slot - gap)
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "top"
                    for (i = 0; i < n; ++i) {
                        var bh = (bins[i].count / maxC) * plotH
                        var x = padL + i * slot + gap * 0.5
                        var y = padT + plotH - bh
                        ctx.fillStyle = root.hoverIndex === i
                                        ? root.fillColor
                                        : ChartUtils.withAlpha(root.fillColor, 0.82)
                        ctx.fillRect(x, y, bw, Math.max(1, bh))
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root._bins.length
                    var idx = Math.floor(mouse.x / Math.max(1, width / n))
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
                    canvas.requestPaint()
                }
                onExited: {
                    root.hoverIndex = -1
                    canvas.requestPaint()
                }
            }
        }
        Text {
            visible: root.hoverIndex >= 0 && root.hoverIndex < root._bins.length
            text: {
                var bins = root._bins
                var idx = root.hoverIndex
                if (!bins || idx < 0 || idx >= bins.length || !bins[idx])
                    return ""
                var b = bins[idx]
                return qsTr("%1 – %2  ·  %3")
                        .arg(ChartUtils.asNumber(b.from).toFixed(1))
                        .arg(ChartUtils.asNumber(b.to).toFixed(1))
                        .arg(ChartUtils.asNumber(b.count))
            }
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}
