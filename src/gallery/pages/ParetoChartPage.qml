import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

// Gallery — ParetoChart.

CatalogPage {
    title: qsTr("ParetoChart")
    subtitle: qsTr("Experimental ranked bars + cumulative percent. ChartUtils.paretoRows.")

    ControlExample {
        headerText: qsTr("Defect share")
        qmlSource: "ParetoChart {\n    values: [42, 18, 12, 8, 5]\n}"
        ParetoChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 240
            title: qsTr("Causes")
            labels: [qsTr("Seal"), qsTr("Align"), qsTr("Paint"), qsTr("Torque"), qsTr("Other")]
            values: [42, 18, 12, 8, 5]
        }
    }
}
