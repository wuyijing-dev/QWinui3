import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// VoltageGauge — 12 V vehicle electrical system.
//
//   VoltageGauge { value: 13.8; unit: "V" }
//
//   // --- API ---
//   // methods: setValue(v)
//
// @notes
//   Experimental 8–16 V cluster meter. Prefer LinearGauge for a generic track.

T.Control {
    id: root
    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("Voltage")
    Accessible.description: (Math.round(animatedValue * 10) / 10) + unit

    property real value: 13.8
    property real minimum: 8
    property real maximum: 16
    property string title: ""
    property string unit: "V"
    property real lowWarn: 11.5
    property real highWarn: 15.2
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 148
    implicitHeight: title.length ? 88 : 64
    padding: 8

    property real animatedValue: value
    Behavior on animatedValue {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionNormal); easing.type: Theme.easingStandard }
    }
    onValueChanged: animatedValue = value
    Component.onCompleted: animatedValue = value

    readonly property real animatedNorm: {
        var span = maximum - minimum
        return span <= 0 ? 0 : Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }
    readonly property color fillColor: {
        if (animatedValue <= lowWarn || animatedValue >= highWarn)
            return Theme.systemCritical
        return Theme.systemSuccess
    }

    function setValue(v) { value = Math.max(minimum, Math.min(maximum, v)) }

    contentItem: ColumnLayout {
        spacing: 4
        RowLayout {
            Text {
                Layout.fillWidth: true
                text: root.title.length ? root.title : qsTr("Batt")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                text: (Math.round(root.animatedValue * 10) / 10).toFixed(1) + " " + root.unit
                font.weight: Theme.fontWeightSemiBold
                color: root.fillColor
            }
        }
        Canvas {
            id: canvas
            Layout.fillWidth: true
            Layout.preferredHeight: 18
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var w = width
                var h = height
                ctx.fillStyle = Theme.strokeDivider
                ctx.fillRect(0, 2, w, h - 4)
                var fw = Math.max(2, w * root.animatedNorm)
                ctx.fillStyle = root.fillColor
                ctx.fillRect(0, 2, fw, h - 4)
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.isInteractive
                onPressed: function (mouse) { positionChanged(mouse) }
                onPositionChanged: function (mouse) {
                    if (!pressed)
                        return
                    root.setValue(root.minimum + Math.max(0, Math.min(1, mouse.x / Math.max(1, width))) * (root.maximum - root.minimum))
                    root.valueEdited(root.value)
                    canvas.requestPaint()
                }
            }
        }
    }
    onAnimatedValueChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    background: Item {}
}
