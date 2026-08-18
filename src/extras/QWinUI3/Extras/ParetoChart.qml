import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ParetoChart — Ranked bars plus cumulative percent line.
//
//   ParetoChart {
//       values: [42, 18, 12, 8, 5]
//       labels: ["A", "B", "C", "D", "E"]
//   }
//
// @notes
//   Experimental. ChartUtils.paretoRows sorts descending and computes cumulative share.
//   Prefer ComboChart when the order is already fixed.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Pareto chart")

    property var values: []
    property var labels: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property string valueUnit: ""
    property alias unit: root.valueUnit
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 360
    implicitHeight: title.length ? 240 : 220
    padding: 8

    readonly property var _rows: ChartUtils.paretoRows(values)
    readonly property bool isEmpty: _rows.length === 0

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
                    var rows = root._rows
                    var n = rows.length
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var maxV = 1
                    for (var i = 0; i < n; ++i)
                        maxV = Math.max(maxV, rows[i].value)
                    var padL = 8
                    var padR = 36
                    var padT = 8
                    var padB = 18
                    var plotW = width - padL - padR
                    var plotH = height - padT - padB
                    var slot = plotW / n
                    var bw = Math.max(2, slot * 0.62)

                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 1
                    for (var g = 0; g <= 4; ++g) {
                        var gy = padT + plotH * g / 4
                        ctx.beginPath()
                        ctx.moveTo(padL, gy)
                        ctx.lineTo(padL + plotW, gy)
                        ctx.stroke()
                    }

                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "top"

                    for (i = 0; i < n; ++i) {
                        var bh = (rows[i].value / maxV) * plotH
                        var x = padL + i * slot + (slot - bw) * 0.5
                        var y = padT + plotH - bh
                        ctx.fillStyle = root.hoverIndex === i
                                        ? Theme.accent
                                        : ChartUtils.withAlpha(Theme.accent, 0.72)
                        ctx.fillRect(x, y, bw, Math.max(1, bh))
                        var src = rows[i].index
                        var lab = (root.labels && root.labels[src] !== undefined)
                                  ? String(root.labels[src]) : String(src + 1)
                        ctx.fillStyle = Theme.textSecondary
                        ctx.fillText(lab, padL + i * slot + slot * 0.5, padT + plotH + 2)
                    }

                    ctx.strokeStyle = Theme.systemCaution
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    for (i = 0; i < n; ++i) {
                        var lx = padL + i * slot + slot * 0.5
                        var ly = padT + plotH - rows[i].cumulative * plotH
                        if (i === 0)
                            ctx.moveTo(lx, ly)
                        else
                            ctx.lineTo(lx, ly)
                    }
                    ctx.stroke()

                    ctx.fillStyle = Theme.textSecondary
                    ctx.textAlign = "left"
                    ctx.textBaseline = "middle"
                    ctx.fillText("100%", padL + plotW + 4, padT)
                    ctx.fillText("0%", padL + plotW + 4, padT + plotH)
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root._rows.length
                    var padL = 8
                    var padR = 36
                    var plotW = width - padL - padR
                    var idx = Math.floor((mouse.x - padL) / Math.max(1, plotW / n))
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
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
