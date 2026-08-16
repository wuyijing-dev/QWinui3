# Tree & hierarchical data (1.33)

LoB recipe for **folder / outline** UIs next to tabular collections ([data-collections.md](data-collections.md)).

Gallery: **TreeView recipe** (end-to-end) · **TreeView** (basics) · **ItemsView** (sectioned flat lists).

Style: Fluent [`TreeViewDelegate`](components/TreeViewDelegate.md) for Qt Quick Controls `TreeView`.

---

## Choosing a control

| Need | Prefer | Why |
|------|--------|-----|
| Parent / child expand-collapse | **`TreeView` + `TreeViewDelegate`** | Real hierarchy, depth indent, Left/Right expand |
| Flat list with group headers | **`ItemsView`** + `sectionRole` | Simpler model; no expand state |
| Columns + sort/filter | **`DataTable`** | Not a tree — keep rows flat |
| List + reading pane | **`ListDetailsView`** | Master–detail, not nested nodes |

Do **not** invent a second tree control. Nested `ItemsView` rows that fake expand/collapse are harder to maintain than `TreeView`.

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

Related: [performance.md](performance.md).

---

## Gallery map

| Page | Role |
|------|------|
| **TreeView recipe** | Expand / collapse, selection, context MenuFlyout, a11y — follows this doc |
| **TreeView** | Minimal expand / collapse sample |
| **ItemsView** | Sectioned flat alternative |

---

## Out of scope (1.33)

Virtualized million-node trees, TreeTable / multi-column trees, drag-reorder of nodes, a new Extras tree control family.
