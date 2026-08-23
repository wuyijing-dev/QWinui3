import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// PieChart — Pie chart with legend.
//
//   PieChart {
//       id: pieChart
//       slices: [{ value: 1, label: "A"
//   }] }
//
//   // --- API ---
//   // signals: onSliceClicked
//   // methods: playReveal(), requestRedraw()
//   // pieChart.playReveal()
//   // pieChart.requestRedraw()
//
// @notes
//   Prefer slices: [{ value, label?, color? }]. Convenience values: number[] (or objects)
//   builds the same shape when slices is empty. interactive / isInteractive aliases.
//   showLegend for ChartLegend.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Pie chart")

    // Pie/donut slice descriptors
    property var slices: []
    // Convenience values when slices is empty (number[] or { value, label?, color? }[])
    property var values: []
    // Show chart legend
    property bool showLegend: true
    // Enable hover / click interaction
    property bool interactive: true
    // Alias of interactive (gauge / KPI naming parity)
    property alias isInteractive: root.interactive
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

    readonly property var _slices: {
        if (slices && slices.length)
            return slices
        var vals = values || []
        var out = []
        for (var i = 0; i < vals.length; ++i) {
            var it = vals[i]
            if (typeof it === "number") {
                out.push({ value: it, label: String(i + 1), color: ChartUtils.palette(Theme, i) })
            } else if (it && typeof it === "object") {
                out.push({
                    value: ChartUtils.asNumber(it.value !== undefined ? it.value : it),
                    label: it.label || String(i + 1),
                    color: it.color || ChartUtils.palette(Theme, i)
                })
            }
        }
        return out
    }

    // True when there is no data
    readonly property bool isEmpty: !_slices.length || total <= 0

    // Sum of segment values
    readonly property real total: {
        var s = 0
        var list = _slices
        for (var i = 0; i < list.length; ++i)
            s += Math.max(0, ChartUtils.asNumber(list[i].value))
        return s
    }

    readonly property var _legendItems: {
        var list = _slices
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

    readonly property int _sliceCount: _slices.length

    Behavior on revealProgress {
        enabled: ChartUtils.shouldAnimateReveal(_sliceCount, root.animated)
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
        if (!ChartUtils.shouldAnimateReveal(_sliceCount, root.animated)) {
            revealProgress = 1
            requestRedraw()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    // Request chart / canvas redraw
    function requestRedraw() { redrawCoalesce.restart() }
    onSlicesChanged: { hoverIndex = -1; Qt.callLater(playReveal) }
    onValuesChanged: { hoverIndex = -1; Qt.callLater(playReveal) }
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
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            elide: Text.ElideRight
        }

        Text {
            visible: root.isEmpty
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.emptyText
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }

        RowLayout {
            id: chartRow
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacingLoose
            visible: !root.isEmpty

            Item {
                id: plot
                readonly property real side: Math.max(64,
                    Math.min(chartRow.height,
                             chartRow.width * (root.showLegend ? 0.52 : 1)))
                Layout.preferredWidth: side
                Layout.preferredHeight: side
                Layout.minimumWidth: 64
                Layout.minimumHeight: 64
                Layout.alignment: Qt.AlignVCenter

                onSideChanged: root.requestRedraw()

                Canvas {
                    id: canvas
                    anchors.fill: parent
                    antialiasing: true
                    renderStrategy: Canvas.Immediate
                    // Center X
                    property real cx: 0
                    // Center Y
                    property real cy: 0
                    // Corner radius
                    property real radius: 0
                    // Arc path descriptors
                    property var arcs: []

                    onWidthChanged: if (width > 8 && height > 8) root.requestRedraw()
                    onHeightChanged: if (width > 8 && height > 8) root.requestRedraw()

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        var w = width
                        var h = height
                        var list = root._slices
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
                                              ChartUtils.asNumber(root._slices[root.hoverIndex].value))
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
                            var v = ChartUtils.asNumber(root._slices[root.hoverIndex].value)
                            return (root.total > 0 ? Math.round(v / root.total * 100) : 0) + "%"
                        }
                        font.pixelSize: Theme.fontSubtitle
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                        style: Text.Outline
                        styleColor: Theme.bgCard
                    }
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: root.hoverIndex >= 0 ? (root._slices[root.hoverIndex].label || "") : ""
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                        style: Text.Outline
                        styleColor: Theme.bgCard
                        elide: Text.ElideRight
                    }
                }
            }

            Column {
                visible: root.showLegend
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 6

                Text {
                    width: parent.width
                    text: qsTr("Legend")
                    font.pixelSize: Theme.fontCaption
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textSecondary
                }

                Repeater {
                    model: root._slices
                    Rectangle {
                        required property var modelData
                        required property int index
                        width: parent.width
                        height: 28
                        radius: Theme.cornerControl
                        color: root.hoverIndex === index ? Theme.fillSubtleSecondary : "transparent"
                        Behavior on color {
                            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 6
                            anchors.rightMargin: 6
                            spacing: 8
                            Rectangle {
                                width: 10
                                height: 10
                                radius: 2
                                anchors.verticalCenter: parent.verticalCenter
                                color: modelData.color || ChartUtils.palette(Theme, index)
                                scale: root.hoverIndex === index ? 1.15 : 1
                                Behavior on scale {
                                    enabled: !Theme.reducedMotion
                                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                                }
                            }
                            Text {
                                width: Math.max(40, parent.width - 18)
                                anchors.verticalCenter: parent.verticalCenter
                                text: {
                                    var label = modelData.label || ("#" + (index + 1))
                                    var v = ChartUtils.asNumber(modelData.value)
                                    var pct = root.total > 0 ? Math.round(v / root.total * 100) : 0
                                    return label + "  " + pct + "%"
                                }
                                font.pixelSize: Theme.fontCaption
                                font.weight: root.hoverIndex === index ? Theme.fontWeightSemiBold
                                                                       : Theme.fontWeightRegular
                                color: root.hoverIndex === index ? Theme.textPrimary : Theme.textSecondary
                                elide: Text.ElideRight
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: root.interactive
                            enabled: root.interactive
                            onEntered: root.hoverIndex = index
                            onExited: if (root.hoverIndex === index) root.hoverIndex = -1
                            onClicked: root.sliceClicked(index, ChartUtils.asNumber(modelData.value))
                        }
                    }
                }
            }
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
