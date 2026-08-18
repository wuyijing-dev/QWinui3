import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// VuMeter — Linear LED / peak-hold meter (audio, signal, load).
//
//   VuMeter { value: 0.72; peakHold: true }
//
// @notes
//   Experimental. Prefer LinearGauge for a single analog track.
//   SegmentedGauge is the circular LED sibling.

T.Control {
    id: root

    Accessible.role: Accessible.ProgressBar
    Accessible.name: title.length ? title : qsTr("VU meter")

    // Current level 0…maximum
    property real value: 0
    // Minimum value
    property real minimum: 0
    // Maximum value
    property real maximum: 1
    // LED segment count
    property int segmentCount: 16
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Vertical
    // Primary title text
    property string title: ""
    property string unit: ""
    property bool peakHold: true
    property int peakHoldMs: 800
    property real cautionThreshold: 0.75
    property real criticalThreshold: 0.9
    property bool isInteractive: false
    property alias interactive: root.isInteractive

    signal valueEdited(real value)

    implicitWidth: orientation === Qt.Vertical ? 56 : 220
    implicitHeight: orientation === Qt.Vertical ? 180 : 48

    readonly property real normalized: {
        var span = maximum - minimum
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (value - minimum) / span))
    }

    property real peakNorm: 0

    onNormalizedChanged: {
        if (normalized >= peakNorm)
            peakNorm = normalized
        else if (peakHold)
            peakDecay.restart()
        else
            peakNorm = normalized
    }

    Timer {
        id: peakDecay
        interval: root.peakHoldMs
        repeat: false
        onTriggered: root.peakNorm = root.normalized
    }

    function setValue(v) {
        var lo = Math.min(minimum, maximum)
        var hi = Math.max(minimum, maximum)
        value = Math.max(lo, Math.min(hi, Number(v) || 0))
    }

    contentItem: ColumnLayout {
        spacing: 4
        Text {
            visible: root.title.length > 0
            text: root.title
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            Layout.alignment: Qt.AlignHCenter
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Grid {
                id: grid
                anchors.fill: parent
                rows: root.orientation === Qt.Vertical ? root.segmentCount : 1
                columns: root.orientation === Qt.Vertical ? 1 : root.segmentCount
                spacing: 2
                Repeater {
                    model: root.segmentCount
                    delegate: Rectangle {
                        required property int index
                        readonly property int led: root.orientation === Qt.Vertical
                                                   ? (root.segmentCount - 1 - index) : index
                        readonly property real t: (led + 0.5) / root.segmentCount
                        width: root.orientation === Qt.Vertical
                               ? grid.width : Math.max(2, (grid.width - (root.segmentCount - 1) * grid.spacing) / root.segmentCount)
                        height: root.orientation === Qt.Vertical
                                ? Math.max(2, (grid.height - (root.segmentCount - 1) * grid.spacing) / root.segmentCount)
                                : grid.height
                        radius: 2
                        color: {
                            var on = root.normalized >= t || Math.abs(root.peakNorm - t) < (0.6 / root.segmentCount)
                            if (!on)
                                return Theme.fillSubtle
                            if (t >= root.criticalThreshold)
                                return Theme.systemCritical
                            if (t >= root.cautionThreshold)
                                return Theme.systemCaution
                            return Theme.systemSuccess
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.isInteractive
                onPressed: function (mouse) { apply(mouse) }
                onPositionChanged: function (mouse) { if (pressed) apply(mouse) }
                function apply(mouse) {
                    var n = root.orientation === Qt.Vertical
                            ? 1 - mouse.y / Math.max(1, height)
                            : mouse.x / Math.max(1, width)
                    root.setValue(root.minimum + Math.max(0, Math.min(1, n)) * (root.maximum - root.minimum))
                    root.valueEdited(root.value)
                }
            }
        }
        Text {
            visible: root.unit.length > 0
            text: (root.normalized * 100).toFixed(0) + root.unit
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            Layout.alignment: Qt.AlignHCenter
        }
    }

    background: Item {}
}
