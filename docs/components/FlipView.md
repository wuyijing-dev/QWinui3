# FlipView

Page carousel with optional navigation buttons.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FlipView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FlipView.qml)

**Category:** Other · **Library:** v2.56

[← Component index](../components.md)

**Gallery:** `FlipView` — [`src/gallery/pages/FlipViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FlipViewPage.qml)

**Extends** `Control`.

## Example

```qml
FlipView {
    id: flipView
    model: pages
}

// --- API ---
// signals: onSelectionChanged, onCurrentIndexChangedByUser
// methods: goNext(), goPrevious()
// flipView.goNext()
// flipView.goPrevious()
```

## Notes

Paged swipe view; currentIndex + buttonsVisible / isIndicatorVisible.
orientation: Qt.Horizontal | Qt.Vertical (WinUI Orientation).
Carousel recipes + reducedMotion: docs/carousel-recipes.md (2.37).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `currentIndex` | `alias` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `count` | `alias` | Item count |
| `interactive` | `alias` | Enable hover / click interaction |
| `buttonsVisible` | `bool` | Show next/prev buttons |
| `isButtonsVisible` | `alias` | Alias of buttonsVisible |
| `buttonVisibility` | `string` | always \| onHover \| hidden |
| `isIndicatorVisible` | `bool` | Show page indicator |
| `wrap` | `bool` | Wrap children to next line |
| `orientation` | `int` | WinUI Orientation — Qt.Horizontal (default) or Qt.Vertical |
| `selectedItem` | `var` | Currently selected page item |
| `contentData` | `alias` | Default children / content slot |

### Signals

| Signature | Description |
| --- | --- |
| `selectionChanged(int index)` | Selection changed |
| `currentIndexChangedByUser(int index)` | Selection changed by user |

### Methods

| Signature | Description |
| --- | --- |
| `goNext()` | Navigate to the next page / item |
| `goPrevious()` | Navigate to the previous page / item |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
