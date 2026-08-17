# TextField

Fluent styled TextField.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/TextField.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/TextField.qml)

**Category:** Styled controls · **Library:** v1.75

[← Component index](../components.md)

**Gallery:** `TextField` — [`src/gallery/pages/TextFieldPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TextFieldPage.qml)

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

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `TextField` API (this file only supplies Fluent visuals / metrics).

### Inherited from `TextField`

- `text`
- `placeholderText`
- `accepted()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
