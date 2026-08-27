import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml.Models
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TreeView recipe.
//
// Selection, expand/collapse keyboard, context MenuFlyout, Accessible names.
// Recipe: docs/tree-data.md

CatalogPage {
    id: page

    title: qsTr("TreeView recipe")
    subtitle: qsTr("Hierarchy LoB: selection, ←/→ expand, MenuFlyout. Recipe: docs/tree-data.md.")

    property int contextRow: -1
    property string selectedLabel: qsTr("(none)")

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    function _treeIndex(row, column) {
        column = (column === undefined || column === null) ? 0 : column
        if (typeof tree.index === "function")
            return tree.index(row, column)
        return tree.modelIndex(row, column)
    }

    function _setCurrentRow(row) {
        if (row < 0)
            return
        var idx = _treeIndex(row, 0)
        if (tree.selectionModel && idx && idx.valid)
            tree.selectionModel.setCurrentIndex(idx,
                ItemSelectionModel.Rows | ItemSelectionModel.ClearAndSelect)
    }

    function refreshSelectionLabel() {
        if (tree.currentRow < 0 || tree.currentRow >= tree.rows) {
            page.selectedLabel = qsTr("(none)")
            return
        }
        var idx = _treeIndex(tree.currentRow, 0)
        if (!idx || !idx.valid) {
            page.selectedLabel = qsTr("(none)")
            return
        }
        page.selectedLabel = String(tree.model.data(idx, Qt.DisplayRole) || qsTr("(none)"))
    }

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "// TreeView — parent/child expand\n// ItemsView + sectionRole — flat groups\n// docs/tree-data.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use TreeView for real folders/outlines. Explorer folder + file columns: FileTree. Prefer ItemsView with sectionRole for Settings-style groups without expand state. DataTable stays flat (columns).")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Keyboard: ↑/↓ move · → expand or enter child · ← collapse or go to parent. Fluent TreeViewDelegate announces expanded/collapsed + level.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Folders + context menu")
        qmlSource: "TreeView {\n    Accessible.name: qsTr(\"Folder tree\")\n    model: DemoTreeModel { }\n    selectionModel: ItemSelectionModel { … }\n    delegate: TreeViewDelegate { }\n}\nMenuFlyout { … }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Expand all")
                    onClicked: tree.expandRecursively(-1)
                }
                Button {
                    text: qsTr("Collapse all")
                    onClicked: tree.collapseRecursively(-1)
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: qsTr("Selected: %1").arg(page.selectedLabel)
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                }
            }

            TreeView {
                id: tree
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                Accessible.name: qsTr("Folder tree")
                Accessible.description: qsTr("Use Left and Right arrows to collapse or expand branches.")
                model: DemoTreeModel {}
                selectionModel: ItemSelectionModel {
                    model: tree.model
                }
                onCurrentRowChanged: page.refreshSelectionLabel()
                delegate: TreeViewDelegate {
                    id: del

                    TapHandler {
                        acceptedButtons: Qt.RightButton
                        onTapped: {
                            page.contextRow = del.row
                            page._setCurrentRow(del.row)
                            treeMenu.showAt(del, 0, del.height)
                        }
                    }
                }

                Component.onCompleted: {
                    if (rows > 0)
                        expand(0)
                    page.refreshSelectionLabel()
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
                    onTriggered: toasts.info(qsTr("Rename “%1”").arg(page.selectedLabel), qsTr("Tree"))
                }
                MenuFlyoutSeparator {}
                MenuFlyoutItem {
                    text: qsTr("Delete")
                    onTriggered: toasts.warningToast(qsTr("Delete “%1”").arg(page.selectedLabel),
                                                     qsTr("Tree"))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Flat groups (ItemsView alternative)")
        qmlSource: "ItemsView {\n    sectionRole: \"group\"\n    accessibleName: qsTr(\"Library groups\")\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("When you only need group headers (no expand), ItemsView + sectionRole is enough — see docs/tree-data.md and the ItemsView Gallery page.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            ItemsView {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                accessibleName: qsTr("Library groups")
                sectionRole: "group"
                model: [
                    { group: qsTr("Documents"), title: qsTr("Projects") },
                    { group: qsTr("Documents"), title: qsTr("Pictures") },
                    { group: qsTr("System"), title: qsTr("Downloads") },
                    { group: qsTr("System"), title: qsTr("Temp") }
                ]
            }
        }
    }
}
