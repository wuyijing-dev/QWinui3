# TextField

Fluent / WinUI 3 TextBox-style TextField.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/TextField.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/TextField.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `TextField` — [`src/gallery/pages/TextFieldPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TextFieldPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
TextField {
    header: qsTr("Name")
    description: qsTr("Displayed on your profile.")
    placeholderText: qsTr("Enter a name")
    clearButtonVisible: true
}
```

## Notes

Header / description / errorMessage / characterLimit chrome around the field.
appearance: filled | outline. Leading icon + clear. For FormLayout left headers use HeaderedTextBox.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `header` | `string` | WinUI Header — label above the field |
| `description` | `string` | Supporting caption under the header (hidden while errorMessage is set) |
| `errorMessage` | `string` | Validation message — critical caption; also paints error chrome |
| `characterLimit` | `int` | Soft character counter (0 = hidden). Over-limit paints critical. |
| `hasError` | `bool` | Form validation error flag (also treated as error when errorMessage is set) |
| `appearance` | `string` | Visual variant: filled \| outline \| "" (filled default) |
| `leadingSymbol` | `var` | Leading FluentIcons symbol (preferred) or raw glyph |
| `leadingGlyph` | `string` | — |
| `clearButtonVisible` | `bool` | Show clear (×) when non-empty and editable |
| `isReadOnly` | `alias` | WinUI IsReadOnly alias |
| `characterCount` | `int` | — |
| `overLimit` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
