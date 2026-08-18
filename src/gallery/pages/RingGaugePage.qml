import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RingGauge.
//
// Closed KPI ring; drag when interactive; thresholds tint the stroke. API: docs/components/RingGauge.md

CatalogPage {
    title: qsTr("RingGauge")
    subtitle: qsTr("Stable (1.23). Closed KPI ring; drag when interactive — docs/charts.md.")

    ControlExample {
        headerText: qsTr("Interactive rings")
        qmlSource: "RingGauge {\n    isInteractive: true\n    target: 80\n    cautionThreshold: 0.7\n}"
        ColumnLayout {
            spacing: Theme.spacingLoose
            RowLayout {
                spacing: Theme.spacingSection
                RingGauge {
                    id: cpuRing
                    width: 160
                    height: 160
                    title: qsTr("CPU")
                    value: 72
                    unit: "%"
                    target: 80
                    showTarget: true
                    showGlow: true
                    showThumb: true
                    isInteractive: true
                    cautionThreshold: 0.7
                    criticalThreshold: 0.9
                    caption: qsTr("Host A")
                    value2: 48
                    fillColor2: Theme.systemCaution
                }
                RingGauge {
                    width: 148
                    height: 148
                    title: qsTr("Battery")
                    value: 28
                    unit: "%"
                    isInteractive: true
                    invertThresholds: true
                    cautionThreshold: 0.55
                    criticalThreshold: 0.8
                    fillColor: Theme.systemSuccess
                    sweepTotal: 360
                    showGlow: false
                    caption: qsTr("Remaining")
                }
            }
            Label {
                text: qsTr("CPU severity %1 — scroll wheel or nudge; target marker at 80%")
                      .arg(cpuRing.severity)
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Nudge −5")
                    onClicked: cpuRing.nudge(-5)
                }
                Button {
                    text: qsTr("Nudge +5")
                    onClicked: cpuRing.nudge(5)
                }
                Button {
                    text: qsTr("Set 95")
                    onClicked: cpuRing.setValue(95)
                }
            }
        }
    }
}
