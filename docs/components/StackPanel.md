# StackPanel

Simple stack layout (orientation + spacing).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StackPanel.qml`](../../src/extras/QWinUI3/Extras/StackPanel.qml)

[← Component index](../components.md)

## Usage

```qml
StackPanel { orientation: Qt.Vertical }
```

## Properties

- `contentData: alias` — Default children / content slot
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `paddingEdges: int` — Edge paddings
- `alignment: int` — Cross-axis alignment: Horizontal → vertical align; Vertical → horizontal align
- `layoutDirection: int` — Qt layout direction
- `stretchChildren: bool` — When true (default for Vertical), stretch children along the cross axis to host size
- `childCount: int` — Number of children

## Methods

- `childWidth(c)` — Child Width
- `childHeight(c)` — Child Height
- `relayout()` — Relayout

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
