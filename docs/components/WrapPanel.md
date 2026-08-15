# WrapPanel

Flow / wrap layout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/WrapPanel.qml`](../../src/extras/QWinUI3/Extras/WrapPanel.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
WrapPanel {
    Repeater { model: 8; Chip { text: modelData } }
}
```

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
| `childCount` | `int` | Number of children |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
