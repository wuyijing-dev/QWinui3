# DataTable

Fluent virtualizing table with sort, filter, resize, and keyboard.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DataTable.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DataTable.qml)

**Category:** Collections & data · **Library:** v2.64

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
}

// --- API ---
// selectedRow / selectedIndex, sortColumn / sortOrder, filterText, columnOrder
// methods: select(row), clearSelection(), refresh(), focusTable(), moveColumn(from, to)
// signals: rowActivated(int, var), selectionChanged(int, var), sortChanged(int, int)
```

## Notes

ListView virtualizes rows (`reuseItems`). Filter + sort rebuild `_viewRows` in JS —
debounced on filter keystrokes (1.88); skips rebuild when query/sort/rows unchanged (2.18).
maxFilterResults caps filter walk for huge JS arrays (2.18).
Column pin + reorder (columnOrder / moveColumn) and row group headers (groupRole) — 2.64.
fine for hundreds of plain objects; prefer a C++ model + custom view for thousands+.
Selection tracks the row **object** across sort/filter (clears if the row is filtered out).
Tab into the table or press Down from the filter; arrows / Home / End / Page / Enter /
Esc navigate. Pinned columns stay fixed; scrollable columns share a horizontal offset.
Live-region announces on selection / sort / filter (2.07) when announceChanges is true.
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
| `sortColumn` | `int` | — |
| `sortOrder` | `int` | — |
| `rowHeight` | `real` | — |
| `minColumnWidth` | `real` | — |
| `headerHeight` | `real` | — |
| `filterDebounceMs` | `int` | Debounce filter keystrokes before rebuilding _viewRows (1.88). |
| `maxFilterResults` | `int` | Cap filtered rows (0 = unlimited). Large JS arrays only (2.18). |
| `announceChanges` | `bool` | Qt 6.8+ Accessible.announce for selection / sort / filter (2.07). |
| `groupRole` | `string` | Row group header role — inserts sticky-style group rows (2.64). |
| `groupHeaderHeight` | `real` | — |
| `columnOrder` | `var` | Persist column order — bind to Settings; empty = natural column index order (2.64). |
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
| `moveColumn(fromDisplay, toDisplay)` | — |
| `focusTable()` | — |
| `clearSelection()` | — |
| `select(index)` | — |
| `refresh()` | — |
| `toggleSort(column)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
