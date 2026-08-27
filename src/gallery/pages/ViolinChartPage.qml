import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

CatalogPage {
    title: qsTr("ViolinChart")
    subtitle: qsTr("Experimental density violins. Prefer BoxPlotChart for Tukey summaries.")

    ControlExample {
        headerText: qsTr("Latency by host")
        qmlSource: "ViolinChart {\n    groups: [{ label: \"A\", values: samples }]\n}"
        ViolinChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 240
            title: qsTr("ms")
            groups: [
                { label: qsTr("A"), values: [38, 40, 42, 44, 48, 52, 41, 43, 61, 39] },
                { label: qsTr("B"), values: [28, 31, 33, 36, 39, 41, 30, 55, 34, 32] },
                { label: qsTr("C"), values: [50, 54, 58, 52, 60, 62, 48, 80, 55, 57] }
            ]
        }
    }
}
