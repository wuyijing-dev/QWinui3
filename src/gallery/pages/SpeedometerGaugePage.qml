import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("SpeedometerGauge")
    subtitle: qsTr("Experimental vehicle speed needle. Prefer RadialGauge for a generic scale.")

    ControlExample {
        headerText: qsTr("Speed")
        qmlSource: "SpeedometerGauge { value: 86; maximum: 240; unit: \"km/h\" }"
        RowLayout {
            spacing: Theme.spacingSection
            SpeedometerGauge {
                id: speedo
                value: 86
                maximum: 240
                unit: "km/h"
                isInteractive: true
            }
            Slider {
                from: 0
                to: 240
                value: speedo.value
                onMoved: speedo.setValue(value)
            }
        }
    }
}
