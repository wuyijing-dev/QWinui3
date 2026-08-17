# SelectorBar

Compact horizontal item selector.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SelectorBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SelectorBar.qml)

**Category:** Navigation · **Library:** v2.55

[← Component index](../components.md)

**Gallery:** `SelectorBar` — [`src/gallery/pages/SelectorBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SelectorBarPage.qml)

**Extends** `Control`.

## Example

```qml
SelectorBar {
    id: selectorBar
    model: ["All", "Unread"]; currentIndex: 0
}

// --- API ---
// signals: onSelected
// methods: select(index), itemAt(index), targetGeometry(index), moveIndicator(instant), syncIndicatorIfIdle()
// selectorBar.select(index)
// selectorBar.itemAt(index)
// selectorBar.targetGeometry(index)
// selectorBar.moveIndicator(instant)
```

## Notes

Horizontal selector tabs; model + currentIndex (nav-style underlines).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `selectedItem` | `var` | Currently selected model item (WinUI SelectedItem) |
| `selectionStyle` | `string` | "pill" (filled accent) or "underline" |

### Signals

| Signature | Description |
| --- | --- |
| `selected(int index, var item)` | Selected state |

### Methods

| Signature | Description |
| --- | --- |
| `select(index)` | Select item by index |
| `itemAt(index)` | Item at the given index |
| `targetGeometry(index)` | Target geometry for placement |
| `moveIndicator(instant)` | Move selection indicator to index |
| `syncIndicatorIfIdle()` | Sync selection indicator when idle |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
