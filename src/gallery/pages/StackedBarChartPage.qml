import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — StackedBarChart.
//
// Composition columns with legend emphasis, category labels, and hover tips. API: docs/components/StackedBarChart.md

CatalogPage {
    id: page
    title: qsTr("StackedBarChart")
    subtitle: qsTr("Experimental (deferred 1.66). Composition columns with legend.")

    property string status: qsTr("Hover a column or legend item")

    ControlExample {
        headerText: qsTr("Weekly composition")
        qmlSource: "StackedBarChart {\n    title: \"Weekly mix\"\n    categories: […]\n    series: […]\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            StackedBarChart {
                id: stacked
                Layout.fillWidth: true
                Layout.preferredHeight: 260
                title: qsTr("Weekly mix")
                categories: [qsTr("Mon"), qsTr("Tue"), qsTr("Wed"), qsTr("Thu"),
                             qsTr("Fri"), qsTr("Sat"), qsTr("Sun")]
                series: [
                    { name: qsTr("Apps"), color: Theme.accent, values: [12, 14, 10, 16, 18, 15, 13] },
                    { name: qsTr("Media"), color: Theme.systemCaution, values: [8, 6, 9, 7, 5, 8, 10] },
                    { name: qsTr("Docs"), color: Theme.systemSuccess, values: [5, 7, 6, 4, 8, 6, 5] }
                ]
                onCategoryClicked: (index) => {
                    page.status = qsTr("Category %1").arg(stacked.categories[index])
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
                    onClicked: stacked.playReveal()
                }
            }
        }
    }
}
