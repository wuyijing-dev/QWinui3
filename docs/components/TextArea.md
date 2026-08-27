# TextArea

Fluent styled TextArea.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/TextArea.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/TextArea.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `TextArea` — [`src/gallery/pages/TextAreaPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TextAreaPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
TextArea {
    id: area
    placeholderText: qsTr("Notes")
    wrapMode: TextEdit.Wrap
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls TextArea.
Public API is the Qt Quick Controls TextArea type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `hasError` | `bool` | Form validation error (2.66 M3) |
| `appearance` | `string` | Visual variant: filled \| outline \| "" (filled default — 2.66 A2/M3) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
