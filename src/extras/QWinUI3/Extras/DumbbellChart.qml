import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// DumbbellChart — Before/after pairs on a shared category axis.
//
//   DumbbellChart {
//       pairs: [
//           { label: qsTr("East"), from: 42, to: 58 },
//           { label: qsTr("West"), from: 31, to: 29 }
//       ]
//   }
//
// @notes
//   Experimental. Prefer BarChart.series grouped columns for more than two states.

T.Control {
    id: root
    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Dumbbell chart")

    property var pairs: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property string fromName: qsTr("From")
    property string toName: qsTr("To")
    property color fromColor: Theme.textSecondary
    property color toColor: Theme.accent
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 320
    implicitHeight: title.length ? 240 : 220
    padding: 8
    readonly property bool isEmpty: !(pairs && pairs.length)

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
                    var list = root.pairs
                    var n = list ? list.length : 0
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var lo = Number.POSITIVE_INFINITY
                    var hi = Number.NEGATIVE_INFINITY
                    for (var i = 0; i < n; ++i) {
                        lo = Math.min(lo, ChartUtils.asNumber(list[i].from), ChartUtils.asNumber(list[i].to))
                        hi = Math.max(hi, ChartUtils.asNumber(list[i].from), ChartUtils.asNumber(list[i].to))
                    }
                    if (hi <= lo)
                        hi = lo + 1
                    var padL = 48
                    var padR = 12
                    var padT = 8
                    var padB = 8
                    var plotW = width - padL - padR
                    var plotH = height - padT - padB
                    var slot = plotH / n
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    for (i = 0; i < n; ++i) {
                        var y = padT + i * slot + slot * 0.5
                        var x0 = padL + ((ChartUtils.asNumber(list[i].from) - lo) / (hi - lo)) * plotW
                        var x1 = padL + ((ChartUtils.asNumber(list[i].to) - lo) / (hi - lo)) * plotW
                        var col = root.hoverIndex === i ? Theme.accent : Theme.strokeControl
                        ctx.strokeStyle = col
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(x0, y)
                        ctx.lineTo(x1, y)
                        ctx.stroke()
                        ctx.fillStyle = root.fromColor
                        ctx.beginPath()
                        ctx.arc(x0, y, 5, 0, Math.PI * 2)
                        ctx.fill()
                        ctx.fillStyle = root.toColor
                        ctx.beginPath()
                        ctx.arc(x1, y, 5, 0, Math.PI * 2)
                        ctx.fill()
                        ctx.fillStyle = Theme.textSecondary
                        ctx.textAlign = "right"
                        ctx.textBaseline = "middle"
                        ctx.fillText(String(list[i].label || (i + 1)), padL - 8, y)
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root.pairs.length
                    var idx = Math.floor(mouse.y / Math.max(1, height / n))
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
                    canvas.requestPaint()
                }
                onExited: { root.hoverIndex = -1; canvas.requestPaint() }
            }
        }
        Row {
            spacing: 12
            visible: !root.isEmpty
            Repeater {
                model: [
                    { label: root.fromName, color: root.fromColor },
                    { label: root.toName, color: root.toColor }
                ]
                Row {
                    required property var modelData
                    spacing: 6
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        anchors.verticalCenter: parent.verticalCenter
                        color: modelData.color
                    }
                    Text {
                        text: modelData.label
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
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
