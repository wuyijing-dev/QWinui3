import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// PolarAreaChart — Coxcomb / polar-area sectors (radius encodes value).
//
//   PolarAreaChart {
//       values: [8, 12, 6, 14, 9]
//       labels: ["CPU", "Mem", "Disk", "Net", "GPU"]
//   }
//
// @notes
//   Experimental. Prefer RadarChart for equal-radius polygons; DonutChart for part-to-whole.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Polar area")

    property var values: []
    property var labels: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 240
    implicitHeight: title.length ? 260 : 240
    padding: 8

    readonly property var _vals: ChartUtils.flattenValues(values)
    readonly property bool isEmpty: _vals.length === 0

    // 3.49 C20 — coalesce Canvas paints (~16 ms).
    Timer {
        id: redrawCoalesce
        interval: ChartUtils.redrawCoalesceMs
        repeat: false
        onTriggered: canvas.requestPaint()
    }
    function requestRedraw() { redrawCoalesce.restart() }
    onValuesChanged: requestRedraw()
    onLabelsChanged: requestRedraw()
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
                    var maxV = 1
                    for (var i = 0; i < n; ++i)
                        maxV = Math.max(maxV, Math.abs(vals[i]))
                    var cx = width / 2
                    var cy = height / 2
                    var rMax = Math.min(width, height) * 0.38
                    var step = (Math.PI * 2) / n

                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 1
                    for (var ring = 1; ring <= 3; ++ring) {
                        ctx.beginPath()
                        ctx.arc(cx, cy, rMax * ring / 3, 0, Math.PI * 2)
                        ctx.stroke()
                    }

                    for (i = 0; i < n; ++i) {
                        var a0 = -Math.PI / 2 + i * step
                        var a1 = a0 + step
                        var rr = rMax * (vals[i] / maxV)
                        ctx.beginPath()
                        ctx.moveTo(cx, cy)
                        ctx.arc(cx, cy, Math.max(2, rr), a0, a1)
                        ctx.closePath()
                        var col = ChartUtils.palette(Theme, i)
                        ctx.fillStyle = ChartUtils.withAlpha(col, root.hoverIndex === i ? 0.92 : 0.55)
                        ctx.fill()
                        ctx.strokeStyle = col
                        ctx.stroke()
                    }

                    ctx.fillStyle = Theme.textSecondary
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "middle"
                    for (i = 0; i < n; ++i) {
                        var lab = root.labels && root.labels[i] !== undefined ? String(root.labels[i]) : ""
                        if (!lab.length)
                            continue
                        var mid = -Math.PI / 2 + (i + 0.5) * step
                        ctx.fillText(lab, cx + Math.cos(mid) * (rMax + 14), cy + Math.sin(mid) * (rMax + 14))
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root._vals.length
                    var cx = width / 2
                    var cy = height / 2
                    var ang = Math.atan2(mouse.y - cy, mouse.x - cx)
                    var fromTop = ang + Math.PI / 2
                    if (fromTop < 0)
                        fromTop += Math.PI * 2
                    var idx = Math.floor((fromTop / (Math.PI * 2)) * n) % n
                    root.hoverIndex = idx
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
