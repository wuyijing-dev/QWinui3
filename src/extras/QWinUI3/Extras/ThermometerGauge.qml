import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ThermometerGauge — Classic bulb + stem temperature / level gauge.
//
//   ThermometerGauge {
//       id: thermo
//       value: 36.5; minimum: 0; maximum: 50
//       unit: "°C"
//       title: qsTr("Ambient")
//       target: 22
//       showTickLabels: true
//       cautionThreshold: 0.7
//       criticalThreshold: 0.85
//   }
//
//   // --- API ---
//   // signals: onValueEdited
//   // methods: clampSnap(v), setValue(v), setValueFromNorm(n), nudge(delta)
//   // thermo.setValue(v); thermo.nudge(0.5); thermo.severity
//
// @notes
//   Classic thermometer: stem fill + bulb. Optional tick labels and target mark.
//   Drag/wheel/keys when interactive; thresholds tint mercury; severity is 0/1/2.

T.Control {
    id: root

    // Current value
    property real value: 0
    // Minimum value
    property real minimum: 0
    // Maximum value
    property real maximum: 100
    // Value step
    property real stepSize: 0
    // Primary title text
    property string title: ""
    // Value unit label (°C, °F, …)
    property string unit: ""
    // Caption under / beside the value
    property string caption: ""
    // Digits after decimal for value text
    property int valuePrecision: 1
    // Mercury / fill color
    property color fillColor: Theme.systemCritical
    // Stem / shell stroke color
    property color trackColor: Theme.strokeDivider
    // Stem width in px
    property real stemWidth: 14
    // Bulb diameter in px
    property real bulbSize: 28
    // Show tick marks along the stem
    property bool showTicks: true
    // Show numeric labels next to ticks
    property bool showTickLabels: false
    // Major tick count
    property int tickCount: 5
    // Show numeric value label
    property bool showValue: true
    // Show min/max labels
    property bool showMinMax: false
    // Target value (NaN to hide)
    property real target: NaN
    // Show target marker when target is finite
    property bool showTarget: true
    // Value where caution zone starts (0..1 norm)
    property real cautionThreshold: -1
    // Value where critical zone starts
    property real criticalThreshold: -1
    // Invert caution/critical threshold logic
    property bool invertThresholds: false
    // Alias of interactive
    property bool isInteractive: false
    // Enable hover / click interaction
    property alias interactive: root.isInteractive

    // Emitted when user commits a value
    signal valueEdited(real value)

    implicitWidth: showTickLabels ? 96 : 72
    implicitHeight: title.length || caption.length || showMinMax ? 220 : 200
    padding: 6
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Thermometer")
    Accessible.description: formattedValue

    readonly property real normalized: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (value - minimum) / span))
    }
    readonly property real percentage: animatedNorm * 100
    readonly property int severity: {
        var n = invertThresholds ? (1 - animatedNorm) : animatedNorm
        if (criticalThreshold >= 0 && n >= criticalThreshold)
            return 2
        if (cautionThreshold >= 0 && n >= cautionThreshold)
            return 1
        return 0
    }
    readonly property color effectiveFillColor: {
        if (severity === 2)
            return Theme.systemCritical
        if (severity === 1)
            return Theme.systemCaution
        return fillColor
    }
    readonly property bool hasTarget: showTarget && isFinite(target)
    readonly property real targetNorm: {
        if (!hasTarget)
            return 0
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (target - minimum) / span))
    }

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

    function nudge(delta) {
        var d = Number(delta) || 0
        if (stepSize > 0 && Math.abs(d) < stepSize)
            d = d < 0 ? -stepSize : stepSize
        setValue(value + d)
        valueEdited(value)
    }

    function _stepAmount() {
        return stepSize > 0 ? stepSize : (maximum - minimum) * 0.05
    }

    function tickLabel(t) {
        var v = minimum + t * (maximum - minimum)
        return valuePrecision > 0 ? Number(v).toFixed(valuePrecision) : String(Math.round(v))
    }

    Keys.onUpPressed: if (isInteractive) nudge(_stepAmount())
    Keys.onDownPressed: if (isInteractive) nudge(-_stepAmount())

    WheelHandler {
        enabled: root.isInteractive && root.enabled
        onWheel: function (event) {
            var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
            if (dir === 0)
                return
            root.nudge(dir > 0 ? root._stepAmount() : -root._stepAmount())
            event.accepted = true
        }
    }

    contentItem: Item {
        Column {
            id: headerCol
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.title.length > 0
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }

        Column {
            id: footerCol
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2
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
                visible: root.caption.length > 0
                text: root.caption
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.showMinMax
                spacing: 10
                Text {
                    text: root.tickLabel(0)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
                Text {
                    text: root.tickLabel(1)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
            }
        }

        Item {
            id: face
            anchors.top: headerCol.bottom
            anchors.bottom: footerCol.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 4
            anchors.bottomMargin: 4

            readonly property real bulb: Math.min(root.bulbSize, width * 0.7)
            readonly property real stemW: Math.min(root.stemWidth, bulb * 0.45)
            readonly property real stemTop: 4
            readonly property real stemBottom: height - bulb * 0.55
            readonly property real stemH: Math.max(8, stemBottom - stemTop)
            readonly property real cx: root.showTickLabels ? width * 0.38 : width / 2

            Rectangle {
                x: face.cx - face.stemW / 2
                y: face.stemTop
                width: face.stemW
                height: face.stemH
                radius: width / 2
                color: Theme.dark ? "#10FFFFFF" : "#08000000"
                border.width: 1
                border.color: root.activeFocus && root.isInteractive
                              ? Theme.focusOuter
                              : root.trackColor
            }

            Item {
                x: face.cx - face.stemW / 2 + 2
                y: face.stemTop + 2
                width: Math.max(2, face.stemW - 4)
                height: Math.max(4, face.stemH - 4)
                clip: true

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: parent.height * root.animatedNorm
                    radius: width / 2
                    color: root.enabled ? root.effectiveFillColor : Theme.textDisabled
                }
            }

            Rectangle {
                width: face.bulb
                height: face.bulb
                radius: width / 2
                x: face.cx - width / 2
                anchors.bottom: parent.bottom
                color: root.enabled ? root.effectiveFillColor : Theme.textDisabled
                border.width: 2
                border.color: root.activeFocus && root.isInteractive
                              ? Theme.focusOuter
                              : Qt.darker(root.effectiveFillColor, 1.15)

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.35
                    height: width
                    radius: width / 2
                    color: Qt.rgba(1, 1, 1, Theme.dark ? 0.22 : 0.35)
                    anchors.horizontalCenterOffset: -parent.width * 0.12
                    anchors.verticalCenterOffset: -parent.height * 0.12
                }
            }

            // Target tick on stem
            Rectangle {
                visible: root.hasTarget
                width: face.stemW + 10
                height: 2
                radius: 1
                color: Theme.textPrimary
                opacity: 0.85
                x: face.cx - width / 2
                y: face.stemTop + (1 - root.targetNorm) * face.stemH - height / 2
            }

            Repeater {
                model: root.showTicks ? Math.max(2, root.tickCount) : 0
                delegate: Item {
                    required property int index
                    readonly property real t: index / Math.max(1, root.tickCount - 1)
                    width: face.width
                    height: 1
                    y: face.stemTop + (1 - t) * face.stemH

                    Rectangle {
                        width: 6
                        height: 1
                        color: Theme.textSecondary
                        opacity: 0.7
                        x: face.cx + face.stemW / 2 + 3
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        visible: root.showTickLabels
                        text: root.tickLabel(t)
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption - 1
                        color: Theme.textSecondary
                        x: face.cx + face.stemW / 2 + 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: root.isInteractive && root.enabled
                cursorShape: Qt.PointingHandCursor
                function apply(my) {
                    var y0 = face.stemTop
                    var y1 = face.stemBottom
                    var n = 1 - Math.max(0, Math.min(1, (my - y0) / Math.max(1, y1 - y0)))
                    root.setValueFromNorm(n)
                    root.valueEdited(root.value)
                }
                onPressed: function (mouse) { apply(mouse.y) }
                onPositionChanged: function (mouse) {
                    if (pressed)
                        apply(mouse.y)
                }
            }
        }
    }

    background: Item {}
}
