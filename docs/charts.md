# Charts & gauges (1.23)

High-traffic Canvas charts and dashboard gauges. **1.23** promotes a **named stable subset**; the rest of the catalog stays **experimental**.

| Surface | Status | Use when | Prefer |
|---------|--------|----------|--------|
| [`LineChart`](components/LineChart.md) | **Stable (1.23)** | Trends over categories / time | `series` or flat `values` |
| [`BarChart`](components/BarChart.md) | **Stable (1.23)** | Compare magnitudes | `values` or `bars` |
| [`DonutChart`](components/DonutChart.md) | **Stable (1.23)** | Part-to-whole | `slices` (or convenience `values`) |
| [`RingGauge`](components/RingGauge.md) | **Stable (1.23)** | Single metric 0…max (ring) | `value` + `unit` |
| [`KpiTile`](components/KpiTile.md) | **Stable (1.23)** | Dashboard metric tile | `unit`, optional `trendValues` |
| [`ChartCard`](components/ChartCard.md) | **Stable (1.23)** | Title/subtitle chrome around one chart | host one chart child |
| [`AreaChart`](components/AreaChart.md) / [`HorizontalBarChart`](components/HorizontalBarChart.md) / [`PieChart`](components/PieChart.md) | Experimental | Same families as above | same naming |
| Other gauges / niche charts | Experimental | See table below | same naming where applicable |

Example app: [`examples/dashboard`](../examples/dashboard/) — **only stable chart types**. Gallery: **Charts** hub + each control page.

---

## Stable subset (1.23)

Use these in production LoB dashboards when you need the “no silent renames” promise from [stable-api.md](stable-api.md):

`LineChart` · `BarChart` · `DonutChart` · `RingGauge` · `KpiTile` · `ChartCard`

Everything else in the Charts category remains experimental (API may still change).

---

## Naming (1.11, still required)

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

RingGauge {
    value: 64
    minimum: 0
    maximum: 100
    unit: "%"
    interactive: false   // alias of isInteractive
}

KpiTile {
    title: qsTr("CPU")
    value: 64
    unit: "%"
    trendValues: cpuHistory
}

ChartCard {
    title: qsTr("Utilization")
    LineChart { anchors.fill: parent; series: utilSeries }
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
- Point budgets, live buffers, and Gallery tips: **[performance.md](performance.md) (1.25)**.

---

## Empty & interaction

- Charts expose `isEmpty` + `emptyText`. Clear data with `values: []` / `slices: []` / `series: []`.
- `playReveal()` replays enter animation (honors `Theme.reducedMotion`).
- Clicks: `barClicked` / `sliceClicked` / gauge `valueEdited` when interactive.

---

## Still experimental

| Area | Examples |
|------|----------|
| Area / horizontal / pie siblings | `AreaChart`, `HorizontalBarChart`, `PieChart` |
| Niche charts | `RadarChart`, `ScatterChart`, `HeatmapChart`, `WaterfallChart`, `StackedBarChart`, `BulletChart`, `Sparkline` |
| Other gauges | `ArcGauge`, `RadialGauge`, `LinearGauge`, `TankGauge`, `ThermometerGauge`, `ZoneGauge`, `SegmentedGauge` |
| Helpers | `ChartLegend`, `ChartUtils` (usable; not in the stable promise) |

Same naming rules apply. Promote candidates for a later slice only after more soak.

---

## Out of scope

New chart engines, WebGL, screenshot diffs, Accessible completeness for every chart (tracked under a11y later).
