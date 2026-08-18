import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — DualRingGauge.

CatalogPage {
    title: qsTr("DualRingGauge")
    subtitle: qsTr("Experimental concentric KPI rings. Prefer RingGauge.value2 when scales match.")

    ControlExample {
        headerText: qsTr("CPU + GPU")
        qmlSource: "DualRingGauge {\n    value: 72; value2: 48\n}"
        RowLayout {
            spacing: Theme.spacingSection
            DualRingGauge {
                id: dual
                value: 72
                value2: 48
                title: qsTr("CPU")
                title2: qsTr("GPU")
            }
            ColumnLayout {
                Slider {
                    from: 0
                    to: 100
                    value: dual.value
                    onMoved: dual.setValue(value)
                }
                Slider {
                    from: 0
                    to: 100
                    value: dual.value2
                    onMoved: dual.setValue2(value)
                }
            }
        }
    }
}
