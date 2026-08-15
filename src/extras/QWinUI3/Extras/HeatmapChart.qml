import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// HeatmapChart — Heatmap matrix chart.
//
//   HeatmapChart {
//       id: heatmapChart
//       values: matrix
//   }
//
//   // --- API ---
//   // signals: onCellClicked
//   // methods: playReveal(), requestRedraw(), clearHover(), lerpColor(a, b, t)
//   // heatmapChart.playReveal()
//   // heatmapChart.requestRedraw()
//   // heatmapChart.clearHover()
//   // heatmapChart.lerpColor(a, b, t)
//
// @notes
//   2D matrix / cells model; cellClicked for selection.
//   colorScale maps value -> color; show axes labels as needed.

T.Control {
    id: root

    // Numeric values array
    property var values: []
    // Heatmap row labels
    property var rowLabels: []
    // Heatmap column labels
    property var columnLabels: []
    // Minimum value
    property real minimum: NaN
    // Maximum value
    property real maximum: NaN
    // Gap between heatmap cells
    property real cellGap: 2
    // Heatmap cell corner radius
    property real cellRadius: 3
    // Play enter / reveal animation
    property bool animated: true
    // Enable hover / click interaction
    property bool interactive: true
    // 0..1 reveal animation progress
    property real revealProgress: 1
    // Hovered heatmap row index
    property int hoverRow: -1
    // Hovered column index
    property int hoverCol: -1
    // Low-zone color
    property color lowColor: Theme.dark ? "#1B3A4B" : "#D6EBFA"
    // High-zone color
    property color highColor: Theme.accent
    // Primary title text
    property string title: ""
    // Placeholder when there is no data
    property string emptyText: qsTr("No data")

    // Emitted when a cell is clicked
    signal cellClicked(int row, int col, real value)

    implicitWidth: 320
    implicitHeight: title.length ? 220 : 200
    padding: 8

    // True when there is no data
    readonly property bool isEmpty: {
        var g = _grid
        if (!g.length)
            return true
        for (var r = 0; r < g.length; ++r) {
            if (g[r] && g[r].length)
                return false
        }
        return true
    }

    readonly property var _grid: {
        var src = values || []
        var rows = []
        for (var r = 0; r < src.length; ++r) {
            var row = src[r] || []
            var out = []
            for (var c = 0; c < row.length; ++c)
                out.push(ChartUtils.asNumber(row[c]))
            rows.push(out)
        }
        return rows
    }

    readonly property var _extent: {
        var flat = []
        var g = root._grid
        for (var r = 0; r < g.length; ++r)
            flat = flat.concat(g[r])
        return ChartUtils.extents(flat)
    }

    Behavior on revealProgress {
        enabled: root.animated && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }

    // Play entrance reveal animation
    function playReveal() {
        if (!root.animated || Theme.reducedMotion) {
            revealProgress = 1
            requestRedraw()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    // Request chart / canvas redraw
    function requestRedraw() { canvas.requestPaint() }
    // Clear hovered item state
    function clearHover() {
        hoverRow = -1
        hoverCol = -1
        requestRedraw()
    }
    // Linearly interpolate two colors
    function lerpColor(a, b, t) {
        t = Math.max(0, Math.min(1, t))
        return Qt.rgba(a.r + (b.r - a.r) * t,
                       a.g + (b.g - a.g) * t,
                       a.b + (b.b - a.b) * t,
                       a.a + (b.a - a.a) * t)
    }

    onValuesChanged: { clearHover(); Qt.callLater(playReveal) }
    onRevealProgressChanged: requestRedraw()
    onHoverRowChanged: requestRedraw()
    onHoverColChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()
    Component.onCompleted: playReveal()

    contentItem: ColumnLayout {
        spacing: 8

        Text {
            visible: root.title.length > 0
            Layout.fillWidth: true
            text: root.title
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            elide: Text.ElideRight
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                anchors.centerIn: parent
                visible: root.isEmpty
                text: root.emptyText
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }

        Canvas {
            id: canvas
            anchors.fill: parent
            visible: !root.isEmpty
            antialiasing: true
            renderStrategy: Canvas.Cooperative
            // Label column width
            property real labelW: 0
            // Label area height
            property real labelH: 0
            // Cell width
            property real cellW: 1
            // Cell height
            property real cellH: 1
            // Grid row count
            property int rows: 0
            // Column count
            property int cols: 0

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var grid = root._grid
                if (!grid.length || width < 8 || height < 8)
                    return
                var rows = grid.length
                var cols = 0
                for (var r = 0; r < rows; ++r)
                    cols = Math.max(cols, grid[r].length)
                if (!cols)
                    return

                var hasRowLabels = root.rowLabels && root.rowLabels.length
                var hasColLabels = root.columnLabels && root.columnLabels.length
                var labelW = hasRowLabels ? 48 : 0
                var labelH = hasColLabels ? 18 : 0
                var gap = root.cellGap
                var plotW = width - labelW
                var plotH = height - labelH
                var cellW = (plotW - gap * (cols - 1)) / cols
                var cellH = (plotH - gap * (rows - 1)) / rows
                var lo = isFinite(root.minimum) ? root.minimum : root._extent.min
                var hi = isFinite(root.maximum) ? root.maximum : root._extent.max
                if (hi <= lo)
                    hi = lo + 1
                var reveal = Math.max(0, Math.min(1, root.revealProgress))
                var visible = Math.max(1, Math.floor(rows * cols * reveal))
                var drawn = 0

                canvas.labelW = labelW
                canvas.labelH = labelH
                canvas.cellW = cellW
                canvas.cellH = cellH
                canvas.rows = rows
                canvas.cols = cols

                ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                ctx.fillStyle = Theme.textSecondary
                ctx.textBaseline = "middle"
                if (hasRowLabels) {
                    ctx.textAlign = "right"
                    for (r = 0; r < rows; ++r) {
                        var ly = labelH + r * (cellH + gap) + cellH * 0.5
                        ctx.fillText(String(root.rowLabels[r] || ""), labelW - 6, ly)
                    }
                }
                if (hasColLabels) {
                    ctx.textAlign = "center"
                    ctx.textBaseline = "top"
                    for (var c = 0; c < cols; ++c) {
                        var lx = labelW + c * (cellW + gap) + cellW * 0.5
                        ctx.fillText(String(root.columnLabels[c] || ""), lx, 0)
                    }
                }

                for (r = 0; r < rows; ++r) {
                    for (c = 0; c < cols; ++c) {
                        if (drawn >= visible)
                            break
                        var v = ChartUtils.asNumber(grid[r][c])
                        var t = (v - lo) / (hi - lo)
                        var color = root.lerpColor(root.lowColor, root.highColor, t)
                        var x = labelW + c * (cellW + gap)
                        var y = labelH + r * (cellH + gap)
                        var hovered = root.hoverRow === r && root.hoverCol === c
                        var rr = Math.min(root.cellRadius, cellW * 0.5, cellH * 0.5)
                        ctx.globalAlpha = hovered ? 1 : 0.92
                        ctx.fillStyle = color
                        ctx.beginPath()
                        ctx.moveTo(x + rr, y)
                        ctx.lineTo(x + cellW - rr, y)
                        ctx.quadraticCurveTo(x + cellW, y, x + cellW, y + rr)
                        ctx.lineTo(x + cellW, y + cellH - rr)
                        ctx.quadraticCurveTo(x + cellW, y + cellH, x + cellW - rr, y + cellH)
                        ctx.lineTo(x + rr, y + cellH)
                        ctx.quadraticCurveTo(x, y + cellH, x, y + cellH - rr)
                        ctx.lineTo(x, y + rr)
                        ctx.quadraticCurveTo(x, y, x + rr, y)
                        ctx.closePath()
                        ctx.fill()
                        if (hovered) {
                            ctx.lineWidth = 2
                            ctx.strokeStyle = Theme.textPrimary
                            ctx.stroke()
                        }
                        drawn++
                    }
                }
                ctx.globalAlpha = 1
            }
        }

        MouseArea {
            anchors.fill: parent
            visible: !root.isEmpty
            hoverEnabled: root.interactive
            enabled: root.interactive
            onPositionChanged: (mouse) => {
                var c = Math.floor((mouse.x - canvas.labelW) / (canvas.cellW + root.cellGap))
                var r = Math.floor((mouse.y - canvas.labelH) / (canvas.cellH + root.cellGap))
                if (r < 0 || c < 0 || r >= canvas.rows || c >= canvas.cols) {
                    root.hoverRow = -1
                    root.hoverCol = -1
                    return
                }
                root.hoverRow = r
                root.hoverCol = c
            }
            onExited: root.clearHover()
            onClicked: {
                if (root.hoverRow >= 0 && root.hoverCol >= 0)
                    root.cellClicked(root.hoverRow, root.hoverCol,
                                     ChartUtils.asNumber(root._grid[root.hoverRow][root.hoverCol]))
            }
        }

        Rectangle {
            visible: root.hoverRow >= 0
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 4
            width: tip.implicitWidth + 14
            height: tip.implicitHeight + 10
            radius: Theme.cornerControl
            color: Theme.bgCardElevated
            border.width: 1
            border.color: Theme.strokeCard
            Text {
                id: tip
                anchors.centerIn: parent
                text: {
                    if (root.hoverRow < 0)
                        return ""
                    var v = ChartUtils.asNumber(root._grid[root.hoverRow][root.hoverCol])
                    var rl = (root.rowLabels && root.rowLabels[root.hoverRow]) || ("R" + (root.hoverRow + 1))
                    var cl = (root.columnLabels && root.columnLabels[root.hoverCol]) || ("C" + (root.hoverCol + 1))
                    return rl + " · " + cl + ": " + v
                }
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
        }
        } // plot Item
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}
