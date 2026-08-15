import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// RadarChart — Radar / spider chart.
//
//   RadarChart { values: [3, 5, 2, 4]; axes: ["A","B","C","D"] }

T.Control {
    id: root

    // Chart series array
    property var series: []
    // Numeric values array
    property var values: []
    // Axis labels
    property var axes: []
    // Minimum value
    property real minimum: 0
    // Maximum value
    property real maximum: NaN
    // Levels
    property int levels: 4
    // Fill under line / area
    property bool filled: true
    // Show item labels
    property bool showLabels: true
    // Play enter / reveal animation
    property bool animated: true
    // Enable hover / click interaction
    property bool interactive: true
    // 0..1 reveal animation progress
    property real revealProgress: 1
    // Hovered series index
    property int hoverSeries: -1
    // Selected index alias
    property alias selectedIndex: root.hoverSeries
    // Primary title text
    property string title: ""
    // Placeholder when there is no data
    property string emptyText: qsTr("No data")

    implicitWidth: 260
    implicitHeight: title.length ? 260 : 240
    padding: 12

    // True when there is no data
    readonly property bool isEmpty: _seriesList.length === 0 || _axisCount < 3

    readonly property var _seriesList: {
        if (series && series.length)
            return series
        if (values && values.length)
            return [{ name: qsTr("Series"), values: values, color: Theme.accent }]
        return []
    }

    readonly property int _axisCount: {
        var n = 0
        var list = root._seriesList
        for (var i = 0; i < list.length; ++i)
            n = Math.max(n, (list[i].values && list[i].values.length) ? list[i].values.length : 0)
        if (axes && axes.length)
            n = Math.max(n, axes.length)
        return n
    }

    Behavior on revealProgress {
        enabled: root.animated && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }

    // Play Reveal
    function playReveal() {
        if (!root.animated || Theme.reducedMotion) {
            revealProgress = 1
            requestRedraw()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    // Request Redraw
    function requestRedraw() { canvas.requestPaint() }

    // Clear Hover
    function clearHover() {
        hoverSeries = -1
        requestRedraw()
    }

    onSeriesChanged: { hoverSeries = -1; Qt.callLater(playReveal) }
    onValuesChanged: { hoverSeries = -1; Qt.callLater(playReveal) }
    onAxesChanged: requestRedraw()
    onRevealProgressChanged: requestRedraw()
    onHoverSeriesChanged: requestRedraw()
    onFilledChanged: requestRedraw()
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
            anchors.bottomMargin: root._seriesList.length > 0 && !root.isEmpty ? 22 : 0
            visible: !root.isEmpty
            antialiasing: true
            renderStrategy: Canvas.Cooperative

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var n = root._axisCount
                var list = root._seriesList
                if (n < 3 || width < 8 || height < 8)
                    return

                var cx = width * 0.5
                var cy = height * 0.5
                var labelPad = root.showLabels ? 22 : 8
                var radius = Math.min(width, height) * 0.5 - labelPad
                var reveal = Math.max(0, Math.min(1, root.revealProgress))

                var all = []
                for (var s = 0; s < list.length; ++s)
                    all = all.concat(ChartUtils.flattenValues(list[s].values))
                var ext = ChartUtils.extents(all)
                var lo = isFinite(root.minimum) ? root.minimum : Math.min(0, ext.min)
                var hi = isFinite(root.maximum) ? root.maximum : ext.max
                if (hi <= lo)
                    hi = lo + 1
                var span = hi - lo

                function point(i, norm) {
                    var ang = -Math.PI / 2 + (i / n) * Math.PI * 2
                    var rr = radius * Math.max(0, Math.min(1, norm)) * reveal
                    return { x: cx + Math.cos(ang) * rr, y: cy + Math.sin(ang) * rr }
                }

                // Grid rings
                ctx.strokeStyle = Theme.strokeDivider
                ctx.lineWidth = 1
                for (var lv = 1; lv <= root.levels; ++lv) {
                    var t = lv / root.levels
                    ctx.beginPath()
                    for (var i = 0; i < n; ++i) {
                        var p = point(i, t)
                        if (i === 0)
                            ctx.moveTo(p.x, p.y)
                        else
                            ctx.lineTo(p.x, p.y)
                    }
                    ctx.closePath()
                    ctx.stroke()
                }

                // Spokes
                for (i = 0; i < n; ++i) {
                    var tip = point(i, 1)
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(tip.x, tip.y)
                    ctx.stroke()
                }

                // Series
                for (s = 0; s < list.length; ++s) {
                    var vals = ChartUtils.flattenValues(list[s].values)
                    if (vals.length < 3)
                        continue
                    var color = list[s].color || ChartUtils.palette(Theme, s)
                    var active = root.hoverSeries < 0 || root.hoverSeries === s
                    ctx.globalAlpha = active ? 1 : 0.28
                    ctx.beginPath()
                    for (i = 0; i < n; ++i) {
                        var v = ChartUtils.asNumber(vals[i % vals.length])
                        var pt = point(i, (v - lo) / span)
                        if (i === 0)
                            ctx.moveTo(pt.x, pt.y)
                        else
                            ctx.lineTo(pt.x, pt.y)
                    }
                    ctx.closePath()
                    if (root.filled) {
                        ctx.fillStyle = ChartUtils.withAlpha(color, Theme.dark ? 0.28 : 0.18)
                        ctx.fill()
                    }
                    ctx.strokeStyle = color
                    ctx.lineWidth = active ? 2.5 : 1.5
                    ctx.lineJoin = "round"
                    ctx.stroke()

                    // Vertices
                    for (i = 0; i < n; ++i) {
                        v = ChartUtils.asNumber(vals[i % vals.length])
                        pt = point(i, (v - lo) / span)
                        ctx.beginPath()
                        ctx.arc(pt.x, pt.y, active ? 3.5 : 2.5, 0, Math.PI * 2)
                        ctx.fillStyle = color
                        ctx.fill()
                    }
                }
                ctx.globalAlpha = 1

                if (root.showLabels) {
                    ctx.fillStyle = Theme.textSecondary
                    ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                    ctx.textBaseline = "middle"
                    for (i = 0; i < n; ++i) {
                        var ang = -Math.PI / 2 + (i / n) * Math.PI * 2
                        var lx = cx + Math.cos(ang) * (radius + 14)
                        var ly = cy + Math.sin(ang) * (radius + 14)
                        var label = (root.axes && root.axes[i]) ? root.axes[i] : String(i + 1)
                        ctx.textAlign = Math.cos(ang) > 0.2 ? "left"
                                      : Math.cos(ang) < -0.2 ? "right" : "center"
                        ctx.fillText(label, lx, ly)
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            visible: !root.isEmpty
            hoverEnabled: root.interactive
            enabled: root.interactive && root._seriesList.length > 1
            onPositionChanged: (mouse) => {
                // Nearest series by average distance of vertices — lightweight pick
                var list = root._seriesList
                if (list.length < 2) {
                    root.hoverSeries = -1
                    return
                }
                var n = root._axisCount
                var cx = width * 0.5
                var cy = height * 0.5
                var best = -1
                var bestDist = 1e9
                for (var s = 0; s < list.length; ++s) {
                    var vals = ChartUtils.flattenValues(list[s].values)
                    var sum = 0
                    for (var i = 0; i < n; ++i)
                        sum += ChartUtils.asNumber(vals[i % vals.length])
                    var avg = sum / n
                    // Map pointer radius vs series average magnitude as soft pick
                    var dx = mouse.x - cx
                    var dy = mouse.y - cy
                    var dist = Math.abs(Math.sqrt(dx * dx + dy * dy) - avg)
                    if (dist < bestDist) {
                        bestDist = dist
                        best = s
                    }
                }
                root.hoverSeries = best
            }
            onExited: root.clearHover()
        }

        Flow {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: 10
            visible: !root.isEmpty && root._seriesList.length > 0
            Repeater {
                model: root._seriesList
                Row {
                    required property var modelData
                    required property int index
                    spacing: 5
                    opacity: root.hoverSeries < 0 || root.hoverSeries === index ? 1 : 0.45
                    Behavior on opacity {
                        enabled: !Theme.reducedMotion
                        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                    Rectangle {
                        width: 8
                        height: 8
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
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: root.hoverSeries = index
                        onExited: if (root.hoverSeries === index) root.hoverSeries = -1
                    }
                }
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
