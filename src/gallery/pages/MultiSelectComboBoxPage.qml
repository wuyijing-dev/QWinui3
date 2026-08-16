import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — MultiSelectComboBox.
//
// Multi-check combo with Fluent Accept checks, ChevronDown, and Accessible. API: docs/components/MultiSelectComboBox.md

CatalogPage {
    title: qsTr("MultiSelectComboBox")
    subtitle: qsTr("Multi-check combo with Fluent Accept checks, ChevronDown, and Accessible.")

    ControlExample {
        headerText: qsTr("Tags")
        qmlSource: "MultiSelectComboBox {\n    header: \"Teams\"\n    onSelectionChanged: …\n}"
        ColumnLayout {
            spacing: Theme.spacing
            MultiSelectComboBox {
                id: tags
                Layout.preferredWidth: 280
                header: qsTr("Teams")
                model: [
                    { text: qsTr("Design"), checked: true },
                    { text: qsTr("Engineering"), checked: false },
                    { text: qsTr("Research"), checked: true },
                    { text: qsTr("Marketing"), checked: false },
                    { text: qsTr("Support"), checked: false }
                ]
                onSelectionChanged: function (items) {
                    selLabel.text = qsTr("%1 selected · indexes %2")
                        .arg(items.length)
                        .arg(JSON.stringify(tags.selectedIndexes))
                }
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Select all")
                    onClicked: tags.selectAll()
                }
                Button {
                    text: qsTr("Clear")
                    onClicked: tags.clearSelection()
                }
                Button {
                    text: qsTr("Indexes [0,2]")
                    onClicked: tags.selectedIndexes = [0, 2]
                }
                Label {
                    id: selLabel
                    text: qsTr("%1 selected").arg(tags.selectedItems.length)
                    color: Theme.textSecondary
                }
            }
        }
    }
}
