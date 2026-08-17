# Page

Fluent styled Page.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Page.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Page.qml)

**Category:** Styled controls · **Library:** v1.72

[← Component index](../components.md)

## Example

```qml
Page {
    header: Label { text: qsTr("Title"); leftPadding: 16; topPadding: 12 }
    Label { anchors.centerIn: parent; text: qsTr("Content") }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Page.
Public API is the Qt Quick Controls Page type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Page` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Page`

- `header` / `footer`
- `title`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
