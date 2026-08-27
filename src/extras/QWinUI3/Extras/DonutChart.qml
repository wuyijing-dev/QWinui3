import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// DonutChart — Donut chart with hover and legend.
//
//   DonutChart {
//       id: donutChart
//       slices: [{ value: 3, label: "A"
//   }] }
//
//   // --- API ---
//   // signals: onSliceClicked
//   // methods: playReveal(), requestRedraw()
//   // donutChart.playReveal()
//   // donutChart.requestRedraw()
//
// @notes
//   Prefer slices: [{ value, label?, color? }]. Convenience values: number[] when slices
//   is empty. Hollow center via thickness; centerText / centerSubText optional.
//   interactive / isInteractive aliases.

T.Control {
    id: root

    Accessible.role: Accessible.Graphic
    Accessible.name: root.title.length ? root.title : qsTr("Donut chart")

    // Pie/donut slice descriptors
    property var slices: []
    // Convenience values when slices is empty (number[] or { value, label?, color? }[])
    property var values: []
    // Donut ring thickness
    property real thickness: 14
    // Show center label in donut
    property bool showCenterLabel: true
    // Donut center primary text
    property string centerText: ""
    // Donut center secondary text
    property string centerSubText: ""
    // Show chart legend
    property bool showLegend: true
    // Legend placement: "right" (default) or "bottom" (2.65)
    property string legendPosition: "right"
    // Enable hover / click interaction
    property bool interactive: true
    // Alias of interactive (gauge / KPI naming parity)
    property alias isInteractive: root.interactive
    // Play enter / reveal animation
    property bool animated: true
    // Lerp slice values on updates (2.68 B4)
    property bool animateDataUpdates: true
    // Arc start angle in degrees
    property real startAngle: -Math.PI / 2
    // 0..1 reveal animation progress
    property real revealProgress: 1
    property real dataProgress: 1
    property var _displayValues: []
    property var _tweenFrom: []
    property var _tweenTo: []
    property bool _everRevealed: false
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
            s += root._sliceValue(i)
        return s
    }

    readonly property int _sliceCount: _slices.length

    Behavior on revealProgress {
        enabled: ChartUtils.shouldAnimateReveal(_sliceCount, root.animated)
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingEnter
        }
    }

    Behavior on dataProgress {
        enabled: ChartUtils.shouldAnimateDataUpdate(_sliceCount, root.animateDataUpdates)
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }

    Timer {
        id: redrawCoalesce
        interval: ChartUtils.redrawCoalesceMs
        repeat: false
        onTriggered: canvas.requestPaint()
    }

    function _targetFlatValues() {
        var list = root._slices
        var out = []
        for (var i = 0; i < list.length; ++i)
            out.push(Math.max(0, ChartUtils.asNumber(list[i].value)))
        return out
    }

    function _syncDisplayFromProgress() {
        var to = root._tweenTo || []
        if (!to.length) {
            root._displayValues = root._targetFlatValues()
            return
        }
        root._displayValues = ChartUtils.lerpValues(root._tweenFrom, to, root.dataProgress)
    }

    function _sliceValue(i) {
        if (root._displayValues && i >= 0 && i < root._displayValues.length)
            return Math.max(0, ChartUtils.asNumber(root._displayValues[i]))
        if (i >= 0 && i < root._slices.length)
            return Math.max(0, ChartUtils.asNumber(root._slices[i].value))
        return 0
    }

    function _handleDataChange() {
        hoverIndex = -1
        var target = root._targetFlatValues()
        if (!root._everRevealed) {
            root._displayValues = target
            root._tweenTo = target
            root._everRevealed = true
            playReveal()
            return
        }
        if (ChartUtils.shouldAnimateDataUpdate(target.length, root.animateDataUpdates)
                && root._displayValues && root._displayValues.length) {
            root._tweenFrom = root._displayValues.slice()
            root._tweenTo = target
            root.dataProgress = 0
            root.dataProgress = 1
        } else {
            root._displayValues = target
            root._tweenTo = target
            root.dataProgress = 1
            requestRedraw()
        }
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
    onSlicesChanged: Qt.callLater(_handleDataChange)
    onValuesChanged: Qt.callLater(_handleDataChange)
    onThicknessChanged: requestRedraw()
    onRevealProgressChanged: requestRedraw()
    onDataProgressChanged: { _syncDisplayFromProgress(); requestRedraw() }
    onHoverIndexChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()
    onStartAngleChanged: requestRedraw()
    Component.onCompleted: _handleDataChange()

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

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: root.legendPosition === "bottom" ? 1 : 2
            rowSpacing: Theme.spacingLoose
            columnSpacing: Theme.spacingLoose
            visible: !root.isEmpty

        Item {
            id: plot
            Layout.preferredWidth: Math.min(parent.height, parent.width * (root.showLegend && root.legendPosition !== "bottom" ? 0.48 : 1))
            Layout.preferredHeight: Layout.preferredWidth
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: root.legendPosition === "bottom" || !root.showLegend
            Layout.maximumWidth: root.legendPosition === "bottom" ? 220 : -1

            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true
                renderStrategy: Canvas.Cooperative
                // Center X
                property real cx: 0
                // Center Y
                property real cy: 0
                // Donut outer radius
                property real outer: 0
                // Donut inner radius
                property real inner: 0
                // Arc path descriptors
                property var arcs: []

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
                    var outer = Math.min(w, h) * 0.5 - 2
                    var inner = Math.max(0, outer - root.thickness)
                    var sum = Math.max(1e-6, root.total)
                    var angle = root.startAngle
                    var reveal = Math.max(0, Math.min(1, root.revealProgress))
                    var arcs = []

                    // Track ring
                    ctx.beginPath()
                    ctx.arc(cx, cy, (outer + inner) * 0.5, 0, Math.PI * 2)
                    ctx.lineWidth = Math.max(1, outer - inner)
                    ctx.strokeStyle = ChartUtils.withAlpha(Theme.strokeDivider, 0.55)
                    ctx.stroke()

                    for (var i = 0; i < list.length; ++i) {
                        var v = root._sliceValue(i)
                        var fullSweep = (v / sum) * Math.PI * 2
                        var sweep = fullSweep * reveal
                        var start = angle
                        if (sweep > 0.001) {
                            var color = list[i].color || ChartUtils.palette(Theme, i)
                            var hovered = root.hoverIndex === i
                            var o = outer + (hovered ? 3 : 0)
                            var inn = Math.max(0, inner - (hovered ? 1 : 0))
                            ctx.beginPath()
                            ctx.arc(cx, cy, o, start, start + sweep, false)
                            ctx.arc(cx, cy, inn, start + sweep, start, true)
                            ctx.closePath()
                            ctx.fillStyle = color
                            ctx.globalAlpha = hovered || root.hoverIndex < 0 ? 1 : 0.45
                            ctx.fill()
                            ctx.globalAlpha = 1
                        }
                        arcs.push({ start: start, sweep: fullSweep, value: v })
                        angle += fullSweep
                    }
                    canvas.cx = cx
                    canvas.cy = cy
                    canvas.outer = outer
                    canvas.inner = inner
                    canvas.arcs = arcs
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: root.interactive
                enabled: root.interactive
                onPositionChanged: (mouse) => root._hitTest(mouse.x, mouse.y)
                onExited: root.hoverIndex = -1
                onClicked: (mouse) => {
                    root._hitTest(mouse.x, mouse.y)
                    if (root.hoverIndex >= 0)
                        root.sliceClicked(root.hoverIndex,
                                          ChartUtils.asNumber(root._slices[root.hoverIndex].value))
                }
            }

            Column {
                anchors.centerIn: parent
                visible: root.showCenterLabel
                spacing: 2
                width: parent.width * 0.42
                opacity: 0.35 + 0.65 * root.revealProgress
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionNormal) }
                }

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (root.hoverIndex >= 0 && root._slices[root.hoverIndex]) {
                            var v = ChartUtils.asNumber(root._slices[root.hoverIndex].value)
                            var pct = root.total > 0 ? Math.round(v / root.total * 100) : 0
                            return pct + "%"
                        }
                        return root.centerText.length ? root.centerText
                               : (root.total > 0 ? Math.round(root.total) : "")
                    }
                    font.pixelSize: Theme.fontSubtitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    elide: Text.ElideRight
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (root.hoverIndex >= 0 && root._slices[root.hoverIndex])
                            return root._slices[root.hoverIndex].label || ""
                        return root.centerSubText
                    }
                    visible: text.length > 0
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    elide: Text.ElideRight
                }
            }
        }

        Column {
            visible: root.showLegend
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 6
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
                                NumberAnimation {
                                    duration: Theme.duration(Theme.motionFast)
                                    easing.type: Theme.easingStandard
                                }
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
                        onEntered: root.hoverIndex = index
                        onExited: if (root.hoverIndex === index) root.hoverIndex = -1
                        onClicked: root.sliceClicked(index, ChartUtils.asNumber(modelData.value))
                    }
                }
            }
        }
        } // GridLayout
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
        if (dist < canvas.inner || dist > canvas.outer + 4) {
            hoverIndex = -1
            return
        }
        var ang = Math.atan2(dy, dx)
        // Normalize to startAngle..startAngle+2π
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
