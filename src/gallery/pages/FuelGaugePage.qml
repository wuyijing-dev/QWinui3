import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("FuelGauge")
    subtitle: qsTr("Experimental E–F arc. Prefer RingGauge for a generic closed ring.")

    ControlExample {
        headerText: qsTr("Tank")
        qmlSource: "FuelGauge { value: 0.28; isInteractive: true }"
        RowLayout {
            spacing: Theme.spacingSection
            FuelGauge {
                id: fuel
                title: qsTr("Main")
                value: 0.28
                isInteractive: true
            }
            Slider {
                from: 0
                to: 1
                value: fuel.value
                onMoved: fuel.setValue(value)
            }
        }
    }
}
