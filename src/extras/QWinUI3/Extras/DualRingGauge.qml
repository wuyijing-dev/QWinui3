import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// DualRingGauge — Two independent concentric KPI rings.
//
//   DualRingGauge {
//       value: 72
//       value2: 48
//       title: qsTr("CPU")
//       title2: qsTr("GPU")
//   }
//
//   // --- API ---
//   // methods: setValue(v), setValue2(v)
//
// @notes
//   Experimental. Prefer RingGauge.value2 when both rings share one min/max scale.

T.Control {
    id: root

    property real value: 0
    property real value2: 0
    property real minimum: 0
    property real maximum: 100
    property string title: ""
    property string title2: ""
    property string unit: "%"
    property color fillColor: Theme.accent
    property color fillColor2: Theme.systemCaution
    property real strokeWidth: 12
    property real strokeWidthInner: 8
    property real startAngle: -90
    property real sweepTotal: 350
    property color trackColor: Theme.strokeDivider

    implicitWidth: 168
    implicitHeight: title.length || title2.length ? 188 : 168
    padding: 8
    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("Dual ring gauge")

    property real animatedValue: value
    property real animatedValue2: value2
    Behavior on animatedValue {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionSlow); easing.type: Theme.easingStandard }
    }
    Behavior on animatedValue2 {
        enabled: !Theme.reducedMotion
        NumberAnimation { duration: Theme.duration(Theme.motionSlow); easing.type: Theme.easingStandard }
    }
    onValueChanged: animatedValue = value
    onValue2Changed: animatedValue2 = value2
    Component.onCompleted: {
        animatedValue = value
        animatedValue2 = value2
    }

    readonly property real animatedNorm: {
        var span = maximum - minimum
        return span <= 0 ? 0 : Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }
    readonly property real animatedNorm2: {
        var span = maximum - minimum
        return span <= 0 ? 0 : Math.max(0, Math.min(1, (animatedValue2 - minimum) / span))
    }

    function setValue(v) { value = v }
    function setValue2(v) { value2 = v }

    contentItem: Item {
        id: face
        readonly property real cx: width / 2
        readonly property real cy: height / 2 - (root.title.length || root.title2.length ? 8 : 0)
        readonly property real radius: Math.min(width, height) * 0.40 - root.strokeWidth * 0.5
        readonly property real innerRadius: Math.max(10, radius - root.strokeWidth * 0.5 - root.strokeWidthInner * 0.5 - 6)

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.trackColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.radius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.radius
                PathAngleArc {
                    centerX: face.cx; centerY: face.cy
                    radiusX: face.radius; radiusY: face.radius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepTotal
                }
            }
        }
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.fillColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.radius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.radius
                PathAngleArc {
                    centerX: face.cx; centerY: face.cy
                    radiusX: face.radius; radiusY: face.radius
                    startAngle: root.startAngle
                    sweepAngle: root.animatedNorm * root.sweepTotal
                }
            }
        }
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidthInner
                strokeColor: root.trackColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.innerRadius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.innerRadius
                PathAngleArc {
                    centerX: face.cx; centerY: face.cy
                    radiusX: face.innerRadius; radiusY: face.innerRadius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepTotal
                }
            }
        }
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidthInner
                strokeColor: root.fillColor2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.cx + Math.cos(root.startAngle * Math.PI / 180) * face.innerRadius
                startY: face.cy + Math.sin(root.startAngle * Math.PI / 180) * face.innerRadius
                PathAngleArc {
                    centerX: face.cx; centerY: face.cy
                    radiusX: face.innerRadius; radiusY: face.innerRadius
                    startAngle: root.startAngle
                    sweepAngle: root.animatedNorm2 * root.sweepTotal
                }
            }
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -6
            spacing: 2
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Math.round(root.animatedValue) + root.unit
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: root.fillColor
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Math.round(root.animatedValue2) + root.unit
                font.pixelSize: Theme.fontCaption
                color: root.fillColor2
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: 12
            Text {
                visible: root.title.length > 0
                text: root.title
                font.pixelSize: Theme.fontCaption
                color: root.fillColor
            }
            Text {
                visible: root.title2.length > 0
                text: root.title2
                font.pixelSize: Theme.fontCaption
                color: root.fillColor2
            }
        }
    }

    background: Item {}
}
