# Dashboard example

Monitoring layout with **DashboardShell** + the **six stable** chart types (`KpiTile`, `ChartCard`, `LineChart`, `BarChart`, `DonutChart`, `RingGauge`) — no Gallery chrome.

Promote list + compose recipes: [`docs/charts.md`](../../docs/charts.md) (**1.23** / **1.66** / **2.08** / **2.65**).

**2.65 Wave A:** `DashboardShell` (filter rail + KPI strip + body), `MetricCompareRow`, `ChartEmptyState`, `LineChart.zoomEnabled`, `ChartCard` export footer, `KpiTile.compareValue` / `sparklineHeight`, `RingGauge.valueFormat`, `DonutChart.legendPosition`.

**2.08:** `KpiTile.trendValues` replaces `Sparkline`; `LineChart { showArea: true }` replaces `AreaChart`. Sibling gauges permanently deferred — use `RingGauge`.

```bat
cmake --build build --config Release --target qwinui3_example_dashboard
build\qwinui3_example_dashboard.exe
```

Resize the window to see chart columns and the filter rail collapse (narrow keeps the chart pane).
