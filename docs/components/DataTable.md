# DataTable

Fluent virtualizing table with sort, filter, resize, and keyboard.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DataTable.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DataTable.qml)

**Category:** Collections & data · **Library:** v1.78

[← Component index](../components.md)

**Gallery:** `DataTable` — [`src/gallery/pages/DataTablePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DataTablePage.qml)

**Extends** `Control`.

## Example

```qml
DataTable {
    columns: [
        { title: qsTr("Name"), role: "name", width: 160, sortable: true },
        { title: qsTr("Role"), role: "role", width: 140, sortable: true },
        { title: qsTr("Status"), role: "status", width: 120 }
    ]
    rows: [ { name: "Alex", role: "Design", status: "Active" }, … ]
    filterPlaceholder: qsTr("Filter rows")
}

// --- API ---
// selectedRow / selectedIndex, sortColumn / sortOrder, filterText
// methods: select(row), clearSelection(), refresh(), focusTable()
// signals: rowActivated(int, var), selectionChanged(int, var), sortChanged(int, int)
```

## Notes

ListView virtualizes rows (`reuseItems`). Filter + sort rebuild `_viewRows` in JS —
fine for hundreds of plain objects; prefer a C++ model + custom view for thousands+.
Selection tracks the row **object** across sort/filter (clears if the row is filtered out).
Tab into the table or press Down from the filter; arrows / Home / End / Page / Enter /
Esc navigate. Horizontal scroll via the bottom scrollbar (list flick is vertical).
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
| `selectedRow` | `var` | — |
| `rowCount` | `int` | — |
| `columnCount` | `int` | — |
| `accessibleName` | `string` | Screen-reader name override (1.19) |

### Signals

| Signature | Description |
| --- | --- |
| `rowActivated(int index, var row)` | — |
| `selectionChanged(int index, var row)` | — |
| `sortChanged(int column, int order)` | — |

### Methods

| Signature | Description |
| --- | --- |
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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
