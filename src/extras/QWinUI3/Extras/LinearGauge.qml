import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// LinearGauge — Horizontal/vertical track gauge with thresholds.
//
//   LinearGauge { value: 42; minimum: 0; maximum: 100 }

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
    property string unit: ""
    property string caption: ""
    property int valuePrecision: 0
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Horizontal
    property real trackThickness: 8
    property bool showValue: true
    property bool showTicks: true
    property bool showMinMax: false
    // Major tick count
    property int tickCount: 5
    property bool showThumb: true
    property bool isInteractive: false
    property alias interactive: root.isInteractive
    property color fillColor: Theme.accent
    property color trackColor: Theme.strokeDivider
    property real cautionThreshold: -1
    property real criticalThreshold: -1
    // When true, low values map to caution/critical (battery-style).
    property bool invertThresholds: false

    signal valueEdited(real value)

    implicitWidth: orientation === Qt.Horizontal ? 240 : 56
    implicitHeight: {
        var h = orientation === Qt.Horizontal ? 48 : 180
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

    readonly property bool horizontal: orientation === Qt.Horizontal
    readonly property real percentage: animatedNorm * 100
    readonly property color effectiveFillColor: {
        var n = invertThresholds ? (1 - animatedNorm) : animatedNorm
        if (criticalThreshold >= 0 && n >= criticalThreshold)
            return Theme.systemCritical
        if (cautionThreshold >= 0 && n >= cautionThreshold)
            return Theme.systemCaution
        return fillColor
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
            x = lo + steps * stepSize
            x = Math.max(lo, Math.min(hi, x))
        }
        return x
    }

    function setValue(v) {
        value = clampSnap(v)
    }

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
            Layout.preferredWidth: root.horizontal ? -1 : Math.max(28, root.trackThickness + 20)
            Layout.preferredHeight: root.horizontal ? Math.max(28, root.trackThickness + 20) : -1
            Layout.minimumHeight: root.horizontal ? root.trackThickness + 16 : 80

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
                width: root.trackThickness + 10
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
