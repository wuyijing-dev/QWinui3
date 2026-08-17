# Frame

Fluent styled Frame.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Frame.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Frame.qml)

**Category:** Styled controls · **Library:** v1.72

[← Component index](../components.md)

**Gallery:** `Frame` — [`src/gallery/pages/FramePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FramePage.qml)

## Example

```qml
Frame {
    id: frame
    Label { text: qsTr("Framed content") }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Frame.
Must declare implicitWidth/Height like Basic — otherwise Layout hosts collapse
to ~0 and children paint over siblings (e.g. Gallery “Source code”).

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Frame` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Frame`

- `padding`
- `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
