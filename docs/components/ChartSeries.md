# ChartSeries

Dense numeric series owned in C++ for million-point charts.

`import QWinUI3.Extras.Charts` · [`src/extras/QWinUI3/Extras/ChartSeries.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ChartSeries.h)

**Category:** Charts & gauges · **Library:** v3.10 · **C++ type**

[← Component index](../components.md)

**Gallery:** `LineChart` — [`src/gallery/pages/LineChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/LineChartPage.qml)

**Extends** `QObject`.

## Notes

Opt-in ring buffer (**3.45** H14): `capacity` **0** = unlimited (default). When `capacity > 0`,
`append` / `appendXY` / `generateWave` / `generateCloud` drop oldest samples. Draw-time LOD
(`lod` / chart `autoLod`) is separate — [performance.md](../performance.md#source-ring-caps-vs-draw-lod-345-h14).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `count` | `int` | — |
| `length` | `int` | — |
| `empty` | `bool` | — |
| `capacity` | `int` | Max retained samples; **0** = unlimited (3.45) |
| `label` | `QString` | — |

### Signals

| Signature | Description |
| --- | --- |
| `dataChanged()` | — |
| `capacityChanged()` | — |
| `labelChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `clear()` | — |
| `generateWave(int count, qreal seed = 1.7)` | — |
| `generateCloud(int count, qreal seed = 0.37)` | — |
| `append(qreal y)` | Append Y; trim to `capacity` when set (3.45) |
| `appendXY(qreal x, qreal y)` | Append X/Y pair; trim to `capacity` when set (3.45) |
| `lod(int maxPoints) const)` | — |
| `densityLod(int binsX, int binsY) const)` | — |
| `valueAt(int index) const)` | — |
| `xAt(int index) const)` | — |
| `yAt(int index) const)` | — |

---
*Synced with ChartSeries.h for **3.45** H14 — regenerate with `scripts/generate_component_docs.py` when convenient.*
