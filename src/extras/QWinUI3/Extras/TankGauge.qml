import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// TankGauge — Vertical / horizontal tank / reservoir level gauge.
//
//   TankGauge {
//       id: tank
//       value: 68; minimum: 0; maximum: 100
//       unit: "%"
//       title: qsTr("Coolant")
//       target: 50
//       showMarks: true
//       cautionThreshold: 0.35
//       criticalThreshold: 0.15
//       invertThresholds: true
//   }
//
//   // --- API ---
//   // signals: onValueEdited
//   // methods: clampSnap(v), setValue(v), setValueFromNorm(n), nudge(delta)
//   // tank.setValue(v); tank.nudge(-5); tank.severity
//
// @notes
//   Liquid-level tank (vertical or horizontal); fill tracks value. Target line + level marks optional.
//   Use invertThresholds for low=critical. Wheel/keys when interactive; setValue clamps+snaps.

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
    // Value unit label
    property string unit: ""
    // Caption under / beside the value
    property string caption: ""
    // Digits after decimal for value text
    property int valuePrecision: 0
    // Primary fill / progress color
    property color fillColor: Theme.accent
    // Tank shell / track color
    property color trackColor: Theme.strokeDivider
    // Corner radius of the tank shell
    property real tankRadius: 10
    // Shell stroke width
    property real shellWidth: 2
    // Qt.Vertical (default) or Qt.Horizontal
    property int orientation: Qt.Vertical
    // Show numeric value label
    property bool showValue: true
    // Show min/max labels
    property bool showMinMax: false
    // Show evenly spaced level marks
    property bool showMarks: false
    // Major mark count
    property int markCount: 4
    // Tint threshold bands inside the shell
    property bool showThresholdBands: true
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

    readonly property bool horizontal: orientation === Qt.Horizontal

    implicitWidth: horizontal ? 220 : 88
    implicitHeight: {
        if (horizontal)
            return title.length || caption.length || showMinMax ? 96 : 72
        return title.length || caption.length || showMinMax ? 200 : 176
    }
    padding: 6
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Tank gauge")
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

    Keys.onUpPressed: if (isInteractive) nudge(_stepAmount())
    Keys.onDownPressed: if (isInteractive) nudge(-_stepAmount())
    Keys.onRightPressed: if (isInteractive) nudge(_stepAmount())
    Keys.onLeftPressed: if (isInteractive) nudge(-_stepAmount())

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
            spacing: 4
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
                spacing: 12
                Text {
                    text: Math.round(root.minimum)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
                Text {
                    text: Math.round(root.maximum)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                }
            }
        }

        Item {
            id: tankBody
            anchors.top: headerCol.bottom
            anchors.bottom: footerCol.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 6
            anchors.bottomMargin: 6

            Rectangle {
                anchors.fill: parent
                radius: root.tankRadius
                color: Theme.dark ? "#10FFFFFF" : "#08000000"
                border.width: root.shellWidth
                border.color: root.activeFocus && root.isInteractive
                              ? Theme.focusOuter
                              : root.trackColor
            }

            // Threshold bands (behind liquid)
            Item {
                id: bands
                anchors.fill: parent
                anchors.margins: root.shellWidth + 1
                visible: root.showThresholdBands
                         && (root.cautionThreshold >= 0 || root.criticalThreshold >= 0)

                function bandY(norm) {
                    return parent.height * (1 - Math.max(0, Math.min(1, norm)))
                }
                function bandX(norm) {
                    return parent.width * Math.max(0, Math.min(1, norm))
                }

                Rectangle {
                    visible: root.criticalThreshold >= 0
                    color: Theme.systemCritical
                    opacity: 0.12
                    x: root.horizontal ? (root.invertThresholds ? 0 : bands.bandX(root.criticalThreshold)) : 0
                    y: root.horizontal ? 0 : (root.invertThresholds ? 0 : bands.bandY(root.criticalThreshold))
                    width: root.horizontal
                           ? (root.invertThresholds
                              ? bands.bandX(root.criticalThreshold)
                              : bands.width - bands.bandX(root.criticalThreshold))
                           : parent.width
                    height: root.horizontal
                            ? parent.height
                            : (root.invertThresholds
                               ? bands.bandY(root.criticalThreshold)
                               : parent.height - bands.bandY(root.criticalThreshold))
                }
                Rectangle {
                    visible: root.cautionThreshold >= 0
                    color: Theme.systemCaution
                    opacity: 0.10
                    x: root.horizontal ? (root.invertThresholds ? 0 : bands.bandX(root.cautionThreshold)) : 0
                    y: root.horizontal ? 0 : (root.invertThresholds ? 0 : bands.bandY(root.cautionThreshold))
                    width: root.horizontal
                           ? (root.invertThresholds
                              ? bands.bandX(root.cautionThreshold)
                              : bands.width - bands.bandX(root.cautionThreshold))
                           : parent.width
                    height: root.horizontal
                            ? parent.height
                            : (root.invertThresholds
                               ? bands.bandY(root.cautionThreshold)
                               : parent.height - bands.bandY(root.cautionThreshold))
                }
            }

            Item {
                anchors.fill: parent
                anchors.margins: root.shellWidth + 1
                clip: true

                Rectangle {
                    id: liquid
                    radius: Math.max(0, root.tankRadius - root.shellWidth - 1)
                    color: root.enabled ? root.effectiveFillColor : Theme.textDisabled
                    opacity: 0.88
                    anchors.left: parent.left
                    anchors.top: root.horizontal ? parent.top : undefined
                    anchors.bottom: parent.bottom
                    width: root.horizontal ? parent.width * root.animatedNorm : parent.width
                    height: root.horizontal ? parent.height : parent.height * root.animatedNorm
                }
            }

            // Level marks
            Repeater {
                model: root.showMarks ? Math.max(2, root.markCount) : 0
                delegate: Rectangle {
                    required property int index
                    readonly property real t: index / Math.max(1, root.markCount - 1)
                    color: Theme.textSecondary
                    opacity: 0.45
                    width: root.horizontal ? 1 : parent.width * 0.28
                    height: root.horizontal ? parent.height * 0.28 : 1
                    x: root.horizontal
                       ? root.shellWidth + 1 + t * (parent.width - 2 * root.shellWidth - 2) - width / 2
                       : parent.width - width - root.shellWidth - 2
                    y: root.horizontal
                       ? root.shellWidth + 2
                       : root.shellWidth + 1 + (1 - t) * (parent.height - 2 * root.shellWidth - 2) - height / 2
                }
            }

            // Target line
            Rectangle {
                visible: root.hasTarget
                color: Theme.textPrimary
                opacity: 0.75
                width: root.horizontal ? 2 : parent.width - 2 * root.shellWidth - 4
                height: root.horizontal ? parent.height - 2 * root.shellWidth - 4 : 2
                x: root.horizontal
                   ? root.shellWidth + 1 + root.targetNorm * (parent.width - 2 * root.shellWidth - 2) - width / 2
                   : root.shellWidth + 2
                y: root.horizontal
                   ? root.shellWidth + 2
                   : root.shellWidth + 1 + (1 - root.targetNorm) * (parent.height - 2 * root.shellWidth - 2) - height / 2
            }

            MouseArea {
                anchors.fill: parent
                enabled: root.isInteractive && root.enabled
                cursorShape: Qt.PointingHandCursor
                function apply(mx, my) {
                    var n = root.horizontal
                            ? Math.max(0, Math.min(1, mx / Math.max(1, width)))
                            : 1 - Math.max(0, Math.min(1, my / Math.max(1, height)))
                    root.setValueFromNorm(n)
                    root.valueEdited(root.value)
                }
                onPressed: function (mouse) { apply(mouse.x, mouse.y) }
                onPositionChanged: function (mouse) {
                    if (pressed)
                        apply(mouse.x, mouse.y)
                }
            }
        }
    }

    background: Item {}
}
