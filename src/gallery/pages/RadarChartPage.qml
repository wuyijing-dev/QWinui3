import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RadarChart.
//
// Spider chart with title, empty state, and legend emphasis. API: docs/components/RadarChart.md

Page {
    id: page
    padding: 0

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("RadarChart")
                subtitle: qsTr("Spider chart with title, empty state, and legend emphasis.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
