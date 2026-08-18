import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("LollipopChart")
    subtitle: qsTr("Experimental stem-and-marker. Prefer BarChart for filled columns.")

    ControlExample {
        headerText: qsTr("Quarter")
        qmlSource: "LollipopChart {\n    values: [12, 28, 18, 34]\n}"
        ColumnLayout {
            spacing: Theme.spacing
            LollipopChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                title: qsTr("Sales")
                labels: ["Q1", "Q2", "Q3", "Q4"]
                values: [12, 28, 18, 34]
            }
            LollipopChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                title: qsTr("Horizontal")
                horizontal: true
                labels: [qsTr("A"), qsTr("B"), qsTr("C"), qsTr("D")]
                values: [72, 48, 91, 33]
            }
        }
    }
}
