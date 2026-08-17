# StackView

Fluent styled StackView.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/StackView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/StackView.qml)

**Category:** Styled controls · **Library:** v2.62

[← Component index](../components.md)

**Gallery:** `StackView` — [`src/gallery/pages/StackViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/StackViewPage.qml)

## Example

```qml
StackView {
    id: stack
    anchors.fill: parent
    initialItem: page1
}
stack.push(page2)
```

## Notes

Style-only Fluent chrome for Qt Quick Controls StackView.
Public API is the Qt Quick Controls StackView type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `StackView` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
