import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// BarChart — Vertical bar chart with reveal animation.
//
//   BarChart { values: [4, 2, 7, 3] }

T.Control {
    id: root

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

    // Emitted when a bar is clicked
    signal barClicked(int index, real value)

    implicitWidth: 320
    implicitHeight: title.length ? 200 : 180
    padding: 8

    // True when there is no data
    readonly property bool isEmpty: _bars.length === 0

    readonly property var _bars: {
        if (bars && bars.length)
            return bars
        var vals = ChartUtils.flattenValues(values)
        var out = []
        for (var i = 0; i < vals.length; ++i)
            out.push({ value: vals[i], color: ChartUtils.palette(Theme, i) })
        return out
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

    onValuesChanged: Qt.callLater(playReveal)
    onBarsChanged: Qt.callLater(playReveal)
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
                // Gap between items
                property real gap: 0
                // Left padding
                property real padL: 2

                onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var w = width
                var h = height
                var list = root._bars
                if (w < 8 || h < 8 || !list.length)
                    return

                var vals = []
                for (var i = 0; i < list.length; ++i)
                    vals.push(ChartUtils.asNumber(list[i].value))
                var ext = ChartUtils.extents(vals)
                var lo = isFinite(root.minimum) ? root.minimum : Math.min(0, ext.min)
                var hi = isFinite(root.maximum) ? root.maximum : Math.max(0, ext.max)
                if (hi <= lo)
                    hi = lo + 1
                var span = hi - lo
                var padT = 10
                var padB = root.showValueLabels ? 4 : 4
                var padL = 2
                var padR = 2
                var plotH = h - padT - padB
                var plotW = w - padL - padR
                var n = list.length
                var slot = plotW / n
                var gap = slot * root.barGap
                var bw = Math.max(1, slot - gap)
                var reveal = Math.max(0, Math.min(1, root.revealProgress))
                canvas.slot = slot
                canvas.gap = gap
                canvas.padL = padL

                if (root.showBaseline) {
                    var zeroY = padT + plotH - ((0 - lo) / span) * plotH
                    zeroY = Math.max(padT, Math.min(padT + plotH, zeroY))
                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(padL, zeroY)
                    ctx.lineTo(padL + plotW, zeroY)
                    ctx.stroke()
                }

                ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                ctx.textAlign = "center"
                ctx.textBaseline = "bottom"

                for (i = 0; i < n; ++i) {
                    var v = vals[i]
                    var x = padL + i * slot + gap * 0.5
                    var y0 = padT + plotH - ((0 - lo) / span) * plotH
                    var y1 = padT + plotH - ((v * reveal - lo) / span) * plotH
                    var top = Math.min(y0, y1)
                    var bot = Math.max(y0, y1)
                    var bh = Math.max(1, bot - top)
                    var baseColor = list[i].color || ChartUtils.palette(Theme, i)
                    var hovered = root.hoverIndex === i
                    var color = hovered ? baseColor : ChartUtils.withAlpha(baseColor, hovered ? 1 : 0.92)
                    if (hovered)
                        color = baseColor
                    else
                        color = ChartUtils.withAlpha(baseColor, 0.88)

                    var r = Math.min(root.barRadius, bw * 0.5, bh)
                    var grad = ctx.createLinearGradient(x, top, x, bot)
                    grad.addColorStop(0, color)
                    grad.addColorStop(1, ChartUtils.withAlpha(baseColor, Theme.dark ? 0.65 : 0.75))
                    ctx.fillStyle = hovered ? color : grad

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

                    if (hovered || root.showValueLabels) {
                        ctx.fillStyle = Theme.textSecondary
                        var label = String(Math.round(v * 10) / 10)
                        if (root.valueUnit.length)
                            label += root.valueUnit
                        ctx.fillText(label, x + bw * 0.5, top - 2)
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
                    var list = root._bars
                    if (!list.length) {
                        root.hoverIndex = -1
                        return
                    }
                    var idx = Math.floor((mouse.x - canvas.padL) / canvas.slot)
                    root.hoverIndex = (idx >= 0 && idx < list.length) ? idx : -1
                }
                onExited: root.hoverIndex = -1
                onClicked: (mouse) => {
                    if (root.hoverIndex >= 0)
                        root.barClicked(root.hoverIndex, ChartUtils.asNumber(root._bars[root.hoverIndex].value))
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
