# NumberBox

Numeric spin/edit with validation (WinUI AcceptsExpression / IsWrapEnabled).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NumberBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/NumberBox.qml)

**Category:** Input & forms · **Library:** v1.13

[← Component index](../components.md)

**Gallery:** `NumberBox` — [`src/gallery/pages/NumberBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/NumberBoxPage.qml)

**Extends** `Control`.

## Example

```qml
NumberBox {
    id: numberBox
    value: 10; minimum: 0; maximum: 100
    acceptsExpression: true
    isWrapEnabled: true
}

// --- API ---
// signals: onValueModified
// methods: clamp(v), format(v), bump(delta), flashInvalid(), focusField(), commitText(), evalExpression(text)
// numberBox.bump(1); numberBox.acceptsExpression
```

## Notes

Numeric TextField with spin buttons / wheel / validation.
acceptsExpression evaluates +−*/() on commit; isWrapEnabled wraps past min/max when spinning.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `stepSize` | `real` | Value step (e.g. 0.5 for half stars) |
| `smallChange` | `alias` | WinUI SmallChange — alias of stepSize (arrows / spin / wheel) |
| `largeChange` | `real` | WinUI LargeChange — used with PageUp/PageDown / wheel+Ctrl |
| `decimals` | `int` | Decimal places for formatting |
| `prefix` | `string` | Leading text prefix |
| `suffix` | `string` | Trailing text suffix |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `errorMessage` | `string` | Validation error text |
| `headerPlacement` | `string` | WinUI HeaderPlacement: top \| left (FormLayout may push fieldHeaderPlacement) |
| `labelWidth` | `real` | Label column width when headerPlacement is left (FormLayout may push labelWidth) |
| `formBound` | `bool` | When true, FormLayout may push labelWidth / fieldHeaderPlacement |
| `placeholderText` | `string` | Placeholder when empty |
| `inputInvalid` | `bool` | True when input fails validation |
| `spinButtonPlacementMode` | `string` | WinUI SpinButtonPlacementMode: "inline" \| "compact" \| "hidden" |
| `validationMode` | `string` | WinUI ValidationMode: "invalidInputOverValue" \| "disabled" |
| `acceptWheel` | `bool` | Handle mouse-wheel value changes |
| `acceptsExpression` | `bool` | WinUI AcceptsExpression — allow 1+2*3 style input on commit |
| `isWrapEnabled` | `bool` | WinUI IsWrapEnabled — wrap past min/max when spinning |
| `hasError` | `bool` | True when validation failed |

### Signals

| Signature | Description |
| --- | --- |
| `valueModified()` | Emitted when the value is modified by the user |

### Methods

| Signature | Description |
| --- | --- |
| `clamp(v)` | Clamp to the valid range |
| `wrap(v)` | Wrap into [minimum, maximum] when both are finite |
| `format(v)` | Format / formatter callback |
| `evalExpression(text)` | Safe arithmetic expression (digits, + − * / ( ) . only) |
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
