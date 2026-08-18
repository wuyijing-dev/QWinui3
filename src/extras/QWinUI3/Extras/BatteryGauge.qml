import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// BatteryGauge — Battery silhouette with charge fill and optional charging bolt.
//
//   BatteryGauge {
//       value: 28
//       charging: false
//   }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental 0–100 battery. Prefer RingGauge for a generic closed KPI ring.

T.Control {
    id: root

    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("Battery")
    Accessible.description: Math.round(value) + unit

    property real value: 0
    property real minimum: 0
    property real maximum: 100
    property string title: ""
    property string unit: "%"
    property bool charging: false
    property real cautionThreshold: 0.3
    property real criticalThreshold: 0.15
    property real bodyRadius: 6

    implicitWidth: 148
    implicitHeight: title.length ? 88 : 64
    padding: 8

    property real animatedValue: value
    Behavior on animatedValue {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionSlow); easing.type: Theme.easingStandard }
    }
    onValueChanged: animatedValue = value
    Component.onCompleted: animatedValue = value

    readonly property real animatedNorm: {
        var span = maximum - minimum
        return span <= 0 ? 0 : Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }
    readonly property int severity: {
        if (animatedNorm <= criticalThreshold)
            return 2
        if (animatedNorm <= cautionThreshold)
            return 1
        return 0
    }
    readonly property color fillColor: {
        if (charging)
            return Theme.systemSuccess
        if (severity === 2)
            return Theme.systemCritical
        if (severity === 1)
            return Theme.systemCaution
        return Theme.accent
    }

    function setValue(v) {
        value = Math.max(minimum, Math.min(maximum, v))
    }

    contentItem: ColumnLayout {
        spacing: 6
        Text {
            visible: root.title.length > 0
            text: root.title
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    var h = height
                    var bodyW = width - 14
                    var bodyH = Math.min(28, h - 4)
                    var x = 2
                    var y = (h - bodyH) / 2
                    var r = Math.min(root.bodyRadius, bodyH / 2)
                    var nubW = 8
                    var nubH = bodyH * 0.42

                    function roundRect(rx, ry, rw, rh, rr) {
                        ctx.beginPath()
                        ctx.moveTo(rx + rr, ry)
                        ctx.lineTo(rx + rw - rr, ry)
                        ctx.quadraticCurveTo(rx + rw, ry, rx + rw, ry + rr)
                        ctx.lineTo(rx + rw, ry + rh - rr)
                        ctx.quadraticCurveTo(rx + rw, ry + rh, rx + rw - rr, ry + rh)
                        ctx.lineTo(rx + rr, ry + rh)
                        ctx.quadraticCurveTo(rx, ry + rh, rx, ry + rh - rr)
                        ctx.lineTo(rx, ry + rr)
                        ctx.quadraticCurveTo(rx, ry, rx + rr, ry)
                        ctx.closePath()
                    }

                    ctx.strokeStyle = Theme.strokeControl
                    ctx.lineWidth = 2
                    roundRect(x, y, bodyW, bodyH, r)
                    ctx.stroke()
                    ctx.fillStyle = Theme.strokeControl
                    ctx.fillRect(x + bodyW, y + (bodyH - nubH) / 2, nubW, nubH)

                    var inset = 3
                    var innerW = bodyW - inset * 2
                    var fillW = innerW * root.animatedNorm
                    ctx.save()
                    roundRect(x + inset, y + inset, innerW, bodyH - inset * 2, Math.max(1, r - 2))
                    ctx.clip()
                    ctx.fillStyle = root.fillColor
                    ctx.fillRect(x + inset, y + inset, fillW, bodyH - inset * 2)
                    ctx.restore()

                    if (root.charging) {
                        ctx.fillStyle = Theme.textPrimary
                        ctx.beginPath()
                        var bx = x + bodyW * 0.42
                        var by = y + 4
                        ctx.moveTo(bx + 10, by)
                        ctx.lineTo(bx + 2, by + bodyH * 0.42)
                        ctx.lineTo(bx + 8, by + bodyH * 0.42)
                        ctx.lineTo(bx, by + bodyH - 6)
                        ctx.lineTo(bx + 14, by + bodyH * 0.48)
                        ctx.lineTo(bx + 8, by + bodyH * 0.48)
                        ctx.closePath()
                        ctx.fill()
                    }
                }
            }
            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round(root.animatedValue) + root.unit
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: root.fillColor
            }
        }
    }

    onAnimatedValueChanged: canvas.requestPaint()
    onChargingChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    background: Item {}
}
