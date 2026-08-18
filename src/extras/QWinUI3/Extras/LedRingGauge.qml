import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// LedRingGauge — Circular LED / peak-hold ring.
//
//   LedRingGauge { value: 0.72; peakHold: true }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental. Prefer VuMeter for a linear LED stack; SegmentedGauge for a thick arc.

T.Control {
    id: root
    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("LED ring")
    Accessible.description: Math.round(normalized * 100) + "%"

    property real value: 0
    property real minimum: 0
    property real maximum: 1
    property int segmentCount: 24
    property string title: ""
    property bool peakHold: true
    property int peakHoldMs: 700
    property real cautionThreshold: 0.75
    property real criticalThreshold: 0.9
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 148
    implicitHeight: title.length ? 168 : 148
    padding: 8

    readonly property real normalized: {
        var span = maximum - minimum
        return span <= 0 ? 0 : Math.max(0, Math.min(1, (value - minimum) / span))
    }
    property real peakNorm: 0

    function setValue(v) { value = Math.max(minimum, Math.min(maximum, v)) }

    onNormalizedChanged: {
        if (normalized >= peakNorm)
            peakNorm = normalized
        else
            peakTimer.restart()
    }

    Timer {
        id: peakTimer
        interval: root.peakHoldMs
        repeat: false
        onTriggered: root.peakNorm = root.normalized
    }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            spacing: 4
            Text {
                visible: root.title.length > 0
                text: root.title
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Canvas {
                id: canvas
                Layout.fillWidth: true
                Layout.fillHeight: true
                antialiasing: true
                onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var n = Math.max(8, root.segmentCount)
                var cx = width / 2
                var cy = height / 2
                var r = Math.min(width, height) * 0.38
                var lit = Math.round(root.normalized * n)
                var peak = Math.round(root.peakNorm * n)
                var start = -Math.PI / 2
                var step = (Math.PI * 2) / n
                for (var i = 0; i < n; ++i) {
                    var a = start + i * step
                    var frac = (i + 1) / n
                    var col = Theme.systemSuccess
                    if (frac >= root.criticalThreshold)
                        col = Theme.systemCritical
                    else if (frac >= root.cautionThreshold)
                        col = Theme.systemCaution
                    var on = i < lit || (root.peakHold && i + 1 === peak)
                    ctx.strokeStyle = on ? col : ChartUtils.withAlpha(Theme.strokeDivider, 0.45)
                    ctx.lineWidth = on ? 6 : 3
                    ctx.lineCap = "round"
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, a, a + step * 0.62)
                    ctx.stroke()
                }
            }
            Text {
                anchors.centerIn: canvas
                text: Math.round(root.normalized * 100) + "%"
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            }
        }

        GaugeDragLayer {
            coordSpace: canvas
            enabled: root.isInteractive && root.enabled
            onDragged: function (x, y) {
                var cx = canvas.width / 2
                var cy = canvas.height / 2
                var a = Math.atan2(y - cy, x - cx) + Math.PI / 2
                if (a < 0)
                    a += Math.PI * 2
                root.setValue(root.minimum + (a / (Math.PI * 2)) * (root.maximum - root.minimum))
                root.valueEdited(root.value)
                canvas.requestPaint()
            }
        }
    }
    onValueChanged: canvas.requestPaint()
    onPeakNormChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    background: Item {}
}
