# RelativePanel

Constraint-based relative layout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RelativePanel.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RelativePanel.qml)

**Category:** Layout · **Library:** v1.51

[← Component index](../components.md)

**Gallery:** `RelativePanel` — [`src/gallery/pages/RelativePanelPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RelativePanelPage.qml)

**Extends** `Item`.

## Example

```qml
RelativePanel {
    id: panel
    width: 320; height: 200
    Rectangle {
        id: a; width: 80; height: 40; color: Theme.accent
        RelativePanel.alignLeftWithPanel: true
        RelativePanel.alignTopWithPanel: true
    }
    Rectangle {
        width: 80; height: 40; color: Theme.fillSecondary
        RelativePanel.rightOf: a
        RelativePanel.alignTopWith: a
    }
}
```

## Notes

Constraint layout via RelativePanel.* attached properties on children.

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
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
