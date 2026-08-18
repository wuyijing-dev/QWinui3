import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("TpmsGauge")
    subtitle: qsTr("Experimental four-corner tire pressure. Prefer KpiTile for a single pressure KPI.")

    ControlExample {
        headerText: qsTr("Tires")
        qmlSource: "TpmsGauge { fl: 2.3; fr: 2.3; rl: 2.4; rr: 2.1 }"
        ColumnLayout {
            spacing: Theme.spacing
            TpmsGauge {
                id: tpms
                title: qsTr("TPMS")
                fl: 2.3
                fr: 2.3
                rl: 2.4
                rr: rrSlider.value
            }
            Slider {
                id: rrSlider
                from: 1.4
                to: 3.2
                value: 2.1
            }
        }
    }
}
