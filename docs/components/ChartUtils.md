# ChartUtils

LOD helpers for large chart series.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartUtils.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ChartUtils.qml)

**Category:** Charts & gauges · **Library:** v2.81 · **singleton**

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `QtObject`.

## Example

```qml
ChartUtils.downsample(values, maxPoints)

// --- API ---
// methods: asNumber(v, fallback), valueCount(input), valueAt(input, index, fallback), pointX(input, index), pointY(input, index), pointColor(input, index), flattenValues(input), extents(values), extentsXY(points), lodBudget(plotWidth, maxPoints, factor), boxPlotStats(values), paretoRows(values), treemapRects(slices, x, y, w, h), violinWidths(values, binCount)
// chartUtils.asNumber(v, fallback)
// chartUtils.valueCount(input)
// chartUtils.valueAt(input, index, fallback)
// chartUtils.pointX(input, index)
```

## Notes

Internal helpers: downsample, extents, palette, formatNumber (used by chart controls).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `largeSeriesThreshold` | `int` | Point count that triggers LOD |
| `revealAnimationPointBudget` | `int` | Reveal animation runs only up to this many points (1.25 / 1.89) |
| `redrawCoalesceMs` | `int` | Coalesce canvas repaints during reveal / hover (ms) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `shouldAnimateReveal(pointCount, animated)` | True when entrance reveal should animate (not snap) |
| `shouldAnimateDataUpdate(pointCount, animateUpdates)` | True when series value tweens should run on data updates (2.68 B4) |
| `lerpValues(fromArr, toArr, t)` | Lerp two flat number arrays toward `to` at progress t (0..1) |
| `asNumber(v, fallback)` | Coerce input to number with fallback |
| `valueCount(input)` | Number of values in the series input |
| `valueAt(input, index, fallback)` | Read one numeric sample without allocating a flattened copy. |
| `pointX(input, index)` | X coordinate for a series point |
| `pointY(input, index)` | Y coordinate for a series point |
| `pointColor(input, index)` | Color for a series point |
| `flattenValues(input)` | Prefer valueAt/valueCount for large series. Dense number arrays are returned as-is. |
| `extents(values)` | Min/max extents of a value series |
| `histogramBins(values, binCount)` | Histogram bins from a numeric series. Returns [{ from, to, count, value }]. |
| `extentsXY(points)` | X/Y extents of a point series |
| `lodBudget(plotWidth, maxPoints, factor)` | Pixel-aware draw budget. Default keeps ~2 samples per horizontal pixel. |
| `buildLod(values, maxPoints)` | Prefers ChartSeries.lod (C++) when available. |
| `downsample(values, maxPoints)` | Back-compat for Sparkline / older call sites. |
| `douglasPeucker(values, maxPoints)` | Douglas–Peucker for y-series (x = index). Returns ≤ maxPoints samples. |
| `buildLodDouglas(values, maxPoints)` | — |
| `densitySample(points, binsX, binsY, minX, maxX, minY, maxY)` | Density binning for scatter — collapses N points into ≤ binsX*binsY cells. |
| `makeWave(count, seed)` | Build a large numeric series (call from a button — not from a binding). |
| `makeCloud(count, seed)` | Build a soft cloud brush / fill path |
| `palette(theme, index)` | Resolve a chart palette color by index |
| `withAlpha(color, alpha)` | Return color with overridden alpha |
| `formatNumber(v, digits)` | Format a number for axis / tooltip text |
| `lerp(a, b, t)` | Linear interpolate between two numbers |
| `formatCount(n)` | Format count |
| `boxPlotStats(values)` | Tukey five-number summary for a numeric series |
| `paretoRows(values)` | Sorted Pareto rows with cumulative share (0..1) |
| `treemapRects(slices, x, y, w, h)` | Slice-and-dice treemap rectangles { x, y, w, h, index } |
| `violinWidths(values, binCount)` | Histogram bins with a 0..1 width for violin / density charts |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
