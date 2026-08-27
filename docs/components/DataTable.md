# DataTable

Fluent virtualizing table with sort, filter, resize, and keyboard.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DataTable.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DataTable.qml)

**Category:** Collections & data · **Library:** v3.10

[← Component index](../components.md)

**Gallery:** `DataTable` — [`src/gallery/pages/DataTablePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DataTablePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

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
// methods: select(row), scrollToRow(row, mode?), ensureRowVisible(row), clearSelection(),
//          refresh(), focusTable(), moveColumn(from, to), pinColumn(i), unpinColumn(i),
//          exportColumnLayout(), importColumnLayout(obj), loadColumnLayout(), saveColumnLayout(),
//          copySelection(), exportCsv(toClipboard?)
// signals: rowActivated(int, var), selectionChanged(int, var), sortChanged(int, int),
//          columnLayoutChanged()
```

## Notes

ListView virtualizes rows (`reuseItems`) — fixed rowHeight fast path (2.66 C1).
ListView model uses lean `{kind,rowIndex}` / group `{kind,label}` wrappers — not raw
row objects — so Qt does not expose every business key as a role (**3.44** H13).
Filter + sort rebuild `_viewRows` in JS — debounced on filter keystrokes (1.88);
skips rebuild when query/sort/rows/hidden unchanged (2.18 / 3.44). Sort keys cached
only for active sortSpecs columns (2.84 C8); filter skips hidden columns until shown.
rows assignment coalesced via Qt.callLater (2.84 C8).
Multi-column sort via sortSpecs / Shift+click header (2.66 D1).
Column visibility (hiddenColumns) + width persistence (columnWidths) — 2.66 D1.
Column pin + reorder (columnOrder / moveColumn) and row group headers (groupRole) — 2.64.
columnLayoutKey Settings persist + export/import layout — 2.82 D14.
Pinned/scroll column layout skips `columnLayoutChanged` when order unchanged (3.50 C21).
`cacheBufferPx` + non-grouped lean-model reuse — 3.52 C23.
Selection tracks the row **object** across sort/filter.
copySelection / exportCsv — clipboard CSV for selection or visible rows (2.71).
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
| `fixedRowHeight` | `bool` | Fixed row-height ListView path (always on — C1 / 3.52) |
| `cacheBufferPx` | `int` | ListView overscan; `< 0` uses `rowHeight * 12` (3.52 C23). |
| `minColumnWidth` | `real` | — |
| `headerHeight` | `real` | — |
| `filterDebounceMs` | `int` | Debounce filter keystrokes before rebuilding _viewRows (1.88). |
| `maxFilterResults` | `int` | Cap filtered rows (0 = unlimited). Large JS arrays only (2.18). |
| `announceChanges` | `bool` | Qt 6.8+ Accessible.announce for selection / sort / filter (2.07). |
| `groupRole` | `string` | Row group header role — inserts sticky-style group rows (2.64). |
| `groupLabel` | `var` | Optional function(groupValue) → label string for group header rows (2.82 D14). |
| `groupHeaderHeight` | `real` | — |
| `columnOrder` | `var` | Persist column order — bind to Settings; empty = natural column index order (2.64). |
| `columnLayoutKey` | `string` | Settings category — auto load/save layout when set (2.82 D14). |
| `hiddenColumns` | `var` | Hidden column indices — omitted from header/body (2.66 D1) |
| `columnWidths` | `var` | Persistable widths — bind to Settings; empty = use columns[].width (2.66 D1) |
| `itemEnter` | `string` | Row enter motion: none \| fade \| slide — 2.67 B2 |
| `itemExit` | `string` | Row exit motion: none \| fade \| slide (prefer none at 10k+) |
| `rowStyle` | `string` | Row chrome: "zebra" \| "plain" \| "hover" (2.69 A6) — zebra keeps alt stripes |
| `selectionAccent` | `bool` | Selection uses accent wash when true (2.69 A6) |
| `headerStyle` | `string` | Sticky header surface: "filled" \| "elevated" \| "outline" (2.69 A6) |
| `rowBackground` | `var` | Optional per-row color override: function(row, index) → color string/undefined |
| `selectedRow` | `var` | — |
| `rowCount` | `int` | — |
| `columnCount` | `int` | — |
| `pinnedColumnIndices` | `var` | — |
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
| `exportColumnLayout()` | — |
| `importColumnLayout(obj)` | — |
| `saveColumnLayout()` | — |
| `loadColumnLayout()` | — |
| `pinColumn(colIndex)` | — |
| `unpinColumn(colIndex)` | — |
| `togglePinColumn(colIndex)` | — |
| `setColumnVisible(column, visible)` | — |
| `isColumnVisible(column)` | — |
| `moveColumn(fromDisplay, toDisplay)` | — |
| `focusTable()` | — |
| `clearSelection()` | — |
| `select(index)` | — |
| `scrollToRow(rowIndex, mode)` | — |
| `ensureRowVisible(rowIndex)` | — |
| `copySelection()` | Copy selected row as CSV (header + one row). Returns text; also writes clipboard. |
| `exportCsv(toClipboard)` | Export visible (filtered/sorted) rows as CSV. toClipboard true (default) copies; false returns only. |
| `refresh()` | — |
| `toggleSort(column, append)` | Toggle sort. append=true (Shift+click) adds/updates a secondary sort key (2.66 D1). |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
