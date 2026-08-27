import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// SunburstChart — Two-level nested rings.
//
//   SunburstChart {
//       slices: [
//           { label: qsTr("Apps"), value: 40, children: [
//               { label: qsTr("Photo"), value: 24 },
//               { label: qsTr("Mail"), value: 16 }
//           ]},
//           { label: qsTr("System"), value: 20 }
//       ]
//   }
//
// @notes
//   Experimental two-level sunburst. Prefer DonutChart for a single ring.

T.Control {
    id: root
    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Sunburst")

    property var slices: []
    property string title: ""
    property string emptyText: qsTr("No data")
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    implicitWidth: 260
    implicitHeight: title.length ? 280 : 260
    padding: 8
    readonly property bool isEmpty: !(slices && slices.length)

    // 3.49 C20 — coalesce Canvas paints (~16 ms).
    Timer {
        id: redrawCoalesce
        interval: ChartUtils.redrawCoalesceMs
        repeat: false
        onTriggered: canvas.requestPaint()
    }
    function requestRedraw() { redrawCoalesce.restart() }
    onSlicesChanged: requestRedraw()
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
                    var list = root.slices
                    var n = list ? list.length : 0
                    if (width < 16 || height < 16 || n === 0)
                        return
                    var total = 0
                    for (var i = 0; i < n; ++i)
                        total += Math.max(0, ChartUtils.asNumber(list[i].value))
                    if (total <= 0)
                        return
                    var cx = width / 2
                    var cy = height / 2
                    var r0 = Math.min(width, height) * 0.16
                    var r1 = Math.min(width, height) * 0.28
                    var r2 = Math.min(width, height) * 0.42
                    var ang = -Math.PI / 2
                    for (i = 0; i < n; ++i) {
                        var sweep = (ChartUtils.asNumber(list[i].value) / total) * Math.PI * 2
                        var col = list[i].color || ChartUtils.palette(Theme, i)
                        if (root.hoverIndex === i)
                            col = Theme.accent
                        ctx.beginPath()
                        ctx.arc(cx, cy, r1, ang, ang + sweep)
                        ctx.arc(cx, cy, r0, ang + sweep, ang, true)
                        ctx.closePath()
                        ctx.fillStyle = ChartUtils.withAlpha(col, 0.92)
                        ctx.fill()
                        var kids = list[i].children
                        if (kids && kids.length) {
                            var ktot = 0
                            for (var k = 0; k < kids.length; ++k)
                                ktot += Math.max(0, ChartUtils.asNumber(kids[k].value))
                            var ka = ang
                            for (k = 0; k < kids.length; ++k) {
                                var ks = ktot > 0 ? (ChartUtils.asNumber(kids[k].value) / ktot) * sweep : 0
                                ctx.beginPath()
                                ctx.arc(cx, cy, r2, ka, ka + ks)
                                ctx.arc(cx, cy, r1 + 2, ka + ks, ka, true)
                                ctx.closePath()
                                ctx.fillStyle = ChartUtils.withAlpha(kids[k].color || ChartUtils.palette(Theme, i + k + 1), 0.75)
                                ctx.fill()
                                ka += ks
                            }
                        } else {
                            ctx.beginPath()
                            ctx.arc(cx, cy, r2, ang, ang + sweep)
                            ctx.arc(cx, cy, r1 + 2, ang + sweep, ang, true)
                            ctx.closePath()
                            ctx.fillStyle = ChartUtils.withAlpha(col, 0.55)
                            ctx.fill()
                        }
                        ang += sweep
                    }
                    ctx.fillStyle = Theme.bgCard
                    ctx.beginPath()
                    ctx.arc(cx, cy, r0 - 1, 0, Math.PI * 2)
                    ctx.fill()
                }
            }
            MouseArea {
                anchors.fill: parent
                visible: !root.isEmpty
                hoverEnabled: root.interactive
                onPositionChanged: function (mouse) {
                    var n = root.slices.length
                    var cx = width / 2
                    var cy = height / 2
                    var a = Math.atan2(mouse.y - cy, mouse.x - cx) + Math.PI / 2
                    if (a < 0)
                        a += Math.PI * 2
                    var total = 0
                    for (var i = 0; i < n; ++i)
                        total += Math.max(0, ChartUtils.asNumber(root.slices[i].value))
                    var acc = 0
                    var idx = -1
                    for (i = 0; i < n; ++i) {
                        acc += Math.max(0, ChartUtils.asNumber(root.slices[i].value)) / total
                        if (a / (Math.PI * 2) <= acc) {
                            idx = i
                            break
                        }
                    }
                    root.hoverIndex = idx
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
