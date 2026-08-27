# ToolButton

Fluent styled ToolButton.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ToolButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ToolButton.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
ToolBar {
    ToolButton {
        text: qsTr("Edit")
        appearance: "subtle"
        onClicked: startEdit()
    }
}
```

## Notes

Style-only Fluent chrome. appearance: subtle | outline | ghost | "" (subtle default — 3.11).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `appearance` | `string` | Visual variant: subtle \| outline \| ghost \| "" (subtle) — 3.11 |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
