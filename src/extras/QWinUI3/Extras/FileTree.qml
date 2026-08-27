import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Templates as T
import QWinUI3.Theme

// FileTree — Explorer-style folder tree + file metadata table (2.06).
//
//   FileTree {
//       treeModel: DemoTreeModel {}
//       fileCatalog: {
//           "Documents": [ { name: "readme.txt", type: "Text", size: "2 KB", modified: "2026-01-01" } ],
//           "Projects": [ … ]
//       }
//   }
//
//   // Or bind files yourself:
//   FileTree {
//       treeModel: folderModel
//       files: currentFolderFiles
//       onFolderChanged: function (row, label) { currentFolderFiles = loadFiles(label) }
//   }
//
//   // --- API ---
//   // readonly: currentTreeRow, currentFolderLabel, selectedFile, tableRows
//   // signals: folderChanged(int treeRow, string folderLabel)
//   //           fileActivated(int index, var row), fileSelectionChanged(int index, var row)
//   // methods: focusTree(), focusTable(), expandAll(), collapseAll()
//   // filterText syncs tree filter + table filter (2.64)
//
// @notes
//   Composes TreeView + DataTable for Explorer LoB. Experimental — see docs/tree-data.md.
//   Tree keyboard: ↑/↓/←/→. Tab moves focus tree ↔ table. DataTable keeps sort/filter/keyboard.
//   filterText applies to file table; optional column chooser hides metadata columns (2.64).
//   fileCatalog keys match folder display text from treeModel (Qt.DisplayRole).

