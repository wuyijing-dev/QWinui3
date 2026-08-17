# SplitView

Fluent styled SplitView.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/SplitView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/SplitView.qml)

**Category:** Styled controls · **Library:** v1.70

[← Component index](../components.md)

**Gallery:** `SplitView` — [`src/gallery/pages/SplitViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SplitViewPage.qml)

## Example

```qml
SplitView {
    orientation: Qt.Horizontal
    Rectangle { SplitView.preferredWidth: 200; color: Theme.bgCard }
    Rectangle { SplitView.fillWidth: true; color: Theme.bgLayer }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls SplitView.
Public API is the Qt Quick Controls SplitView type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `SplitView` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
