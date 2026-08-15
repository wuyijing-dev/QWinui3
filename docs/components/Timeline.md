# Timeline

Vertical event timeline.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Timeline.qml`](../../src/extras/QWinUI3/Extras/Timeline.qml)

[← Component index](../components.md)

## Usage

```qml
Timeline { model: events }
```

## Properties

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `railWidth: real` — Rail Width
- `nodeSize: real` — Node Size
- `isInteractive: bool` — Alias of interactive
- `modelData: var`
- `index: int`
- `isLast: bool` — Is Last
- `isActive: bool` — Active / animating state
- `nodeColor: color` — Node Color

## Signals

- `itemClicked(int index)` — Emitted when an item is clicked
- `selectionChanged(int index)` — Selection changed

## Methods

- `select(index)` — Select
- `next()` — Next
- `previous()` — Previous

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
