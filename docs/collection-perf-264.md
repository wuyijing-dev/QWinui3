# Collection perf + a11y sign-off (2.64)

Closes **FL-008** (documented perf paths) and **FL-016** (DataTable pin/group) for ops LoB — collection **wave 10** in [performance.md](performance.md).

Related: [data-collections.md](data-collections.md) · [accessibility.md](accessibility.md) · [tree-data.md](tree-data.md) · [planning/friction-log.md](planning/friction-log.md) (**FL-008**, **FL-016**) · Gallery **DataTable**, **ListDetailsView**, **FileTree** pages.

Controls: `DataTable` · `ListDetailsView` · `TreeDataGrid` · `FileTree` — **`import QWinUI3.Extras`**.

---

## Goal

Product apps need **spreadsheet-style tables** and **mail-style master–detail** without dropping kit controls at a few hundred rows. **2.64** deepens collection APIs from [component-capabilities-expansion.md](planning/expansion/component-capabilities-expansion.md):

| Control | 2.64 capability |
|---------|-----------------|
| **DataTable** | Column **pin** (`pinned: true`), **group** headers (`groupRole`), **columnOrder** / `moveColumn` |
| **ListDetailsView** | **multiSelectEnabled**, **selectedItems**, **detailToolbar** bulk actions |
| **TreeDataGrid** | Column **resize** handles; **freezeFirstColumn** API (name column) |
| **FileTree** | **filterText** sync to table; **hiddenColumnRoles** + column chooser |

**Out:** Million-row GPU grid; C++ model rewrite.

---

## DataTable — pin + group recipe

```qml
DataTable {
    id: opsTable
    groupRole: "team"
    columns: [
        { title: qsTr("Name"), role: "name", width: 160, pinned: true, sortable: true },
        { title: qsTr("Role"), role: "role", width: 140, sortable: true },
        { title: qsTr("Team"), role: "team", width: 120, sortable: true },
        { title: qsTr("Status"), role: "status", width: 110, sortable: true }
    ]
    rows: employeeRows
    // Persist column order from Settings:
    // columnOrder: settings.tableColumnOrder
    // onColumnLayoutChanged: settings.tableColumnOrder = columnOrder
}
```

- **Pinned** columns stay fixed while horizontal-scrolling the rest.
- **Group** headers insert non-selectable rows when `groupRole` is set (sort applies before grouping).
- Bind **`columnOrder`** to app settings for reorder persistence across sessions.

Gallery: **DataTable** page — **2.64** block (grouped + pinned demo).

---

## ListDetailsView — multi-select toolbar

```qml
ListDetailsView {
    id: mail
    multiSelectEnabled: true
    model: messages
    detailToolbar: RowLayout {
        Label { text: qsTr("%1 selected").arg(mail.selectionCount) }
        Button {
            text: qsTr("Archive")
            enabled: mail.selectionCount > 0
            onClicked: archiveRows(mail.selectedItems)
        }
        Button {
            flat: true
            text: qsTr("Clear selection")
            visible: mail.selectionCount > 0
            onClicked: mail.clearMultiSelection()
        }
    }
    details: MessageBody { item: mail.selectedItem }
}
```

- **Ctrl+click** toggles checkboxes; **Shift+click** range-selects; **Ctrl+A** selects filtered master rows.
- **`selectedIndex`** still drives the detail pane; **`selectedItems`** powers bulk commands.

Gallery: **ListDetailsView** page — mail bulk-action demo.

---

## Tree / file polish

| Control | Pattern |
|---------|---------|
| **TreeDataGrid** | Drag header splitters to resize; set **`freezeFirstColumn: true`** for wide hierarchies |
| **FileTree** | **`filterText`** filters the file table; toggle columns via **`hiddenColumnRoles`** |

---

## Performance checklist (wave 10)

| # | Check | API |
|---|-------|-----|
| 1 | Filter debounce | `filterDebounceMs` (**120**) on **DataTable** / **ListDetailsView** |
| 2 | Cap JS filter walk | `maxFilterResults` on huge arrays |
| 3 | Virtualize rows | `ListView.reuseItems` (built-in) |
| 4 | Skip unchanged rebuild | `_lastRefreshKey` / `_lastFilterKey` |
| 5 | Pin identity columns | `columns[].pinned` — less horizontal hunting |
| 6 | Group before paint | `groupRole` — ops dashboards scan by team/status |
| 7 | Bulk without ItemsView | **ListDetailsView** multi-select + toolbar |

Named paths: filter keystroke → debounce → capped walk; ops table → pin name → group by team; mail list → multi-select → archive toolbar.

---

## Accessibility (2.64)

- **DataTable** group headers expose **`Accessible.StaticText`**; pinned headers announce **", pinned"**.
- **ListDetailsView** checkboxes named **Select {title}**; multi-count announced on toggle.
- **NavigationView** live-region paths from **2.07** remain **Done** — no regressions in sign-off.

---

## App checklist

1. Set **`maxFilterResults`** when JS arrays exceed a few hundred rows.
2. Pin the primary identity column (`name`, `id`) for wide ops tables.
3. Use **`detailToolbar`** for bulk actions instead of a second **ItemsView**.
4. Persist **`columnOrder`** (and widths if needed) via app settings.
5. Run Gallery **`--smoke`** after upgrading — collection pages are in the smoke path.
