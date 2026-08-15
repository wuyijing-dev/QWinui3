import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Shapes
import QWinUI3.Theme

T.Control {
    id: root

    property real value: 0
    property real minimum: 0
    property real maximum: 100
    property real stepSize: 0
    property real strokeWidth: 10
    property bool showValue: true
    property string unit: ""
    property string title: ""
    property string caption: ""
    property int valuePrecision: 0
    property int tickCount: 8
    property color trackColor: Theme.strokeDivider
    property color fillColor: Theme.accent
    property bool showNeedle: true
    property real startAngle: -210
    property real sweepTotal: 240
    property real cautionThreshold: -1
    property real criticalThreshold: -1
    property bool invertThresholds: false
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: 148
    implicitHeight: title.length ? 176 : 148
    padding: 8
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Gauge")
    Accessible.description: {
        var parts = []
        if (caption.length)
            parts.push(caption)
        parts.push(formattedValue)
        return parts.join(" — ")
    }

    readonly property real percentage: animatedNorm * 100
    readonly property color effectiveFillColor: {
        var n = invertThresholds ? (1 - animatedNorm) : animatedNorm
        if (criticalThreshold >= 0 && n >= criticalThreshold)
            return Theme.systemCritical
        if (cautionThreshold >= 0 && n >= cautionThreshold)
            return Theme.systemCaution
        return fillColor
    }

    readonly property real normalized: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (value - minimum) / span))
    }

    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        return t + (unit.length ? unit : "")
    }

    function setValue(v) {
        var lo = Math.min(minimum, maximum)
        var hi = Math.max(minimum, maximum)
        var x = Math.max(lo, Math.min(hi, Number(v) || 0))
        if (stepSize > 0) {
            var steps = Math.round((x - lo) / stepSize)
            x = Math.max(lo, Math.min(hi, lo + steps * stepSize))
        }
        value = x
    }

    function setValueFromNorm(n) {
        setValue(minimum + Math.max(0, Math.min(1, n)) * (maximum - minimum))
    }

    function normFromPoint(px, py) {
        var cx = gaugeFace.width / 2
        var cy = gaugeFace.height / 2
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

    contentItem: Item {
        id: gaugeFace
        readonly property real radius: Math.min(width, height) / 2 - root.strokeWidth - 2

        // Soft glow under progress
        Rectangle {
            anchors.centerIn: parent
            width: gaugeFace.radius * 1.15
            height: width
            radius: width / 2
            color: ChartUtils.withAlpha(root.effectiveFillColor, Theme.dark ? 0.12 : 0.08)
            scale: 0.85 + root.animatedNorm * 0.15
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionSlow)
                    easing.type: Theme.easingStandard
                }
            }
        }

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.trackColor
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: gaugeFace.width / 2 + Math.cos(root.startAngle * Math.PI / 180) * gaugeFace.radius
                startY: gaugeFace.height / 2 + Math.sin(root.startAngle * Math.PI / 180) * gaugeFace.radius
                PathAngleArc {
                    centerX: gaugeFace.width / 2
                    centerY: gaugeFace.height / 2
                    radiusX: gaugeFace.radius
                    radiusY: gaugeFace.radius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepTotal
                }
            }
        }

        Shape {
            id: fillArc
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            property real sweep: root.animatedNorm * root.sweepTotal
            ShapePath {
                strokeWidth: root.strokeWidth
                strokeColor: root.enabled ? root.effectiveFillColor : Theme.textDisabled
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                startX: gaugeFace.width / 2 + Math.cos(root.startAngle * Math.PI / 180) * gaugeFace.radius
                startY: gaugeFace.height / 2 + Math.sin(root.startAngle * Math.PI / 180) * gaugeFace.radius
                PathAngleArc {
                    centerX: gaugeFace.width / 2
                    centerY: gaugeFace.height / 2
                    radiusX: gaugeFace.radius
                    radiusY: gaugeFace.radius
                    startAngle: root.startAngle
                    sweepAngle: fillArc.sweep
                }
            }
        }

        Repeater {
            model: root.tickCount
            Rectangle {
                required property int index
                width: 2
                height: root.strokeWidth * 0.4
                radius: 1
                color: Theme.textSecondary
                opacity: 0.45
                property real angDeg: root.startAngle + (index / Math.max(1, root.tickCount - 1)) * root.sweepTotal
                property real ang: angDeg * Math.PI / 180
                property real rr: gaugeFace.radius
                x: gaugeFace.width / 2 + Math.cos(ang) * rr - width / 2
                y: gaugeFace.height / 2 + Math.sin(ang) * rr - height / 2
                rotation: angDeg + 90
            }
        }

        // Needle
        Item {
            visible: root.showNeedle
            anchors.fill: parent
            rotation: root.startAngle + 90 + root.animatedNorm * root.sweepTotal
            transformOrigin: Item.Center
            Behavior on rotation {
                enabled: false // driven by animatedNorm already
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                width: 3
                height: gaugeFace.radius * 0.72
                radius: 1.5
                color: Theme.textPrimary
                opacity: 0.85
            }
            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 10
                radius: 5
                color: Theme.bgCard
                border.width: 2
                border.color: root.effectiveFillColor
            }
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.sweepTotal < 360 ? gaugeFace.radius * 0.22 : 0
            spacing: 2
            visible: root.showValue
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
                text: root.formattedValue
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontSubtitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.caption.length > 0
                text: root.caption
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.caption.length === 0 && root.unit.length === 0
                text: qsTr("%1 / %2").arg(Math.round(root.minimum)).arg(Math.round(root.maximum))
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
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
