import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// WaterfallChart — Waterfall chart.
//
//   WaterfallChart {
//       id: waterfallChart
//       values: [10, -3, 5]
//   }
//
//   // --- API ---
//   // signals: onStepClicked
//   // methods: playReveal(), requestRedraw(), clearHover()
//   // waterfallChart.playReveal()
//   // waterfallChart.requestRedraw()
//   // waterfallChart.clearHover()
//
// @notes
//   values are signed deltas; total/connector styling via chart props.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Waterfall chart")

    // Waterfall step descriptors
    property var steps: []
    // Numeric values array
    property var values: [] // convenience deltas
    // Show connectors between steps
    property bool showConnector: true
    // Show item labels
    property bool showLabels: true
    // Enable hover / click interaction
    property bool interactive: true
    // Play enter / reveal animation
    property bool animated: true
    // 0..1 reveal animation progress
    property real revealProgress: 1
    // Hovered item index
    property int hoverIndex: -1
    // Selected index alias
    property alias selectedIndex: root.hoverIndex
    // Waterfall total bar color
    property color totalColor: Theme.accentDark1
    // Show total column
    property bool showTotal: true
    // Primary title text
    property string title: ""
    // Placeholder when there is no data
    property string emptyText: qsTr("No data")
    // Unit appended to value text
    property string valueUnit: ""

    // Emitted when a step is clicked
    signal stepClicked(int index, real value)

    implicitWidth: 320
    implicitHeight: title.length ? 220 : 200
    padding: 8

    // True when there is no data
    readonly property bool isEmpty: _steps.length === 0

    readonly property var _steps: {
        if (steps && steps.length)
            return steps
        var vals = ChartUtils.flattenValues(values)
        var out = []
        for (var i = 0; i < vals.length; ++i)
            out.push({ value: vals[i], label: String(i + 1) })
        return out
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
        hoverIndex = -1
        requestRedraw()
    }

    onStepsChanged: { hoverIndex = -1; Qt.callLater(playReveal) }
    onValuesChanged: { hoverIndex = -1; Qt.callLater(playReveal) }
    onRevealProgressChanged: requestRedraw()
    onHoverIndexChanged: requestRedraw()
    onShowTotalChanged: requestRedraw()
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
            // Named content slot
            property real slot: 1
            // Left padding
            property real padL: 4
            // Item count
            property int count: 0

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var list = root._steps
                var w = width
                var h = height
                if (!list.length || w < 8 || h < 8)
                    return

                var running = [0]
                var acc = 0
                for (var i = 0; i < list.length; ++i) {
                    acc += ChartUtils.asNumber(list[i].value)
                    running.push(acc)
                }
                var total = acc
                var levels = running.slice()
                if (root.showTotal)
                    levels.push(0)
                var ext = ChartUtils.extents(levels.concat([total, 0]))
                var lo = Math.min(0, ext.min)
                var hi = Math.max(0, ext.max)
                if (hi <= lo)
                    hi = lo + 1
                var span = hi - lo

                var n = list.length + (root.showTotal ? 1 : 0)
                var labelH = root.showLabels ? 18 : 0
                var padT = 8, padB = labelH + 4, padL = 4, padR = 4
                var plotH = h - padT - padB
                var plotW = w - padL - padR
                var slot = plotW / n
                var gap = slot * 0.3
                var bw = Math.max(2, slot - gap)
                var reveal = Math.max(0, Math.min(1, root.revealProgress))
                canvas.slot = slot
                canvas.padL = padL
                canvas.count = n

                function Y(v) { return padT + plotH - ((v - lo) / span) * plotH }

                // Baseline
                ctx.strokeStyle = Theme.strokeDivider
                ctx.beginPath()
                ctx.moveTo(padL, Y(0))
                ctx.lineTo(padL + plotW, Y(0))
                ctx.stroke()

                ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                ctx.textAlign = "center"

                for (i = 0; i < list.length; ++i) {
                    if (i / Math.max(1, n - 1) > reveal && reveal < 1)
                        break
                    var v = ChartUtils.asNumber(list[i].value)
                    var y0 = Y(running[i])
                    var y1 = Y(running[i + 1])
                    var top = Math.min(y0, y1)
                    var bot = Math.max(y0, y1)
                    var bh = Math.max(1, bot - top)
                    var x = padL + i * slot + gap * 0.5
                    var color = list[i].color
                                 || (v >= 0 ? Theme.systemSuccess : Theme.systemCritical)
                    var hovered = root.hoverIndex === i

                    if (root.showConnector && i > 0) {
                        ctx.strokeStyle = Theme.strokeDivider
                        ctx.setLineDash([3, 3])
                        ctx.beginPath()
                        ctx.moveTo(padL + (i - 1) * slot + gap * 0.5 + bw, Y(running[i]))
                        ctx.lineTo(x, Y(running[i]))
                        ctx.stroke()
                        ctx.setLineDash([])
                    }

                    ctx.globalAlpha = hovered || root.hoverIndex < 0 ? 1 : 0.4
                    ctx.fillStyle = color
                    var r = Math.min(3, bw * 0.5, bh)
                    ctx.beginPath()
                    ctx.moveTo(x + r, top)
                    ctx.lineTo(x + bw - r, top)
                    ctx.quadraticCurveTo(x + bw, top, x + bw, top + r)
                    ctx.lineTo(x + bw, top + bh)
                    ctx.lineTo(x, top + bh)
                    ctx.lineTo(x, top + r)
                    ctx.quadraticCurveTo(x, top, x + r, top)
                    ctx.closePath()
                    ctx.fill()
                    ctx.globalAlpha = 1

                    ctx.fillStyle = Theme.textSecondary
                    ctx.textBaseline = "bottom"
                    var deltaLabel = (v >= 0 ? "+" : "") + ChartUtils.formatNumber(v)
                    if (root.valueUnit.length)
                        deltaLabel += root.valueUnit
                    ctx.fillText(deltaLabel, x + bw * 0.5, top - 2)

                    if (root.showLabels) {
                        ctx.textBaseline = "top"
                        ctx.fillText(list[i].label || String(i + 1), x + bw * 0.5, h - labelH)
                    }
                }

                if (root.showTotal && reveal > 0.85) {
                    var ti = list.length
                    var tx = padL + ti * slot + gap * 0.5
                    var ty0 = Y(0)
                    var ty1 = Y(total)
                    var ttop = Math.min(ty0, ty1)
                    var tbot = Math.max(ty0, ty1)
                    var tbh = Math.max(1, tbot - ttop)
                    ctx.fillStyle = root.totalColor
                    ctx.fillRect(tx, ttop, bw, tbh)
                    ctx.fillStyle = Theme.textPrimary
                    ctx.textBaseline = "bottom"
                    var totalLabel = ChartUtils.formatNumber(total)
                    if (root.valueUnit.length)
                        totalLabel += root.valueUnit
                    ctx.fillText(totalLabel, tx + bw * 0.5, ttop - 2)
                    if (root.showLabels) {
                        ctx.fillStyle = Theme.textSecondary
                        ctx.textBaseline = "top"
                        ctx.fillText(qsTr("Total"), tx + bw * 0.5, h - labelH)
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            visible: !root.isEmpty
            hoverEnabled: root.interactive
            enabled: root.interactive
            onPositionChanged: (mouse) => {
                var idx = Math.floor((mouse.x - canvas.padL) / canvas.slot)
                root.hoverIndex = (idx >= 0 && idx < root._steps.length) ? idx : -1
            }
            onExited: root.clearHover()
            onClicked: {
                if (root.hoverIndex >= 0)
                    root.stepClicked(root.hoverIndex, ChartUtils.asNumber(root._steps[root.hoverIndex].value))
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
