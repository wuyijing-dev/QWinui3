import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Compact KPI bullet chart (qualitative ranges + performance + target).
T.Control {
    id: root

    property real value: 0
    property real target: 0
    property real maximum: 100
    property real minimum: 0
    // Qualitative bands as fractions of maximum, e.g. [0.5, 0.75, 1]
    property var ranges: [0.5, 0.75, 1.0]
    property var rangeColors: []
    property string label: ""
    property string unit: ""
    property int valuePrecision: -1 // -1 = auto
    property bool showValueText: true
    property bool showTarget: true

    implicitWidth: 240
    implicitHeight: label.length || showValueText ? 40 : 18
    padding: 0

    readonly property real _span: Math.max(1e-6, maximum - minimum)
    readonly property real _norm: Math.max(0, Math.min(1, (value - minimum) / _span))
    readonly property real _targetNorm: Math.max(0, Math.min(1, (target - minimum) / _span))

    readonly property string formattedValue: {
        var n = Number(value)
        var prec = valuePrecision
        if (prec < 0)
            prec = (n % 1 === 0) ? 0 : 1
        return n.toFixed(prec) + (unit.length ? unit : "")
    }

    function setValue(v) {
        value = Math.max(minimum, Math.min(maximum, Number(v) || 0))
    }

    function bandColor(index) {
        if (rangeColors && rangeColors.length > index)
            return rangeColors[index]
        var defaults = [
            Theme.systemCriticalBg,
            Theme.systemCautionBg,
            Theme.systemSuccessBg
        ]
        return defaults[Math.min(index, defaults.length - 1)]
    }

    contentItem: Column {
        spacing: 4

        Row {
            visible: root.label.length > 0 || root.showValueText
            width: parent.width
            Text {
                width: parent.width - valueLabel.width
                text: root.label
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                elide: Text.ElideRight
            }
            Text {
                id: valueLabel
                visible: root.showValueText
                text: root.formattedValue
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
        }

        Item {
            id: track
            width: parent.width
            height: 14

            // Qualitative ranges
            Row {
                anchors.fill: parent
                spacing: 0
                Repeater {
                    model: root.ranges
                    Rectangle {
                        required property int index
                        required property var modelData
                        property real prev: index === 0 ? 0 : Number(root.ranges[index - 1])
                        property real cur: Number(modelData)
                        width: Math.max(0, (cur - prev) * track.width)
                        height: parent.height
                        color: root.bandColor(index)
                        radius: index === 0 || index === root.ranges.length - 1 ? 2 : 0
                    }
                }
            }

            // Performance bar
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height: 6
                radius: 2
                width: Math.max(2, root._norm * parent.width)
                color: Theme.accent
                Behavior on width {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionSlow)
                        easing.type: Theme.easingStandard
                    }
                }
            }

            // Target marker
            Rectangle {
                visible: root.showTarget && root.target !== undefined && root.target !== null
                anchors.verticalCenter: parent.verticalCenter
                x: root._targetNorm * parent.width - width * 0.5
                width: 3
                height: parent.height
                radius: 1
                color: Theme.textPrimary
                Behavior on x {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionNormal)
                        easing.type: Theme.easingStandard
                    }
                }
            }
        }
    }

    background: Item {}
}
