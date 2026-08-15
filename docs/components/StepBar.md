# StepBar

Horizontal step / wizard progress.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StepBar.qml`](../../src/extras/QWinUI3/Extras/StepBar.qml)

[← Component index](../components.md)

## Usage

```qml
StepBar { model: ["Cart", "Ship", "Pay"]; currentIndex: 1 }
```

## Properties

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `orientation: string` — horizontal | vertical
- `isInteractive: bool` — Alias of interactive
- `modelData: var`
- `index: int`

## Signals

- `stepActivated(int index)` — Emitted when a step is activated

## Methods

- `next()` — Advance to next
- `previous()` — Go to previous
- `goTo(index)` — Navigate to the given index

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
