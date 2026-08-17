# WrapPanel

Flow / wrap layout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/WrapPanel.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/WrapPanel.qml)

**Category:** Layout · **Library:** v1.78

[← Component index](../components.md)

**Gallery:** `WrapPanel` — [`src/gallery/pages/WrapPanelPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/WrapPanelPage.qml)

**Extends** `Control`.

## Example

```qml
WrapPanel {
    id: wrap
    width: parent.width
    itemSpacing: 8
    horizontalSpacing: 12
    verticalSpacing: 6
    Repeater {
        model: 12
        Chip { text: "Tag " + index }
    }
}
// --- API ---
// wrap.itemSpacing / horizontalSpacing / verticalSpacing / orientation
```

## Notes

Wrapping flow of children; itemSpacing / horizontalSpacing / verticalSpacing / orientation.
implicitWidth is the single-line natural width (not availableWidth) to avoid Layout loops.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `contentData` | `alias` | Default children / content slot |
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `itemWidth` | `real` | Item width |
| `itemHeight` | `real` | Item height |
| `paddingEdges` | `int` | Edge paddings |
| `layoutDirection` | `int` | Qt layout direction |
| `itemSpacing` | `alias` | Uniform spacing alias (WinUI ItemSpacing) |
| `horizontalSpacing` | `real` | Gap between items on a line (<0 → spacing) |
| `verticalSpacing` | `real` | Gap between wrapped lines (<0 → spacing) |
| `childCount` | `int` | Number of children |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `relayout()` | Recompute wrapped layout |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
