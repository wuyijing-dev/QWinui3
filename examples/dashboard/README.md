# Dashboard example

Monitoring layout with **all six stable** chart types (`KpiTile`, `ChartCard`, `LineChart`, `BarChart`, `DonutChart`, `RingGauge`) — no Gallery chrome.

Promote list + compose recipes: [`docs/charts.md`](../../docs/charts.md) (**1.23** / **1.66** / **2.08**).

**2.08:** `KpiTile.trendValues` replaces `Sparkline`; `LineChart { showArea: true }` replaces `AreaChart`. Sibling gauges permanently deferred — use `RingGauge`.

**2.22:** Responsive breakpoints — KPI `GridLayout` (3 cols when width > 700), chart grid (2 cols when > 900), optional filter rail via `TwoPaneView` (`minWideWidth: 720`). Live readout in the example window.

```bat
cmake --build build --config Release --target qwinui3_example_dashboard
build\qwinui3_example_dashboard.exe
```

Resize the window to see KPI/chart columns and filter pane mode change.
