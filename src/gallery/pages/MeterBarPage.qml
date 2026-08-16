import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — MeterBar.
//
// Multi-segment meter with showTotal, remaining space, and segment tooltips. API: docs/components/MeterBar.md

CatalogPage {
    title: qsTr("MeterBar")
    subtitle: qsTr("Multi-segment meter with showTotal, remaining space, and segment tooltips.")

    ControlExample {
        headerText: qsTr("Disk usage")
        qmlSource: "MeterBar {\n    header: \"C:\"\n    showRemaining: true\n    segments: [ ... ]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: meterStatus
                text: qsTr("Hover or click a segment")
                color: Theme.textSecondary
            }
            MeterBar {
                Layout.fillWidth: true
                header: qsTr("Local Disk (C:)")
                maximum: 100
                showLegend: true
                showRemaining: true
                showTotal: true
                remainingLabel: qsTr("Free")
                segments: [
                    { value: 42, color: Theme.accent, label: qsTr("Apps") },
                    { value: 18, color: Theme.systemCaution, label: qsTr("Media") },
                    { value: 12, color: Theme.systemSuccess, label: qsTr("Docs") }
                ]
                onSegmentClicked: function (index, value) {
                    meterStatus.text = qsTr("Segment %1 · %2").arg(index + 1).arg(value)
                }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Compact")
        qmlSource: "MeterBar { trackHeight: 6; segments: [...] }"
        MeterBar {
            Layout.fillWidth: true
            trackHeight: 6
            maximum: 100
            segments: [
                { value: 70, color: Theme.systemCritical },
                { value: 20, color: Theme.systemCaution }
            ]
        }
    }
}
