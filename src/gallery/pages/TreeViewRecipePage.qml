import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml.Models
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TreeView recipe (expand + context menu).
//
// Fluent TreeViewDelegate rows with a right-click MenuFlyout.

CatalogPage {
    id: page

    title: qsTr("TreeView recipe")
    subtitle: qsTr("Expand / collapse via chevron, row click, or context menu.")

    property int contextRow: -1

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    ControlExample {
        headerText: qsTr("Folders")
        qmlSource: "TreeView {\n    model: DemoTreeModel { }\n    delegate: TreeViewDelegate { }\n}\nMenuFlyout { … }"

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
                delegate: TreeViewDelegate {
                    id: del

                    TapHandler {
                        acceptedButtons: Qt.RightButton
                        onTapped: {
                            page.contextRow = del.row
                            treeMenu.showAt(del, 0, del.height)
                        }
                    }
                }

                Component.onCompleted: {
                    if (rows > 0)
                        expand(0)
                }
            }

            MenuFlyout {
                id: treeMenu
                MenuFlyoutItem {
                    text: {
                        if (page.contextRow < 0 || page.contextRow >= tree.rows)
                            return qsTr("Expand")
                        return tree.isExpanded(page.contextRow) ? qsTr("Collapse")
                                                                : qsTr("Expand")
                    }
                    enabled: page.contextRow >= 0 && page.contextRow < tree.rows
                    onTriggered: {
                        if (page.contextRow < 0 || page.contextRow >= tree.rows)
                            return
                        tree.toggleExpanded(page.contextRow)
                        toasts.info(tree.isExpanded(page.contextRow)
                                    ? qsTr("Expanded row %1").arg(page.contextRow)
                                    : qsTr("Collapsed row %1").arg(page.contextRow),
                                    qsTr("Tree"))
                    }
                }
                MenuFlyoutItem {
                    text: qsTr("Expand recursively")
                    enabled: page.contextRow >= 0 && page.contextRow < tree.rows
                    onTriggered: {
                        tree.expandRecursively(page.contextRow)
                        toasts.info(qsTr("Expanded recursively from row %1").arg(page.contextRow),
                                    qsTr("Tree"))
                    }
                }
                MenuFlyoutItem {
                    text: qsTr("Rename")
                    onTriggered: toasts.info(qsTr("Rename row %1").arg(page.contextRow), qsTr("Tree"))
                }
                MenuFlyoutSeparator {}
                MenuFlyoutItem {
                    text: qsTr("Delete")
                    onTriggered: toasts.warningToast(qsTr("Delete row %1").arg(page.contextRow),
                                                     qsTr("Tree"))
                }
            }
        }
    }
}
