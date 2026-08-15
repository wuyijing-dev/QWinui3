import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ScatterChart — Scatter / bubble chart.
//
//   ScatterChart { points: [{ x: 1, y: 2 }] }

T.Control {
    id: root

    // Scatter points
    property var points: []
    // Numeric values array
    property var values: []
    // X-axis minimum
    property real minimumX: NaN
    // X-axis maximum
    property real maximumX: NaN
    // Y-axis minimum
    property real minimumY: NaN
    // Y-axis maximum
    property real maximumY: NaN
    // Scatter point radius
    property real pointRadius: 3.5
    // Show chart grid
    property bool showGrid: true
    // Show trend line
    property bool showTrendLine: false
    // Enable hover / click interaction
    property bool interactive: true
    // Play enter / reveal animation
    property bool animated: true
    // Max points before LOD kicks in
    property int maxPoints: 0
    // Auto-enable LOD for large series
    property bool autoLod: true
    // Level-of-detail downsample factor
    property real lodFactor: 1
    // Grid line color
    property color gridColor: Theme.strokeDivider
    // Point Color
    property color pointColor: Theme.accent
    // Trend Color
    property color trendColor: Theme.systemCaution
    // 0..1 reveal animation progress
    property real revealProgress: 1
    // Hovered item index
    property int hoverIndex: -1
    // Selected index alias
    property alias selectedIndex: root.hoverIndex
    // Tooltip / hover readout text
    property string hoverText: ""
    // Primary title text
    property string title: ""
    // Placeholder when there is no data
    property string emptyText: qsTr("No data")
    // Raw point count before LOD
    property int sourcePointCount: 0
    // Points drawn after LOD
    property int drawnPointCount: 0
    property string _lodKey: ""
    property var _lodPoints: []
    property real _loX: 0
    property real _hiX: 1
    property real _loY: 0
    property real _hiY: 1

    // Point Clicked
    signal pointClicked(int index, real x, real y)

    implicitWidth: 320
    implicitHeight: title.length ? 200 : 180
    padding: 8

    // Prefer points[]; values[] / ChartSeries uses index as x without expanding to objects.
    readonly property var _raw: (points && ChartUtils.valueCount(points) > 0) ? points : values
    // True when there is no data
    readonly property bool isEmpty: ChartUtils.valueCount(_raw) === 0

    Behavior on revealProgress {
        enabled: root.animated && !Theme.reducedMotion && ChartUtils.valueCount(root._raw) < ChartUtils.largeSeriesThreshold
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }

    function invalidateLod() {
        _lodKey = ""
        _lodPoints = []
    }

    function ensureLod(binsX, binsY) {
        var raw = root._raw
        var n = ChartUtils.valueCount(raw)
        var key = binsX + "x" + binsY + "|" + n
        if (key === _lodKey && _lodPoints)
            return _lodPoints

        var sampled
        if (raw && typeof raw.densityLod === "function") {
            var pack = raw.densityLod(binsX, binsY)
            sampled = pack.points || []
            _loX = isFinite(root.minimumX) ? root.minimumX : pack.minX
            _hiX = isFinite(root.maximumX) ? root.maximumX : pack.maxX
            _loY = isFinite(root.minimumY) ? root.minimumY : pack.minY
            _hiY = isFinite(root.maximumY) ? root.maximumY : pack.maxY
            sourcePointCount = pack.sourceCount || n
        } else {
            var ext = ChartUtils.extentsXY(raw)
            var loX = isFinite(root.minimumX) ? root.minimumX : ext.minX
            var hiX = isFinite(root.maximumX) ? root.maximumX : ext.maxX
            var loY = isFinite(root.minimumY) ? root.minimumY : ext.minY
            var hiY = isFinite(root.maximumY) ? root.maximumY : ext.maxY
            if (hiX <= loX) hiX = loX + 1
            if (hiY <= loY) hiY = loY + 1

            var budget = root.maxPoints > 0 ? root.maxPoints : Math.max(64, binsX * binsY)
            if (root.autoLod && n > budget)
                sampled = ChartUtils.densitySample(raw, binsX, binsY, loX, hiX, loY, hiY)
            else if (n > budget) {
                sampled = []
                var step = (n - 1) / Math.max(1, budget - 1)
                for (var i = 0; i < budget; ++i) {
                    var idx = Math.round(i * step)
                    sampled.push({
                        x: ChartUtils.pointX(raw, idx),
                        y: ChartUtils.pointY(raw, idx),
                        color: ChartUtils.pointColor(raw, idx),
                        count: 1,
                        index: idx
                    })
                }
            } else {
                sampled = ChartUtils.densitySample(raw, binsX, binsY, loX, hiX, loY, hiY)
            }
            _loX = loX
            _hiX = hiX
            _loY = loY
            _hiY = hiY
            sourcePointCount = n
        }
        if (_hiX <= _loX) _hiX = _loX + 1
        if (_hiY <= _loY) _hiY = _loY + 1

        _lodKey = key
        _lodPoints = sampled
        drawnPointCount = sampled.length
        return sampled
    }

    function playReveal() {
        invalidateLod()
        var huge = ChartUtils.valueCount(root._raw) >= ChartUtils.largeSeriesThreshold
        if (!root.animated || Theme.reducedMotion || huge) {
            revealProgress = 1
            requestRedraw()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    function requestRedraw() { canvas.requestPaint() }

    function clearHover() {
        hoverIndex = -1
        hoverText = ""
    }

    onPointsChanged: { hoverIndex = -1; hoverText = ""; invalidateLod(); Qt.callLater(playReveal) }
    onValuesChanged: { hoverIndex = -1; hoverText = ""; invalidateLod(); Qt.callLater(playReveal) }
    onMaxPointsChanged: { invalidateLod(); requestRedraw() }
    onMinimumXChanged: { invalidateLod(); requestRedraw() }
    onMaximumXChanged: { invalidateLod(); requestRedraw() }
    onMinimumYChanged: { invalidateLod(); requestRedraw() }
    onMaximumYChanged: { invalidateLod(); requestRedraw() }
    onShowGridChanged: requestRedraw()
    onShowTrendLineChanged: requestRedraw()
    onRevealProgressChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()
    Component.onCompleted: playReveal()

    Connections {
        target: root._raw && root._raw.dataChanged !== undefined ? root._raw : null
        function onDataChanged() {
            root.hoverIndex = -1
            root.hoverText = ""
            root.invalidateLod()
            Qt.callLater(root.playReveal)
        }
    }

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
            // Screen Pts
            property var screenPts: []
            // Pad L
            property real padL: 6
            // Pad T
            property real padT: 6
            // Plot width
            property real plotW: 1
            // Plot height
            property real plotH: 1

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var w = width
                var h = height
                if (w < 8 || h < 8 || root.isEmpty)
                    return

                var padL = 6, padR = 6, padT = 6, padB = 6
                var plotW = w - padL - padR
                var plotH = h - padT - padB
                var binsX = Math.max(24, Math.floor(plotW * Math.max(0.5, root.lodFactor)))
                var binsY = Math.max(18, Math.floor(plotH * Math.max(0.5, root.lodFactor)))
                var list = root.ensureLod(binsX, binsY)
                if (!list.length)
                    return

                var loX = root._loX
                var hiX = root._hiX
                var loY = root._loY
                var hiY = root._hiY
                canvas.padL = padL
                canvas.padT = padT
                canvas.plotW = plotW
                canvas.plotH = plotH

                if (root.showGrid) {
                    ctx.strokeStyle = root.gridColor
                    ctx.lineWidth = 1
                    ctx.globalAlpha = 0.5
                    for (var g = 0; g <= 4; ++g) {
                        var gy = padT + (plotH * g / 4)
                        ctx.beginPath()
                        ctx.moveTo(padL, gy)
                        ctx.lineTo(padL + plotW, gy)
                        ctx.stroke()
                        var gx = padL + (plotW * g / 4)
                        ctx.beginPath()
                        ctx.moveTo(gx, padT)
                        ctx.lineTo(gx, padT + plotH)
                        ctx.stroke()
                    }
                    ctx.globalAlpha = 1
                }

                function SX(x) { return padL + ((x - loX) / (hiX - loX)) * plotW }
                function SY(y) { return padT + plotH - ((y - loY) / (hiY - loY)) * plotH }

                if (root.showTrendLine && list.length >= 2) {
                    var n = list.length
                    var sumX = 0, sumY = 0, sumXY = 0, sumXX = 0
                    for (var i = 0; i < n; ++i) {
                        var vx = ChartUtils.asNumber(list[i].x)
                        var vy = ChartUtils.asNumber(list[i].y)
                        sumX += vx; sumY += vy
                        sumXY += vx * vy; sumXX += vx * vx
                    }
                    var den = n * sumXX - sumX * sumX
                    if (Math.abs(den) > 1e-9) {
                        var slope = (n * sumXY - sumX * sumY) / den
                        var intercept = (sumY - slope * sumX) / n
                        ctx.strokeStyle = ChartUtils.withAlpha(root.trendColor, 0.85)
                        ctx.lineWidth = 1.5
                        ctx.setLineDash([5, 4])
                        ctx.beginPath()
                        ctx.moveTo(SX(loX), SY(slope * loX + intercept))
                        ctx.lineTo(SX(hiX), SY(slope * hiX + intercept))
                        ctx.stroke()
                        ctx.setLineDash([])
                    }
                }

                var reveal = (!root.animated || root.sourcePointCount >= ChartUtils.largeSeriesThreshold)
                             ? 1 : Math.max(0, Math.min(1, root.revealProgress))
                var count = Math.max(1, Math.floor(list.length * reveal))
                var screen = []
                for (i = 0; i < count; ++i) {
                    var px = SX(ChartUtils.asNumber(list[i].x))
                    var py = SY(ChartUtils.asNumber(list[i].y))
                    var dens = Math.max(1, ChartUtils.asNumber(list[i].count, 1))
                    screen.push({
                        x: px,
                        y: py,
                        vx: ChartUtils.asNumber(list[i].x),
                        vy: ChartUtils.asNumber(list[i].y),
                        color: list[i].color,
                        index: list[i].index !== undefined ? list[i].index : i,
                        count: dens,
                        r: root.pointRadius + Math.min(3, Math.log(dens + 1))
                    })
                    var r = screen[i].r
                    ctx.beginPath()
                    ctx.arc(px, py, r, 0, Math.PI * 2)
                    ctx.fillStyle = list[i].color || root.pointColor
                    ctx.globalAlpha = Math.min(0.95, 0.45 + dens * 0.08)
                    ctx.fill()
                }
                ctx.globalAlpha = 1
                canvas.screenPts = screen
            }
        }

        // Hover highlight overlay — no Canvas repaint while moving
        Rectangle {
            visible: root.hoverIndex >= 0 && root.hoverIndex < canvas.screenPts.length
            width: {
                var p = canvas.screenPts[root.hoverIndex]
                return p ? (p.r + 2.5) * 2 : 0
            }
            height: width
            radius: width / 2
            x: {
                var p = canvas.screenPts[root.hoverIndex]
                return p ? p.x - width / 2 : 0
            }
            y: {
                var p = canvas.screenPts[root.hoverIndex]
                return p ? p.y - height / 2 : 0
            }
            color: Theme.bgCard
            border.width: 2
            border.color: {
                var p = canvas.screenPts[root.hoverIndex]
                return (p && p.color) ? p.color : root.pointColor
            }
        }

        MouseArea {
            anchors.fill: parent
            visible: !root.isEmpty
            hoverEnabled: root.interactive
            enabled: root.interactive
            onPositionChanged: (mouse) => {
                var pts = canvas.screenPts
                if (!pts || !pts.length) {
                    root.hoverIndex = -1
                    root.hoverText = ""
                    return
                }
                var best = -1
                var bestD = 14 * 14
                for (var i = 0; i < pts.length; ++i) {
                    var dx = mouse.x - pts[i].x
                    var dy = mouse.y - pts[i].y
                    var d = dx * dx + dy * dy
                    if (d < bestD) {
                        bestD = d
                        best = i
                    }
                }
                root.hoverIndex = best
                if (best >= 0) {
                    var hit = pts[best]
                    root.hoverText = "x: " + ChartUtils.formatNumber(hit.vx)
                                   + "\ny: " + ChartUtils.formatNumber(hit.vy)
                                   + (hit.count > 1 ? ("\nn: " + hit.count) : "")
                } else {
                    root.hoverText = ""
                }
            }
            onExited: root.clearHover()
            onClicked: {
                if (root.hoverIndex >= 0) {
                    var p = canvas.screenPts[root.hoverIndex]
                    root.pointClicked(p.index !== undefined ? p.index : root.hoverIndex, p.vx, p.vy)
                }
            }
        }

        Rectangle {
            visible: root.hoverText.length > 0
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
                text: root.hoverText
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
