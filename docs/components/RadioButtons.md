# RadioButtons

Grouped RadioButton list from a model.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RadioButtons.qml`](../../src/extras/QWinUI3/Extras/RadioButtons.qml)

[← Component index](../components.md)

## Usage

```qml
RadioButtons { header: qsTr("Choice"); model: ["A", "B"] }
```

## Properties

- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `horizontal: bool` — Horizontal orientation when true
- `modelData: var`
- `index: int`

## Signals

- `selected(int index, var item)` — Selected state
- `selectionChanged(int index)` — Selection changed

## Methods

- `select(index)` — Select item by index

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
