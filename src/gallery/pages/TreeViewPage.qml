import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — TreeView.

CatalogPage {
    title: qsTr("TreeView")
    subtitle: qsTr("TreeViewDelegate styles hierarchical TreeView rows (use with a tree model).")

    ControlExample {
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
}
