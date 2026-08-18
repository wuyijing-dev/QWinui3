import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("QuarterGauge")
    subtitle: qsTr("Experimental 90° quadrant meter. Prefer RadialGauge for a full needle scale.")

    ControlExample {
        headerText: qsTr("Load")
        qmlSource: "QuarterGauge { value: 72; unit: \"%\" }"
        RowLayout {
            spacing: Theme.spacingSection
            QuarterGauge {
                id: qg
                title: qsTr("CPU")
                value: 72
                unit: "%"
                isInteractive: true
            }
            Slider {
                from: 0
                to: 100
                value: qg.value
                onMoved: qg.setValue(value)
            }
        }
    }
}
