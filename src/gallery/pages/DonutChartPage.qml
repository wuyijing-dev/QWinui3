import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

// Gallery — DonutChart.
//
// Animated reveal, hover emphasis, and synchronized legend. API: docs/components/DonutChart.md

CatalogPage {
    id: page
    title: qsTr("DonutChart")
    subtitle: qsTr("Stable. Reveal, hover, legend — docs/charts.md.")

    property var slices: [
        { value: 42, label: qsTr("Apps"), color: Theme.accent },
        { value: 24, label: qsTr("Media"), color: Theme.systemCaution },
        { value: 18, label: qsTr("Docs"), color: Theme.systemSuccess },
        { value: 16, label: qsTr("Other"), color: Theme.systemCritical }
    ]
    property string status: qsTr("Hover a slice or legend row")

    ControlExample {
        headerText: qsTr("Interactive donut")
        qmlSource: "DonutChart {\n    title: \"Capacity\"\n    interactive: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            DonutChart {
                id: donut
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                title: qsTr("Capacity")
                centerText: "100%"
                centerSubText: qsTr("Total")
                slices: page.slices
                onSliceClicked: (index, value) => {
                    var label = page.slices[index].label
                    page.status = qsTr("Selected %1 (%2)").arg(label).arg(value)
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
                    onClicked: donut.playReveal()
                }
                Button {
                    text: qsTr("Shuffle")
                    onClicked: {
                        var next = []
                        for (var i = 0; i < page.slices.length; ++i) {
                            var s = page.slices[i]
                            next.push({
                                value: 10 + Math.round(Math.random() * 40),
                                label: s.label,
                                color: s.color
                            })
                        }
                        page.slices = next
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Compact ring")
        qmlSource: "DonutChart { showLegend: false; thickness: 10 }"
        DonutChart {
            Layout.preferredWidth: 148
            Layout.preferredHeight: 148
            Layout.alignment: Qt.AlignHCenter
            showLegend: false
            thickness: 10
            centerText: "68%"
            centerSubText: qsTr("Used")
            slices: [
                { value: 68, color: Theme.accent },
                { value: 32, color: Theme.strokeDivider }
            ]
        }
    }
}
