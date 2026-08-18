import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — BoxPlotChart.

CatalogPage {
    title: qsTr("BoxPlotChart")
    subtitle: qsTr("Experimental Tukey boxes. Pass values[] or precomputed min/q1/median/q3/max.")

    ControlExample {
        headerText: qsTr("Latency by region")
        qmlSource: "BoxPlotChart {\n    groups: [{ label: \"A\", values: […] }]\n}"
        BoxPlotChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 240
            title: qsTr("ms")
            groups: [
                { label: qsTr("East"), values: [38, 40, 42, 44, 48, 52, 61] },
                { label: qsTr("West"), values: [28, 31, 33, 36, 39, 41, 55] },
                { label: qsTr("EU"), min: 22, q1: 30, median: 35, q3: 44, max: 70 },
                { label: qsTr("APAC"), values: [45, 48, 50, 54, 58, 62, 80] }
            ]
        }
    }
}
