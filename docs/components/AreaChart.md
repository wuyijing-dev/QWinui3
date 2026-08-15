# AreaChart

Filled area chart with legend and hover crosshair.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AreaChart.qml`](../../src/extras/QWinUI3/Extras/AreaChart.qml)

[← Component index](../components.md)

## Usage

```qml
AreaChart { values: [1, 3, 2, 5] }
```

## Properties

- `series: var` — Chart series array
- `values: var` — Numeric values array
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `showGrid: bool` — Show chart grid
- `stacked: bool` — Stack series instead of overlay
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `maxPoints: int` — Max points before LOD kicks in
- `lodFactor: real` — Level-of-detail downsample factor
- `autoLod: bool` — Auto-enable LOD for large series
- `gridColor: color` — Grid line color
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `hoverLineX: real` — Hover crosshair X
- `hoverMarkers: var` — Hover marker descriptors
- `hoverText: string` — Tooltip / hover readout text
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `sourcePointCount: int` — Raw point count before LOD
- `drawnPointCount: int` — Points drawn after LOD
- `isEmpty: bool` — True when there is no data
- `plotL: real` — Plot left inset
- `plotT: real` — Plot top inset
- `plotW: real` — Plot width
- `plotH: real` — Plot height

## Methods

- `invalidateLod()` — Invalidate level-of-detail cache
- `sourcePointCountEstimate()` — Estimated source point count before LOD
- `ensureLod(budget)` — Build LOD samples for the given budget
- `playReveal()`
- `requestRedraw()`
- `onDataChanged()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
