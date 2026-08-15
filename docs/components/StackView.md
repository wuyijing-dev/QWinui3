# StackView

Fluent styled StackView.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/StackView.qml`](../../src/style/QWinUI3/StackView.qml)

[← Component index](../components.md)

## Example

```qml
StackView {
    id: stack
    anchors.fill: parent
    initialItem: page1
}
stack.push(page2)
```

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `StackView` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
