import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — TreeView.
//
// TreeViewDelegate styles hierarchical TreeView rows (use with a tree model).

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
                title: qsTr("TreeView")
                subtitle: qsTr("TreeViewDelegate styles hierarchical TreeView rows (use with a tree model).")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Styled hierarchy rows")
                qmlSource: "TreeView {\n    delegate: TreeViewDelegate { }\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Repeater {
                        model: [
                            { title: qsTr("Documents"), depth: 0, expanded: true },
                            { title: qsTr("Projects"), depth: 1, expanded: true },
                            { title: qsTr("QWinUI3"), depth: 2, expanded: false },
                            { title: qsTr("Pictures"), depth: 1, expanded: false },
                            { title: qsTr("Downloads"), depth: 0, expanded: false }
                        ]
                        ItemDelegate {
                            required property var modelData
                            Layout.fillWidth: true
                            leftPadding: 12 + modelData.depth * 16
                            text: (modelData.expanded ? "\uE70E " : "\uE76C ") + modelData.title
                            font.family: Theme.fontFamily
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
