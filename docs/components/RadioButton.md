# RadioButton

Fluent / WinUI 3 RadioButton (description caption).

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RadioButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/RadioButton.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `RadioButton` — [`src/gallery/pages/RadioButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RadioButtonPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
RadioButton {
    text: qsTr("Option A")
    description: qsTr("Recommended for most users.")
    checked: true
}
```

## Notes

Fluent chrome with optional description. Group with ButtonGroup or RadioButtons.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `description` | `string` | Supporting caption under the label (Fluent settings pattern) |
| `header` | `alias` | WinUI Header alias of text |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
