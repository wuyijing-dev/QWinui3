import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// BarChart — Vertical bar chart with reveal animation.
//
//   BarChart {
//       id: barChart
//       values: [4, 2, 7, 3]
//   }
//
//   // --- API ---
//   // signals: onBarClicked
//   // methods: playReveal(), requestRedraw()
//   // barChart.playReveal()
//   // barChart.requestRedraw()
//
// @notes
//   Prefer values: number[] or bars: [{ value, label?, color? }].
//   unit aliases valueUnit. interactive / isInteractive aliases. playReveal() for enter.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Bar chart")

    // Numeric values array
    property var values: []
    // Bar descriptors
    property var bars: []
    // Minimum value
    property real minimum: 0
    // Maximum value
    property real maximum: NaN
    // Bar corner radius
    property real barRadius: 4
    // Gap between bars
    property real barGap: 0.28
    // Show zero baseline
    property bool showBaseline: true
    // Show value labels on bars
    property bool showValueLabels: false
    // Enable hover / click interaction
    property bool interactive: true
    // Alias of interactive (gauge / KPI naming parity)
    property alias isInteractive: root.interactive
    // Play enter / reveal animation
    property bool animated: true
    // 0..1 reveal animation progress
    property real revealProgress: 1
    // Hovered item index
    property int hoverIndex: -1
    // Selected index alias
    property alias selectedIndex: root.hoverIndex
    // Primary title text
    property string title: ""
    // Placeholder when there is no data
    property string emptyText: qsTr("No data")
    // Unit appended to value text
    property string valueUnit: ""
    // Alias of valueUnit (gauge / KPI naming parity)
    property alias unit: root.valueUnit
    // Draw bars left-to-right instead of bottom-up
    property bool horizontal: false
    // Stack series on the same category (requires series)
    property bool stacked: false
    // Multi-series [{ name, values, color? }] — grouped when stacked is false
    property var series: []
    // Category labels (used with series)
    property var labels: []

    // Emitted when a bar is clicked
    signal barClicked(int index, real value)

    implicitWidth: 320
    implicitHeight: title.length ? 200 : 180
    padding: 8

    // True when there is no data
    readonly property bool isEmpty: _hasSeries ? _categoryCount === 0 : _bars.length === 0

    readonly property bool _hasSeries: series && series.length > 0
    readonly property int _categoryCount: {
        if (!_hasSeries)
            return _bars.length
        return ChartUtils.valueCount(series[0].values)
    }

    readonly property var _bars: {
        if (bars && bars.length)
            return bars
        var vals = ChartUtils.flattenValues(values)
        var out = []
        for (var i = 0; i < vals.length; ++i)
            out.push({ value: vals[i], color: ChartUtils.palette(Theme, i) })
        return out
    }

    readonly property int _pointCount: _hasSeries ? _categoryCount : _bars.length

    Behavior on revealProgress {
        enabled: ChartUtils.shouldAnimateReveal(_pointCount, root.animated)
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }

    Timer {
        id: redrawCoalesce
        interval: ChartUtils.redrawCoalesceMs
        repeat: false
        onTriggered: canvas.requestPaint()
    }

    // Play entrance reveal animation
    function playReveal() {
        if (!ChartUtils.shouldAnimateReveal(_pointCount, root.animated)) {
            revealProgress = 1
            requestRedraw()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    // Request chart / canvas redraw
    function requestRedraw() { redrawCoalesce.restart() }

    function _categoryValue(index) {
        if (root._hasSeries) {
            var sum = 0
            for (var s = 0; s < root.series.length; ++s)
                sum += ChartUtils.valueAt(root.series[s].values, index, 0)
            return sum
        }
        if (index < 0 || index >= root._bars.length)
            return 0
        return ChartUtils.asNumber(root._bars[index].value)
    }

    onValuesChanged: Qt.callLater(playReveal)
    onBarsChanged: Qt.callLater(playReveal)
    onSeriesChanged: Qt.callLater(playReveal)
    onStackedChanged: requestRedraw()
    onHorizontalChanged: requestRedraw()
    onLabelsChanged: requestRedraw()
    onMinimumChanged: requestRedraw()
    onMaximumChanged: requestRedraw()
    onRevealProgressChanged: requestRedraw()
    onHoverIndexChanged: requestRedraw()
    onShowValueLabelsChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()
    Component.onCompleted: playReveal()

    contentItem: ColumnLayout {
        spacing: 6

        Text {
            visible: root.title.length > 0
            Layout.fillWidth: true
            text: root.title
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
                property real gap: 0
                property real padL: 2
                property real padT: 10
                property bool horiz: false

                onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var w = width
                var h = height
                if (w < 8 || h < 8)
                    return

                var reveal = Math.max(0, Math.min(1, root.revealProgress))
                var hasSeries = root._hasSeries
                var n = hasSeries ? root._categoryCount : root._bars.length
                if (n <= 0)
                    return

                var horiz = root.horizontal && !hasSeries
                canvas.horiz = horiz
                var padT = 10
                var padB = (root.labels && root.labels.length && !horiz) ? 16 : 4
                var padL = horiz ? 8 : 2
                var padR = 2
                var plotH = h - padT - padB
                var plotW = w - padL - padR

                var lo = isFinite(root.minimum) ? root.minimum : 0
                var hi = isFinite(root.maximum) ? root.maximum : NaN

                function seriesVal(s, i) {
                    return ChartUtils.valueAt(root.series[s].values, i, 0)
                }

                if (hasSeries) {
                    var extMax = 0
                    for (var ci = 0; ci < n; ++ci) {
                        var stack = 0
                        var peak = 0
                        for (var s = 0; s < root.series.length; ++s) {
                            var sv = seriesVal(s, ci)
                            if (root.stacked)
                                stack += sv
                            else
                                peak = Math.max(peak, sv)
                        }
                        extMax = Math.max(extMax, root.stacked ? stack : peak)
                    }
                    if (!isFinite(hi))
                        hi = Math.max(extMax, 1)
                } else {
                    var vals = []
                    for (var i = 0; i < n; ++i)
                        vals.push(ChartUtils.asNumber(root._bars[i].value))
                    var ext = ChartUtils.extents(vals)
                    if (!isFinite(root.minimum))
                        lo = Math.min(0, ext.min)
                    if (!isFinite(hi))
                        hi = Math.max(0, ext.max)
                }
                if (hi <= lo)
                    hi = lo + 1
                var span = hi - lo

                var slot = horiz ? (plotH / n) : (plotW / n)
                var gap = slot * root.barGap
                var bw = Math.max(1, slot - gap)
                canvas.slot = slot
                canvas.gap = gap
                canvas.padL = padL
                canvas.padT = padT

                if (root.showBaseline) {
                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    if (horiz) {
                        var zeroX = padL + ((0 - lo) / span) * plotW
                        zeroX = Math.max(padL, Math.min(padL + plotW, zeroX))
                        ctx.moveTo(zeroX, padT)
                        ctx.lineTo(zeroX, padT + plotH)
                    } else {
                        var zeroY = padT + plotH - ((0 - lo) / span) * plotH
                        zeroY = Math.max(padT, Math.min(padT + plotH, zeroY))
                        ctx.moveTo(padL, zeroY)
                        ctx.lineTo(padL + plotW, zeroY)
                    }
                    ctx.stroke()
                }

                ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""

                function fillBar(x, top, barW, barH, baseColor, hovered) {
                    var color = hovered ? baseColor : ChartUtils.withAlpha(baseColor, 0.88)
                    var r = Math.min(root.barRadius, barW * 0.5, barH)
                    var grad = ctx.createLinearGradient(x, top, x, top + barH)
                    grad.addColorStop(0, color)
                    grad.addColorStop(1, ChartUtils.withAlpha(baseColor, Theme.dark ? 0.65 : 0.75))
                    ctx.fillStyle = hovered ? color : grad
                    ctx.beginPath()
                    ctx.moveTo(x + r, top)
                    ctx.lineTo(x + barW - r, top)
                    ctx.quadraticCurveTo(x + barW, top, x + barW, top + r)
                    ctx.lineTo(x + barW, top + barH)
                    ctx.lineTo(x, top + barH)
                    ctx.lineTo(x, top + r)
                    ctx.quadraticCurveTo(x, top, x + r, top)
                    ctx.closePath()
                    ctx.fill()
                }

                if (hasSeries) {
                    var sc = root.series.length
                    for (i = 0; i < n; ++i) {
                        var hovered = root.hoverIndex === i
                        var catX = padL + i * slot + gap * 0.5
                        if (root.stacked) {
                            var acc = 0
                            for (s = 0; s < sc; ++s) {
                                var v = seriesVal(s, i) * reveal
                                var y0 = padT + plotH - ((acc - lo) / span) * plotH
                                acc += v
                                var y1 = padT + plotH - ((acc - lo) / span) * plotH
                                var top = Math.min(y0, y1)
                                var bh = Math.max(1, Math.abs(y1 - y0))
                                var col = root.series[s].color || ChartUtils.palette(Theme, s)
                                fillBar(catX, top, bw, bh, col, hovered)
                            }
                        } else {
                            var inner = bw / sc
                            for (s = 0; s < sc; ++s) {
                                v = seriesVal(s, i) * reveal
                                var yBase = padT + plotH - ((0 - lo) / span) * plotH
                                var yTip = padT + plotH - ((v - lo) / span) * plotH
                                top = Math.min(yBase, yTip)
                                bh = Math.max(1, Math.abs(yTip - yBase))
                                col = root.series[s].color || ChartUtils.palette(Theme, s)
                                fillBar(catX + s * inner, top, Math.max(1, inner - 1), bh, col, hovered)
                            }
                        }
                    }
                } else {
                    for (i = 0; i < n; ++i) {
                        v = vals[i] * reveal
                        var baseColor = root._bars[i].color || ChartUtils.palette(Theme, i)
                        hovered = root.hoverIndex === i
                        if (horiz) {
                            var y = padT + i * slot + gap * 0.5
                            var x0 = padL + ((0 - lo) / span) * plotW
                            var x1 = padL + ((v - lo) / span) * plotW
                            var left = Math.min(x0, x1)
                            var barW = Math.max(1, Math.abs(x1 - x0))
                            fillBar(left, y, barW, bw, baseColor, hovered)
                            if (hovered || root.showValueLabels) {
                                ctx.fillStyle = Theme.textSecondary
                                ctx.textAlign = "left"
                                ctx.textBaseline = "middle"
                                var label = String(Math.round(vals[i] * 10) / 10)
                                if (root.valueUnit.length)
                                    label += root.valueUnit
                                ctx.fillText(label, left + barW + 4, y + bw * 0.5)
                            }
                        } else {
                            var x = padL + i * slot + gap * 0.5
                            var y0v = padT + plotH - ((0 - lo) / span) * plotH
                            var y1v = padT + plotH - ((v - lo) / span) * plotH
                            top = Math.min(y0v, y1v)
                            bh = Math.max(1, Math.abs(y1v - y0v))
                            fillBar(x, top, bw, bh, baseColor, hovered)
                            if (hovered || root.showValueLabels) {
                                ctx.fillStyle = Theme.textSecondary
                                ctx.textAlign = "center"
                                ctx.textBaseline = "bottom"
                                label = String(Math.round(vals[i] * 10) / 10)
                                if (root.valueUnit.length)
                                    label += root.valueUnit
                                ctx.fillText(label, x + bw * 0.5, top - 2)
                            }
                        }
                    }
                }

                if (root.labels && root.labels.length && !horiz) {
                    ctx.fillStyle = Theme.textSecondary
                    ctx.textAlign = "center"
                    ctx.textBaseline = "top"
                    var stride = Math.max(1, Math.ceil(n / 8))
                    for (i = 0; i < n; i += stride) {
                        var lab = root.labels[i]
                        if (lab === undefined)
                            continue
                        ctx.fillText(String(lab), padL + i * slot + slot * 0.5, padT + plotH + 2)
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
                    var n = root._hasSeries ? root._categoryCount : root._bars.length
                    if (n <= 0) {
                        root.hoverIndex = -1
                        return
                    }
                    var idx = canvas.horiz
                              ? Math.floor((mouse.y - canvas.padT) / canvas.slot)
                              : Math.floor((mouse.x - canvas.padL) / canvas.slot)
                    root.hoverIndex = (idx >= 0 && idx < n) ? idx : -1
                }
                onExited: root.hoverIndex = -1
                onClicked: (mouse) => {
                    if (root.hoverIndex >= 0)
                        root.barClicked(root.hoverIndex, root._categoryValue(root.hoverIndex))
                }
            }
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: root.hoverIndex >= 0 ? Theme.strokeControl : Theme.strokeCard
        Behavior on border.color {
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }
}
