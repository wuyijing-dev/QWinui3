# ChartSeries

Dense numeric series owned in C++ for million-point charts.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartSeries.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ChartSeries.h)

**Category:** Charts & gauges · **Library:** v2.67 · **C++ type**

[← Component index](../components.md)

**Gallery:** `LineChart` — [`src/gallery/pages/LineChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/LineChartPage.qml)

**Extends** `QObject`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `count` | `int` | — |
| `length` | `int` | — |
| `empty` | `bool` | — |
| `label` | `QString` | — |

### Signals

| Signature | Description |
| --- | --- |
| `dataChanged()` | — |
| `labelChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `clear()` | — |
| `generateWave(int count, qreal seed = 1.7)` | — |
| `generateCloud(int count, qreal seed = 0.37)` | — |
| `lod(int maxPoints) const)` | — |
| `densityLod(int binsX, int binsY) const)` | — |
| `valueAt(int index) const)` | — |
| `xAt(int index) const)` | — |
| `yAt(int index) const)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
