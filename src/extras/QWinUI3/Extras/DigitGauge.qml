import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// DigitGauge — Seven-segment numeric readout.
//
//   DigitGauge { value: 42.8; digits: 4; valuePrecision: 1 }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental LED digits. Prefer KpiTile for dashboard KPI text.

T.Control {
    id: root
    Accessible.role: Accessible.StaticText
    Accessible.name: title.length ? title : qsTr("Digit gauge")
    Accessible.description: formattedValue

    property real value: 0
    property int digits: 3
    property int valuePrecision: 0
    property string title: ""
    property string unit: ""
    property color fillColor: Theme.accent
    property color dimColor: Theme.strokeDivider

    implicitWidth: Math.max(120, digits * 28 + 24)
    implicitHeight: title.length ? 72 : 52
    padding: 8

    property real animatedValue: value
    Behavior on animatedValue {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionNormal); easing.type: Theme.easingStandard }
    }
    onValueChanged: animatedValue = value
    Component.onCompleted: animatedValue = value

    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        return t + (unit.length ? unit : "")
    }

    function setValue(v) { value = v }

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
            Layout.preferredHeight: 36
            antialiasing: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var maps = [
                    [1,1,1,1,1,1,0],
                    [0,1,1,0,0,0,0],
                    [1,1,0,1,1,0,1],
                    [1,1,1,1,0,0,1],
                    [0,1,1,0,0,1,1],
                    [1,0,1,1,0,1,1],
                    [1,0,1,1,1,1,1],
                    [1,1,1,0,0,0,0],
                    [1,1,1,1,1,1,1],
                    [1,1,1,1,0,1,1]
                ]
                var raw = root.valuePrecision > 0
                          ? Number(root.animatedValue).toFixed(root.valuePrecision)
                          : String(Math.round(root.animatedValue))
                var chars = raw.split("")
                while (chars.length < root.digits)
                    chars.unshift(" ")
                if (chars.length > root.digits)
                    chars = chars.slice(chars.length - root.digits)
                var slot = width / Math.max(1, chars.length)
                var dw = Math.min(22, slot * 0.7)
                var dh = height - 4
                function seg(on, x, y, w, h) {
                    ctx.fillStyle = on ? root.fillColor : ChartUtils.withAlpha(root.dimColor, 0.35)
                    ctx.fillRect(x, y, w, h)
                }
                for (var i = 0; i < chars.length; ++i) {
                    var ch = chars[i]
                    var ox = i * slot + (slot - dw) * 0.5
                    var oy = 2
                    if (ch === ".") {
                        ctx.fillStyle = root.fillColor
                        ctx.fillRect(ox + dw * 0.7, oy + dh - 6, 4, 4)
                        continue
                    }
                    if (ch === "-") {
                        seg(true, ox + 3, oy + dh * 0.5 - 1.5, dw - 6, 3)
                        continue
                    }
                    var d = parseInt(ch, 10)
                    if (isNaN(d))
                        continue
                    var m = maps[d]
                    var t = 3
                    seg(m[0], ox + 4, oy, dw - 8, t)
                    seg(m[1], ox + dw - t, oy + 3, t, dh * 0.42)
                    seg(m[2], ox + dw - t, oy + dh * 0.5, t, dh * 0.42)
                    seg(m[3], ox + 4, oy + dh - t, dw - 8, t)
                    seg(m[4], ox, oy + dh * 0.5, t, dh * 0.42)
                    seg(m[5], ox, oy + 3, t, dh * 0.42)
                    seg(m[6], ox + 4, oy + dh * 0.5 - 1.5, dw - 8, t)
                }
            }
        }
        Text {
            visible: root.unit.length > 0
            text: root.unit
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
    }
    onAnimatedValueChanged: canvas.requestPaint()
    onDigitsChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}
