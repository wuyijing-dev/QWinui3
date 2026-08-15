# ChartUtils

LOD helpers for large chart series.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartUtils.qml`](../../src/extras/QWinUI3/Extras/ChartUtils.qml)

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

## Usage

```qml
ChartUtils.downsample(values, maxPoints)
```

## Properties

- `largeSeriesThreshold: int` — Point count that triggers LOD

## Methods

- `asNumber(v, fallback)` — As Number
- `valueCount(input)` — Value Count
- `valueAt(input, index, fallback)` — Read one numeric sample without allocating a flattened copy.
- `pointX(input, index)` — Point X
- `pointY(input, index)` — Point Y
- `pointColor(input, index)` — Point Color
- `flattenValues(input)` — Prefer valueAt/valueCount for large series. Dense number arrays are returned as-is.
- `extents(values)` — Extents
- `extentsXY(points)` — Extents XY
- `lodBudget(plotWidth, maxPoints, factor)` — Pixel-aware draw budget. Default keeps ~2 samples per horizontal pixel.
- `buildLod(values, maxPoints)` — Prefers ChartSeries.lod (C++) when available.

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
