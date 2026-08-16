# PagerControl

Numbered page navigation (prev / numbers / next).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PagerControl.qml`](../../src/extras/QWinUI3/Extras/PagerControl.qml)

[← Component index](../components.md)

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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
