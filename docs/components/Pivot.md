# Pivot

Header tabs with sliding underline and pages.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Pivot.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Pivot.qml)

**Category:** Navigation · **Library:** v2.66

[← Component index](../components.md)

**Gallery:** `Pivot` — [`src/gallery/pages/PivotPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PivotPage.qml)

**Extends** `Control`.

## Example

```qml
Pivot {
    id: pivot
    model: ["Overview", "Details"]
}

// --- API ---
// signals: onCurrentIndexChangedByUser, onSelectionChanged
// methods: selectIndex(index)
// pivot.selectIndex(index)
```

## Notes

Tab-like pivot headers + content; model or PivotItem children.
leftHeader / rightHeader slots flank the tab strip (WinUI LeftHeader / RightHeader).
selectedItem mirrors the current model entry.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `selectedItem` | `var` | Currently selected model item |
| `keyboardNavigationEnabled` | `bool` | Allow arrow-key navigation |
| `leftHeader` | `alias` | WinUI LeftHeader — content before the tab strip |
| `rightHeader` | `alias` | WinUI RightHeader — content after the tab strip |

### Signals

| Signature | Description |
| --- | --- |
| `currentIndexChangedByUser(int index)` | Selection changed by user |
| `selectionChanged(int index)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `selectIndex(index)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
