import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — HeatmapChart.
//
// Density grid with title, empty state, and hover readout. API: docs/components/HeatmapChart.md

CatalogPage {
    id: page
    title: qsTr("HeatmapChart")
    subtitle: qsTr("Experimental (deferred). Density grid with hover readout.")

    property string status: qsTr("Hover a cell")
    readonly property var matrix: {
        var rows = []
        for (var r = 0; r < 6; ++r) {
            var row = []
            for (var c = 0; c < 8; ++c)
                row.push(Math.round(20 + Math.sin(r * 0.9 + c * 0.55) * 30 + c * 4 + r * 3))
            rows.push(row)
        }
        return rows
    }

    ControlExample {
        headerText: qsTr("Activity matrix")
        qmlSource: "HeatmapChart {\n    title: \"Week\"\n    values: matrix\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            HeatmapChart {
                id: heat
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                title: qsTr("Week")
                values: page.matrix
                rowLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                columnLabels: ["0", "3", "6", "9", "12", "15", "18", "21"]
                onCellClicked: (row, col, value) => {
                    page.status = qsTr("Cell [%1,%2] = %3").arg(row).arg(col).arg(value)
                }
            }
            RowLayout {
                Label {
                    Layout.fillWidth: true
                    color: Theme.textSecondary
                    text: page.status
                }
                Button {
                    text: qsTr("Replay")
                    onClicked: heat.playReveal()
                }
            }
        }
    }
}
