# PipsPager

Dot pager for carousels.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PipsPager.qml`](../../src/extras/QWinUI3/Extras/PipsPager.qml)

[← Component index](../components.md)

## Usage

```qml
PipsPager { count: 5; currentIndex: 2 }
```

## Properties

- `count: int` — Item count
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `wrap: bool` — Wrap children to next line
- `previousButtonVisibility: string` — WinUI ButtonVisibility: "visible" | "visibleOnPointerOver" | "collapsed"
- `nextButtonVisibility: string` — Visibility of the next button

## Signals

- `currentIndexEdited(int index)` — Emitted when currentIndex changes via user edit
- `selectionChanged(int index)` — Selection changed

## Methods

- `goNext()` — Navigate to the next page / item
- `goPrevious()` — Navigate to the previous page / item
- `select(index)` — Select item by index

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
