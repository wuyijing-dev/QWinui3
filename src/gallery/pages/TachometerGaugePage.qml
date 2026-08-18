import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TachometerGauge.

CatalogPage {
    title: qsTr("TachometerGauge")
    subtitle: qsTr("Experimental RPM needle with a redline band. Prefer RadialGauge for generic scales.")

    ControlExample {
        headerText: qsTr("Engine")
        qmlSource: "TachometerGauge {\n    value: 4200; redline: 6500\n}"
        RowLayout {
            spacing: Theme.spacingSection
            TachometerGauge {
                id: tacho
                value: 4200
                maximum: 8000
                redline: 6500
                title: qsTr("RPM")
                isInteractive: true
            }
            Slider {
                from: 0
                to: 8000
                value: tacho.value
                onMoved: tacho.setValue(value)
            }
        }
    }
}
