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
- `nextButtonVisibility: string` — Next Button Visibility
- `glyph: string` — Fluent glyph drawn in the button
- `index: int`

## Signals

- `currentIndexEdited(int index)` — Current Index Edited
- `selectionChanged(int index)` — Selection changed

## Methods

- `goNext()` — Go Next
- `goPrevious()` — Go Previous
- `select(index)` — Select

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
