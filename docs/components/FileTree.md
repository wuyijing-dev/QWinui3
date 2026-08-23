# FileTree

Explorer-style folder tree + file metadata table (2.06).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FileTree.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FileTree.qml)

**Category:** Collections & data · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `FileTree` — [`src/gallery/pages/FileTreePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FileTreePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
FileTree {
    treeModel: DemoTreeModel {}
    fileCatalog: {
        "Documents": [ { name: "readme.txt", type: "Text", size: "2 KB", modified: "2026-01-01" } ],
        "Projects": [ … ]
    }
}

// Or bind files yourself:
FileTree {
    treeModel: folderModel
    files: currentFolderFiles
    onFolderChanged: function (row, label) { currentFolderFiles = loadFiles(label) }
}

// --- API ---
// readonly: currentTreeRow, currentFolderLabel, selectedFile, tableRows
// signals: folderChanged(int treeRow, string folderLabel)
//           fileActivated(int index, var row), fileSelectionChanged(int index, var row)
// methods: focusTree(), focusTable(), expandAll(), collapseAll()
// filterText syncs tree filter + table filter (2.64)
```

## Notes

Composes TreeView + DataTable for Explorer LoB. Experimental — see docs/tree-data.md.
Tree keyboard: ↑/↓/←/→. Tab moves focus tree ↔ table. DataTable keeps sort/filter/keyboard.
filterText applies to file table; optional column chooser hides metadata columns (2.64).
fileCatalog keys match folder display text from treeModel (Qt.DisplayRole).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `treeModel` | `var` | — |
| `files` | `var` | Flat file rows for the selected folder (when fileCatalog is not used). |
| `fileCatalog` | `var` | Optional map: folder display label → file row objects. |
| `columns` | `var` | — |
| `treeWidth` | `real` | — |
| `minWideWidth` | `real` | — |
| `filterVisible` | `bool` | — |
| `filterPlaceholder` | `string` | — |
| `filterText` | `string` | Shared filter for the file table (2.64). |
| `hiddenColumnRoles` | `var` | Hide column roles — e.g. ["modified"] (2.64). |
| `columnChooserVisible` | `bool` | — |
| `treeAccessibleName` | `string` | — |
| `tableAccessibleName` | `string` | — |
| `accessibleName` | `string` | — |
| `announceChanges` | `bool` | — |
| `currentTreeRow` | `int` | — |
| `currentFolderLabel` | `string` | — |
| `selectedFile` | `var` | — |
| `tableRows` | `var` | — |
| `visibleColumns` | `var` | — |

### Signals

| Signature | Description |
| --- | --- |
| `folderChanged(int treeRow, string folderLabel)` | — |
| `fileActivated(int index, var row)` | — |
| `fileSelectionChanged(int index, var row)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `focusTree()` | — |
| `focusTable()` | — |
| `expandAll()` | — |
| `collapseAll()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
