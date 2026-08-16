# ChartUtils

LOD helpers for large chart series.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartUtils.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ChartUtils.qml)

**Category:** Charts & gauges · **Library:** v1.08

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `QtObject`.

## Example

```qml
ChartUtils.downsample(values, maxPoints)

// --- API ---
// methods: asNumber(v, fallback), valueCount(input), valueAt(input, index, fallback), pointX(input, index), pointY(input, index), pointColor(input, index), flattenValues(input), extents(values), extentsXY(points), lodBudget(plotWidth, maxPoints, factor)
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

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `asNumber(v, fallback)` | Coerce input to number with fallback |
| `valueCount(input)` | Number of values in the series input |
| `valueAt(input, index, fallback)` | Read one numeric sample without allocating a flattened copy. |
| `pointX(input, index)` | X coordinate for a series point |
| `pointY(input, index)` | Y coordinate for a series point |
| `pointColor(input, index)` | Color for a series point |
| `flattenValues(input)` | Prefer valueAt/valueCount for large series. Dense number arrays are returned as-is. |
| `extents(values)` | Min/max extents of a value series |
| `extentsXY(points)` | X/Y extents of a point series |
| `lodBudget(plotWidth, maxPoints, factor)` | Pixel-aware draw budget. Default keeps ~2 samples per horizontal pixel. |
| `buildLod(values, maxPoints)` | Prefers ChartSeries.lod (C++) when available. |
| `downsample(values, maxPoints)` | Back-compat for Sparkline / older call sites. |
| `densitySample(points, binsX, binsY, minX, maxX, minY, maxY)` | Density binning for scatter — collapses N points into ≤ binsX*binsY cells. |
| `makeWave(count, seed)` | Build a large numeric series (call from a button — not from a binding). |
| `makeCloud(count, seed)` | Build a soft cloud brush / fill path |
| `palette(theme, index)` | Resolve a chart palette color by index |
| `withAlpha(color, alpha)` | Return color with overridden alpha |
| `formatNumber(v, digits)` | Format a number for axis / tooltip text |
| `lerp(a, b, t)` | Linear interpolate between two numbers |
| `formatCount(n)` | Format count |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
