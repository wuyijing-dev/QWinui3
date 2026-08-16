# BreadcrumbBar

Path trail; model items raise itemClicked.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BreadcrumbBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BreadcrumbBar.qml)

**Category:** Navigation · **Library:** v1.13

[← Component index](../components.md)

**Gallery:** `BreadcrumbBar` — [`src/gallery/pages/BreadcrumbBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/BreadcrumbBarPage.qml)

**Extends** `Control`.

## Example

```qml
BreadcrumbBar {
    id: breadcrumbBar
    model: [{ title: "Home" }, { title: "Docs" }]
    onItemClicked: (index) => navigate(index)
}

// --- API ---
// signals: onItemClicked, onItemInvoked
// methods: crumbTitle(data), crumbIcon(data), isCurrent(index), isClickable(entry)
// breadcrumbBar.crumbTitle(data)
// breadcrumbBar.crumbIcon(data)
// breadcrumbBar.isCurrent(index)
// breadcrumbBar.isClickable(entry)
```

## Notes

Path trail from model [{ title, icon? }]; itemClicked(index); overflow collapses.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedItem` | `var` | Currently selected model item (WinUI SelectedItem) |
| `maxVisibleItems` | `int` | Collapse middle crumbs when count exceeds this (0 = show all) |
| `maxItems` | `alias` | WinUI MaxItems alias |
| `lastItemClickable` | `bool` | WinUI: current/last crumb is usually non-interactive |
| `separatorSymbol` | `var` | Breadcrumb separator FluentIcons symbol |
| `separatorGlyph` | `string` | Breadcrumb separator glyph string |
| `effectiveSeparatorGlyph` | `string` | Resolved separator glyph |
| `visibleModel` | `var` | Visible (non-overflow) crumbs |
| `overflowModel` | `var` | Overflow crumb items |

### Signals

| Signature | Description |
| --- | --- |
| `itemClicked(int index)` | Emitted when an item is clicked |
| `itemInvoked(int index)` | WinUI ItemInvoked |

### Methods

| Signature | Description |
| --- | --- |
| `crumbTitle(data)` | Title text for a breadcrumb item |
| `crumbIcon(data)` | Icon for a breadcrumb item |
| `isCurrent(index)` | True when this crumb is the current page |
| `isClickable(entry)` | Emit clicked when activated |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
