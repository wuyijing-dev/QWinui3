# AvatarGroup

Overlapping PersonPicture stack with overflow count.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AvatarGroup.qml`](../../src/extras/QWinUI3/Extras/AvatarGroup.qml)

[← Component index](../components.md)

## Usage

```qml
AvatarGroup { model: [{ displayName: "A" }, { displayName: "B" }] }
```

## Properties

- `model: var` — Data model / item list for this control
- `size: real` — Diameter or box size in px
- `overlap: real` — Avatar stack overlap in px
- `maxVisible: int` — Max visible items before overflow
- `showOverflowCount: bool` — Show +N overflow chip
- `layoutDirection: int` — Qt layout direction
- `overflowCount: int` — Hidden avatar count
- `modelData: var`
- `index: int`

## Signals

- `personClicked(int index, var item)` — Avatar clicked
- `overflowClicked()` — Overflow chip clicked

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
