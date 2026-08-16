import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// LinearGauge — Horizontal/vertical track gauge with thresholds.
//
//   LinearGauge {
//       id: linearGauge
//       value: 42; minimum: 0; maximum: 100
//   }
//
//   // --- API ---
//   // signals: onValueEdited
//   // methods: clampSnap(v), setValue(v), setValueFromNorm(n)
//   // linearGauge.clampSnap(v)
//   // linearGauge.setValue(v)
//   // linearGauge.setValueFromNorm(n)
//
// @notes
//   Horizontal/vertical bar gauge; same value/min/max + zone patterns as radial.

T.Control {
    id: root

    // Current value
    property real value: 0
    // Minimum value
    property real minimum: 0
    // Maximum value
    property real maximum: 100
    // Value step (e.g. 0.5 for half stars)
    property real stepSize: 0
    // Primary title text
    property string title: ""
    // Value unit label (%, rpm, …)
    property string unit: ""
    // Caption under / beside the value
    property string caption: ""
    // Digits after decimal for value text
    property int valuePrecision: 0
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Horizontal
    // Track thickness in px
    property real trackThickness: 8
    // Show numeric value label
    property bool showValue: true
    // Show tick marks
    property bool showTicks: true
    // Show min/max labels
    property bool showMinMax: false
    // Major tick count
    property int tickCount: 5
    // Show draggable thumb
    property bool showThumb: true
    // Extra hit padding around the track for easier drag (px)
    property real interactionPadding: 20
    // Alias of interactive
    property bool isInteractive: false
    // Enable hover / click interaction
    property alias interactive: root.isInteractive
    // Primary fill / progress color
    property color fillColor: Theme.accent
    // Track / remaining color
    property color trackColor: Theme.strokeDivider
    // Value where caution zone starts
    property real cautionThreshold: -1
    // Value where critical zone starts
    property real criticalThreshold: -1
    // When true, low values map to caution/critical (battery-style).
    property bool invertThresholds: false

    // Emitted when user commits a value
    signal valueEdited(real value)

    implicitWidth: orientation === Qt.Horizontal ? 240 : 64
    implicitHeight: {
        var h = orientation === Qt.Horizontal ? 64 : 180
        if (title.length || showValue)
            h += Theme.fontCaption + 8
        if (caption.length || showMinMax)
            h += Theme.fontCaption + 4
        return h
    }
    padding: 4
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: Accessible.Slider
    Accessible.name: title.length ? title : qsTr("Linear gauge")
    Accessible.description: formattedValue

    // Horizontal orientation when true
    readonly property bool horizontal: orientation === Qt.Horizontal
    // Value as 0..100 percentage
    readonly property real percentage: animatedNorm * 100
    // Resolved fill color
    readonly property color effectiveFillColor: {
        var n = invertThresholds ? (1 - animatedNorm) : animatedNorm
        if (criticalThreshold >= 0 && n >= criticalThreshold)
            return Theme.systemCritical
        if (cautionThreshold >= 0 && n >= cautionThreshold)
            return Theme.systemCaution
        return fillColor
    }

    // Formatted value string
    readonly property string formattedValue: {
        var n = Number(animatedValue)
        var t = valuePrecision > 0 ? n.toFixed(valuePrecision) : String(Math.round(n))
        return t + (unit.length ? unit : "")
    }

    // Animated display value
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

    // Animated 0..1 normalized value
    readonly property real animatedNorm: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (animatedValue - minimum) / span))
    }

    // Clamp and snap a value to the valid range
    function clampSnap(v) {
        var lo = Math.min(minimum, maximum)
        var hi = Math.max(minimum, maximum)
        var x = Math.max(lo, Math.min(hi, Number(v) || 0))
        if (stepSize > 0) {
            var steps = Math.round((x - lo) / stepSize)
            x = lo + steps * stepSize
            x = Math.max(lo, Math.min(hi, x))
        }
        return x
    }

    // Set value
    function setValue(v) {
        value = clampSnap(v)
    }

    // Set value from norm
    function setValueFromNorm(n) {
        var span = maximum - minimum
        setValue(minimum + Math.max(0, Math.min(1, n)) * span)
    }

    Keys.onLeftPressed: if (isInteractive && horizontal) {
        setValue(value - (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }
    Keys.onRightPressed: if (isInteractive && horizontal) {
        setValue(value + (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }
    Keys.onDownPressed: if (isInteractive && !horizontal) {
        setValue(value - (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }
    Keys.onUpPressed: if (isInteractive && !horizontal) {
        setValue(value + (stepSize > 0 ? stepSize : (maximum - minimum) * 0.05))
        valueEdited(value)
    }

    function _stepAmount() {
        return stepSize > 0 ? stepSize : (maximum - minimum) * 0.05
    }

    WheelHandler {
        enabled: root.isInteractive && root.enabled
        onWheel: function (event) {
            var dir = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
            if (dir === 0)
                return
            root.setValue(root.value + (dir > 0 ? root._stepAmount() : -root._stepAmount()))
            root.valueEdited(root.value)
            event.accepted = true
        }
    }

    contentItem: ColumnLayout {
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            visible: root.title.length > 0 || root.showValue
            spacing: Theme.spacing
            Text {
                visible: root.title.length > 0
                Layout.fillWidth: true
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textSecondary
                elide: Text.ElideRight
            }
            Text {
                visible: root.showValue
                text: root.formattedValue
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
        }

            Item {
            id: trackHost
            Layout.fillWidth: root.horizontal
            Layout.fillHeight: !root.horizontal
            Layout.preferredWidth: root.horizontal ? -1
                                 : Math.max(44, root.trackThickness + root.interactionPadding * 2)
            Layout.preferredHeight: root.horizontal
                                    ? Math.max(44, root.trackThickness + root.interactionPadding * 2)
                                    : -1
            Layout.minimumHeight: root.horizontal
                                  ? root.trackThickness + root.interactionPadding * 2
                                  : 80
            Layout.minimumWidth: root.horizontal ? 80
                               : root.trackThickness + root.interactionPadding * 2

            // Caution / critical zone markers on track
            Rectangle {
                id: track
                anchors.centerIn: parent
                width: root.horizontal ? parent.width : root.trackThickness
                height: root.horizontal ? root.trackThickness : parent.height
                radius: root.trackThickness / 2
                color: root.trackColor
                clip: true

                Rectangle {
                    visible: root.cautionThreshold >= 0 && !root.invertThresholds
                    anchors.right: parent.right
                    anchors.verticalCenter: root.horizontal ? parent.verticalCenter : undefined
                    anchors.top: root.horizontal ? undefined : parent.top
                    anchors.horizontalCenter: root.horizontal ? undefined : parent.horizontalCenter
                    width: root.horizontal
                           ? parent.width * (1 - root.cautionThreshold)
                           : root.trackThickness
                    height: root.horizontal
                            ? root.trackThickness
                            : parent.height * (1 - root.cautionThreshold)
                    color: ChartUtils.withAlpha(Theme.systemCaution, 0.2)
                }

                Rectangle {
                    anchors.left: root.horizontal ? parent.left : undefined
                    anchors.bottom: root.horizontal ? undefined : parent.bottom
                    anchors.verticalCenter: root.horizontal ? parent.verticalCenter : undefined
                    anchors.horizontalCenter: root.horizontal ? undefined : parent.horizontalCenter
                    width: root.horizontal ? Math.max(root.trackThickness, parent.width * root.animatedNorm)
                                           : root.trackThickness
                    height: root.horizontal ? root.trackThickness
                                            : Math.max(root.trackThickness, parent.height * root.animatedNorm)
                    radius: root.trackThickness / 2
                    color: root.enabled ? root.effectiveFillColor : Theme.textDisabled
                }
            }

            Repeater {
                model: root.showTicks ? root.tickCount : 0
                Rectangle {
                    required property int index
                    width: root.horizontal ? 2 : 6
                    height: root.horizontal ? 6 : 2
                    radius: 1
                    color: Theme.textSecondary
                    opacity: 0.45
                    // Normalized 0..1 parameter
                    readonly property real t: index / Math.max(1, root.tickCount - 1)
                    x: root.horizontal
                       ? track.x + t * track.width - width / 2
                       : track.x + track.width + 4
                    y: root.horizontal
                       ? track.y + track.height + 4
                       : track.y + (1 - t) * track.height - height / 2
                }
            }

            Rectangle {
                visible: root.showThumb
                width: Math.max(root.trackThickness + 14, 28)
                height: width
                radius: width / 2
                color: Theme.bgCard
                border.width: root.activeFocus && root.isInteractive ? 2 : 2
                border.color: root.activeFocus && root.isInteractive
                              ? Theme.focusOuter
                              : (root.enabled ? root.effectiveFillColor : Theme.textDisabled)
                scale: drag.pressed && !Theme.reducedMotion ? 1.08 : 1
                x: root.horizontal
                   ? track.x + root.animatedNorm * track.width - width / 2
                   : track.x + track.width / 2 - width / 2
                y: root.horizontal
                   ? track.y + track.height / 2 - height / 2
                   : track.y + (1 - root.animatedNorm) * track.height - height / 2
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }

            MouseArea {
                id: drag
                anchors.fill: parent
                enabled: root.isInteractive && root.enabled
                hoverEnabled: true
                preventStealing: true
                cursorShape: Qt.PointingHandCursor
                function apply(px, py) {
                    var n = root.horizontal
                            ? (px - track.x) / Math.max(1, track.width)
                            : 1 - (py - track.y) / Math.max(1, track.height)
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

        RowLayout {
            Layout.fillWidth: true
            visible: root.showMinMax || root.caption.length > 0
            Text {
                visible: root.showMinMax
                text: valuePrecision > 0 ? Number(root.minimum).toFixed(valuePrecision)
                                         : String(Math.round(root.minimum))
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                visible: root.caption.length > 0
                text: root.caption
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                horizontalAlignment: root.showMinMax ? Text.AlignHCenter : Text.AlignLeft
            }
            Text {
                visible: root.showMinMax
                text: valuePrecision > 0 ? Number(root.maximum).toFixed(valuePrecision)
                                         : String(Math.round(root.maximum))
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }
    }

    background: Item {}
}
