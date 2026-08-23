# TextField

Fluent styled TextField.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/TextField.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/TextField.qml)

**Category:** Styled controls · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `TextField` — [`src/gallery/pages/TextFieldPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TextFieldPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
TextField {
    id: field
    placeholderText: qsTr("Name")
    onAccepted: submit(field.text)
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls TextField.
Public API is the Qt Quick Controls TextField type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `hasError` | `bool` | Form validation error (2.66 M3) |
| `appearance` | `string` | Visual variant: filled \| outline \| "" (filled default — 2.66 A2/M3) |
| `leadingSymbol` | `var` | Leading FluentIcons symbol (preferred) or raw glyph (2.67 — I11) |
| `leadingGlyph` | `string` | — |
| `clearButtonVisible` | `bool` | Show clear (×) when non-empty and editable |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
