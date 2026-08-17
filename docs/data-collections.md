# Data collections (1.07)

Recipes for **tabular and master–detail** LoB surfaces. Prefer these over inventing a second table stack.

| Control | Use when | Gallery |
|---------|----------|---------|
| [`DataTable`](components/DataTable.md) | Multiple columns, sort / filter / resize, keyboard row nav | DataTable |
| [`ItemsView`](components/ItemsView.md) | Single-column list, sections, multi-select, context menu | ItemsView |
| [`ListDetailsView`](components/ListDetailsView.md) | Master list + details pane (`TwoPaneView`) | ListDetailsView |
| [`ItemsWrapGrid`](components/ItemsWrapGrid.md) | Variable-size wrap tiles / tag clouds | ItemsWrapGrid (**2.24**, experimental) |
| [`TreeView`](components/TreeViewDelegate.md) + style delegate | Parent/child expand-collapse | TreeView / TreeView recipe |
| [`FileTree`](components/FileTree.md) | Explorer folder tree + file metadata table | FileTree (**2.06**, experimental) |

**Hierarchy (folders / outlines):** see **[tree-data.md](tree-data.md) (1.33)** — TreeView vs sectioned ItemsView, keyboard, a11y, **FileTree** Explorer compose (**2.06**).

Related: [`ListTile`](components/ListTile.md), [`TwoPaneView`](components/TwoPaneView.md), [`ConnectedAnimation`](components/ConnectedAnimation.md).

**Adaptive breakpoints / SinglePane:** [adaptive-layout.md](adaptive-layout.md) (**1.42**).

Example app: [`examples/master-detail`](../examples/master-detail/) (1.26) — ticket-style `ListDetailsView` shell.

---

## Choosing a control

1. **Need columns + sort/filter** → `DataTable` with plain row objects (or wrap a model you map into `rows`).
2. **Need multi-select / sections / flyout actions** → `ItemsView`, or **`ListDetailsView`** with `multiSelectEnabled` (**2.64**) when you still need a detail pane.
3. **Need list + detail reading pane** → `ListDetailsView` (Wide side-by-side; SinglePane with **Back** / Esc).
4. **Need parent/child expand** → `TreeView` + Fluent `TreeViewDelegate` — [tree-data.md](tree-data.md) (1.33).
5. **Need Explorer folder tree + file columns** → `FileTree` — [tree-data.md](tree-data.md) (**2.06**, experimental).
6. **Compose** — put an `ItemsView` (or custom list) in `listHeader` / beside `TwoPaneView` yourself; `ListDetailsView` keeps a simple `ItemDelegate` master on purpose.

---

## DataTable behavior (1.07 / 2.64)

| Topic | Behavior |
|-------|----------|
| **Selection** | Tracks the selected **row object**. Sort/filter keep the same person selected when still visible; clears if filtered out. |
| **Keyboard** | Tab into the table, or **Down** / Enter from the filter. Arrows, Home/End, PageUp/Down, Enter activate, Esc clears. |
| **Accessible (1.19 / 2.64)** | `accessibleName`; rows announce first cell + selection; headers expose sort; pinned headers announce **", pinned"**; group rows are `StaticText`. |
| **Filter / sort** | Rebuild `_viewRows` in JS on each change (debounced). |
| **Pin / group (2.64)** | `columns[].pinned`; `groupRole` inserts section headers (rows sorted by group then by `sortColumn`); bind `columnOrder` / `moveColumn()` to persist layout. |
| **Scroll** | Rows virtualize via `ListView` + `reuseItems`. Pinned columns stay fixed; remaining columns share a horizontal offset. |

Recipe: [collection-perf-264.md](collection-perf-264.md).

---

## ListDetailsView behavior (1.07 / 2.64)

| Topic | Behavior |
|-------|----------|
| **Keyboard** | Focus the control; arrows / Home / End move selection; Enter opens details in SinglePane. |
| **Multi-select (2.64)** | `multiSelectEnabled`: checkboxes, Ctrl+click, Shift+range, Ctrl+A, Space. `selectedItems` / `selectionCount`; `detailToolbar` slot for bulk actions. |
| **Accessible (1.19)** | `accessibleName` / `listAccessibleName`; list rows named from title/subtitle. |
| **Narrow** | Selecting an item calls `showPane2()`. **Back** button or **Esc** calls `showList()` (`showPane1()`). Breakpoints: [adaptive-layout.md](adaptive-layout.md) (**1.42**). |
| **Animation** | Optional `connectedAnimationEnabled` + `ConnectedAnimationService`. |

---

## ItemsView behavior (1.07)

| Topic | Behavior |
|-------|----------|
| **Keyboard** | Arrows, Home/End, PageUp/Down, Enter; Space toggles multi-select; Ctrl+A; Esc clears. |
| **Accessible (1.19)** | `accessibleName` + count/selection description; multi CheckBox ignored. |
| **Filter** | Not built-in — put a `TextField` / `SearchBox` above and pass a filtered model (Gallery **ItemsView** + **Search recipes**, **1.59**) — [search.md](search.md). |
| **Scale** | Prefer `QAbstractListModel` for large lists; shell enables `reuseItems`. |

---

## Performance notes

| Size (rule of thumb) | Guidance |
|----------------------|----------|
| **≤ a few hundred** plain objects | `DataTable` / `ItemsView` JS arrays are fine. Filter keystrokes debounce (1.88). |
| **Thousands+** | Use a C++ `QAbstractListModel` (or similar). Do not expect JS filter+sort on every keystroke to stay cheap — use app-side filter or model query. |
| **Virtualization** | Both tables/lists use QQC `ListView` — not a custom viewport engine. |

Full checklist (charts, Gallery heavy pages, `reuseItems`, **2.40** collection wave 7, **2.64** wave 10): **[performance.md](performance.md)** · [collection-perf-264.md](collection-perf-264.md).

---

## Out of scope (still)

Multi-select **DataTable**, cell editors, TreeTable, chart engines, merging ItemsView into ListDetailsView as a hard dependency. Virtualized million-node trees stay out of scope — [tree-data.md](tree-data.md). **2.64** adds **DataTable** pin/group, **ListDetailsView** multi-select — [collection-perf-264.md](collection-perf-264.md).
