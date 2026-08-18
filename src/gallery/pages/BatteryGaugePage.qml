import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — BatteryGauge.

CatalogPage {
    title: qsTr("BatteryGauge")
    subtitle: qsTr("Experimental battery silhouette. Prefer RingGauge for a generic closed ring.")

    ControlExample {
        headerText: qsTr("Charge")
        qmlSource: "BatteryGauge {\n    value: 28; charging: false\n}"
        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                spacing: Theme.spacingSection
                BatteryGauge {
                    id: batt
                    title: qsTr("Pack")
                    value: 28
                    charging: chargeBox.checked
                }
                BatteryGauge {
                    title: qsTr("Full")
                    value: 92
                }
                BatteryGauge {
                    title: qsTr("Critical")
                    value: 8
                }
            }
            CheckBox {
                id: chargeBox
                text: qsTr("Charging")
            }
            Slider {
                from: 0
                to: 100
                value: batt.value
                onMoved: batt.setValue(value)
            }
        }
    }
}
