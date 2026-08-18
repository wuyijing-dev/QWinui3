import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("OdometerGauge")
    subtitle: qsTr("Experimental total and trip distance. Prefer DigitGauge for a generic numeric face.")

    ControlExample {
        headerText: qsTr("Distance")
        qmlSource: "OdometerGauge { totalKm: 12480.3; tripKm: 36.2 }"
        ColumnLayout {
            spacing: Theme.spacing
            OdometerGauge {
                id: odo
                title: qsTr("Cluster")
                totalKm: 12480.3
                tripKm: 36.2
                Layout.fillWidth: true
            }
            Slider {
                from: 0
                to: 250
                value: odo.tripKm
                onMoved: odo.setTrip(value)
            }
            Button {
                text: qsTr("Reset trip")
                onClicked: odo.resetTrip()
            }
        }
    }
}
