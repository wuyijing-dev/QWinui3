import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Extras

// BulletChart — Compact KPI bullet (ranges + performance + target).
//
//   BulletChart {
//       id: bulletChart
//       value: 70; target: 80; maximum: 100
//   }
//
//   // --- API ---
//   // methods: setValue(v), bandColor(index)
//   // bulletChart.setValue(v)
//   // bulletChart.bandColor(index)
//
// @notes
//   KPI bullet: qualitative bands + performance value + target marker.
//   setValue(v) clamps into range; bandColor(index) for band fills.

T.Control {
    id: root

    // Current value
    property real value: 0
    // Anchor item for placement
    property real target: 0
    // Maximum value
    property real maximum: 100
    // Minimum value
    property real minimum: 0
    // Bullet qualitative ranges
    property var ranges: [0.5, 0.75, 1.0]
    // Colors for bullet ranges
    property var rangeColors: []
    // Field label
    property string label: ""
    // Value unit label (%, rpm, …)
    property string unit: ""
    // Digits after decimal for value text
    property int valuePrecision: -1 // -1 = auto
    // Show value as text
    property bool showValueText: true
    // Show target marker
    property bool showTarget: true
    // Show delta vs target
    property bool showTargetDelta: false

    implicitWidth: 240
    implicitHeight: label.length || showValueText ? 40 : 18
    padding: 0
    Accessible.role: Accessible.ProgressBar
    Accessible.name: label.length ? label : qsTr("Bullet chart")
    Accessible.description: qsTr("%1 of %2").arg(Math.round(value)).arg(Math.round(maximum))

    readonly property real _span: Math.max(1e-6, maximum - minimum)
    readonly property real _norm: Math.max(0, Math.min(1, (value - minimum) / _span))
    readonly property real _targetNorm: Math.max(0, Math.min(1, (target - minimum) / _span))
    // True when value meets target
    readonly property bool targetMet: value >= target
    // Value minus target
    readonly property real targetDelta: value - target

    // Formatted value string
    readonly property string formattedValue: {
        var n = Number(value)
        var prec = valuePrecision
        if (prec < 0)
            prec = (n % 1 === 0) ? 0 : 1
        return n.toFixed(prec) + (unit.length ? unit : "")
    }

    // Formatted target delta text
    readonly property string formattedDelta: {
        var d = targetDelta
        var prec = valuePrecision < 0 ? 0 : valuePrecision
        var s = (d >= 0 ? "+" : "") + d.toFixed(prec)
        return s + (unit.length ? unit : "")
    }

    // Set value (clamped / snapped)
    function setValue(v) {
        value = Math.max(minimum, Math.min(maximum, Number(v) || 0))
    }

    // Color for a qualitative band
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
                width: parent.width - valueLabel.width - (deltaLabel.visible ? deltaLabel.width + 8 : 0)
                text: root.label
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                elide: Text.ElideRight
            }
            Text {
                id: deltaLabel
                visible: root.showTargetDelta
                text: root.formattedDelta
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: root.targetMet ? Theme.systemSuccess : Theme.systemCritical
                rightPadding: 8
            }
            Text {
                id: valueLabel
                visible: root.showValueText
                text: root.formattedValue
                font.pixelSize: Theme.fontCaption
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
        }

        Item {
            id: track
            width: parent.width
            height: 14

            Row {
                anchors.fill: parent
                spacing: 0
                Repeater {
                    model: root.ranges
                    Rectangle {
                        required property int index
                        required property var modelData
                        // Previous animated value
                        property real prev: index === 0 ? 0 : Number(root.ranges[index - 1])
                        // Current animated value
                        property real cur: Number(modelData)
                        width: Math.max(0, (cur - prev) * track.width)
                        height: parent.height
                        color: root.bandColor(index)
                        radius: index === 0 || index === root.ranges.length - 1 ? 2 : 0
                    }
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height: 6
                radius: 2
                width: Math.max(2, root._norm * parent.width)
                color: root.targetMet ? Theme.systemSuccess : Theme.accent
                Behavior on width {
                    enabled: !Theme.reducedMotion
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionSlow)
                        easing.type: Theme.easingStandard
                    }
                }
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation { duration: Theme.duration(Theme.motionNormal) }
                }
            }

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
