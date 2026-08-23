# UniformGrid

Even cell grid.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/UniformGrid.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/UniformGrid.qml)

**Category:** Input & forms · **Library:** v2.66

[← Component index](../components.md)

**Gallery:** `UniformGrid` — [`src/gallery/pages/UniformGridPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/UniformGridPage.qml)

**Extends** `Control`.

## Example

```qml
UniformGrid {
    id: uniformGrid
    columns: 3
}

// --- API ---
// methods: visibleChildren(), relayout()
// uniformGrid.visibleChildren()
// uniformGrid.relayout()
```

## Notes

Even cell grid; columns / rows + cellSpacing.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `contentData` | `alias` | Default children / content slot |
| `rows` | `int` | Grid row count |
| `columns` | `int` | Grid column count |
| `rowSpacing` | `real` | Vertical spacing between rows |
| `columnSpacing` | `real` | Horizontal spacing between columns |
| `cellWidth` | `real` | Cell width |
| `cellHeight` | `real` | Cell height |
| `layoutDirection` | `int` | Qt layout direction |
| `cellSpacing` | `real` | Spacing between cells |
| `childCount` | `int` | Number of children |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `visibleChildren()` | Currently visible child items |
| `relayout()` | Recompute layout |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
