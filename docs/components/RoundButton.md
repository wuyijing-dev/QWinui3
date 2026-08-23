# RoundButton

Fluent styled RoundButton.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RoundButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/RoundButton.qml)

**Category:** Styled controls · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
RoundButton {
    id: round
    text: "+"
    enabled: true
    onClicked: add()
}
// --- API ---
// inherits AbstractButton: text, enabled, clicked()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls RoundButton.
Public API is the Qt Quick Controls RoundButton type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `RoundButton` API (this file only supplies Fluent visuals / metrics).

### Inherited from `RoundButton`

- `text`
- `clicked()`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
