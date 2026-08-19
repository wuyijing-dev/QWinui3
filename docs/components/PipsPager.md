# PipsPager

Dot pager for carousels.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PipsPager.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/PipsPager.qml)

**Category:** Navigation · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `PipsPager` — [`src/gallery/pages/PipsPagerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PipsPagerPage.qml)

**Extends** `Control`.

## Example

```qml
PipsPager {
    id: pipsPager
    count: 5; currentIndex: 2
}

// --- API ---
// signals: onCurrentIndexEdited, onSelectionChanged
// methods: goNext(), goPrevious(), select(index)
// pipsPager.goNext()
// pipsPager.goPrevious()
// pipsPager.select(index)
```

## Notes

Dot pager synced to a FlipView / SwipeView currentIndex.
MaxVisiblePips windows the visible dots; NumberOfPages aliases count.
Carousel hosts + reducedMotion: docs/carousel-recipes.md (2.37).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `count` | `int` | Item count |
| `numberOfPages` | `alias` | WinUI NumberOfPages alias of count |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `maxVisiblePips` | `int` | WinUI MaxVisiblePips — 0 = show all |
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `wrap` | `bool` | Wrap children to next line |
| `previousButtonVisibility` | `string` | WinUI ButtonVisibility: "visible" \| "visibleOnPointerOver" \| "collapsed" |
| `nextButtonVisibility` | `string` | Visibility of the next button |

### Signals

| Signature | Description |
| --- | --- |
| `currentIndexEdited(int index)` | Emitted when currentIndex changes via user edit |
| `selectionChanged(int index)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `goNext()` | Navigate to the next page / item |
| `goPrevious()` | Navigate to the previous page / item |
| `select(index)` | Select item by index |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
