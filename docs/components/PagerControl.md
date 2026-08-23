# PagerControl

Numbered page navigation (prev / numbers / next).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PagerControl.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/PagerControl.qml)

**Category:** Navigation · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `PagerControl` — [`src/gallery/pages/PagerControlPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PagerControlPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
PagerControl {
    numberOfPages: 12
    selectedIndex: 0
    onSelectedIndexChanged: { … }
}

// --- API ---
// methods: goNext(), goPrevious(), select(index)
// signals: onSelectionChanged, onCurrentIndexEdited
```

## Notes

WinUI-style numbered pager for lists/grids. maxVisiblePages windows the
number strip; pairs with ListView / ItemsView pageSize patterns.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `numberOfPages` | `int` | — |
| `selectedIndex` | `int` | — |
| `currentIndex` | `alias` | — |
| `maxVisiblePages` | `int` | — |
| `wrap` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `selectionChanged(int index)` | — |
| `currentIndexEdited(int index)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `select(index)` | — |
| `goNext()` | — |
| `goPrevious()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
