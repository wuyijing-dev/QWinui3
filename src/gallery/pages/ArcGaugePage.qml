import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ArcGauge.
//
// Drag the arc; invertThresholds for battery-style low=critical. API: docs/components/ArcGauge.md

CatalogPage {
    title: qsTr("ArcGauge")
    subtitle: qsTr("Drag the arc; invertThresholds for battery-style low=critical.")

    ControlExample {
        headerText: qsTr("Interactive arcs")
        qmlSource: "ArcGauge {\n    isInteractive: true\n    invertThresholds: true\n}"
        ColumnLayout {
            spacing: Theme.spacingLoose
            RowLayout {
                spacing: Theme.spacingSection
                ArcGauge {
                    id: arc
                    width: 180
                    height: 140
                    title: qsTr("Battery")
                    value: 76
                    unit: "%"
                    isInteractive: true
                    showMinMax: true
                    invertThresholds: true
                    cautionThreshold: 0.55
                    criticalThreshold: 0.8
                    fillColor: Theme.systemSuccess
                    caption: qsTr("Remaining")
                }
                ArcGauge {
                    width: 160
                    height: 130
                    title: qsTr("Upload")
                    value: 42
                    unit: " Mbps"
                    isInteractive: true
                    stepSize: 1
                    fillColor: Theme.accent
                    caption: qsTr("Link speed")
                }
            }
        }
    }
}
