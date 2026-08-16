import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml.Models
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TreeView.
//
// Basics. End-to-end LoB: TreeView recipe + docs/tree-data.md (1.33).

CatalogPage {
    title: qsTr("TreeView")
    subtitle: qsTr("Fluent TreeViewDelegate — expand / collapse. Recipe: docs/tree-data.md (1.33).")

    ControlExample {
        headerText: qsTr("Folders")
        qmlSource: "TreeView {\n    Accessible.name: qsTr(\"Folder tree\")\n    model: DemoTreeModel { }\n    delegate: TreeViewDelegate { }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Click the chevron or row to expand. Keyboard ←/→ collapses or expands. Full selection + context menu: TreeView recipe page.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }

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
                Accessible.name: qsTr("Folder tree")
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
