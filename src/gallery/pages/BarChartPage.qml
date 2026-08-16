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
    subtitle: qsTr("Gradient columns with title, valueUnit, and empty state.")

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
}
