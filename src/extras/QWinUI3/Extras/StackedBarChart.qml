import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// StackedBarChart — Stacked bar chart.
//
//   StackedBarChart {
//       id: stackedBarChart
//       series: [{ values: [1, 2]
//   }] }
//
//   // --- API ---
//   // signals: onCategoryClicked
//   // methods: playReveal(), requestRedraw()
//   // stackedBarChart.playReveal()
//   // stackedBarChart.requestRedraw()
//
// @notes
//   Stacked series segments per category; series items supply stacked values.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Stacked bar chart")

    // Chart series array
    property var series: []
    // Category labels for bars
    property var categories: []
    // Minimum value
    property real minimum: 0
    // Maximum value
    property real maximum: NaN
    // Bar corner radius
    property real barRadius: 4
    // Gap between bars
    property real barGap: 0.32
    // Show zero baseline
    property bool showBaseline: true
    // Show chart legend
    property bool showLegend: true
    // Show category axis labels
    property bool showCategoryLabels: true
    // Enable hover / click interaction
    property bool interactive: true
    // Alias of interactive (gauge / KPI naming parity)
    property alias isInteractive: root.interactive
    // Play enter / reveal animation
    property bool animated: true
    // 0..1 reveal animation progress
    property real revealProgress: 1
    // Hovered category index
    property int hoverCategory: -1
    // Hovered series index
    property int hoverSeries: -1
    // Tooltip / hover readout text
    property string hoverText: ""
    // Primary title text
    property string title: ""
    // Placeholder when there is no data
    property string emptyText: qsTr("No data")

    // Emitted when a category is clicked
    signal categoryClicked(int categoryIndex)

    implicitWidth: 320
    implicitHeight: {
        var h = showLegend ? 220 : 180
        if (title.length)
            h += Theme.fontBody + 10
        return h
    }
    padding: 8

    // True when there is no data
    readonly property bool isEmpty: !series || series.length === 0

    readonly property var _legendItems: {
        var list = series || []
        var out = []
        for (var i = 0; i < list.length; ++i) {
            out.push({
                label: list[i].name || (qsTr("Series") + " " + (i + 1)),
                color: list[i].color || ChartUtils.palette(Theme, i)
            })
        }
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
    onSeriesChanged: Qt.callLater(playReveal)
    onCategoriesChanged: requestRedraw()
    onMinimumChanged: requestRedraw()
    onMaximumChanged: requestRedraw()
    onRevealProgressChanged: requestRedraw()
    onHoverCategoryChanged: requestRedraw()
    onHoverSeriesChanged: requestRedraw()
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
                property real padL: 2
                // Bottom padding
                property real padB: 4
                // Category count
                property int catCount: 0

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var w = width
                    var h = height
                    var list = root.series || []
                    if (w < 8 || h < 8 || !list.length)
                        return

                    var catCount = 0
                    for (var s = 0; s < list.length; ++s) {
                        var len = (list[s].values && list[s].values.length) ? list[s].values.length : 0
                        if (len > catCount)
                            catCount = len
                    }
                    if (!catCount)
                        return

                    var sums = []
                    for (var c = 0; c < catCount; ++c) {
                        var sum = 0
                        for (s = 0; s < list.length; ++s)
                            sum += ChartUtils.asNumber(list[s].values ? list[s].values[c] : 0)
                        sums.push(sum)
                    }
                    var ext = ChartUtils.extents(sums)
                    var lo = isFinite(root.minimum) ? root.minimum : Math.min(0, ext.min)
                    var hi = isFinite(root.maximum) ? root.maximum : Math.max(0, ext.max)
                    if (hi <= lo)
                        hi = lo + 1
                    var span = hi - lo

                    var labelH = root.showCategoryLabels ? 18 : 0
                    var padT = 8, padB = labelH + 4, padL = 2, padR = 2
                    var plotH = h - padT - padB
                    var plotW = w - padL - padR
                    var slot = plotW / catCount
                    var gap = slot * root.barGap
                    var bw = Math.max(1, slot - gap)
                    var reveal = Math.max(0, Math.min(1, root.revealProgress))
                    canvas.slot = slot
                    canvas.padL = padL
                    canvas.padB = padB
                    canvas.catCount = catCount

                    // Grid
                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 1
                    ctx.globalAlpha = 0.45
                    for (var g = 0; g <= 4; ++g) {
                        var gy = padT + plotH * g / 4
                        ctx.beginPath()
                        ctx.moveTo(padL, gy)
                        ctx.lineTo(padL + plotW, gy)
                        ctx.stroke()
                    }
                    ctx.globalAlpha = 1

                    if (root.showBaseline) {
                        var zeroY = padT + plotH - ((0 - lo) / span) * plotH
                        zeroY = Math.max(padT, Math.min(padT + plotH, zeroY))
                        ctx.beginPath()
                        ctx.moveTo(padL, zeroY)
                        ctx.lineTo(padL + plotW, zeroY)
                        ctx.stroke()
                    }

                    for (c = 0; c < catCount; ++c) {
                        var x = padL + c * slot + gap * 0.5
                        var acc = 0
                        var dimmed = root.hoverCategory >= 0 && root.hoverCategory !== c
                        for (s = 0; s < list.length; ++s) {
                            var v = ChartUtils.asNumber(list[s].values ? list[s].values[c] : 0) * reveal
                            if (v === 0)
                                continue
                            var y0 = padT + plotH - ((acc - lo) / span) * plotH
                            acc += v
                            var y1 = padT + plotH - ((acc - lo) / span) * plotH
                            var top = Math.min(y0, y1)
                            var bot = Math.max(y0, y1)
                            var bh = Math.max(1, bot - top)
                            var color = list[s].color || ChartUtils.palette(Theme, s)
                            var seriesHover = root.hoverSeries === s
                            var r = (s === list.length - 1) ? Math.min(root.barRadius, bw * 0.5, bh) : 0

                            ctx.globalAlpha = dimmed ? 0.28 : (root.hoverSeries >= 0 && !seriesHover ? 0.35 : 1)
                            ctx.fillStyle = color
                            ctx.beginPath()
                            if (r > 0) {
                                ctx.moveTo(x + r, top)
                                ctx.lineTo(x + bw - r, top)
                                ctx.quadraticCurveTo(x + bw, top, x + bw, top + r)
                                ctx.lineTo(x + bw, top + bh)
                                ctx.lineTo(x, top + bh)
                                ctx.lineTo(x, top + r)
                                ctx.quadraticCurveTo(x, top, x + r, top)
                            } else {
                                ctx.rect(x, top, bw, bh)
                            }
                            ctx.closePath()
                            ctx.fill()
                        }
                        ctx.globalAlpha = 1

                        if (root.showCategoryLabels) {
                            ctx.fillStyle = root.hoverCategory === c ? Theme.textPrimary : Theme.textSecondary
                            ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                            ctx.textAlign = "center"
                            ctx.textBaseline = "top"
                            var label = (root.categories && root.categories[c]) ? root.categories[c]
                                        : String(c + 1)
                            ctx.fillText(label, x + bw * 0.5, h - labelH)
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: (mouse) => {
                    var idx = Math.floor((mouse.x - canvas.padL) / canvas.slot)
                    if (idx < 0 || idx >= canvas.catCount) {
                        root.hoverCategory = -1
                        root.hoverText = ""
                        return
                    }
                    root.hoverCategory = idx
                    var list = root.series || []
                    var lines = []
                    var cat = (root.categories && root.categories[idx]) ? root.categories[idx]
                              : ("#" + (idx + 1))
                    lines.push(cat)
                    for (var s = 0; s < list.length; ++s) {
                        var name = list[s].name || ("S" + (s + 1))
                        var v = ChartUtils.asNumber(list[s].values ? list[s].values[idx] : 0)
                        lines.push(name + ": " + ChartUtils.formatNumber(v))
                    }
                    root.hoverText = lines.join("\n")
                }
                onExited: {
                    root.hoverCategory = -1
                    root.hoverText = ""
                }
                onClicked: {
                    if (root.hoverCategory >= 0)
                        root.categoryClicked(root.hoverCategory)
                }
            }

            Rectangle {
                visible: root.hoverText.length > 0
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 4
                width: tipLabel.implicitWidth + 16
                height: tipLabel.implicitHeight + 12
                radius: Theme.cornerControl
                color: Theme.bgCardElevated
                border.width: 1
                border.color: Theme.strokeCard
                Text {
                    id: tipLabel
                    anchors.centerIn: parent
                    text: root.hoverText
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textPrimary
                }
            }
        }

        ChartLegend {
            id: legend
            visible: root.showLegend
            Layout.fillWidth: true
            items: root._legendItems
            showValue: false
            interactive: root.interactive
            hoverIndex: root.hoverSeries
            onHoverIndexChanged: root.hoverSeries = hoverIndex
            onItemHovered: (index) => root.hoverSeries = index
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}
