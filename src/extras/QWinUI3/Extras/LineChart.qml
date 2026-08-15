import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// LineChart — Multi-series line/area chart.
//
//   LineChart { values: [1, 4, 2, 6] }

T.Control {
    id: root

    // Chart series array
    property var series: []
    // Numeric values array
    property var values: []
    // Minimum value
    property real minimum: NaN
    // Maximum value
    property real maximum: NaN
    property bool showGrid: true
    property bool showArea: true
    // Show chart legend
    property bool showLegend: true
    property bool interactive: true
    property bool animated: true
    property int maxPoints: 0
    property real lodFactor: 2
    property bool autoLod: true
    property real strokeWidth: 2
    property color gridColor: Theme.strokeDivider

    property real revealProgress: 1
    // Hovered item index
    property int hoverIndex: -1
    property real hoverX: 0
    property real hoverY: 0
    property real hoverLineX: 0
    property var hoverMarkers: [] // [{ y, color }]
    property string hoverText: ""
    // Primary title text
    property string title: ""
    property string emptyText: qsTr("No data")

    // LOD diagnostics
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
            return [{ name: qsTr("Series"), values: values, color: Theme.accent, filled: root.showArea }]
        return []
    }

    Behavior on revealProgress {
        enabled: root.animated && !Theme.reducedMotion && root.sourcePointCountEstimate() < ChartUtils.largeSeriesThreshold
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }

    function playReveal() {
        invalidateLod()
        var huge = root.sourcePointCountEstimate() >= ChartUtils.largeSeriesThreshold
        if (!root.animated || Theme.reducedMotion || huge) {
            // Assign without Behavior: force full series visible immediately.
            revealProgress = 1
            requestRedraw()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    function sourcePointCountEstimate() {
        var list = root._seriesList
        var n = 0
        for (var i = 0; i < list.length; ++i)
            n = Math.max(n, ChartUtils.valueCount(list[i].values))
        return n
    }

    function invalidateLod() {
        _lodKey = ""
        _lodPacks = []
    }

    function ensureLod(budget) {
        var list = root._seriesList
        var key = String(budget)
        for (var s = 0; s < list.length; ++s)
            key += "|" + ChartUtils.valueCount(list[s].values)
        // Soft reuse when resize only nudges budget (±15%)
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

    function requestRedraw() { canvas.requestPaint() }

    onSeriesChanged: { hoverIndex = -1; invalidateLod(); Qt.callLater(playReveal) }
    onValuesChanged: { hoverIndex = -1; invalidateLod(); Qt.callLater(playReveal) }
    onMaxPointsChanged: { invalidateLod(); requestRedraw() }
    onLodFactorChanged: { invalidateLod(); requestRedraw() }
    onMinimumChanged: requestRedraw()
    onMaximumChanged: requestRedraw()
    onShowGridChanged: requestRedraw()
    onShowAreaChanged: requestRedraw()
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

    function clearHover() {
        hoverIndex = -1
        hoverText = ""
        hoverMarkers = []
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

                // Cache last paint metrics for hover hit-testing
                property real plotL: 4
                property real plotT: 6
                property real plotW: 1
                property real plotH: 1
                property var sampled: []
                property real lo: 0
                property real hi: 1

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

                    var padL = 4
                    var padR = 4
                    var padT = 6
                    var padB = 6
                    var plotW = w - padL - padR
                    var plotH = h - padT - padB
                    var budget = root.autoLod
                                 ? ChartUtils.lodBudget(plotW, root.maxPoints, root.lodFactor)
                                 : (root.maxPoints > 0 ? root.maxPoints : Math.max(48, Math.floor(plotW)))
                    var packs = root.ensureLod(budget)
                    var sampled = []
                    for (var s = 0; s < packs.length; ++s)
                        sampled.push(packs[s].values)
                    if (!sampled.length || !sampled[0].length)
                        return

                    var lo = isFinite(root.minimum) ? root.minimum : root._lodMin
                    var hi = isFinite(root.maximum) ? root.maximum : root._lodMax
                    if (hi <= lo)
                        hi = lo + 1
                    var span = hi - lo
                    var reveal = (!root.animated || root.sourcePointCount >= ChartUtils.largeSeriesThreshold)
                                 ? 1 : Math.max(0, Math.min(1, root.revealProgress))

                    canvas.plotL = padL
                    canvas.plotT = padT
                    canvas.plotW = plotW
                    canvas.plotH = plotH
                    canvas.lo = lo
                    canvas.hi = hi
                    canvas.sampled = sampled

                    if (root.showGrid) {
                        ctx.strokeStyle = root.gridColor
                        ctx.lineWidth = 1
                        ctx.globalAlpha = Theme.dark ? 0.4 : 0.5
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
                    if (reveal < 0.999) {
                        ctx.beginPath()
                        ctx.rect(padL, padT - 2, plotW * reveal, plotH + 4)
                        ctx.clip()
                    }

                    for (s = 0; s < list.length; ++s) {
                        var ser = list[s]
                        var pts = sampled[s]
                        if (!pts || pts.length < 2)
                            continue
                        var color = ser.color || ChartUtils.palette(Theme, s)
                        var filled = ser.filled !== undefined ? !!ser.filled : root.showArea

                        function X(i) {
                            return padL + (i / (pts.length - 1)) * plotW
                        }
                        function Y(v) {
                            return padT + plotH - ((v - lo) / span) * plotH
                        }

                        if (filled) {
                            ctx.beginPath()
                            ctx.moveTo(X(0), Y(pts[0]))
                            for (var i = 1; i < pts.length; ++i)
                                ctx.lineTo(X(i), Y(pts[i]))
                            ctx.lineTo(X(pts.length - 1), padT + plotH)
                            ctx.lineTo(X(0), padT + plotH)
                            ctx.closePath()
                            var grad = ctx.createLinearGradient(0, padT, 0, padT + plotH)
                            grad.addColorStop(0, ChartUtils.withAlpha(color, Theme.dark ? 0.32 : 0.22))
                            grad.addColorStop(1, ChartUtils.withAlpha(color, 0.02))
                            ctx.fillStyle = grad
                            ctx.fill()
                        }

                        ctx.lineWidth = root.strokeWidth
                        ctx.lineJoin = "round"
                        ctx.lineCap = "round"
                        ctx.strokeStyle = color
                        ctx.beginPath()
                        ctx.moveTo(X(0), Y(pts[0]))
                        for (i = 1; i < pts.length; ++i)
                            ctx.lineTo(X(i), Y(pts[i]))
                        ctx.stroke()
                    }
                    ctx.restore()
                    // Hover crosshair is a QML overlay — never paint it here (keeps mouse move cheap).
                }
            }

            // Crosshair + markers (no Canvas repaint on hover)
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
                id: mouse
                anchors.fill: parent
                hoverEnabled: root.interactive
                enabled: root.interactive
                acceptedButtons: Qt.NoButton
                onPositionChanged: (mouse) => root._updateHover(mouse.x, mouse.y)
                onExited: root.clearHover()
            }

            // Hover tooltip card
            Rectangle {
                id: tip
                visible: root.hoverIndex >= 0 && root.hoverText.length > 0
                x: Math.min(parent.width - width - 4, Math.max(4, root.hoverX + 12))
                y: Math.max(4, root.hoverY - height - 8)
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

        Flow {
            visible: root.showLegend && root._seriesList.length > 0
            Layout.fillWidth: true
            spacing: 12
            Repeater {
                model: root._seriesList
                Row {
                    required property var modelData
                    required property int index
                    spacing: 6
                    Rectangle {
                        width: 10
                        height: 10
                        radius: 2
                        anchors.verticalCenter: parent.verticalCenter
                        color: modelData.color || ChartUtils.palette(Theme, index)
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.name || (qsTr("Series") + " " + (index + 1))
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                    }
                }
            }
        }
    }

    function _updateHover(mx, my) {
        var sampled = canvas.sampled
        if (!sampled || !sampled.length || !sampled[0].length) {
            clearHover()
            return
        }
        var n = sampled[0].length
        var t = (mx - canvas.plotL) / Math.max(1, canvas.plotW)
        var idx = Math.round(Math.max(0, Math.min(1, t)) * (n - 1))
        var lo = canvas.lo
        var hi = canvas.hi
        var span = Math.max(1e-9, hi - lo)
        hoverIndex = idx
        hoverX = mx
        hoverY = my
        hoverLineX = canvas.plotL + (idx / Math.max(1, n - 1)) * canvas.plotW
        var lines = []
        var markers = []
        var list = root._seriesList
        for (var s = 0; s < sampled.length; ++s) {
            if (idx >= sampled[s].length)
                continue
            var name = list[s].name || ("#" + (s + 1))
            var v = sampled[s][idx]
            lines.push(name + ": " + (Math.round(v * 10) / 10))
            markers.push({
                y: canvas.plotT + canvas.plotH - ((v - lo) / span) * canvas.plotH,
                color: list[s].color || ChartUtils.palette(Theme, s)
            })
        }
        hoverText = lines.join("\n")
        hoverMarkers = markers
        // Intentionally no canvas.requestPaint() — overlay only.
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}
