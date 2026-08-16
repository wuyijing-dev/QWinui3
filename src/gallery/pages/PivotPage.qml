import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Pivot.
//
// Headered multi-view with Fluent symbols, keyboard arrows, and Component pages. API: docs/components/Pivot.md

CatalogPage {
    title: qsTr("Pivot")
    subtitle: qsTr("Headered multi-view with Fluent symbols, keyboard arrows, and Component pages.")

    Component {
        id: homePage
        ColumnLayout {
            spacing: Theme.spacing
            Label {
                text: qsTr("Home")
                font.pixelSize: Theme.fontSubtitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("Custom page Component hosted by Pivot via model[].page.")
            }
            Button { text: qsTr("Primary action") }
        }
    }
    Component {
        id: recentPage
        ListView {
            clip: true
            model: [qsTr("Report.docx"), qsTr("Budget.xlsx"), qsTr("Notes.txt")]
            delegate: ItemDelegate {
                required property string modelData
                width: ListView.view.width
                text: modelData
            }
        }
    }

    ControlExample {
        headerText: qsTr("Pages + keyboard")
        qmlSource: "Pivot {\n    leftHeader: …\n    rightHeader: …\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Pivot {
                id: pivot
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                focus: true
                model: [
                    { title: qsTr("Home"), symbol: FluentIcons.Home, page: homePage },
                    { title: qsTr("Recent"), symbol: FluentIcons.History, page: recentPage },
                    { title: qsTr("Shared"), symbol: FluentIcons.Share, content: qsTr("Items shared with you.") }
                ]
                leftHeader: Button {
                    flat: true
                    text: FluentIcons.Back
                    font.family: Theme.fontFamilyIcon
                    Accessible.name: qsTr("Back")
                    onClicked: status.text = qsTr("LeftHeader: Back")
                }
                rightHeader: Button {
                    flat: true
                    text: FluentIcons.More
                    font.family: Theme.fontFamilyIcon
                    Accessible.name: qsTr("More")
                    onClicked: status.text = qsTr("RightHeader: More")
                }
                onSelectionChanged: function (index) {
                    var item = pivot.selectedItem
                    var title = item && item.title !== undefined ? item.title : String(item)
                    status.text = qsTr("Selected index %1 · %2").arg(index).arg(title)
                }
            }
            Label {
                id: status
                text: qsTr("Focus the Pivot and use ← → to change tabs.")
                color: Theme.textSecondary
            }
        }
    }
}
