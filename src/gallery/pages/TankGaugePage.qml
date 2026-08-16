import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TankGauge.
//
// Vertical level fill; invertThresholds for low=critical. API: docs/components/TankGauge.md

CatalogPage {
    title: qsTr("TankGauge")
    subtitle: qsTr("Vertical tank level; drag to set; invertThresholds for low=critical.")

    ControlExample {
        headerText: qsTr("Reservoir levels")
        qmlSource: "TankGauge {\n    isInteractive: true\n    invertThresholds: true\n}"
        RowLayout {
            spacing: Theme.spacingSection
            TankGauge {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 220
                title: qsTr("Coolant")
                value: 64
                unit: "%"
                target: 50
                showMarks: true
                showThresholdBands: true
                isInteractive: true
                showMinMax: true
                invertThresholds: true
                cautionThreshold: 0.45
                criticalThreshold: 0.7
                fillColor: Theme.accent
                caption: qsTr("Loop A")
            }
            TankGauge {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 220
                title: qsTr("Fuel")
                value: 22
                unit: "%"
                isInteractive: true
                invertThresholds: true
                cautionThreshold: 0.4
                criticalThreshold: 0.75
                fillColor: Theme.systemCaution
                caption: qsTr("Primary")
            }
            TankGauge {
                Layout.preferredWidth: 220
                Layout.preferredHeight: 100
                Layout.alignment: Qt.AlignBottom
                orientation: Qt.Horizontal
                title: qsTr("Buffer")
                value: 88
                unit: "%"
                target: 70
                showMarks: true
                isInteractive: true
                cautionThreshold: 0.75
                criticalThreshold: 0.92
                fillColor: Theme.systemSuccess
                caption: qsTr("Queue")
            }
        }
    }
}
