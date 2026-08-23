# DataTable

Fluent virtualizing table with sort, filter, resize, and keyboard.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DataTable.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DataTable.qml)

**Category:** Collections & data · **Library:** v2.67

[← Component index](../components.md)

**Gallery:** `DataTable` — [`src/gallery/pages/DataTablePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DataTablePage.qml)

**Extends** `Control`.

## Example

```qml
DataTable {
    columns: [
        { title: qsTr("Name"), role: "name", width: 160, sortable: true, pinned: true },
        { title: qsTr("Role"), role: "role", width: 140, sortable: true },
        { title: qsTr("Status"), role: "status", width: 120 }
    ]
    rows: [ { name: "Alex", role: "Design", status: "Active", team: "Alpha" }, … ]
    groupRole: "team"
    filterPlaceholder: qsTr("Filter rows")
    // 2.66 D1
    sortSpecs: [ { column: 1, order: Qt.AscendingOrder } ]
    hiddenColumns: [ 4 ]
    columnWidths: [ 160, 140, 120 ]  // bind to Settings
}

// --- API ---
// selectedRow / selectedIndex, sortColumn / sortOrder / sortSpecs, filterText, columnOrder
// hiddenColumns, columnWidths, setColumnVisible(), toggleSort(col, append?)
// methods: select(row), clearSelection(), refresh(), focusTable(), moveColumn(from, to)
// signals: rowActivated(int, var), selectionChanged(int, var), sortChanged(int, int),
//          columnLayoutChanged()
```

## Notes

ListView virtualizes rows (`reuseItems`) — fixed rowHeight fast path (2.66 C1).
Filter + sort rebuild `_viewRows` in JS — debounced on filter keystrokes (1.88);
skips rebuild when query/sort/rows unchanged (2.18). maxFilterResults caps filter walk.
Multi-column sort via sortSpecs / Shift+click header (2.66 D1).
Column visibility (hiddenColumns) + width persistence (columnWidths) — 2.66 D1.
Column pin + reorder (columnOrder / moveColumn) and row group headers (groupRole) — 2.64.
Selection tracks the row **object** across sort/filter.
See docs/data-collections.md for DataTable vs ItemsView vs ListDetailsView.

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
| `sortColumn` | `int` | Primary sort column (compat); kept in sync with sortSpecs[0] |
| `sortOrder` | `int` | — |
| `sortSpecs` | `var` | Multi-column sort specs: [{ column, order }, …] — first entry is primary (2.66 D1) |
| `rowHeight` | `real` | — |
| `fixedRowHeight` | `bool` | Fixed row-height ListView path (always on — C1 contract) |
| `minColumnWidth` | `real` | — |
| `headerHeight` | `real` | — |
| `filterDebounceMs` | `int` | Debounce filter keystrokes before rebuilding _viewRows (1.88). |
| `maxFilterResults` | `int` | Cap filtered rows (0 = unlimited). Large JS arrays only (2.18). |
| `announceChanges` | `bool` | Qt 6.8+ Accessible.announce for selection / sort / filter (2.07). |
| `groupRole` | `string` | Row group header role — inserts sticky-style group rows (2.64). |
| `groupHeaderHeight` | `real` | — |
| `columnOrder` | `var` | Persist column order — bind to Settings; empty = natural column index order (2.64). |
| `hiddenColumns` | `var` | Hidden column indices — omitted from header/body (2.66 D1) |
| `columnWidths` | `var` | Persistable widths — bind to Settings; empty = use columns[].width (2.66 D1) |
| `itemEnter` | `string` | Row enter motion: none \| fade \| slide — 2.67 B2 |
| `itemExit` | `string` | Row exit motion: none \| fade \| slide (prefer none at 10k+) |
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
| `columnLayoutChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `setColumnVisible(column, visible)` | — |
| `isColumnVisible(column)` | — |
| `moveColumn(fromDisplay, toDisplay)` | — |
| `focusTable()` | — |
| `clearSelection()` | — |
| `select(index)` | — |
| `refresh()` | — |
| `toggleSort(column, append)` | Toggle sort. append=true (Shift+click) adds/updates a secondary sort key (2.66 D1). |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
