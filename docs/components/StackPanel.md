# StackPanel

Simple stack layout (orientation + spacing).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StackPanel.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/StackPanel.qml)

**Category:** Layout · **Library:** v1.06

[← Component index](../components.md)

**Gallery:** `StackPanel` — [`src/gallery/pages/StackPanelPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/StackPanelPage.qml)

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

## Notes

Simple stack/flow panel with orientation + spacing.

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
