# RelativePanel

Constraint-based relative layout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RelativePanel.qml`](../../src/extras/QWinUI3/Extras/RelativePanel.qml)

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
RelativePanel {
    id: relativePanel
    // children with RelativePanel.* attached props
}

// --- API ---
// methods: isPanel(ref), leftEdge(ref), rightEdge(ref), topEdge(ref), bottomEdge(ref), centerX(ref), centerY(ref), preferredWidth(item), preferredHeight(item), has(item, name)
// relativePanel.isPanel(ref)
// relativePanel.leftEdge(ref)
// relativePanel.rightEdge(ref)
// relativePanel.topEdge(ref)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `panelSpacing` | `real` | Spacing between panels |
| `paddingEdges` | `int` | Edge paddings |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `isPanel(ref)` | True when rendered as a panel |
| `leftEdge(ref)` | Left edge anchor |
| `rightEdge(ref)` | Right edge anchor |
| `topEdge(ref)` | Top edge anchor |
| `bottomEdge(ref)` | Bottom edge anchor |
| `centerX(ref)` | Center X in local coords |
| `centerY(ref)` | Center Y in local coords |
| `preferredWidth(item)` | Preferred width hint |
| `preferredHeight(item)` | Preferred height hint |
| `has(item, name)` | True when the named case / key exists |
| `relayout()` | Recompute layout |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors` / `x` / `y`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
