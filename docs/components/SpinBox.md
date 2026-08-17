# SpinBox

Fluent styled SpinBox.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/SpinBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/SpinBox.qml)

**Category:** Styled controls · **Library:** v1.81

[← Component index](../components.md)

**Gallery:** `SpinBox` — [`src/gallery/pages/SpinBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SpinBoxPage.qml)

## Example

```qml
SpinBox {
    id: spin
    from: 0; to: 10; value: 3
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls SpinBox.
Public API is the Qt Quick Controls SpinBox type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `SpinBox` API (this file only supplies Fluent visuals / metrics).

### Inherited from `SpinBox`

- `from` / `to`
- `value`
- `valueModified()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
