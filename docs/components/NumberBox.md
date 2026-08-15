# NumberBox

Numeric spin/edit with validation.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NumberBox.qml`](../../src/extras/QWinUI3/Extras/NumberBox.qml)

[← Component index](../components.md)

## Usage

```qml
NumberBox { value: 10; minimum: 0; maximum: 100 }
```

## Properties

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `largeChange: real` — WinUI LargeChange — used with PageUp/PageDown / wheel+Ctrl
- `decimals: int` — Decimals
- `prefix: string` — Prefix
- `suffix: string` — Suffix
- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `errorMessage: string` — Validation error text
- `placeholderText: string` — Placeholder when empty
- `inputInvalid: bool` — Input Invalid
- `spinButtonPlacementMode: string` — WinUI SpinButtonPlacementMode: "inline" | "compact" | "hidden"
- `validationMode: string` — WinUI ValidationMode: "invalidInputOverValue" | "disabled"
- `acceptWheel: bool` — Accept Wheel
- `hasError: bool` — True when validation failed

## Signals

- `valueModified()` — Value Modified

## Methods

- `clamp(v)` — Clamp
- `format(v)` — Format
- `bump(delta)` — Bump
- `flashInvalid()` — Flash Invalid
- `focusField()` — Focus Field
- `commitText()` — Commit Text

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
