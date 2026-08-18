import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("GMeterGauge")
    subtitle: qsTr("Experimental lateral/longitudinal G plot. Prefer ScatterChart for a generic XY plot.")

    ControlExample {
        headerText: qsTr("G-force")
        qmlSource: "GMeterGauge { lateral: 0.25; longitudinal: -0.1 }"
        RowLayout {
            spacing: Theme.spacingSection
            GMeterGauge {
                id: gmeter
                title: qsTr("G")
                lateral: latSlider.value
                longitudinal: lonSlider.value
            }
            ColumnLayout {
                Slider {
                    id: latSlider
                    from: -1
                    to: 1
                    value: 0.25
                }
                Slider {
                    id: lonSlider
                    from: -1
                    to: 1
                    value: -0.1
                }
            }
        }
    }
}
