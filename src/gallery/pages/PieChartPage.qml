import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — PieChart.
//
// Interactive pie with title, selectedIndex, and synchronized legend. API: docs/components/PieChart.md

CatalogPage {
    id: page
    title: qsTr("PieChart")
    subtitle: qsTr("Experimental (deferred). Prefer DonutChart.")

    property string status: qsTr("Hover a slice")

    property var slices: [
        { value: 36, label: qsTr("Compute"), color: Theme.accent },
        { value: 28, label: qsTr("Storage"), color: Theme.systemSuccess },
        { value: 20, label: qsTr("Network"), color: Theme.systemCaution },
        { value: 16, label: qsTr("Other"), color: Theme.systemCritical }
    ]

    ControlExample {
        headerText: qsTr("Workload mix")
        qmlSource: "PieChart {\n    title: \"Workload\"\n    interactive: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            PieChart {
                id: pie
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                Layout.minimumHeight: 200
                title: qsTr("Workload")
                slices: page.slices
                onSliceClicked: (index, value) => {
                    page.status = qsTr("%1 → %2").arg(page.slices[index].label).arg(value)
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: Theme.spacing
                Label {
                    Layout.fillWidth: true
                    color: Theme.textSecondary
                    text: page.status
                }
                Button {
                    text: qsTr("Replay")
                    onClicked: pie.playReveal()
                }
            }
        }
    }
}
