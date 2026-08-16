# Data collections (1.07)

Recipes for **tabular and master–detail** LoB surfaces. Prefer these over inventing a second table stack.

| Control | Use when | Gallery |
|---------|----------|---------|
| [`DataTable`](components/DataTable.md) | Multiple columns, sort / filter / resize, keyboard row nav | DataTable |
| [`ItemsView`](components/ItemsView.md) | Single-column list, sections, multi-select, context menu | ItemsView |
| [`ListDetailsView`](components/ListDetailsView.md) | Master list + details pane (`TwoPaneView`) | ListDetailsView |
| [`TreeView`](components/TreeViewDelegate.md) + style delegate | Parent/child expand-collapse | TreeView / TreeView recipe |

**Hierarchy (folders / outlines):** see **[tree-data.md](tree-data.md) (1.33)** — TreeView vs sectioned ItemsView, keyboard, a11y.

Related: [`ListTile`](components/ListTile.md), [`TwoPaneView`](components/TwoPaneView.md), [`ConnectedAnimation`](components/ConnectedAnimation.md).

**Adaptive breakpoints / SinglePane:** [adaptive-layout.md](adaptive-layout.md) (**1.42**).

Example app: [`examples/master-detail`](../examples/master-detail/) (1.26) — ticket-style `ListDetailsView` shell.

---

## Choosing a control

1. **Need columns + sort/filter** → `DataTable` with plain row objects (or wrap a model you map into `rows`).
2. **Need multi-select / sections / flyout actions** → `ItemsView`.
3. **Need list + detail reading pane** → `ListDetailsView` (Wide side-by-side; SinglePane with **Back** / Esc).
4. **Need parent/child expand** → `TreeView` + Fluent `TreeViewDelegate` — [tree-data.md](tree-data.md) (1.33).
5. **Compose** — put an `ItemsView` (or custom list) in `listHeader` / beside `TwoPaneView` yourself; `ListDetailsView` keeps a simple `ItemDelegate` master on purpose.

---

## DataTable behavior (1.07)

| Topic | Behavior |
|-------|----------|
| **Selection** | Tracks the selected **row object**. Sort/filter keep the same person selected when still visible; clears if filtered out. |
| **Keyboard** | Tab into the table, or **Down** / Enter from the filter. Arrows, Home/End, PageUp/Down, Enter activate, Esc clears. |
| **Accessible (1.19)** | `accessibleName`; rows announce first cell + selection; headers expose sort. |
| **Filter / sort** | Rebuild `_viewRows` in JS on each change. |
| **Scroll** | Rows virtualize via `ListView` + `reuseItems`. Wide tables use the **horizontal scrollbar** (vertical flick only). |

---

## ListDetailsView behavior (1.07)

| Topic | Behavior |
|-------|----------|
| **Keyboard** | Focus the control; arrows / Home / End move selection; Enter opens details in SinglePane. |
| **Accessible (1.19)** | `accessibleName` / `listAccessibleName`; list rows named from title/subtitle. |
| **Narrow** | Selecting an item calls `showPane2()`. **Back** button or **Esc** calls `showList()` (`showPane1()`). Breakpoints: [adaptive-layout.md](adaptive-layout.md) (**1.42**). |
| **Animation** | Optional `connectedAnimationEnabled` + `ConnectedAnimationService`. |

---

## ItemsView behavior (1.07)

| Topic | Behavior |
|-------|----------|
| **Keyboard** | Arrows, Home/End, PageUp/Down, Enter; Space toggles multi-select; Ctrl+A; Esc clears. |
| **Accessible (1.19)** | `accessibleName` + count/selection description; multi CheckBox ignored. |
| **Filter** | Not built-in — put a `TextField` / `SearchBox` above and pass a filtered model (Gallery demo). |
| **Scale** | Prefer `QAbstractListModel` for large lists; shell enables `reuseItems`. |

---

## Performance notes

| Size (rule of thumb) | Guidance |
|----------------------|----------|
| **≤ a few hundred** plain objects | `DataTable` / `ItemsView` JS arrays are fine. |
| **Thousands+** | Use a C++ `QAbstractListModel` (or similar). Do not expect JS filter+sort on every keystroke to stay cheap. |
| **Virtualization** | Both tables/lists use QQC `ListView` — not a custom viewport engine. |

Full checklist (charts, Gallery heavy pages, `reuseItems`): **[performance.md](performance.md) (1.25)**.

---

## Out of scope (still)

Multi-select DataTable, cell editors, frozen columns, TreeTable, chart engines, merging ItemsView into ListDetailsView as a hard dependency. Virtualized million-node trees stay out of scope — [tree-data.md](tree-data.md).
