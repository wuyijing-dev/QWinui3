# Tree & hierarchical data (1.33)

LoB recipe for **folder / outline** UIs next to tabular collections ([data-collections.md](data-collections.md)).

Gallery: **TreeView recipe** (end-to-end) · **TreeView** (basics) · **ItemsView** (sectioned flat lists).

Style: Fluent [`TreeViewDelegate`](components/TreeViewDelegate.md) for Qt Quick Controls `TreeView`.

---

## Choosing a control

| Need | Prefer | Why |
|------|--------|-----|
| Parent / child expand-collapse | **`TreeView` + `TreeViewDelegate`** | Real hierarchy, depth indent, Left/Right expand |
| Explorer folder tree + file columns | **`FileTree`** (experimental, **2.06**) | TreeView + DataTable wired — keyboard Tab, `fileCatalog` or `onFolderChanged` |
| Flat list with group headers | **`ItemsView`** + `sectionRole` | Simpler model; no expand state |
| Columns + sort/filter | **`DataTable`** | Not a tree — keep rows flat |
| List + reading pane | **`ListDetailsView`** | Master–detail, not nested nodes |
| Multi-column hierarchy in one grid | **`TreeDataGrid`** (experimental, **2.21**) | Nested `children` + column roles; sort/filter per branch |

Do **not** invent a second tree control. Nested `ItemsView` rows that fake expand/collapse are harder to maintain than `TreeView`. Use **`FileTree`** when you need Explorer-style folder + metadata table (**2.06**).

---

## FileTree (Explorer compose, 2.06)

**Experimental** — `import QWinUI3.Extras` · [`FileTree.qml`](../src/extras/QWinUI3/Extras/FileTree.qml)

Composes **folder `TreeView`** + **`DataTable`** with shared keyboard focus (Tab switches panes). Does **not** replace `TreeView` for outline-only UIs.

```qml
import QWinUI3.Extras

FileTree {
    treeModel: folderModel          // QAbstractItemModel — folder labels via DisplayRole
    fileCatalog: {                  // optional — keys = folder display text
        "Documents": [
            { name: "readme.txt", type: "Text", size: "2 KB", modified: "2026-01-01" }
        ]
    }
    onFileActivated: function (index, row) { openFile(row.name) }
}
```

Or bind `files` yourself:

```qml
FileTree {
    treeModel: folderModel
    files: currentFiles
    onFolderChanged: function (row, label) {
        currentFiles = loadFilesForFolder(label)
    }
}
```

| Topic | Guidance |
|-------|----------|
| Keyboard | Tree: ↑/↓/←/→ · **Tab** tree ↔ table · Table: DataTable arrows/sort/filter |
| Filter / columns (**2.64**) | `filterText` syncs the file table; `hiddenColumnRoles` + in-control column checkboxes |
| Models | Tree: C++ `QAbstractItemModel` (Gallery `DemoTreeModel`) · Files: plain JS objects or app-owned list model |
| Multi-column tree rows | **`TreeDataGrid`** (experimental, **2.21**) | Sort/filter per sibling group; nested `children` |
| Full file system | App-owned `QFileSystemModel` / indexing — kit does not ship OS file watchers |
| Path trust (**2.36**) | Controls render **your** labels/rows — validate before open/reveal/execute — [security-trust.md](security-trust.md) |

Gallery: **FileTree** page · friction **FL-012**.

---

## Path trust (FileTree / TreeDataGrid, 2.36)

Hierarchical data surfaces are **not** path validators. Sort, filter, and a11y announcements do not sanitize cell text.

| Risk | Mitigation |
|------|------------|
| `fileActivated` / `rowActivated` opens `installer.exe` | Extension allowlist + confirm; never shell-execute from list double-click alone |
| `fileCatalog` key spoofing | Keys are folder **display** text — resolve paths in app code |
| `QFileSystemModel` + `..` / symlinks | Canonicalize in C++ before IO |
| Reveal in Explorer | `revealFileInFolder` only on validated absolute paths |

Gallery **FileTree** demo includes `installer.exe` under **Downloads** to illustrate risky filenames in UI — production apps must gate opens the same way as [FileDropZone](drag-drop.md) ingest.

Cross-links: [security-trust.md](security-trust.md) wave 3 · Gallery **Security & trust** · **TreeDataGrid** page.

---

## TreeDataGrid (hierarchical grid, 2.21)

**Experimental** — `import QWinUI3.Extras` · [`TreeDataGrid.qml`](../src/extras/QWinUI3/Extras/TreeDataGrid.qml)

### Lazy expand (2.69)

```qml
TreeDataGrid {
    loadChildren: function (path, row) {
        return fetchChildrenFor(path)  // return [] of child row objects
    }
    releaseChildrenOnCollapse: true
    onChildrenRequested: (path, row) => { /* optional async kickoff */ }
}
```

Multi-column **hierarchical** rows in one grid. Unlike **FileTree** (tree + separate flat table), each row can have `children` and multiple column roles.

```qml
import QWinUI3.Extras

TreeDataGrid {
    columns: [
        { title: qsTr("Name"), role: "name", width: 200, sortable: true },
        { title: qsTr("Role"), role: "role", width: 120, sortable: true },
        { title: qsTr("Status"), role: "status", width: 100, sortable: true }
    ]
    rows: [
        {
            name: "Engineering", role: "Group", status: "Active",
            children: [
                { name: "Alex", role: "Engineer", status: "Active" }
            ]
        }
    ]
    freezeFirstColumn: true
    onRowActivated: function (index, row) { … }
}
```

