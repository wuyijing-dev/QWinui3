# RelativePanel

Constraint-based relative layout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RelativePanel.qml`](../../src/extras/QWinUI3/Extras/RelativePanel.qml)

[← Component index](../components.md)

## Usage

```qml
RelativePanel {
    // children with RelativePanel.* attached props
}
```

## Properties

- `panelSpacing: real` — Spacing between panels
- `paddingEdges: int` — Edge paddings

## Methods

- `isPanel(ref)` — True when rendered as a panel
- `leftEdge(ref)` — Left edge anchor
- `rightEdge(ref)` — Right edge anchor
- `topEdge(ref)` — Top edge anchor
- `bottomEdge(ref)` — Bottom edge anchor
- `centerX(ref)` — Center X in local coords
- `centerY(ref)` — Center Y in local coords
- `preferredWidth(item)` — Preferred width hint
- `preferredHeight(item)` — Preferred height hint
- `has(item, name)` — True when the named case / key exists
- `relayout()` — Recompute layout

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
