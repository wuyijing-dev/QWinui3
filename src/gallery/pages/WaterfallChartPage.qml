import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — WaterfallChart.
//
// Cumulative bridge with title, valueUnit, and empty state. API: docs/components/WaterfallChart.md

CatalogPage {
    id: page
    title: qsTr("WaterfallChart")
    subtitle: qsTr("Cumulative bridge with title, valueUnit, and empty state.")

    property string status: qsTr("Hover a step")

    ControlExample {
        headerText: qsTr("P&L bridge")
        qmlSource: "WaterfallChart {\n    title: \"P&L\"\n    valueUnit: \"k\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            WaterfallChart {
                id: water
                Layout.fillWidth: true
                Layout.preferredHeight: 260
                title: qsTr("P&L")
                valueUnit: "k"
                steps: [
                    { value: 40, label: qsTr("Start") },
                    { value: 18, label: qsTr("Sales") },
                    { value: -8, label: qsTr("Cost") },
                    { value: 12, label: qsTr("Upsell") },
                    { value: -6, label: qsTr("Refund") },
                    { value: 5, label: qsTr("Other") }
                ]
                onStepClicked: (index, value) => {
                    page.status = qsTr("Step %1 → %2").arg(index + 1).arg(value)
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
                    onClicked: water.playReveal()
                }
            }
        }
    }
}
