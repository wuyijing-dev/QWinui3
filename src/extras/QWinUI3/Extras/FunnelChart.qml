import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// FunnelChart — Conversion funnel from stage values.
//
//   FunnelChart {
//       stages: [
//           { value: 1200, label: qsTr("Visit") },
//           { value: 480, label: qsTr("Signup") },
//           { value: 96, label: qsTr("Paid") }
//       ]
//   }
//
// @notes
//   Experimental Canvas funnel. Prefer DonutChart for part-to-whole without stages.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Funnel chart")

    // Stage descriptors { value, label?, color? }
    property var stages: []
    // Convenience numeric values
    property var values: []
    // Primary title text
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1
    property string valueUnit: ""
    property alias unit: root.valueUnit

    signal stageClicked(int index, real value)

    implicitWidth: 320
    implicitHeight: title.length ? 260 : 240
    padding: 8

    readonly property var _stages: {
        if (stages && stages.length)
            return stages
        var vals = ChartUtils.flattenValues(values)
        var out = []
        for (var i = 0; i < vals.length; ++i)
            out.push({ value: vals[i], label: String(i + 1) })
        return out
    }

    readonly property bool isEmpty: _stages.length === 0

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
                    var list = root._stages
                    var n = list.length
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var maxV = 1
                    for (var i = 0; i < n; ++i)
                        maxV = Math.max(maxV, Math.abs(ChartUtils.asNumber(list[i].value)))
                    var rowH = height / n
                    var gap = Math.min(6, rowH * 0.12)
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textBaseline = "middle"
                    for (i = 0; i < n; ++i) {
                        var v = Math.abs(ChartUtils.asNumber(list[i].value))
                        var frac = v / maxV
                        var w = Math.max(24, width * (0.35 + 0.65 * frac))
                        var x = (width - w) / 2
                        var y = i * rowH + gap * 0.5
                        var h = Math.max(8, rowH - gap)
                        var col = list[i].color || ChartUtils.palette(Theme, i)
                        ctx.fillStyle = root.hoverIndex === i ? col : ChartUtils.withAlpha(col, 0.88)
                        ctx.beginPath()
                        ctx.moveTo(x, y)
                        ctx.lineTo(x + w, y)
                        ctx.lineTo(x + w * 0.92, y + h)
                        ctx.lineTo(x + w * 0.08, y + h)
                        ctx.closePath()
                        ctx.fill()
                        ctx.fillStyle = Theme.textPrimary
                        ctx.textAlign = "center"
                        var lab = list[i].label ? String(list[i].label) : String(i + 1)
                        var val = String(Math.round(v)) + root.valueUnit
                        ctx.fillText(lab + "  " + val, width / 2, y + h / 2)
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root._stages.length
                    var idx = Math.floor(mouse.y / Math.max(1, height / n))
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
                    canvas.requestPaint()
                }
                onExited: {
                    root.hoverIndex = -1
                    canvas.requestPaint()
                }
                onClicked: {
                    if (root.hoverIndex >= 0)
                        root.stageClicked(root.hoverIndex, ChartUtils.asNumber(root._stages[root.hoverIndex].value))
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
