# DataTable

Fluent virtualizing table with sort, filter, resize, and keyboard.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DataTable.qml`](../../src/extras/QWinUI3/Extras/DataTable.qml)

[← Component index](../components.md)

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

ListView virtualizes rows. Filter + sort rebuild the view model.
Column resize via header drag handles; arrows / Home / End / Enter navigate.

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
