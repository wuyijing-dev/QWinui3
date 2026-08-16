import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — MultiSelectComboBox.
//
// Multi-check combo with Fluent Accept checks, ChevronDown, and Accessible. API: docs/components/MultiSelectComboBox.md

Page {
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
                title: qsTr("MultiSelectComboBox")
                subtitle: qsTr("Multi-check combo with Fluent Accept checks, ChevronDown, and Accessible.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
