# UniformGrid

Even cell grid.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/UniformGrid.qml`](../../src/extras/QWinUI3/Extras/UniformGrid.qml)

[← Component index](../components.md)

## Usage

```qml
UniformGrid { columns: 3 }
```

## Properties

- `contentData: alias` — Default children / content slot
- `rows: int` — Grid row count
- `columns: int` — Grid column count
- `rowSpacing: real` — Vertical spacing between rows
- `columnSpacing: real` — Horizontal spacing between columns
- `cellWidth: real` — Cell width
- `cellHeight: real` — Cell height
- `layoutDirection: int` — Qt layout direction
- `cellSpacing: real` — Spacing between cells
- `childCount: int` — Number of children

## Methods

- `visibleChildren()` — Currently visible child items
- `relayout()` — Recompute layout

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
