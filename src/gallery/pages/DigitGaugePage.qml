import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    id: page
    title: qsTr("DigitGauge")
    subtitle: qsTr("Experimental seven-segment readout. Prefer KpiTile for dashboard text.")

    property real rpm: 3210

    Timer {
        interval: 400
        running: page.visible
        repeat: true
        onTriggered: page.rpm = 2800 + Math.round(Math.random() * 900)
    }

    ControlExample {
        headerText: qsTr("Readout")
        qmlSource: "DigitGauge { value: 42.8; digits: 4; valuePrecision: 1 }"
        RowLayout {
            spacing: Theme.spacingSection
            DigitGauge {
                title: qsTr("RPM")
                value: page.rpm
                digits: 4
                unit: "rpm"
            }
            DigitGauge {
                title: qsTr("Temp")
                value: 36.6
                digits: 4
                valuePrecision: 1
                unit: "°C"
                fillColor: Theme.systemCaution
            }
        }
    }
}
