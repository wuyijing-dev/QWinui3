# TreeDataGrid

hierarchical multi-column grid with sort + filter (2.21).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TreeDataGrid.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TreeDataGrid.qml)

**Category:** Collections & data · **Library:** v3.10

[← Component index](../components.md)

**Gallery:** `TreeDataGrid` — [`src/gallery/pages/TreeDataGridPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TreeDataGridPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
TreeDataGrid {
    columns: [
        { title: qsTr("Name"), role: "name", width: 200, sortable: true },
        { title: qsTr("Role"), role: "role", width: 120, sortable: true },
        { title: qsTr("Status"), role: "status", width: 100 }
    ]
    rows: [
        { name: "Engineering", role: "Group", status: "Active",
          children: [ { name: "Alex", role: "Engineer", status: "Active" } ] }
    ]
}

// --- API ---
// selectedRow / selectedIndex, sortColumn / sortOrder, filterText
// methods: select(index), clearSelection(), refresh(), focusGrid(),
//          expandAll(), collapseAll(), toggleExpanded(path),
//          exportColumnLayout(), importColumnLayout(), loadColumnLayout(), saveColumnLayout()
// signals: rowActivated(int, var), selectionChanged(int, var), sortChanged(int, int)
```

## Notes

Experimental — nested JS rows with optional `children`. Sort applies per sibling
group; filter keeps matching branches (ancestors auto-expanded). Not Excel-scale;
prefer C++ model + custom view for huge trees. Filter debounce + maxFilterResults
match DataTable (2.18 / 2.40). Column resize + freezeFirstColumn (2.64).
columnLayoutKey Settings persist — 2.82 D17 · cached tree flatten — 2.84 C7.
Fixed `rowHeight` + `cacheBufferPx` / rows `callLater` — 3.52 C23.
See docs/tree-data.md · docs/collection-perf-264.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `columns` | `var` | — |
| `rows` | `var` | — |
| `filterText` | `string` | — |
| `filterPlaceholder` | `string` | — |
| `filterVisible` | `bool` | — |
| `selectedIndex` | `int` | — |
| `sortColumn` | `int` | — |
| `sortOrder` | `int` | — |
| `rowHeight` | `real` | — |
| `fixedRowHeight` | `bool` | Fixed row-height ListView path (always on — 3.52 C23). |
| `cacheBufferPx` | `int` | ListView overscan; `< 0` uses `rowHeight * 12` (3.52 C23). |
| `minColumnWidth` | `real` | — |
| `headerHeight` | `real` | — |
| `indentWidth` | `real` | — |
| `filterDebounceMs` | `int` | — |
| `maxFilterResults` | `int` | — |
| `announceChanges` | `bool` | — |
| `expandOnFilter` | `bool` | — |
| `loadChildren` | `var` | Lazy children: loadChildren(path, row) → array when expanding (2.69 C5) |
| `releaseChildrenOnCollapse` | `bool` | — |
| `freezeFirstColumn` | `bool` | Keep name column visible during horizontal scroll (2.64). |
| `columnWidths` | `var` | Persistable widths — bind to Settings; empty = use columns[].width (2.82 D17) |
| `columnLayoutKey` | `string` | Settings category — auto load/save layout when set (2.82 D17) |
| `selectedRow` | `var` | — |
| `rowCount` | `int` | — |
| `columnCount` | `int` | — |
| `accessibleName` | `string` | — |

### Signals

| Signature | Description |
| --- | --- |
| `rowActivated(int index, var row)` | — |
| `selectionChanged(int index, var row)` | — |
| `sortChanged(int column, int order)` | — |
| `expandedChanged(string path, bool expanded)` | — |
| `childrenRequested(string path, var row)` | — |
| `columnLayoutChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `exportColumnLayout()` | — |
| `importColumnLayout(obj)` | — |
| `saveColumnLayout()` | — |
| `loadColumnLayout()` | — |
| `toggleExpanded(path)` | — |
| `expandAll()` | — |
| `collapseAll()` | — |
| `focusGrid()` | — |
| `clearSelection()` | — |
| `select(index)` | — |
| `toggleSort(column)` | — |
| `refresh()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
