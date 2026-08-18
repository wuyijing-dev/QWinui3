import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TreemapChart — Nested slice-and-dice treemap.
//
//   TreemapChart {
//       slices: [
//           { value: 42, label: qsTr("Apps") },
//           { value: 18, label: qsTr("Media") }
//       ]
//   }
//
// @notes
//   Experimental. ChartUtils.treemapRects. Prefer DonutChart for part-to-whole.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Treemap")

    property var slices: []
    property var values: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    signal sliceClicked(int index, real value)

    implicitWidth: 280
    implicitHeight: title.length ? 220 : 200
    padding: 8

    readonly property var _slices: {
        if (slices && slices.length)
            return slices
        var vals = ChartUtils.flattenValues(values)
        var out = []
        for (var i = 0; i < vals.length; ++i)
            out.push({ value: vals[i], color: ChartUtils.palette(Theme, i) })
        return out
    }
    readonly property bool isEmpty: _slices.length === 0
    property var _rects: []

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
                    var list = root._slices
                    if (width < 8 || height < 8 || !list.length)
                        return
                    var pad = 2
                    var rects = ChartUtils.treemapRects(list, pad, pad, width - pad * 2, height - pad * 2)
                    root._rects = rects
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "left"
                    ctx.textBaseline = "top"
                    for (var i = 0; i < rects.length; ++i) {
                        var r = rects[i]
                        var sl = list[r.index]
                        var col = sl.color || ChartUtils.palette(Theme, r.index)
                        if (root.hoverIndex === r.index)
                            col = Theme.accent
                        ctx.fillStyle = ChartUtils.withAlpha(col, 0.82)
                        ctx.fillRect(r.x, r.y, Math.max(1, r.w - 1), Math.max(1, r.h - 1))
                        if (r.w > 36 && r.h > 22 && sl.label) {
                            ctx.fillStyle = Theme.textPrimary
                            ctx.fillText(String(sl.label), r.x + 6, r.y + 5)
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                enabled: root.interactive
                function hit(mx, my) {
                    var rects = root._rects
                    for (var i = 0; i < rects.length; ++i) {
                        var r = rects[i]
                        if (mx >= r.x && my >= r.y && mx <= r.x + r.w && my <= r.y + r.h)
                            return r.index
                    }
                    return -1
                }
                onPositionChanged: function (mouse) {
                    root.hoverIndex = hit(mouse.x, mouse.y)
                    canvas.requestPaint()
                }
                onExited: {
                    root.hoverIndex = -1
                    canvas.requestPaint()
                }
                onClicked: function (mouse) {
                    var idx = hit(mouse.x, mouse.y)
                    if (idx >= 0)
                        root.sliceClicked(idx, ChartUtils.asNumber(root._slices[idx].value))
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
