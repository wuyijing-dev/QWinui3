import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// LollipopChart — Stem-and-marker chart (compact bar alternative).
//
//   LollipopChart {
//       values: [12, 28, 18, 34]
//       labels: ["Q1", "Q2", "Q3", "Q4"]
//   }
//
// @notes
//   Experimental. Prefer BarChart for filled columns.

T.Control {
    id: root
    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Lollipop chart")

    property var values: []
    property var labels: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool horizontal: false
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1
    property color fillColor: Theme.accent

    implicitWidth: 320
    implicitHeight: title.length ? 220 : 200
    padding: 8
    readonly property var _vals: ChartUtils.flattenValues(values)
    readonly property bool isEmpty: _vals.length === 0

    Timer {
        id: redrawCoalesce
        interval: ChartUtils.redrawCoalesceMs
        repeat: false
        onTriggered: canvas.requestPaint()
    }

    function requestRedraw() { redrawCoalesce.restart() }

    onValuesChanged: requestRedraw()
    onLabelsChanged: requestRedraw()
    onHorizontalChanged: requestRedraw()
    onFillColorChanged: requestRedraw()
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
                    var vals = root._vals
                    var n = vals.length
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var ext = ChartUtils.extents(vals)
                    var lo = Math.min(0, ext.min)
                    var hi = Math.max(ext.max, lo + 1)
                    var padL = root.horizontal ? 36 : 8
                    var padR = 10
                    var padT = 10
                    var padB = root.horizontal ? 8 : 18
                    var plotW = width - padL - padR
                    var plotH = height - padT - padB
                    var slot = (root.horizontal ? plotH : plotW) / n
                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.beginPath()
                    if (root.horizontal) {
                        ctx.moveTo(padL, padT)
                        ctx.lineTo(padL, padT + plotH)
                    } else {
                        var zy = padT + plotH - ((0 - lo) / (hi - lo)) * plotH
                        ctx.moveTo(padL, zy)
                        ctx.lineTo(padL + plotW, zy)
                    }
                    ctx.stroke()
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "top"
                    for (var i = 0; i < n; ++i) {
                        var col = root.hoverIndex === i ? Theme.accent : root.fillColor
                        ctx.strokeStyle = col
                        ctx.fillStyle = col
                        ctx.lineWidth = 2
                        if (root.horizontal) {
                            var y = padT + i * slot + slot * 0.5
                            var x1 = padL + ((vals[i] - lo) / (hi - lo)) * plotW
                            ctx.beginPath()
                            ctx.moveTo(padL, y)
                            ctx.lineTo(x1, y)
                            ctx.stroke()
                            ctx.beginPath()
                            ctx.arc(x1, y, 5, 0, Math.PI * 2)
                            ctx.fill()
                            ctx.fillStyle = Theme.textSecondary
                            ctx.textAlign = "right"
                            ctx.textBaseline = "middle"
                            var lab = root.labels && root.labels[i] !== undefined ? String(root.labels[i]) : String(i + 1)
                            ctx.fillText(lab, padL - 6, y)
                        } else {
                            var x = padL + i * slot + slot * 0.5
                            var y1 = padT + plotH - ((vals[i] - lo) / (hi - lo)) * plotH
                            var y0 = padT + plotH - ((0 - lo) / (hi - lo)) * plotH
                            ctx.beginPath()
                            ctx.moveTo(x, y0)
                            ctx.lineTo(x, y1)
                            ctx.stroke()
                            ctx.beginPath()
                            ctx.arc(x, y1, 5, 0, Math.PI * 2)
                            ctx.fill()
                            ctx.fillStyle = Theme.textSecondary
                            ctx.textAlign = "center"
                            ctx.textBaseline = "top"
                            lab = root.labels && root.labels[i] !== undefined ? String(root.labels[i]) : String(i + 1)
                            ctx.fillText(lab, x, padT + plotH + 2)
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root._vals.length
                    var idx = root.horizontal
                              ? Math.floor(mouse.y / Math.max(1, height / n))
                              : Math.floor(mouse.x / Math.max(1, width / n))
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
                    root.requestRedraw()
                }
                onExited: { root.hoverIndex = -1; root.requestRedraw() }
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
