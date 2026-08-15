import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// PieChart — Pie chart with legend.
//
//   PieChart { slices: [{ value: 1, label: "A" }] }

T.Control {
    id: root

    // Pie/donut slice descriptors
    property var slices: []
    // Show chart legend
    property bool showLegend: true
    // Enable hover / click interaction
    property bool interactive: true
    // Play enter / reveal animation
    property bool animated: true
    // Arc start angle in degrees
    property real startAngle: -Math.PI / 2
    // Padding angle between pie slices
    property real padAngle: 0.02
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

    // Emitted when a slice is clicked
    signal sliceClicked(int index, real value)

    implicitWidth: showLegend ? 300 : 168
    implicitHeight: title.length ? 188 : 168
    padding: 8

    // True when there is no data
    readonly property bool isEmpty: !slices || slices.length === 0 || total <= 0

    // Sum of segment values
    readonly property real total: {
        var s = 0
        var list = slices || []
        for (var i = 0; i < list.length; ++i)
            s += Math.max(0, ChartUtils.asNumber(list[i].value))
        return s
    }

    readonly property var _legendItems: {
        var list = slices || []
        var out = []
        for (var i = 0; i < list.length; ++i) {
            var v = ChartUtils.asNumber(list[i].value)
            var pct = total > 0 ? Math.round(v / total * 100) : 0
            out.push({
                label: list[i].label || ("#" + (i + 1)),
                color: list[i].color || ChartUtils.palette(Theme, i),
                secondary: pct + "%"
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
    onSlicesChanged: { hoverIndex = -1; Qt.callLater(playReveal) }
    onPadAngleChanged: requestRedraw()
    onStartAngleChanged: requestRedraw()
    onRevealProgressChanged: requestRedraw()
    onHoverIndexChanged: requestRedraw()
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

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacingLoose
            visible: !root.isEmpty

        Item {
            Layout.preferredWidth: Math.min(parent.height, parent.width * (root.showLegend ? 0.48 : 1))
            Layout.preferredHeight: Layout.preferredWidth
            Layout.alignment: Qt.AlignVCenter

            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true
                renderStrategy: Canvas.Cooperative
                // Center X
                property real cx: 0
                // Center Y
                property real cy: 0
                // Corner radius
                property real radius: 0
                // Arc path descriptors
                property var arcs: []

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var w = width
                    var h = height
                    var list = root.slices || []
                    if (w < 8 || h < 8 || !list.length)
                        return
                    var cx = w * 0.5
                    var cy = h * 0.5
                    var radius = Math.min(w, h) * 0.5 - 4
                    var sum = Math.max(1e-6, root.total)
                    var angle = root.startAngle
                    var pad = Math.max(0, root.padAngle)
                    var reveal = Math.max(0, Math.min(1, root.revealProgress))
                    var arcs = []

                    for (var i = 0; i < list.length; ++i) {
                        var v = Math.max(0, ChartUtils.asNumber(list[i].value))
                        var fullSweep = (v / sum) * Math.PI * 2
                        var sweep = fullSweep * reveal - pad
                        var start = angle
                        if (sweep > 0.001) {
                            var color = list[i].color || ChartUtils.palette(Theme, i)
                            var hovered = root.hoverIndex === i
                            var rad = radius + (hovered ? 4 : 0)
                            ctx.beginPath()
                            ctx.moveTo(cx, cy)
                            ctx.arc(cx, cy, rad, start + pad * 0.5, start + pad * 0.5 + sweep, false)
                            ctx.closePath()
                            ctx.fillStyle = color
                            ctx.globalAlpha = hovered || root.hoverIndex < 0 ? 1 : 0.4
                            ctx.fill()
                            ctx.globalAlpha = 1
                            if (hovered) {
                                ctx.lineWidth = 2
                                ctx.strokeStyle = Theme.bgCard
                                ctx.stroke()
                            }
                        }
                        arcs.push({ start: start, sweep: fullSweep, value: v })
                        angle += fullSweep
                    }
                    canvas.cx = cx
                    canvas.cy = cy
                    canvas.radius = radius
                    canvas.arcs = arcs
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: (mouse) => root._hitTest(mouse.x, mouse.y)
                onExited: root.hoverIndex = -1
                onClicked: {
                    if (root.hoverIndex >= 0)
                        root.sliceClicked(root.hoverIndex,
                                          ChartUtils.asNumber(root.slices[root.hoverIndex].value))
                }
            }

            // Center hover readout
            Column {
                anchors.centerIn: parent
                visible: root.hoverIndex >= 0
                spacing: 2
                width: parent.width * 0.4
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (root.hoverIndex < 0)
                            return ""
                        var v = ChartUtils.asNumber(root.slices[root.hoverIndex].value)
                        return (root.total > 0 ? Math.round(v / root.total * 100) : 0) + "%"
                    }
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSubtitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    style: Text.Outline
                    styleColor: Theme.bgCard
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: root.hoverIndex >= 0 ? (root.slices[root.hoverIndex].label || "") : ""
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    style: Text.Outline
                    styleColor: Theme.bgCard
                    elide: Text.ElideRight
                }
            }
        }

        ChartLegend {
            visible: root.showLegend
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignVCenter
            orientation: Qt.Vertical
            header: qsTr("Legend")
            items: root._legendItems
            showValue: false
            interactive: root.interactive
            hoverIndex: root.hoverIndex
            selectedIndex: root.selectedIndex
            onHoverIndexChanged: root.hoverIndex = hoverIndex
            onItemHovered: (index) => root.hoverIndex = index
            onItemClicked: (index) => {
                root.selectedIndex = index
                root.sliceClicked(index, ChartUtils.asNumber(root.slices[index].value))
            }
        }
        } // RowLayout

        Text {
            visible: root.isEmpty
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.emptyText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
    }

    function _hitTest(mx, my) {
        var arcs = canvas.arcs
        if (!arcs || !arcs.length) {
            hoverIndex = -1
            return
        }
        var dx = mx - canvas.cx
        var dy = my - canvas.cy
        var dist = Math.sqrt(dx * dx + dy * dy)
        if (dist > canvas.radius + 6) {
            hoverIndex = -1
            return
        }
        var ang = Math.atan2(dy, dx)
        var a = ang
        while (a < root.startAngle)
            a += Math.PI * 2
        while (a >= root.startAngle + Math.PI * 2)
            a -= Math.PI * 2
        for (var i = 0; i < arcs.length; ++i) {
            if (a >= arcs[i].start && a < arcs[i].start + arcs[i].sweep) {
                hoverIndex = i
                return
            }
        }
        hoverIndex = -1
    }

    background: Item {}
}
