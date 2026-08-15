import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

// Zone / band gauge — colored ranges + needle; interactive drag; activeZone.
// zones: [{ from: 0, to: 0.4, color, label? }, ...] normalized 0..1
T.Control {
    id: root

    property real value: 0
    property real minimum: 0
    property real maximum: 100
    property real stepSize: 0
    property string title: ""
    property string unit: ""
    property string caption: ""
    property int valuePrecision: 0
    property real strokeWidth: 14
    property bool showNeedle: true
    property bool showValue: true
    property bool showTicks: true
    property int tickCount: 9
    property real startAngle: -210
    property real sweepTotal: 240
    property bool isInteractive: false
    property alias interactive: root.isInteractive
    property var zones: [
        { from: 0, to: 0.55, color: "" },
        { from: 0.55, to: 0.8, color: "" },
        { from: 0.8, to: 1.0, color: "" }
    ]

    signal valueEdited(real value)

    implicitWidth: 156
    implicitHeight: title.length ? 180 : 156
    padding: 8
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Zone gauge")
    Accessible.description: {
        var z = activeZoneLabel
        return z.length ? (formattedValue + " — " + z) : formattedValue
    }

    readonly property real percentage: animatedNorm * 100
    readonly property int activeZoneIndex: {
        var n = animatedNorm
        var zs = zones || []
        for (var i = 0; i < zs.length; ++i) {
            var a = Number(zs[i].from) || 0
            var b = Number(zs[i].to) || 1
            if (n >= a && n <= b)
                return i
        }
        return Math.max(0, zs.length - 1)
    }
    readonly property string activeZoneLabel: {
        var zs = zones || []
        var i = activeZoneIndex
        if (i < 0 || i >= zs.length)
            return ""
        return zs[i].label || ""
    }
    readonly property color activeZoneColor: zoneColor(
        (zones && zones[activeZoneIndex]) ? zones[activeZoneIndex] : null,
        activeZoneIndex)

    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        return t + (unit.length ? unit : "")
    }

    property real animatedValue: value
    Behavior on animatedValue {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: Theme.easingStandard
        }
    }
    onValueChanged: animatedValue = value
    Component.onCompleted: animatedValue = value

    readonly property real animatedNorm: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }

    function zoneColor(z, index) {
        if (z && z.color !== undefined && String(z.color).length)
            return z.color
        switch (index) {
        case 0: return Theme.systemSuccess
        case 1: return Theme.systemCaution
        default: return Theme.systemCritical
        }
    }

    function clampSnap(v) {
        var lo = Math.min(minimum, maximum)
        var hi = Math.max(minimum, maximum)
        var x = Math.max(lo, Math.min(hi, Number(v) || 0))
        if (stepSize > 0) {
            var steps = Math.round((x - lo) / stepSize)
            x = Math.max(lo, Math.min(hi, lo + steps * stepSize))
        }
        return x
    }

    function setValue(v) { value = clampSnap(v) }

    function setValueFromNorm(n) {
        setValue(minimum + Math.max(0, Math.min(1, n)) * (maximum - minimum))
    }

    function normFromPoint(px, py) {
        var cx = face.width / 2
        var cy = face.height / 2
        var deg = Math.atan2(py - cy, px - cx) * 180 / Math.PI
        var a = deg
        while (a < root.startAngle)
            a += 360
        while (a > root.startAngle + root.sweepTotal + 180)
            a -= 360
        return Math.max(0, Math.min(1, (a - root.startAngle) / Math.max(1e-6, root.sweepTotal)))
    }

    Keys.onLeftPressed: if (isInteractive) {
        setValue(value - (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }
    Keys.onRightPressed: if (isInteractive) {
        setValue(value + (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }

    contentItem: Item {
        id: face
        readonly property real radius: Math.min(width, height) / 2 - root.strokeWidth - 2

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: Theme.strokeDivider
                fillColor: "transparent"
                capStyle: ShapePath.FlatCap
                startX: face.width / 2 + Math.cos(root.startAngle * Math.PI / 180) * face.radius
                startY: face.height / 2 + Math.sin(root.startAngle * Math.PI / 180) * face.radius
                PathAngleArc {
                    centerX: face.width / 2
                    centerY: face.height / 2
                    radiusX: face.radius
                    radiusY: face.radius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepTotal
                }
            }
        }

        Repeater {
            model: root.zones
            Shape {
                id: zoneShape
                required property var modelData
                required property int index
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer
                readonly property real zFrom: Math.max(0, Math.min(1, Number(modelData.from) || 0))
                readonly property real zTo: Math.max(zFrom, Math.min(1, Number(modelData.to) || 1))
                readonly property real zStart: root.startAngle + zFrom * root.sweepTotal
                readonly property real zSweep: (zTo - zFrom) * root.sweepTotal
                opacity: root.activeZoneIndex === index ? 1 : 0.72
                Behavior on opacity {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
                ShapePath {
                    strokeWidth: root.strokeWidth - 2
                    strokeColor: root.zoneColor(modelData, index)
                    fillColor: "transparent"
                    capStyle: ShapePath.FlatCap
                    startX: face.width / 2 + Math.cos(zoneShape.zStart * Math.PI / 180) * face.radius
                    startY: face.height / 2 + Math.sin(zoneShape.zStart * Math.PI / 180) * face.radius
                    PathAngleArc {
                        centerX: face.width / 2
                        centerY: face.height / 2
                        radiusX: face.radius
                        radiusY: face.radius
                        startAngle: zoneShape.zStart
                        sweepAngle: zoneShape.zSweep
                    }
                }
            }
        }

        Repeater {
            model: root.showTicks ? root.tickCount : 0
            Rectangle {
                required property int index
                width: 2
                height: root.strokeWidth * 0.45
                radius: 1
                color: Theme.textSecondary
                opacity: 0.5
                property real angDeg: root.startAngle + (index / Math.max(1, root.tickCount - 1)) * root.sweepTotal
                property real ang: angDeg * Math.PI / 180
                x: face.width / 2 + Math.cos(ang) * face.radius - width / 2
                y: face.height / 2 + Math.sin(ang) * face.radius - height / 2
                rotation: angDeg + 90
            }
        }

        Item {
            visible: root.showNeedle
            anchors.fill: parent
            rotation: root.startAngle + 90 + root.animatedNorm * root.sweepTotal
            transformOrigin: Item.Center
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                width: 3
                height: face.radius * 0.78
                radius: 1.5
                color: Theme.textPrimary
                opacity: 0.9
            }
            Rectangle {
                anchors.centerIn: parent
                width: 12
                height: 12
                radius: 6
                color: Theme.bgCard
                border.width: 2
                border.color: root.activeZoneColor
            }
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.sweepTotal < 360 ? face.radius * 0.28 : 0
            spacing: 2
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.title.length > 0
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.showValue
                text: root.formattedValue
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontSubtitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.activeZoneLabel.length > 0 || root.caption.length > 0
                text: root.activeZoneLabel.length ? root.activeZoneLabel : root.caption
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: root.activeZoneLabel.length ? root.activeZoneColor : Theme.textSecondary
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.isInteractive && root.enabled
            cursorShape: Qt.PointingHandCursor
            function apply(mx, my) {
                root.setValueFromNorm(root.normFromPoint(mx, my))
                root.valueEdited(root.value)
            }
            onPressed: function (mouse) { apply(mouse.x, mouse.y) }
            onPositionChanged: function (mouse) {
                if (pressed)
                    apply(mouse.x, mouse.y)
            }
        }
    }

    background: Item {}
}
