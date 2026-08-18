import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("CoolantGauge")
    subtitle: qsTr("Experimental C–H coolant arc. Prefer ThermometerGauge for a stem-and-bulb scale.")

    ControlExample {
        headerText: qsTr("Temp")
        qmlSource: "CoolantGauge { value: 92; unit: \"°C\" }"
        RowLayout {
            spacing: Theme.spacingSection
            CoolantGauge {
                id: cool
                title: qsTr("Engine")
                value: 92
                isInteractive: true
            }
            Slider {
                from: 50
                to: 130
                value: cool.value
                onMoved: cool.setValue(value)
            }
        }
    }
}
