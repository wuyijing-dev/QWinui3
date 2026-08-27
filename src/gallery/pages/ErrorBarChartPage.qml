import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

CatalogPage {
    title: qsTr("ErrorBarChart")
    subtitle: qsTr("Experimental mean ± error. Prefer BoxPlotChart when you have the raw samples.")

    ControlExample {
        headerText: qsTr("Region mean")
        qmlSource: "ErrorBarChart {\n    points: [{ value: 42, error: 4 }]\n}"
        ErrorBarChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 220
            title: qsTr("p95")
            points: [
                { label: qsTr("East"), value: 42, error: 4 },
                { label: qsTr("West"), value: 31, low: 26, high: 38 },
                { label: qsTr("EU"), value: 36, error: 3.5 },
                { label: qsTr("APAC"), value: 51, error: 6 }
            ]
        }
    }
}
