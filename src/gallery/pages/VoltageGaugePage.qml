import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("VoltageGauge")
    subtitle: qsTr("Experimental 8–16 V electrical bar. Prefer LinearGauge for a generic track.")

    ControlExample {
        headerText: qsTr("Battery")
        qmlSource: "VoltageGauge { value: 13.8; unit: \"V\" }"
        ColumnLayout {
            spacing: Theme.spacing
            VoltageGauge {
                id: volt
                title: qsTr("Batt")
                value: 13.8
                isInteractive: true
                Layout.fillWidth: true
            }
            Slider {
                from: 8
                to: 16
                value: volt.value
                onMoved: volt.setValue(value)
            }
        }
    }
}
