import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ThermometerGauge.
//
// Stem + bulb; drag to set; thresholds tint mercury. API: docs/components/ThermometerGauge.md

CatalogPage {
    title: qsTr("ThermometerGauge")
    subtitle: qsTr("Classic stem + bulb; drag to set; thresholds tint the mercury.")

    ControlExample {
        headerText: qsTr("Temperature")
        qmlSource: "ThermometerGauge {\n    value: 36.5\n    unit: \"°C\"\n    isInteractive: true\n}"
        RowLayout {
            spacing: Theme.spacingSection
            ThermometerGauge {
                Layout.preferredWidth: 110
                Layout.preferredHeight: 240
                title: qsTr("Ambient")
                value: 36.5
                minimum: 0
                maximum: 50
                unit: "°C"
                target: 22
                showTickLabels: true
                isInteractive: true
                showTicks: true
                showMinMax: true
                cautionThreshold: 0.7
                criticalThreshold: 0.85
                caption: qsTr("Room")
            }
            ThermometerGauge {
                Layout.preferredWidth: 88
                Layout.preferredHeight: 240
                title: qsTr("CPU die")
                value: 72
                minimum: 20
                maximum: 100
                unit: "°C"
                valuePrecision: 0
                isInteractive: true
                fillColor: Theme.systemCaution
                cautionThreshold: 0.65
                criticalThreshold: 0.8
                caption: qsTr("Package")
            }
            ThermometerGauge {
                Layout.preferredWidth: 88
                Layout.preferredHeight: 240
                title: qsTr("Cold chain")
                value: -12
                minimum: -40
                maximum: 10
                unit: "°C"
                valuePrecision: 0
                isInteractive: true
                invertThresholds: true
                cautionThreshold: 0.45
                criticalThreshold: 0.7
                fillColor: Theme.accent
                caption: qsTr("Freezer")
            }
        }
    }
}