T.Control {
    id: root

    property var treeModel: null
    // Flat file rows for the selected folder (when fileCatalog is not used).
    property var files: []
    // Optional map: folder display label → file row objects.
    property var fileCatalog: null
    property var columns: [
        { title: qsTr("Name"), role: "name", width: 180, sortable: true },
        { title: qsTr("Type"), role: "type", width: 100, sortable: true },
        { title: qsTr("Size"), role: "size", width: 72, sortable: true },
        { title: qsTr("Modified"), role: "modified", width: 120, sortable: true }
    ]
    property real treeWidth: 260
    property real minWideWidth: 640
    property bool filterVisible: true
    property string filterPlaceholder: qsTr("Filter files")
    // Shared filter for the file table (2.64).
    property string filterText: ""
    // Hide column roles — e.g. ["modified"] (2.64).
    property var hiddenColumnRoles: []
    property bool columnChooserVisible: true
    property string treeAccessibleName: qsTr("Folders")
    property string tableAccessibleName: qsTr("Files")
    property string accessibleName: qsTr("File tree")
    property bool announceChanges: true

    readonly property int currentTreeRow: tree.currentRow
    readonly property string currentFolderLabel: _folderLabel
    readonly property var selectedFile: fileTable.selectedRow
    readonly property var tableRows: fileCatalog ? _catalogFiles : files
    readonly property var visibleColumns: {
        var cols = columns || []
        var hidden = hiddenColumnRoles || []
        if (!hidden.length)
            return cols
        var out = []
        for (var i = 0; i < cols.length; ++i) {
            var role = cols[i].role || ("c" + i)
            var hide = false
            for (var h = 0; h < hidden.length; ++h) {
                if (hidden[h] === role) {
                    hide = true
                    break
                }
            }
            if (!hide)
                out.push(cols[i])
        }
        return out.length ? out : cols
    }

    property var _catalogFiles: []
    property string _folderLabel: ""

    signal folderChanged(int treeRow, string folderLabel)
    signal fileActivated(int index, var row)
    signal fileSelectionChanged(int index, var row)

    function _announce(text) {
        if (!root.announceChanges || !text || text.length === 0)
            return
        if (typeof Accessible.announce === "function")
            Accessible.announce(text)
    }

    implicitWidth: 720
    implicitHeight: 400
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.Pane
    Accessible.name: accessibleName.length ? accessibleName : qsTr("File tree")
    Accessible.description: _folderLabel.length
                            ? qsTr("Folder %1, %2 files").arg(_folderLabel).arg(tableRows.length)
                            : qsTr("Select a folder")

    function focusTree() {
        tree.forceActiveFocus()
    }

    function focusTable() {
        fileTable.focusTable()
    }

    function expandAll() {
        tree.expandRecursively(-1)
    }

    function collapseAll() {
        tree.collapseRecursively(-1)
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

    function _folderLabelAtRow(row) {
        if (row < 0 || !root.treeModel)
            return ""
        var idx = _treeIndex(row, 0)
        if (!idx || !idx.valid)
            return ""
        return String(root.treeModel.data(idx, Qt.DisplayRole) || "")
    }

    function _syncFolder(row) {
        var label = _folderLabelAtRow(row)
        if (label === root._folderLabel && row === root.currentTreeRow)
            return
        root._folderLabel = label
        if (root.fileCatalog)
            root._catalogFiles = root.fileCatalog[label] || []
        fileTable.clearSelection()
        if (label.length)
            _announce(qsTr("Folder %1, %2 files").arg(label).arg(root.tableRows.length))
        root.folderChanged(row, label)
    }

    Keys.onTabPressed: function (event) {
        if (tree.activeFocus) {
            focusTable()
            event.accepted = true
        } else if (fileTable.activeFocus) {
            focusTree()
            event.accepted = true
        }
    }

    contentItem: TwoPaneView {
        id: panes
        anchors.fill: parent
        minWideWidth: root.minWideWidth
        panePriorityWidth: root.treeWidth
        preferredMode: TwoPaneView.Wide

        pane1: Rectangle {
            color: Theme.bgCard
            border.width: 1
            border.color: Theme.strokeCard
            radius: Theme.cornerCard
            clip: true

            TreeView {
                id: tree
                anchors.fill: parent
                anchors.margins: 1
                clip: true
                // 3.43 H12 — TableView-backed; pool rows + mild overscan.
                reuseItems: true
                cacheBuffer: Math.max(240, Math.round(height * 1.5))
                boundsBehavior: Flickable.StopAtBounds
                focusPolicy: Qt.StrongFocus
                model: root.treeModel
                selectionModel: ItemSelectionModel {
                    model: tree.model
                }
                Accessible.role: Accessible.Tree
                Accessible.name: root.treeAccessibleName
                Accessible.description: qsTr("Use Left and Right arrows to expand or collapse folders. Tab moves to the file list.")
                onCurrentRowChanged: root._syncFolder(currentRow)
                delegate: TreeViewDelegate {}

                Component.onCompleted: {
                    if (rows > 0) {
                        expand(0)
                        root._setCurrentRow(0)
                    }
                    root._syncFolder(currentRow)
                }
            }
        }

        pane2: Rectangle {
            color: Theme.bgCard
            border.width: 1
            border.color: Theme.strokeCard
            radius: Theme.cornerCard
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 1
                spacing: Theme.spacingTight

                Flow {
                    Layout.fillWidth: true
                    visible: root.columnChooserVisible && (root.columns || []).length > 1
                    spacing: Theme.spacingTight
                    Repeater {
                        model: root.columns || []
                        delegate: CheckBox {
                            required property var modelData
                            required property int index
                            readonly property string colRole: modelData.role || ("c" + index)
                            text: modelData.title || colRole
                            checked: {
                                var hidden = root.hiddenColumnRoles || []
                                for (var i = 0; i < hidden.length; ++i) {
                                    if (hidden[i] === colRole)
                                        return false
                                }
                                return true
                            }
                            onClicked: {
                                var hidden = (root.hiddenColumnRoles || []).slice()
                                var role = colRole
                                var pos = hidden.indexOf(role)
                                if (checked && pos >= 0)
                                    hidden.splice(pos, 1)
                                else if (!checked && pos < 0)
                                    hidden.push(role)
                                root.hiddenColumnRoles = hidden
                            }
                        }
                    }
                }

                DataTable {
                    id: fileTable
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    columns: root.visibleColumns
                    rows: root.tableRows
                    filterVisible: root.filterVisible
                    filterPlaceholder: root.filterPlaceholder
                    filterText: root.filterText
                    onFilterTextChanged: root.filterText = filterText
                    accessibleName: root.tableAccessibleName
                    onRowActivated: function (index, row) {
                        root.fileActivated(index, row)
                    }
                    onSelectionChanged: function (index, row) {
                        root.fileSelectionChanged(index, row)
                    }
                }
            }
        }
    }
}
