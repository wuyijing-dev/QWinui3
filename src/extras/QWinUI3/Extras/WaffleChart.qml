import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// WaffleChart — 10×10 part-to-whole grid.
//
//   WaffleChart {
//       slices: [
//           { value: 42, label: qsTr("Used") },
//           { value: 58, label: qsTr("Free") }
//       ]
//   }
//
// @notes
//   Experimental 100-cell waffle. Prefer DonutChart for a compact part-to-whole.

T.Control {
    id: root
    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Waffle chart")

    property var slices: []
    property var values: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property int gridSize: 10
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 220
    implicitHeight: title.length ? 260 : 240
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
                    var list = root._slices
                    if (width < 16 || height < 16 || !list.length)
                        return
                    var total = 0
                    for (var i = 0; i < list.length; ++i)
                        total += Math.max(0, ChartUtils.asNumber(list[i].value))
                    if (total <= 0)
                        return
                    var g = Math.max(2, root.gridSize)
                    var cells = g * g
                    var owners = []
                    var acc = 0
                    for (i = 0; i < list.length; ++i) {
                        var n = Math.round(cells * ChartUtils.asNumber(list[i].value) / total)
                        for (var k = 0; k < n && owners.length < cells; ++k)
                            owners.push(i)
                    }
                    while (owners.length < cells)
                        owners.push(list.length - 1)
                    var gap = 3
                    var cell = Math.min((width - (g - 1) * gap) / g, (height - (g - 1) * gap) / g)
                    var ox = (width - (cell * g + gap * (g - 1))) / 2
                    var oy = (height - (cell * g + gap * (g - 1))) / 2
                    for (i = 0; i < cells; ++i) {
                        var col = i % g
                        var row = Math.floor(i / g)
                        var si = owners[i]
                        var color = list[si].color || ChartUtils.palette(Theme, si)
                        if (root.hoverIndex === si)
                            color = Theme.accent
                        ctx.fillStyle = ChartUtils.withAlpha(color, 0.9)
                        ctx.fillRect(ox + col * (cell + gap), oy + row * (cell + gap), cell, cell)
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                onExited: { root.hoverIndex = -1; canvas.requestPaint() }
            }
        }
        Flow {
            visible: !root.isEmpty
            spacing: 10
            Repeater {
                model: root._slices
                Item {
                    id: chip
                    required property var modelData
                    required property int index
                    implicitWidth: row.implicitWidth
                    implicitHeight: row.implicitHeight
                    Row {
                        id: row
                        spacing: 6
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 2
                            anchors.verticalCenter: parent.verticalCenter
                            color: chip.modelData.color || ChartUtils.palette(Theme, chip.index)
                        }
                        Text {
                            text: (chip.modelData.label || ("#" + (chip.index + 1)))
                                  + "  " + ChartUtils.asNumber(chip.modelData.value)
                            font.pixelSize: Theme.fontCaption
                            color: Theme.textSecondary
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: { root.hoverIndex = chip.index; canvas.requestPaint() }
                        onExited: { if (root.hoverIndex === chip.index) { root.hoverIndex = -1; canvas.requestPaint() } }
                    }
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
