# FocusStroke

Focus ring helper.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/FocusStroke.qml`](../../src/style/QWinUI3/FocusStroke.qml)

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `Item`.

## Example

```qml
FocusStroke { anchors.fill: parent; visible: control.visualFocus }
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `show` | `bool` | Show the control |
| `frameRadius` | `real` | Frame corner radius |
| `outerSize` | `real` | Outer size |
| `innerSize` | `real` | Inner size |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors` / `x` / `y`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
