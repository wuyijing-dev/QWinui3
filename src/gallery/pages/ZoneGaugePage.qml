import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ZoneGauge.
//
// Drag needle; activeZoneIndex / label; zone colors and ticks. API: docs/components/ZoneGauge.md

CatalogPage {
    title: qsTr("ZoneGauge")
    subtitle: qsTr("Experimental (deferred). Prefer RingGauge. Needle with zone bands.")

    ControlExample {
        headerText: qsTr("Interactive zones")
        qmlSource: "ZoneGauge {\n    isInteractive: true\n    zones: [{ from, to, color, label }]\n}"
        ColumnLayout {
            spacing: Theme.spacingLoose
            Label {
                text: qsTr("Active zone: %1 (%2) — angle %3° — scroll wheel when focused")
                      .arg(temp.activeZoneLabel)
                      .arg(temp.activeZoneIndex)
                      .arg(Math.round(temp.valueAngle))
                color: temp.activeZoneColor
            }
            RowLayout {
                spacing: Theme.spacingSection
                ZoneGauge {
                    id: temp
                    width: 168
                    height: 168
                    title: qsTr("CPU")
                    value: 64
                    unit: "°C"
                    maximum: 100
                    isInteractive: true
                    stepSize: 1
                    showTicks: true
                    tickCount: 9
                    scaleWidth: 16
                    needleLength: 0.72
                    needleWidth: 3
                    valueStringFormat: "N0"
                    minAngle: -210
                    maxAngle: 30
                    zones: [
                        { from: 0, to: 0.55, color: Theme.systemSuccess, label: qsTr("Cool") },
                        { from: 0.55, to: 0.8, color: Theme.systemCaution, label: qsTr("Warm") },
                        { from: 0.8, to: 1.0, color: Theme.systemCritical, label: qsTr("Hot") }
                    ]
                }
                ZoneGauge {
                    width: 148
                    height: 148
                    title: qsTr("Pressure")
                    value: 32
                    maximum: 60
                    unit: " psi"
                    isInteractive: true
                    zones: [
                        { from: 0, to: 0.35, color: Theme.systemCritical, label: qsTr("Low") },
                        { from: 0.35, to: 0.7, color: Theme.systemSuccess, label: qsTr("OK") },
                        { from: 0.7, to: 1.0, color: Theme.systemCaution, label: qsTr("High") }
                    ]
                }
            }
        }
    }
}
