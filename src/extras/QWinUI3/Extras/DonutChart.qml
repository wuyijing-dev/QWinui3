import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Donut chart with reveal animation, hover emphasis, and legend.
// slices: [{ value, color?, label? }]
T.Control {
    id: root

    property var slices: []
    property real thickness: 14
    property bool showCenterLabel: true
    property string centerText: ""
    property string centerSubText: ""
    property bool showLegend: true
    property bool interactive: true
    property bool animated: true
    property real startAngle: -Math.PI / 2
    property real revealProgress: 1
    property int hoverIndex: -1
    property alias selectedIndex: root.hoverIndex
    property string title: ""
    property string emptyText: qsTr("No data")

    signal sliceClicked(int index, real value)

    implicitWidth: showLegend ? 300 : 168
    implicitHeight: title.length ? 188 : 168
    padding: 8

    readonly property bool isEmpty: !slices || slices.length === 0 || total <= 0

    readonly property real total: {
        var s = 0
        var list = slices || []
        for (var i = 0; i < list.length; ++i)
            s += Math.max(0, ChartUtils.asNumber(list[i].value))
        return s
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
    onSlicesChanged: { hoverIndex = -1; Qt.callLater(playReveal) }
    onThicknessChanged: requestRedraw()
    onRevealProgressChanged: requestRedraw()
    onHoverIndexChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()
    onStartAngleChanged: requestRedraw()
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

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacingLoose
            visible: !root.isEmpty

        Item {
            id: plot
            Layout.preferredWidth: Math.min(parent.height, parent.width * (root.showLegend ? 0.48 : 1))
            Layout.preferredHeight: Layout.preferredWidth
            Layout.alignment: Qt.AlignVCenter

            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true
                renderStrategy: Canvas.Cooperative
                property real cx: 0
                property real cy: 0
                property real outer: 0
                property real inner: 0
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
                        var v = Math.max(0, ChartUtils.asNumber(list[i].value))
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
                                          ChartUtils.asNumber(root.slices[root.hoverIndex].value))
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
                        if (root.hoverIndex >= 0 && root.slices && root.slices[root.hoverIndex]) {
                            var v = ChartUtils.asNumber(root.slices[root.hoverIndex].value)
                            var pct = root.total > 0 ? Math.round(v / root.total * 100) : 0
                            return pct + "%"
                        }
                        return root.centerText.length ? root.centerText
                               : (root.total > 0 ? Math.round(root.total) : "")
                    }
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSubtitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    elide: Text.ElideRight
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (root.hoverIndex >= 0 && root.slices && root.slices[root.hoverIndex])
                            return root.slices[root.hoverIndex].label || ""
                        return root.centerSubText
                    }
                    visible: text.length > 0
                    font.family: Theme.fontFamily
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
                model: root.slices
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
                            font.family: Theme.fontFamily
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
        } // RowLayout
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
