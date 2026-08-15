# Slider

Fluent styled Slider.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Slider.qml`](../../src/style/QWinUI3/Slider.qml)

[← Component index](../components.md)

## Example

```qml
Slider {
    id: slider
    from: 0; to: 100; value: 40
    onMoved: apply(slider.value)
}
```

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Slider` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
