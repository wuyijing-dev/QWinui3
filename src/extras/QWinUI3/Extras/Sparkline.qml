import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Sparkline — Inline mini line chart.
//
//   Sparkline { values: [1, 3, 2, 5, 4] }

T.Control {
    id: root

    // Numeric values array
    property var values: []
    // Stroke color
    property color strokeColor: Theme.accent
    // Primary fill / progress color
    property color fillColor: ChartUtils.withAlpha(Theme.accent, Theme.dark ? 0.28 : 0.16)
    // Stroke thickness in px
    property real strokeWidth: 1.5
    // Fill under line / area
    property bool filled: true
    // Show end-point marker
    property bool showEndMarker: true
    // Play enter / reveal animation
    property bool animated: true
    // Minimum value
    property real minimum: NaN
    // Maximum value
    property real maximum: NaN
    // 0..1 reveal animation progress
    property real revealProgress: 1
    // Caption under / beside the value
    property string caption: ""
    // Show delta vs first point
    property bool showDelta: false

    implicitWidth: 120
    implicitHeight: caption.length || showDelta ? 44 : 28
    padding: 0
    Accessible.role: Accessible.Pane
    Accessible.name: caption.length ? caption : qsTr("Sparkline")
    Accessible.description: isFinite(delta) ? qsTr("Change %1").arg(delta) : ""

    // Last Value
    readonly property real lastValue: {
        var pts = ChartUtils.flattenValues(values)
        if (!pts.length)
            return NaN
        return Number(pts[pts.length - 1])
    }
    // First Value
    readonly property real firstValue: {
        var pts = ChartUtils.flattenValues(values)
        if (!pts.length)
            return NaN
        return Number(pts[0])
    }
    // Delta
    readonly property real delta: {
        if (!isFinite(lastValue) || !isFinite(firstValue))
            return NaN
        return lastValue - firstValue
    }
    // Delta Positive
    readonly property bool deltaPositive: isFinite(delta) && delta >= 0

    Behavior on revealProgress {
        enabled: root.animated && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }

    // Play Reveal
    function playReveal() {
        if (!root.animated || Theme.reducedMotion) {
            revealProgress = 1
            canvas.requestPaint()
            return
        }
        revealProgress = 0
        revealProgress = 1
    }

    onValuesChanged: Qt.callLater(playReveal)
    onStrokeColorChanged: canvas.requestPaint()
    onFillColorChanged: canvas.requestPaint()
    onFilledChanged: canvas.requestPaint()
    onShowEndMarkerChanged: canvas.requestPaint()
    onRevealProgressChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onMinimumChanged: canvas.requestPaint()
    onMaximumChanged: canvas.requestPaint()
    Component.onCompleted: playReveal()

    contentItem: Item {
        Text {
            id: captionLabel
            visible: root.caption.length > 0 || (root.showDelta && isFinite(root.delta))
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            text: {
                var t = root.caption
                if (isFinite(root.lastValue) && root.caption.length > 0)
                    t += "  " + ChartUtils.formatNumber(root.lastValue)
                if (isFinite(root.delta) && (root.showDelta || root.caption.length > 0))
                    t += (root.deltaPositive ? "  +" : "  ") + ChartUtils.formatNumber(root.delta)
                return t
            }
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            font.weight: root.showDelta ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
            color: {
                if (root.showDelta && isFinite(root.delta))
                    return root.deltaPositive ? Theme.systemSuccess : Theme.systemCritical
                return Theme.textSecondary
            }
            elide: Text.ElideRight
        }

        Canvas {
            id: canvas
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: captionLabel.visible ? captionLabel.bottom : parent.top
            anchors.topMargin: captionLabel.visible ? 2 : 0
            antialiasing: true
            renderStrategy: Canvas.Cooperative

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var w = width
                var h = height
                if (w < 2 || h < 2)
                    return

                var pts = ChartUtils.downsample(root.values, Math.max(32, Math.floor(w)))
                if (pts.length < 2)
                    return

                var ext = ChartUtils.extents(pts)
                var lo = isFinite(root.minimum) ? root.minimum : ext.min
                var hi = isFinite(root.maximum) ? root.maximum : ext.max
                if (hi <= lo)
                    hi = lo + 1
                var span = hi - lo
                var pad = root.strokeWidth
                var reveal = Math.max(0, Math.min(1, root.revealProgress))

                function X(i) {
                    return (i / (pts.length - 1)) * (w - pad * 2) + pad
                }
                function Y(v) {
                    return h - pad - ((v - lo) / span) * (h - pad * 2)
                }

                ctx.save()
                ctx.beginPath()
                ctx.rect(0, 0, w * reveal, h)
                ctx.clip()

                ctx.lineWidth = root.strokeWidth
                ctx.lineJoin = "round"
                ctx.lineCap = "round"
                ctx.strokeStyle = root.strokeColor
                ctx.beginPath()
                ctx.moveTo(X(0), Y(pts[0]))
                for (var i = 1; i < pts.length; ++i)
                    ctx.lineTo(X(i), Y(pts[i]))
                ctx.stroke()

                if (root.filled) {
                    ctx.lineTo(X(pts.length - 1), h)
                    ctx.lineTo(X(0), h)
                    ctx.closePath()
                    var grad = ctx.createLinearGradient(0, 0, 0, h)
                    grad.addColorStop(0, root.fillColor)
                    grad.addColorStop(1, ChartUtils.withAlpha(root.strokeColor, 0.02))
                    ctx.fillStyle = grad
                    ctx.fill()
                }
                ctx.restore()

                if (root.showEndMarker && reveal > 0.98) {
                    var ex = X(pts.length - 1)
                    var ey = Y(pts[pts.length - 1])
                    ctx.beginPath()
                    ctx.arc(ex, ey, 2.5, 0, Math.PI * 2)
                    ctx.fillStyle = root.strokeColor
                    ctx.fill()
                    ctx.beginPath()
                    ctx.arc(ex, ey, 5, 0, Math.PI * 2)
                    ctx.strokeStyle = ChartUtils.withAlpha(root.strokeColor, 0.35)
                    ctx.lineWidth = 1.5
                    ctx.stroke()
                }
            }
        }
    }

    background: Item {}
}
