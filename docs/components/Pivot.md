# Pivot

Header tabs with sliding underline and pages.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Pivot.qml`](../../src/extras/QWinUI3/Extras/Pivot.qml)

[← Component index](../components.md)

## Usage

```qml
Pivot { model: ["Overview", "Details"] }
```

## Properties

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `keyboardNavigationEnabled: bool` — Allow arrow-key navigation

## Signals

- `currentIndexChangedByUser(int index)` — Selection changed by user
- `selectionChanged(int index)` — Selection changed

## Methods

- `selectIndex(index)` — Select by index

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
