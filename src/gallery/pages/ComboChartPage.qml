import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

// Gallery — ComboChart (volume bars + overlay line).

CatalogPage {
    title: qsTr("ComboChart")
    subtitle: qsTr("Experimental dual-axis bars + line. Not part of the stable six.")

    ControlExample {
        headerText: qsTr("Volume vs price")
        qmlSource: "ComboChart {\n    bars: [12, 18, 9, 22]\n    line: [40, 42, 38, 51]\n}"
        ComboChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 240
            title: qsTr("Session")
            barName: qsTr("Volume")
            lineName: qsTr("VWAP")
            barUnit: "k"
            lineUnit: ""
            labels: ["09", "10", "11", "12", "13", "14", "15"]
            bars: [18, 24, 16, 31, 22, 19, 14]
            line: [101, 103, 99, 108, 106, 110, 107]
        }
    }
}
