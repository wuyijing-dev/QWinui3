# NumberBox

Numeric spin/edit with validation.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NumberBox.qml`](../../src/extras/QWinUI3/Extras/NumberBox.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
NumberBox {
    id: numberBox
    value: 10; minimum: 0; maximum: 100
}

// --- API ---
// signals: onValueModified
// methods: clamp(v), format(v), bump(delta), flashInvalid(), focusField(), commitText()
// numberBox.clamp(v)
// numberBox.format(v)
// numberBox.bump(delta)
// numberBox.flashInvalid()
```

## Notes

Numeric TextField with spin buttons / wheel / validation.
Bind value; spinButtonPlacement and validationMode control UX.
valueChanged / validationError for feedback.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `stepSize` | `real` | Value step (e.g. 0.5 for half stars) |
| `largeChange` | `real` | WinUI LargeChange — used with PageUp/PageDown / wheel+Ctrl |
| `decimals` | `int` | Decimal places for formatting |
| `prefix` | `string` | Leading text prefix |
| `suffix` | `string` | Trailing text suffix |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `errorMessage` | `string` | Validation error text |
| `placeholderText` | `string` | Placeholder when empty |
| `inputInvalid` | `bool` | True when input fails validation |
| `spinButtonPlacementMode` | `string` | WinUI SpinButtonPlacementMode: "inline" \| "compact" \| "hidden" |
| `validationMode` | `string` | WinUI ValidationMode: "invalidInputOverValue" \| "disabled" |
| `acceptWheel` | `bool` | Handle mouse-wheel value changes |
| `hasError` | `bool` | True when validation failed |

### Signals

| Signature | Description |
| --- | --- |
| `valueModified()` | Emitted when the value is modified by the user |

### Methods

| Signature | Description |
| --- | --- |
| `clamp(v)` | Clamp to the valid range |
| `format(v)` | Format / formatter callback |
| `bump(delta)` | Nudge value by one step |
| `flashInvalid()` | Flash invalid-input feedback |
| `focusField()` | Move keyboard focus to the text field |
| `commitText()` | Commit edited text |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
