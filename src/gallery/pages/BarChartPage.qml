import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — BarChart.
//
// Gradient columns with title, valueUnit, and empty state. API: docs/components/BarChart.md

CatalogPage {
    id: page
    title: qsTr("BarChart")
    subtitle: qsTr("Stable (1.23). Gradient columns, valueUnit, empty state — docs/charts.md.")

    property string lastClick: qsTr("Click a bar")

    ControlExample {
        headerText: qsTr("Interactive columns")
        qmlSource: "BarChart {\n    title: \"Monthly\"\n    valueUnit: \"k\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            BarChart {
                id: bars
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                title: qsTr("Monthly")
                interactive: true
                valueUnit: "k"
                values: [18, 26, 22, 34, 40, 31, 28, 36, 42, 38, 30, 24]
                onBarClicked: (index, value) => {
                    page.lastClick = qsTr("Bar %1 → %2").arg(index + 1).arg(value)
                }
            }
            RowLayout {
                Label {
                    Layout.fillWidth: true
                    color: Theme.textSecondary
                    text: page.lastClick
                }
                Button {
                    text: qsTr("Replay")
                    onClicked: bars.playReveal()
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Always show values")
        qmlSource: "BarChart { showValueLabels: true }"
        BarChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            showValueLabels: true
            maximum: 100
            bars: [
                { value: 72, color: Theme.accent },
                { value: 48, color: Theme.systemSuccess },
                { value: 91, color: Theme.systemCaution },
                { value: 33, color: Theme.systemCritical },
                { value: 60, color: Theme.accentLight1 },
                { value: 55, color: Theme.accentDark1 }
            ]
        }
    }

    ControlExample {
        headerText: qsTr("Stacked series")
        qmlSource: "BarChart {\n    stacked: true\n    series: [{ name: \"A\", values: […] }]\n}"
        BarChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            title: qsTr("Stacked")
            stacked: true
            labels: ["Q1", "Q2", "Q3", "Q4"]
            series: [
                { name: qsTr("New"), values: [12, 18, 14, 20], color: Theme.accent },
                { name: qsTr("Renew"), values: [8, 10, 11, 9], color: Theme.systemSuccess },
                { name: qsTr("Churn"), values: [3, 4, 2, 5], color: Theme.systemCaution }
            ]
        }
    }

    ControlExample {
        headerText: qsTr("Horizontal")
        qmlSource: "BarChart { horizontal: true }"
        BarChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            title: qsTr("Share")
            horizontal: true
            showValueLabels: true
            values: [72, 48, 91, 33]
        }
    }
}
