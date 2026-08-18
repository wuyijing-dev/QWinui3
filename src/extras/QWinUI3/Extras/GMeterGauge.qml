import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// GMeterGauge — Lateral / longitudinal G-force plot.
//
//   GMeterGauge { lateral: 0.25; longitudinal: -0.1 }
//
// @notes
//   Experimental. Prefer ScatterChart for a generic XY plot.

T.Control {
    id: root
    Accessible.role: Accessible.Graphic
    Accessible.name: title.length ? title : qsTr("G-meter")
    Accessible.description: "lat " + lateral.toFixed(2) + " long " + longitudinal.toFixed(2)

    property real lateral: 0
    property real longitudinal: 0
    property real maxG: 1
    property string title: ""

    implicitWidth: 148
    implicitHeight: title.length ? 168 : 148
    padding: 8

    function setG(lat, lon) {
        lateral = lat
        longitudinal = lon
    }

    contentItem: ColumnLayout {
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
                var cx = width / 2
                var cy = height / 2
                var r = Math.min(width, height) * 0.42
                ctx.strokeStyle = Theme.strokeDivider
                ctx.lineWidth = 1
                for (var ring = 1; ring <= 2; ++ring) {
                    ctx.beginPath()
                    ctx.arc(cx, cy, r * ring / 2, 0, Math.PI * 2)
                    ctx.stroke()
                }
                ctx.beginPath()
                ctx.moveTo(cx - r, cy)
                ctx.lineTo(cx + r, cy)
                ctx.moveTo(cx, cy - r)
                ctx.lineTo(cx, cy + r)
                ctx.stroke()
                var px = cx + (root.lateral / Math.max(0.01, root.maxG)) * r
                var py = cy - (root.longitudinal / Math.max(0.01, root.maxG)) * r
                ctx.fillStyle = Theme.accent
                ctx.beginPath()
                ctx.arc(px, py, 6, 0, Math.PI * 2)
                ctx.fill()
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: root.lateral.toFixed(2) + " / " + root.longitudinal.toFixed(2) + " g"
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }
    }
    onLateralChanged: canvas.requestPaint()
    onLongitudinalChanged: canvas.requestPaint()
    onMaxGChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()
    background: Item {}
}
