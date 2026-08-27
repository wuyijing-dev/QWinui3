# MaskedTextField

Simple input mask for phone / ID-style patterns (2.71).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MaskedTextField.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MaskedTextField.qml)

**Category:** Input & forms · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `MaskedTextField` — [`src/gallery/pages/MaskedTextFieldPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/MaskedTextFieldPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `TextField`.

## Example

```qml
MaskedTextField {
    mask: "(###) ###-####"
    text: ""
}

// --- API ---
// mask: '#' = digit, 'A' = letter, '*' = alphanumeric, other chars are literals
// text / displayText / rawText, acceptableInput
```

## Notes

Thin TextField wrapper — not a full locale/IME mask engine.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `mask` | `string` | — |
| `rawText` | `string` | — |
| `acceptableInput` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `TextField`

Also available (base type / Qt Quick Controls):

- `text`
- `placeholderText`
- `accepted()`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
