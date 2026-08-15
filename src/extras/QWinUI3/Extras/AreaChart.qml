import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Area chart with legend and hover crosshair (Fluent dashboard style).
T.Control {
    id: root

    property var series: []
    property var values: []
    property real minimum: NaN
    property real maximum: NaN
    property bool showGrid: true
    property bool stacked: false
    property bool showLegend: true
    property bool interactive: true
    property bool animated: true
    property int maxPoints: 0
    property real lodFactor: 2
    property bool autoLod: true
    property color gridColor: Theme.strokeDivider
    property real revealProgress: 1
    property int hoverIndex: -1
    property real hoverLineX: 0
    property var hoverMarkers: []
    property string hoverText: ""
    property string title: ""
    property string emptyText: qsTr("No data")
    property int sourcePointCount: 0
    property int drawnPointCount: 0
    property string _lodKey: ""
    property var _lodPacks: []
    property real _lodMin: 0
    property real _lodMax: 1

    implicitWidth: 320
    implicitHeight: {
        var h = showLegend ? 210 : 180
        if (title.length)
            h += Theme.fontBody + 10
        return h
    }
    padding: 8

    readonly property bool isEmpty: _seriesList.length === 0
            || ChartUtils.valueCount(_seriesList[0] ? _seriesList[0].values : []) === 0

    readonly property var _seriesList: {
        if (series && series.length)
            return series
        if (ChartUtils.valueCount(values) > 0)
            return [{ name: qsTr("Series"), values: values, color: Theme.accent }]
        return []
    }

    readonly property var _legendItems: {
        var list = root._seriesList
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
        enabled: root.animated && !Theme.reducedMotion && root.sourcePointCountEstimate() < ChartUtils.largeSeriesThreshold
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }

    function invalidateLod() {
        _lodKey = ""
        _lodPacks = []
    }

    function sourcePointCountEstimate() {
        var list = root._seriesList
        var n = 0
        for (var i = 0; i < list.length; ++i)
            n = Math.max(n, ChartUtils.valueCount(list[i].values))
        return n
    }

    function ensureLod(budget) {
        var list = root._seriesList
        var key = String(budget)
        for (var s = 0; s < list.length; ++s)
            key += "|" + ChartUtils.valueCount(list[s].values)
        if (_lodKey.length && _lodPacks && _lodPacks.length === list.length) {
            var prevBudget = Number(_lodKey.split("|")[0])
            if (prevBudget > 0 && Math.abs(budget - prevBudget) <= prevBudget * 0.15
                    && key.substring(key.indexOf("|")) === _lodKey.substring(_lodKey.indexOf("|"))) {
                return _lodPacks
            }
        }
        if (key === _lodKey && _lodPacks && _lodPacks.length)
            return _lodPacks

        var packs = []
        var glo = NaN
        var ghi = NaN
        var drawn = 0
        var src = 0
        for (s = 0; s < list.length; ++s) {
            var pack = ChartUtils.buildLod(list[s].values, budget)
            packs.push(pack)
            drawn += pack.values.length
            src = Math.max(src, pack.sourceCount)
            if (!isFinite(glo) || pack.min < glo)
                glo = pack.min
            if (!isFinite(ghi) || pack.max > ghi)
                ghi = pack.max
        }
        if (!isFinite(glo) || !isFinite(ghi) || ghi <= glo) {
            glo = 0
            ghi = 1
        }
        _lodKey = key
        _lodPacks = packs
        _lodMin = glo
        _lodMax = ghi
        sourcePointCount = src
        drawnPointCount = drawn
        return packs
    }

    function playReveal() {
        invalidateLod()
        var huge = root.sourcePointCountEstimate() >= ChartUtils.largeSeriesThreshold
        if (!root.animated || Theme.reducedMotion || huge) {
            revealProgress = 1
            requestRedraw()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    function requestRedraw() { canvas.requestPaint() }
    onSeriesChanged: { invalidateLod(); Qt.callLater(playReveal) }
    onValuesChanged: { invalidateLod(); Qt.callLater(playReveal) }
    onMaxPointsChanged: { invalidateLod(); requestRedraw() }
    onLodFactorChanged: { invalidateLod(); requestRedraw() }
    onMinimumChanged: requestRedraw()
    onMaximumChanged: requestRedraw()
    onShowGridChanged: requestRedraw()
    onStackedChanged: { invalidateLod(); requestRedraw() }
    onRevealProgressChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()
    Component.onCompleted: playReveal()

    Connections {
        target: root.values && root.values.dataChanged !== undefined ? root.values : null
        function onDataChanged() {
            root.hoverIndex = -1
            root.hoverText = ""
            root.hoverMarkers = []
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
                property real plotL: 4
                property real plotT: 6
                property real plotW: 1
                property real plotH: 1
                property real lo: 0
                property real hi: 1
                property var sampled: []

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var w = width
                    var h = height
                    if (w < 8 || h < 8)
                        return
                    var list = root._seriesList
                    if (!list.length)
                        return

                    var padL = 4, padR = 4, padT = 6, padB = 6
                    var plotW = w - padL - padR
                    var plotH = h - padT - padB
                    var budget = root.autoLod
                                 ? ChartUtils.lodBudget(plotW, root.maxPoints, root.lodFactor)
                                 : (root.maxPoints > 0 ? root.maxPoints : Math.max(48, Math.floor(plotW)))
                    var packs = root.ensureLod(budget)
                    var sampled = []
                    var maxLen = 0
                    for (var s = 0; s < packs.length; ++s) {
                        sampled.push(packs[s].values)
                        if (packs[s].values.length > maxLen)
                            maxLen = packs[s].values.length
                    }
                    if (maxLen < 2)
                        return
                    canvas.sampled = sampled
                    canvas.plotL = padL
                    canvas.plotT = padT
                    canvas.plotW = plotW
                    canvas.plotH = plotH

                    var reveal = (!root.animated || root.sourcePointCount >= ChartUtils.largeSeriesThreshold)
                                 ? 1 : Math.max(0, Math.min(1, root.revealProgress))
                    var lo = 0, hi = 0
                    if (root.stacked) {
                        for (var i = 0; i < maxLen; ++i) {
                            var sum = 0
                            for (s = 0; s < sampled.length; ++s)
                                sum += ChartUtils.asNumber(sampled[s][Math.min(i, sampled[s].length - 1)])
                            if (i === 0 || sum > hi)
                                hi = sum
                        }
                    } else {
                        lo = isFinite(root.minimum) ? root.minimum : root._lodMin
                        hi = isFinite(root.maximum) ? root.maximum : root._lodMax
                    }
                    if (hi <= lo)
                        hi = lo + 1
                    canvas.lo = lo
                    canvas.hi = hi
                    var span = hi - lo

                    function X(i, n) { return padL + (i / Math.max(1, n - 1)) * plotW }
                    function Y(v) { return padT + plotH - ((v - lo) / span) * plotH }

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
                        }
                        ctx.globalAlpha = 1
                    }

                    ctx.save()
                    ctx.beginPath()
                    ctx.rect(padL, padT - 2, plotW * reveal, plotH + 4)
                    ctx.clip()

                    var baselines = []
                    for (i = 0; i < maxLen; ++i)
                        baselines.push(0)

                    for (s = 0; s < sampled.length; ++s) {
                        var ptsS = sampled[s]
                        var n = ptsS.length
                        var color = list[s].color || ChartUtils.palette(Theme, s)
                        var top = []
                        for (i = 0; i < n; ++i) {
                            var v = ChartUtils.asNumber(ptsS[i])
                            if (root.stacked) {
                                baselines[i] += v
                                top.push(baselines[i])
                            } else {
                                top.push(v)
                            }
                        }
                        ctx.beginPath()
                        ctx.moveTo(X(0, n), Y(top[0]))
                        for (i = 1; i < n; ++i)
                            ctx.lineTo(X(i, n), Y(top[i]))
                        if (root.stacked) {
                            for (i = n - 1; i >= 0; --i)
                                ctx.lineTo(X(i, n), Y(baselines[i] - ChartUtils.asNumber(ptsS[i])))
                        } else {
                            ctx.lineTo(X(n - 1, n), padT + plotH)
                            ctx.lineTo(X(0, n), padT + plotH)
                        }
                        ctx.closePath()
                        var grad = ctx.createLinearGradient(0, padT, 0, padT + plotH)
                        grad.addColorStop(0, ChartUtils.withAlpha(color, Theme.dark ? 0.42 : 0.3))
                        grad.addColorStop(1, ChartUtils.withAlpha(color, 0.04))
                        ctx.fillStyle = grad
                        ctx.fill()
                        ctx.beginPath()
                        ctx.moveTo(X(0, n), Y(top[0]))
                        for (i = 1; i < n; ++i)
                            ctx.lineTo(X(i, n), Y(top[i]))
                        ctx.strokeStyle = color
                        ctx.lineWidth = 2
                        ctx.lineJoin = "round"
                        ctx.stroke()
                    }
                    ctx.restore()
                }
            }

            Rectangle {
                visible: root.hoverIndex >= 0
                x: root.hoverLineX
                y: canvas.plotT
                width: 1
                height: canvas.plotH
                color: Theme.strokeDivider
            }
            Repeater {
                model: root.hoverMarkers
                Rectangle {
                    required property var modelData
                    width: 9
                    height: 9
                    radius: 4.5
                    x: root.hoverLineX - width / 2
                    y: modelData.y - height / 2
                    color: Theme.bgCard
                    border.width: 2
                    border.color: modelData.color
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: (mouse) => {
                    var sampled = canvas.sampled
                    if (!sampled || !sampled.length || !sampled[0].length) {
                        root.hoverIndex = -1
                        root.hoverText = ""
                        root.hoverMarkers = []
                        return
                    }
                    var n = sampled[0].length
                    var t = (mouse.x - canvas.plotL) / Math.max(1, canvas.plotW)
                    var idx = Math.round(Math.max(0, Math.min(1, t)) * (n - 1))
                    var lo = canvas.lo
                    var hi = canvas.hi
                    var span = Math.max(1e-9, hi - lo)
                    root.hoverIndex = idx
                    root.hoverLineX = canvas.plotL + (idx / Math.max(1, n - 1)) * canvas.plotW
                    var lines = []
                    var markers = []
                    var list = root._seriesList
                    for (var s = 0; s < sampled.length; ++s) {
                        if (idx >= sampled[s].length)
                            continue
                        var v = sampled[s][idx]
                        var py
                        if (root.stacked) {
                            var acc = 0
                            for (var ss = 0; ss <= s; ++ss)
                                acc += ChartUtils.asNumber(sampled[ss][Math.min(idx, sampled[ss].length - 1)])
                            py = canvas.plotT + canvas.plotH - ((acc - lo) / span) * canvas.plotH
                        } else {
                            py = canvas.plotT + canvas.plotH - ((v - lo) / span) * canvas.plotH
                        }
                        lines.push((list[s].name || ("#" + (s + 1))) + ": "
                                   + ChartUtils.formatNumber(v))
                        markers.push({
                            y: py,
                            color: list[s].color || ChartUtils.palette(Theme, s)
                        })
                    }
                    root.hoverText = lines.join("\n")
                    root.hoverMarkers = markers
                }
                onExited: {
                    root.hoverIndex = -1
                    root.hoverText = ""
                    root.hoverMarkers = []
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
        }

        ChartLegend {
            visible: root.showLegend && root._legendItems.length > 0
            Layout.fillWidth: true
            items: root._legendItems
            showValue: false
            interactive: false
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}
