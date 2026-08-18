import QtQuick
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// CompassGauge — Heading / bearing compass (0–360°, wraparound).
//
//   CompassGauge { heading: 42 }
//
// @notes
//   Experimental. Prefer RadialGauge for non-wrapping scales. Dual-use as a heading readout.

T.Control {
    id: root

    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Compass")

    // Heading in degrees (0 = N, clockwise)
    property real heading: 0
    // Primary title text
    property string title: ""
    // Caption under the value
    property string caption: qsTr("Heading")
    property bool showCardinals: true
    property color needleBrush: Theme.systemCritical
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 168
    implicitHeight: title.length ? 196 : 168
    padding: 8

    readonly property real normalizedHeading: {
        var h = heading % 360
        if (h < 0)
            h += 360
        return h
    }

    readonly property string cardinal: {
        var d = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        var idx = Math.round(normalizedHeading / 45) % 8
        return d[idx]
    }

    function setHeading(v) {
        var h = Number(v) || 0
        h = h % 360
        if (h < 0)
            h += 360
        heading = h
    }

    contentItem: Item {
        id: face
        readonly property real radius: Math.min(width, height) / 2 - 8

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: 10
                strokeColor: Theme.strokeDivider
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: face.width / 2 + face.radius
                startY: face.height / 2
                PathAngleArc {
                    centerX: face.width / 2
                    centerY: face.height / 2
                    radiusX: face.radius
                    radiusY: face.radius
                    startAngle: 0
                    sweepAngle: 360
                }
            }
        }

        Repeater {
            model: root.showCardinals ? ["N", "E", "S", "W"] : []
            delegate: Text {
                required property int index
                required property string modelData
                text: modelData
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textSecondary
                readonly property real ang: (index * 90 - 90) * Math.PI / 180
                x: face.width / 2 + Math.cos(ang) * (face.radius - 18) - implicitWidth / 2
                y: face.height / 2 + Math.sin(ang) * (face.radius - 18) - implicitHeight / 2
            }
        }

        Item {
            anchors.fill: parent
            rotation: root.normalizedHeading
            transformOrigin: Item.Center
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                width: 4
                height: face.radius * 0.62
                radius: 2
                color: root.needleBrush
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.verticalCenter
                width: 3
                height: face.radius * 0.28
                radius: 1
                color: Theme.textSecondary
                opacity: 0.55
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 12
            height: 12
            radius: 6
            color: Theme.bgCard
            border.width: 2
            border.color: Theme.accent
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: face.radius * 0.28
            spacing: 0
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.title.length > 0
                text: root.title
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Math.round(root.normalizedHeading) + "°  " + root.cardinal
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.caption.length > 0
                text: root.caption
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.isInteractive
            preventStealing: true
            onPositionChanged: function (mouse) {
                if (!pressed)
                    return
                var dx = mouse.x - width / 2
                var dy = mouse.y - height / 2
                var deg = Math.atan2(dx, -dy) * 180 / Math.PI
                if (deg < 0)
                    deg += 360
                root.setHeading(deg)
                root.valueEdited(root.heading)
            }
            onPressed: function (mouse) {
                var dx = mouse.x - width / 2
                var dy = mouse.y - height / 2
                var deg = Math.atan2(dx, -dy) * 180 / Math.PI
                if (deg < 0)
                    deg += 360
                root.setHeading(deg)
                root.valueEdited(root.heading)
            }
        }
    }

    background: Item {}
}
