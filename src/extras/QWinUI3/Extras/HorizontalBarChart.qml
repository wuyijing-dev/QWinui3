import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// HorizontalBarChart — Horizontal bar chart.
//
//   HorizontalBarChart { values: [3, 5, 2] }

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
    // Show item labels
    property bool showLabels: true
    // Show value labels on bars
    property bool showValueLabels: true
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
    implicitHeight: title.length ? 220 : 200
    padding: 8

    // True when there is no data
    readonly property bool isEmpty: _bars.length === 0

    readonly property var _bars: {
        if (bars && bars.length)
            return bars
        var vals = ChartUtils.flattenValues(values)
        var out = []
        for (var i = 0; i < vals.length; ++i)
            out.push({ value: vals[i], color: ChartUtils.palette(Theme, i), label: String(i + 1) })
        return out
    }

    Behavior on revealProgress {
        enabled: root.animated && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }

    function playReveal() {
        if (!root.animated || Theme.reducedMotion) {
            revealProgress = 1
            requestRedraw()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    function requestRedraw() { canvas.requestPaint() }
    onValuesChanged: Qt.callLater(playReveal)
    onBarsChanged: Qt.callLater(playReveal)
    onMinimumChanged: requestRedraw()
    onMaximumChanged: requestRedraw()
    onShowLabelsChanged: requestRedraw()
    onShowValueLabelsChanged: requestRedraw()
    onRevealProgressChanged: requestRedraw()
    onHoverIndexChanged: requestRedraw()
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
                // Top padding
                property real padT: 2
                // Label column width
                property real labelW: 0

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

                var labelW = root.showLabels ? 64 : 0
                var padT = 2, padB = 2, padL = labelW + 4, padR = root.showValueLabels ? 36 : 8
                var plotH = h - padT - padB
                var plotW = w - padL - padR
                var n = list.length
                var slot = plotH / n
                var gap = slot * root.barGap
                var bh = Math.max(1, slot - gap)
                var reveal = Math.max(0, Math.min(1, root.revealProgress))
                canvas.slot = slot
                canvas.padT = padT
                canvas.labelW = labelW

                if (root.showBaseline) {
                    var zeroX = padL + ((0 - lo) / span) * plotW
                    zeroX = Math.max(padL, Math.min(padL + plotW, zeroX))
                    ctx.strokeStyle = Theme.strokeDivider
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(zeroX, padT)
                    ctx.lineTo(zeroX, padT + plotH)
                    ctx.stroke()
                }

                ctx.font = Theme.fontCaption + "px \"" + Theme.fontFamily + "\""
                ctx.textBaseline = "middle"

                for (i = 0; i < n; ++i) {
                    var v = vals[i]
                    var y = padT + i * slot + gap * 0.5
                    var x0 = padL + ((0 - lo) / span) * plotW
                    var x1 = padL + ((v * reveal - lo) / span) * plotW
                    var left = Math.min(x0, x1)
                    var right = Math.max(x0, x1)
                    var bw = Math.max(1, right - left)
                    var baseColor = list[i].color || ChartUtils.palette(Theme, i)
                    var hovered = root.hoverIndex === i
                    var color = hovered ? baseColor : ChartUtils.withAlpha(baseColor, 0.88)
                    var r = Math.min(root.barRadius, bh * 0.5, bw)

                    if (hovered) {
                        ctx.fillStyle = Theme.fillSubtleSecondary
                        ctx.fillRect(0, y - gap * 0.25, w, bh + gap * 0.5)
                    }

                    var grad = ctx.createLinearGradient(left, y, left + bw, y)
                    grad.addColorStop(0, color)
                    grad.addColorStop(1, ChartUtils.withAlpha(baseColor, Theme.dark ? 0.7 : 0.8))
                    ctx.fillStyle = grad
                    ctx.beginPath()
                    ctx.moveTo(left, y + r)
                    ctx.lineTo(left, y + bh - r)
                    ctx.quadraticCurveTo(left, y + bh, left + r, y + bh)
                    ctx.lineTo(left + bw, y + bh)
                    ctx.lineTo(left + bw, y)
                    ctx.lineTo(left + r, y)
                    ctx.quadraticCurveTo(left, y, left, y + r)
                    ctx.closePath()
                    ctx.fill()

                    if (root.showLabels) {
                        ctx.fillStyle = hovered ? Theme.textPrimary : Theme.textSecondary
                        ctx.textAlign = "right"
                        ctx.fillText(list[i].label || ("#" + (i + 1)), padL - 8, y + bh * 0.5)
                    }
                    if (root.showValueLabels || hovered) {
                        ctx.fillStyle = Theme.textSecondary
                        ctx.textAlign = "left"
                        var label = String(Math.round(v * 10) / 10)
                        if (root.valueUnit.length)
                            label += root.valueUnit
                        ctx.fillText(label, left + bw + 6, y + bh * 0.5)
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
                    var idx = Math.floor((mouse.y - canvas.padT) / canvas.slot)
                    root.hoverIndex = (idx >= 0 && idx < root._bars.length) ? idx : -1
                }
                onExited: root.hoverIndex = -1
                onClicked: {
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
