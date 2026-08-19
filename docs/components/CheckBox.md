# CheckBox

Fluent styled CheckBox.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/CheckBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/CheckBox.qml)

**Category:** Styled controls · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `CheckBox` — [`src/gallery/pages/CheckBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CheckBoxPage.qml)

## Example

```qml
CheckBox {
    id: box
    text: qsTr("Remember me")
    checked: true
    onToggled: save()
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls CheckBox.
Public API is the Qt Quick Controls CheckBox type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `CheckBox` API (this file only supplies Fluent visuals / metrics).

### Inherited from `CheckBox`

- `text`
- `checked` / `checkState`
- `toggled()`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
