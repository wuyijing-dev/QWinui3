# RoundButton

Fluent styled RoundButton.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RoundButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/RoundButton.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
RoundButton {
    text: "+"
    appearance: "filled"   // filled | subtle | outline | ghost | "" (standard)
    loading: false
    onClicked: add()
}
```

## Notes

Style chrome. Empty appearance keeps bordered rest chrome; highlighted → accent.
loading shows BusyIndicator and blocks click (3.11 / M11).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `appearance` | `string` | Visual variant: filled \| subtle \| outline \| ghost \| "" (standard bordered) — 3.11 |
| `loading` | `bool` | Async action — inline busy ring, disables click (3.11) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
