import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RadarChart.
//
// Spider chart with title, empty state, and legend emphasis. API: docs/components/RadarChart.md

CatalogPage {
    id: page
    title: qsTr("RadarChart")
    subtitle: qsTr("Experimental (deferred). Spider chart with legend emphasis.")

    ControlExample {
        headerText: qsTr("Team comparison")
        qmlSource: "RadarChart {\n    title: \"Scorecard\"\n    series: […]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RadarChart {
                id: radar
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                title: qsTr("Scorecard")
                axes: [qsTr("Speed"), qsTr("Quality"), qsTr("UX"), qsTr("Stability"), qsTr("Cost"), qsTr("Support")]
                series: [
                    { name: qsTr("Product A"), color: Theme.accent, values: [80, 70, 90, 65, 55, 75] },
                    { name: qsTr("Product B"), color: Theme.systemSuccess, values: [60, 85, 70, 80, 70, 60] }
                ]
            }
            Button {
                text: qsTr("Replay reveal")
                onClicked: radar.playReveal()
            }
        }
    }
}
