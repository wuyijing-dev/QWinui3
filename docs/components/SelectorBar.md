# SelectorBar

Compact horizontal item selector.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SelectorBar.qml`](../../src/extras/QWinUI3/Extras/SelectorBar.qml)

[← Component index](../components.md)

## Usage

```qml
SelectorBar { model: ["All", "Unread"]; currentIndex: 0 }
```

## Properties

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `selectionStyle: string` — "pill" (filled accent) or "underline"
- `modelData: var`
- `index: int`
- `segmentIndex: int` — Active segment index
- `contentRow: alias` — Content Row

## Signals

- `selected(int index, var item)` — Selected state

## Methods

- `select(index)` — Select
- `itemAt(index)` — Item At
- `targetGeometry(index)` — Target Geometry
- `moveIndicator(instant)` — Move Indicator
- `syncIndicatorIfIdle()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