| Topic | Guidance |
|-------|----------|
| Keyboard | ↑/↓ selection · ← collapse / → expand branch · filter field Tab → grid |
| Sort | Per **sibling group** at each depth (not global flat sort) |
| Filter | Keeps matching branches; `expandOnFilter` opens ancestors |
| Resize / freeze (**2.64**) | Drag header splitters; `freezeFirstColumn` keeps the name column visible |
| Scale | Demo-sized JS trees — not Excel / million-node virtualization |
| vs FileTree | FileTree = folder tree + **flat** file table per folder |

Gallery: **TreeDataGrid** page (master-detail readout) · pairs with **FileTree** Explorer recipe.

---

## Supported TreeView recipe

```qml
import QtQuick
import QtQuick.Controls
import QtQml.Models
import QWinUI3.Theme   // Fluent TreeViewDelegate via style

TreeView {
    id: tree
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    Accessible.name: qsTr("Folder tree")
    model: DemoTreeModel {}          // QStandardItemModel / QAbstractItemModel
    selectionModel: ItemSelectionModel { model: tree.model }
    delegate: TreeViewDelegate {}

    Component.onCompleted: {
        if (rows > 0)
            expand(0)                // open root so children are discoverable
    }
}
```

Product tips:

1. Use a C++ `QAbstractItemModel` (or `QStandardItemModel`) — JS trees do not scale.
2. Wire `selectionModel` for current row / LoB commands.
3. Context actions: `MenuFlyout` on right-click (Gallery recipe).
4. Bulk chrome: `expandRecursively(-1)` / `collapseRecursively(-1)`.
5. Paint with Fluent `TreeViewDelegate` (style) — do not restyle from scratch.

---

## Keyboard & pointer

| Input | Behavior (QQC TreeView) |
|-------|-------------------------|
| ↑ / ↓ | Move current row |
| → | Expand branch, or move into first child when already expanded |
| ← | Collapse branch, or move to parent |
| Click chevron / row | Toggle expand (style indicator + built-in pointer nav) |
| Home / End | First / last visible row (when focus is in the view) |

Announce expand state via `Accessible.description` on the Fluent delegate (1.33). Keep `Accessible.name` as the node label (`display` / `text`).

---

## Accessibility checklist

| Surface | Expectation |
|---------|-------------|
| Tree | `Accessible.name` describing the whole tree (e.g. “Folder tree”) |
| Row | `Accessible.role: TreeItem`; name = display text |
| Row description | Expanded/collapsed + level when applicable (Fluent delegate) |
| Context menu | MenuFlyout items keep clear `text` (Rename / Delete / Expand) |

**Wave 5 (2.29):** **`TreeDataGrid`** — selection / sort / filter / expand live regions; **`FileTree`** — `Accessible.Tree` + folder-change announce. See [accessibility.md](accessibility.md) wave 5 checklist.

---

## Lazy children & checkbox cascade (2.64 policy)

Kit **`TreeView`** does not grow a fetch hook or cascade-check API. Product apps own the model:

| Need | Pattern |
|------|---------|
| **Lazy load** | Keep `children` empty (or a placeholder) until expand; on expand, replace the node’s children from your loader. Do not rebuild the entire tree on every keystroke. |
| **Checkbox cascade** | Store checked state on the model; when a parent toggles, walk descendants in app code (or a C++ `QAbstractItemModel`). Document the policy in the app, not in the kit control. |

**Out:** Kit-level `fetchMore` / tri-state cascade on QQC `TreeView`.

Related: [collection-perf-264.md](collection-perf-264.md).

---

## Nested ItemsView (when not a tree)

Sectioned lists are hierarchy **without** expand state:

```qml
ItemsView {
    accessibleName: qsTr("Settings groups")
    sectionRole: "group"
    model: settingsModel   // each row has group / title
}
```

Use this for Settings-style groups. Switch to `TreeView` when users must open/close branches or nest more than one level deep.

---

## Performance

| Size | Guidance |
|------|----------|
| Dozens of nodes | `QStandardItemModel` (Gallery `DemoTreeModel`) is fine |
| Hundreds+ | Custom `QAbstractItemModel`; avoid rebuilding the whole tree on every keystroke |
| Millions | Out of scope for 1.33 — no virtualized million-node tree product |

Related: [performance.md](performance.md) — **Collection controls wave 7 (2.40)** and **wave 10 (2.64)** for **FileTree** / **TreeDataGrid** / **DataTable** — [collection-perf-264.md](collection-perf-264.md).

---

## Gallery map

| Page | Role |
|------|------|
| **TreeView recipe** | Expand / collapse, selection, context MenuFlyout, a11y — follows this doc |
| **FileTree** | Explorer folder tree + file metadata table (**2.06**, experimental) |
| **TreeDataGrid** | Hierarchical multi-column grid (**2.21**, experimental) |
| **TreeView** | Minimal expand / collapse sample |
| **ItemsView** | Sectioned flat alternative |

---

## Out of scope (1.33 / 2.06)

Virtualized million-node trees, drag-reorder of nodes. **FileTree** covers folder tree + **flat** file table per folder — not a hierarchical grid (**TreeDataGrid** covers multi-column hierarchy in **2.21**).
