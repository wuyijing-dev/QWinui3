# StackPanel

Simple stack layout (orientation + spacing).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StackPanel.qml`](../../src/extras/QWinUI3/Extras/StackPanel.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
StackPanel {
    id: stackPanel
   orientation: Qt.Vertical
}

// --- API ---
// methods: childWidth(c), childHeight(c), relayout()
// stackPanel.childWidth(c)
// stackPanel.childHeight(c)
// stackPanel.relayout()
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `contentData` | `alias` | Default children / content slot |
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `paddingEdges` | `int` | Edge paddings |
| `alignment` | `int` | Cross-axis alignment: Horizontal → vertical align; Vertical → horizontal align |
| `layoutDirection` | `int` | Qt layout direction |
| `stretchChildren` | `bool` | When true (default for Vertical), stretch children along the cross axis to host size |
| `childCount` | `int` | Number of children |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `childWidth(c)` | Child item width |
| `childHeight(c)` | Child item height |
| `relayout()` | Recompute layout |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
