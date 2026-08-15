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

- `panelSpacing: real` — Panel Spacing
- `paddingEdges: int` — Edge paddings

## Methods

- `isPanel(ref)` — Is Panel
- `leftEdge(ref)` — Left Edge
- `rightEdge(ref)` — Right Edge
- `topEdge(ref)` — Top Edge
- `bottomEdge(ref)` — Bottom Edge
- `centerX(ref)` — Center X
- `centerY(ref)` — Center Y
- `preferredWidth(item)` — Preferred Width
- `preferredHeight(item)` — Preferred Height
- `has(item, name)` — Has
- `relayout()` — Relayout

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
