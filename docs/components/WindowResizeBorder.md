# WindowResizeBorder

Non-native resize hit edges.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/WindowResizeBorder.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/WindowResizeBorder.qml)

**Category:** Platform · **Library:** v1.80

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `Item`.

## Example

```qml
WindowResizeBorder {
    id: windowResizeBorder
   targetWindow: root
}

// --- API ---
// methods: edgeResize(edges)
// windowResizeBorder.edgeResize(edges)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `targetWindow` | `var` | Window this chrome is attached to |
| `thickness` | `real` | Donut ring thickness |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `edgeResize(edges)` | Enable edge resize grips |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
