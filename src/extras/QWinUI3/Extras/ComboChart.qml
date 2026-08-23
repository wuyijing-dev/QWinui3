import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ComboChart — Bars plus an overlay line (volume vs price).
//
//   ComboChart {
//       bars: [12, 18, 9, 22]
//       line: [40, 42, 38, 51]
//   }
//
// @notes
//   Dual-axis Canvas chart. Bars use the left scale; line uses the right scale.
//   Experimental — compose on ChartCard. Not a new stable-six name.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Combo chart")

    // Column values (left axis)
    property var bars: []
    // Overlay line values (right axis)
    property var line: []
    // Category labels
    property var labels: []
    // Left-axis unit
    property string barUnit: ""
    // Right-axis unit
    property string lineUnit: ""
    // Left series name
    property string barName: qsTr("Volume")
    // Right series name
    property string lineName: qsTr("Price")
    // Show legend
    property bool showLegend: true
    // Show grid
    property bool showGrid: true
    // Primary title text
    property string title: ""
    // Placeholder when there is no data
    property string emptyText: qsTr("No data")
    // Enable hover
    property bool interactive: true
    property alias isInteractive: root.interactive
    property int hoverIndex: -1

    Timer {
        id: redrawCoalesce
        interval: ChartUtils.redrawCoalesceMs
        repeat: false
        onTriggered: canvas.requestPaint()
    }

    function requestRedraw() { redrawCoalesce.restart() }

    onBarsChanged: requestRedraw()
    onLineChanged: requestRedraw()
    onLabelsChanged: requestRedraw()
    onHoverIndexChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()

    implicitWidth: 360
    implicitHeight: title.length || showLegend ? 240 : 200
    padding: 8

    readonly property bool isEmpty: ChartUtils.valueCount(bars) === 0
            && ChartUtils.valueCount(line) === 0

    readonly property int _count: Math.max(ChartUtils.valueCount(bars), ChartUtils.valueCount(line))

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
                font.pixelSize: Theme.fontCaption
            }

            Canvas {
                id: canvas
                anchors.fill: parent
                visible: !root.isEmpty
                antialiasing: true
                renderStrategy: Canvas.Cooperative
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var w = width
                    var h = height
                    var n = root._count
                    if (w < 16 || h < 16 || n <= 0)
                        return
                    var padL = 36
                    var padR = 36
                    var padT = 8
                    var padB = 18
                    var plotW = w - padL - padR
                    var plotH = h - padT - padB
                    var barExt = ChartUtils.extents(root.bars)
                    var lineExt = ChartUtils.extents(root.line)
                    var barLo = Math.min(0, barExt.min)
                    var barHi = Math.max(barExt.max, barLo + 1)
                    var lineLo = lineExt.min
                    var lineHi = lineExt.max
                    if (lineHi <= lineLo)
                        lineHi = lineLo + 1
                    var slot = plotW / n

                    if (root.showGrid) {
                        ctx.strokeStyle = Theme.strokeDivider
                        ctx.lineWidth = 1
                        for (var g = 0; g <= 4; ++g) {
                            var gy = padT + plotH * g / 4
                            ctx.beginPath()
                            ctx.moveTo(padL, gy)
                            ctx.lineTo(padL + plotW, gy)
                            ctx.stroke()
                        }
                    }

                    var bw = Math.max(2, slot * 0.55)
                    for (var i = 0; i < n; ++i) {
                        var bv = ChartUtils.valueAt(root.bars, i, 0)
                        var bh = ((bv - barLo) / (barHi - barLo)) * plotH
                        var x = padL + i * slot + (slot - bw) * 0.5
                        var y = padT + plotH - bh
                        ctx.fillStyle = root.hoverIndex === i
                                        ? Theme.accent
                                        : ChartUtils.withAlpha(Theme.accent, 0.55)
                        ctx.fillRect(x, y, bw, Math.max(1, bh))
                    }

                    ctx.strokeStyle = Theme.systemCaution
                    ctx.lineWidth = 2
                    ctx.lineJoin = "round"
                    ctx.beginPath()
                    for (i = 0; i < n; ++i) {
                        var lv = ChartUtils.valueAt(root.line, i, lineLo)
                        var lx = padL + i * slot + slot * 0.5
                        var ly = padT + plotH - ((lv - lineLo) / (lineHi - lineLo)) * plotH
                        if (i === 0)
                            ctx.moveTo(lx, ly)
                        else
                            ctx.lineTo(lx, ly)
                    }
                    ctx.stroke()

                    ctx.fillStyle = Theme.textSecondary
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textAlign = "center"
                    ctx.textBaseline = "top"
                    for (i = 0; i < n; ++i) {
                        var lab = (root.labels && root.labels[i] !== undefined)
                                  ? String(root.labels[i]) : String(i + 1)
                        ctx.fillText(lab, padL + i * slot + slot * 0.5, padT + plotH + 2)
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
                    if (n <= 0) {
                        root.hoverIndex = -1
                        return
                    }
                    var padL = 36
                    var padR = 36
                    var plotW = parent.width - padL - padR
                    var idx = Math.floor((mouse.x - padL) / (plotW / n))
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
                    canvas.requestPaint()
                }
                onExited: {
                    root.hoverIndex = -1
                    canvas.requestPaint()
                }
            }
        }

        Row {
            visible: root.showLegend
            spacing: Theme.dp(12)
            Repeater {
                model: [
                    { label: root.barName + (root.barUnit.length ? " (" + root.barUnit + ")" : ""), color: Theme.accent },
                    { label: root.lineName + (root.lineUnit.length ? " (" + root.lineUnit + ")" : ""), color: Theme.systemCaution }
                ]
                delegate: Row {
                    required property var modelData
                    spacing: 6
                    Rectangle {
                        width: 10
                        height: 10
                        radius: 2
                        color: modelData.color
                        anchors.verticalCenter: parent.verticalCenter
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
