import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — PolarAreaChart.

CatalogPage {
    title: qsTr("PolarAreaChart")
    subtitle: qsTr("Experimental coxcomb / polar area. Prefer RadarChart for equal-radius polygons.")

    ControlExample {
        headerText: qsTr("Host scores")
        qmlSource: "PolarAreaChart {\n    values: [8, 12, 6, 14, 9]\n}"
        PolarAreaChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 280
            title: qsTr("Load")
            values: [8, 12, 6, 14, 9, 11]
            labels: [qsTr("CPU"), qsTr("Mem"), qsTr("Disk"), qsTr("Net"), qsTr("GPU"), qsTr("IOPS")]
        }
    }
}
