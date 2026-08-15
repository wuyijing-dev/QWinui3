# HeaderedTextBox

TextBox with header and description.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HeaderedTextBox.qml`](../../src/extras/QWinUI3/Extras/HeaderedTextBox.qml)

[← Component index](../components.md)

## Usage

```qml
HeaderedTextBox { header: qsTr("Name"); placeholderText: qsTr("Required") }
```

## Properties

- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `errorMessage: string` — Validation error text
- `clearButtonVisible: bool` — Show clear affordance
- `characterLimit: int` — Soft character counter limit
- `text: alias` — Display / input text
- `placeholderText: alias` — Placeholder when empty
- `echoMode: alias` — TextField echo mode
- `readOnly: alias` — Read-only when true
- `isReadOnly: alias` — Alias of readOnly
- `maximumLength: alias` — Hard maximum text length
- `validator: alias` — Optional input validator
- `inputMethodHints: alias` — Qt input method hints
- `acceptableInput: alias` — Acceptable Input
- `field: alias` — Inner text field
- `hasError: bool` — True when validation failed
- `characterCount: int` — Character Count
- `overLimit: bool` — Over Limit

## Signals

- `accepted()` — Emitted on accept / submit
- `editingFinished()` — Editing Finished
- `textEdited()` — Text Edited
- `cleared()` — Emitted when content is cleared

## Methods

- `clear()` — Clear
- `focusField()` — Focus Field

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
