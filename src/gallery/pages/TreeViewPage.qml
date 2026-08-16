import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml.Models
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TreeView.

CatalogPage {
    title: qsTr("TreeView")
    subtitle: qsTr("Real TreeView + TreeViewDelegate — click the chevron (or the row) to expand / collapse.")

    ControlExample {
        headerText: qsTr("Folders")
        qmlSource: "TreeView {\n    model: DemoTreeModel { }\n    delegate: TreeViewDelegate { }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Expand all")
                    onClicked: tree.expandRecursively(-1)
                }
                Button {
                    text: qsTr("Collapse all")
                    onClicked: tree.collapseRecursively(-1)
                }
            }

            TreeView {
                id: tree
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                model: DemoTreeModel {}
                selectionModel: ItemSelectionModel {
                    model: tree.model
                }
                delegate: TreeViewDelegate {}

                Component.onCompleted: {
                    // Open the root folder so children are discoverable.
                    if (rows > 0)
                        expand(0)
                }
            }
        }
    }
}
