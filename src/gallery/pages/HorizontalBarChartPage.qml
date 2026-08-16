import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — HorizontalBarChart.
//
// Ranked bars with reveal, hover row highlight, and value labels. API: docs/components/HorizontalBarChart.md

CatalogPage {
    id: page
    title: qsTr("HorizontalBarChart")
    subtitle: qsTr("Ranked bars with reveal, hover row highlight, and value labels.")

    property string status: qsTr("Hover or click a bar")

    ControlExample {
        headerText: qsTr("Top categories")
        qmlSource: "HorizontalBarChart {\n    title: \"Scorecard\"\n    valueUnit: \"%\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            HorizontalBarChart {
                id: hbars
                Layout.fillWidth: true
                Layout.preferredHeight: 260
                title: qsTr("Scorecard")
                maximum: 100
                valueUnit: "%"
                bars: [
                    { value: 92, label: qsTr("Design"), color: Theme.accent },
                    { value: 78, label: qsTr("Eng"), color: Theme.systemSuccess },
                    { value: 64, label: qsTr("Sales"), color: Theme.systemCaution },
                    { value: 51, label: qsTr("Support"), color: Theme.accentLight1 },
                    { value: 38, label: qsTr("Ops"), color: Theme.systemCritical }
                ]
                onBarClicked: (index, value) => {
                    page.status = qsTr("Selected #%1 → %2").arg(index + 1).arg(value)
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
                    onClicked: hbars.playReveal()
                }
            }
        }
    }
}
