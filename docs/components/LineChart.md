# LineChart

Multi-series line/area chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LineChart.qml`](../../src/extras/QWinUI3/Extras/LineChart.qml)

[← Component index](../components.md)

## Usage

```qml
LineChart { values: [1, 4, 2, 6] }
```

## Properties

- `series: var` — Chart series array
- `values: var` — Numeric values array
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `showGrid: bool` — Show chart grid
- `showArea: bool` — Fill area under the line
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `maxPoints: int` — Max points before LOD kicks in
- `lodFactor: real` — Level-of-detail downsample factor
- `autoLod: bool` — Auto-enable LOD for large series
- `strokeWidth: real` — Stroke thickness in px
- `gridColor: color` — Grid line color
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `hoverX: real` — Hover X
- `hoverY: real` — Hover Y
- `hoverLineX: real` — Hover crosshair X
- `hoverMarkers: var` — Hover marker descriptors
- `hoverText: string` — Tooltip / hover readout text
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `sourcePointCount: int` — LOD diagnostics
- `drawnPointCount: int` — Points drawn after LOD
- `isEmpty: bool` — True when there is no data
- `plotL: real` — Cache last paint metrics for hover hit-testing

## Methods

- `playReveal()` — Play Reveal
- `sourcePointCountEstimate()` — Source Point Count Estimate
- `invalidateLod()` — Invalidate Lod
- `ensureLod(budget)`
- `requestRedraw()`
- `onDataChanged()`
- `clearHover()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
