# RatingControl

Star rating; stepSize supports halves.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RatingControl.qml`](../../src/extras/QWinUI3/Extras/RatingControl.qml)

[← Component index](../components.md)

## Usage

```qml
RatingControl { value: 3.5; stepSize: 0.5 }
```

## Properties

- `value: real` — Current value
- `placeholderValue: real` — Shown when value unset
- `maxRating: int` — Maximum star count
- `readOnly: bool` — Read-only when true
- `isReadOnly: alias` — Alias of readOnly
- `isClearEnabled: bool` — Allow clearing the rating
- `stepSize: real` — 1 = whole, 0.5 = half, 0.1 / 0.25 = fine-grained mouse pick
- `previewEnabled: bool` — Preview value on hover
- `previewValue: real` — Hovered preview value
- `caption: string` — Caption under / beside the value

## Signals

- `valueEdited(real value)` — Emitted when user commits a value

## Methods

- `clampValue(v)` — Clamp value into min..max
- `valueFromPos(x)` — Map a pointer position to a value
- `commitValue(next)` — Commit the edited value

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
