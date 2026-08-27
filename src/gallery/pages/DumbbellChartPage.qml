import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

CatalogPage {
    title: qsTr("DumbbellChart")
    subtitle: qsTr("Experimental before/after pairs. Prefer BarChart.series for more than two states.")

    ControlExample {
        headerText: qsTr("This week vs last")
        qmlSource: "DumbbellChart {\n    pairs: [{ label: \"East\", from: 42, to: 58 }]\n}"
        DumbbellChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 240
            title: qsTr("NPS")
            fromName: qsTr("Last")
            toName: qsTr("Now")
            pairs: [
                { label: qsTr("East"), from: 42, to: 58 },
                { label: qsTr("West"), from: 31, to: 29 },
                { label: qsTr("EU"), from: 50, to: 61 },
                { label: qsTr("APAC"), from: 22, to: 40 }
            ]
        }
    }
}
