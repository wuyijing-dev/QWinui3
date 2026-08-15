# BreadcrumbBar

Path trail; model items raise itemClicked.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BreadcrumbBar.qml`](../../src/extras/QWinUI3/Extras/BreadcrumbBar.qml)

[← Component index](../components.md)

## Usage

```qml
BreadcrumbBar {
    model: [{ title: "Home" }, { title: "Docs" }]
    onItemClicked: (index) => navigate(index)
}
```

## Properties

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `maxVisibleItems: int` — Collapse middle crumbs when count exceeds this (0 = show all)
- `lastItemClickable: bool` — WinUI: current/last crumb is usually non-interactive
- `separatorSymbol: var` — Breadcrumb separator FluentIcons symbol
- `separatorGlyph: string` — Breadcrumb separator glyph string
- `effectiveSeparatorGlyph: string` — Resolved separator glyph
- `visibleModel: var` — Visible (non-overflow) crumbs
- `overflowModel: var` — Overflow crumb items

## Signals

- `itemClicked(int index)` — Emitted when an item is clicked
- `itemInvoked(int index)` — WinUI ItemInvoked

## Methods

- `crumbTitle(data)` — Title text for a breadcrumb item
- `crumbIcon(data)` — Icon for a breadcrumb item
- `isCurrent(index)` — True when this crumb is the current page
- `isClickable(entry)` — Emit clicked when activated

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
