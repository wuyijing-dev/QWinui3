# SelectionPip

Navigation selection pip indicator.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/SelectionPip.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/SelectionPip.qml)

**Category:** Styled controls · **Library:** v0.1.0

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `Item`.

## Example

```qml
SelectionPip {
    id: selectionPip
   
}

// --- API ---
// methods: snapTo(index), animateTo(index)
// selectionPip.snapTo(index)
// selectionPip.animateTo(index)
```

## Notes

Style-only Fluent chrome for Qt Quick Controls SelectionPip.
Public API is the Qt Quick Controls SelectionPip type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `listView` | `var` | ListView this pip tracks |
| `targetIndex` | `int` | Index the pip should track |
| `baseHeight` | `real` | Pip rest height |
| `leftMargin` | `real` | Pip left inset |
| `instant` | `bool` | Skip motion when true |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `snapTo(index)` | Snap the selection pip instantly |
| `animateTo(index)` | Animate the selection pip to the target |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
