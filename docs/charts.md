# Charts & gauges (1.11)

Short recipe for the **high-traffic** Canvas charts and dashboard gauges. The full catalog stays **experimental** in [stable-api.md](stable-api.md) until a later promote slice (see roadmap **1.23**).

| Surface | Use when | Prefer |
|---------|----------|--------|
| [`LineChart`](components/LineChart.md) / [`AreaChart`](components/AreaChart.md) | Trends over categories / time | `series` or flat `values` |
| [`BarChart`](components/BarChart.md) / [`HorizontalBarChart`](components/HorizontalBarChart.md) | Compare magnitudes | `values` or `bars` |
| [`DonutChart`](components/DonutChart.md) / [`PieChart`](components/PieChart.md) | Part-to-whole | `slices` (or convenience `values`) |
| [`KpiTile`](components/KpiTile.md) + [`ChartCard`](components/ChartCard.md) | Dashboard chrome | `unit`, optional `trendValues` |
| [`ArcGauge`](components/ArcGauge.md) / [`RadialGauge`](components/RadialGauge.md) / [`LinearGauge`](components/LinearGauge.md) / [`RingGauge`](components/RingGauge.md) | Single metric 0…max | `value` + `unit` |
| [`ChartLegend`](components/ChartLegend.md) | Shared legend chrome | `items: [{ label, color }]` |

Example app: [`examples/dashboard`](../examples/dashboard/). Gallery: **Charts** hub + each control page.

---

## Naming (1.11)

Use these names in new code. Aliases keep old call sites working.

| Concept | Preferred | Also accepted |
|---------|-----------|---------------|
| Hover / click | `interactive` | `isInteractive` (gauges/KPI historically; charts alias both ways) |
| Unit suffix | `unit` | `valueUnit` on bar / waterfall charts (`unit` aliases it) |
| Multi-series | `series: [{ name, values, color? }]` | flat `values: number[]` → one series |
| Columns | `values: number[]` or `bars: [{ value, label?, color? }]` | — |
| Part-to-whole | `slices: [{ value, label?, color? }]` | `values` when `slices` is empty (Pie / Donut) |
| Gauge metric | `value` / `minimum` / `maximum` / `unit` | — |

```qml
LineChart {
    series: [
        { name: qsTr("CPU"), color: Theme.accent, values: cpuHistory },
        { name: qsTr("Mem"), color: Theme.systemCaution, values: memHistory }
    ]
}

BarChart {
    values: [18, 26, 22, 34]
    unit: " MB"          // alias of valueUnit
}

DonutChart {
    centerText: "72%"
    slices: [
        { value: 42, label: qsTr("Apps"), color: Theme.accent },
        { value: 18, label: qsTr("Media"), color: Theme.systemCaution }
    ]
    // or: values: [42, 18, 12]  when labels are optional
}

ArcGauge {
    value: 64
    minimum: 0
    maximum: 100
    unit: "%"
    interactive: false   // alias of isInteractive
}
```

---

## Theme & color

- Default series/bar/slice colors come from `ChartUtils.palette(Theme, index)` (`accent`, success, caution, critical, accent light/dark).
- Prefer **explicit** `color:` on series/slices for branded dashboards; keep Theme tokens so dark/light still work.
- Gauges: `fillColor` / thresholds → `Theme.systemCaution` / `Theme.systemCritical` when thresholds fire.

---

## Performance

- Line / Area: large `values` use **LOD** (`autoLod`, `maxPoints`, `lodFactor`). Prefer mutating data then `invalidateLod()` / `requestRedraw()` over rebuilding the whole control.
- Avoid binding `ChartUtils.makeWave(…)` in property bindings — call from a button or timer once.
- Prefer `ChartCard` around one chart; do not nest many full-size canvases in a single view without scroll virtualization.

---

## Empty & interaction

- Charts expose `isEmpty` + `emptyText`. Clear data with `values: []` / `slices: []` / `series: []`.
- `playReveal()` replays enter animation (honors `Theme.reducedMotion`).
- Clicks: `barClicked` / `sliceClicked` / gauge `valueEdited` when interactive.

---

## Still experimental

Radar, Scatter, Heatmap, Waterfall, StackedBar, Bullet, niche gauges (Tank, Thermometer, Zone, Segmented) follow the same naming where applicable but are **not** promote candidates in 1.11. See roadmap **1.23** for a named stable subset after soak.

---

## Out of scope

New chart engines, WebGL, screenshot diffs, Accessible completeness for every chart (tracked under a11y later).
