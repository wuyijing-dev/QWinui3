# Charts & gauges (1.23 / 1.66)

High-traffic Canvas charts and dashboard gauges. **1.23** promoted a **named stable subset**. **1.66** keeps that six-pack frozen and **defers** the rest of the catalog for remaining 1.xx — Gallery still demos them; product apps should not treat those names as freeze-covered.

| Surface | Status | Use when | Prefer |
|---------|--------|----------|--------|
| [`LineChart`](components/LineChart.md) | **Stable (1.23)** | Trends over categories / time | `series` or flat `values` |
| [`BarChart`](components/BarChart.md) | **Stable (1.23)** | Compare magnitudes | `values` or `bars` |
| [`DonutChart`](components/DonutChart.md) | **Stable (1.23)** | Part-to-whole | `slices` (or convenience `values`) |
| [`RingGauge`](components/RingGauge.md) | **Stable (1.23)** | Single metric 0…max (ring) | `value` + `unit` |
| [`KpiTile`](components/KpiTile.md) | **Stable (1.23)** | Dashboard metric tile | `unit`, optional `trendValues` |
| [`ChartCard`](components/ChartCard.md) | **Stable (1.23)** | Title/subtitle chrome around one chart | host one chart child |
| Area / pie / extra gauges / niche | **Deferred (1.66)** | Gallery / prototypes | table below |

Example app: [`examples/dashboard`](../examples/dashboard/) — **all six stable types**. Gallery: **Charts** hub + **Dashboard** (stable row vs deferred gauges).

Related: [stable-api.md](stable-api.md) · [performance.md](performance.md) · [recipes.md](recipes.md).

---

## Stable subset (1.23, unchanged 1.66)

Use these in production LoB dashboards when you need the “no silent renames” promise from [stable-api.md](stable-api.md):

`LineChart` · `BarChart` · `DonutChart` · `RingGauge` · `KpiTile` · `ChartCard`

Do **not** expand this list without a later named soak. `LineChart { showArea: true }` covers filled trends without `AreaChart`.

---

## Deferred — won’t promote in remaining 1.xx (1.66)

Kept in the kit and Gallery. APIs may still change. Same [naming](#naming-111-still-required) aliases apply.

| Keep experimental | Prefer instead | Why |
|-------------------|----------------|-----|
| [`AreaChart`](components/AreaChart.md) | `LineChart` + `showArea: true` | Sibling of the stable line |
| [`HorizontalBarChart`](components/HorizontalBarChart.md) | [`BarChart`](components/BarChart.md) | Same family, less soak |
| [`PieChart`](components/PieChart.md) | [`DonutChart`](components/DonutChart.md) | Same part-to-whole |
| [`Sparkline`](components/Sparkline.md) | `KpiTile.trendValues` / `LineChart` | Inline glyph, not a dashboard card |
| `RadarChart` · `ScatterChart` · `HeatmapChart` · `WaterfallChart` · `StackedBarChart` · `BulletChart` | Stay experimental or custom | Niche; no LoB freeze |
| `ArcGauge` · `RadialGauge` · `LinearGauge` · `TankGauge` · `ThermometerGauge` · `ZoneGauge` · `SegmentedGauge` | [`RingGauge`](components/RingGauge.md) | Extra gauges |
| `ChartLegend` · `ChartUtils` | Usable helpers | Not in the freeze promise |

---

## Dashboard recipe

Copy [`examples/dashboard`](../examples/dashboard/): `KpiTile` row + `ChartCard` hosts for `LineChart` / `BarChart` / `DonutChart` + one `RingGauge`. One chart per card; live series stay short ([performance.md](performance.md)).

Gallery **Charts** hosts Dashboard, KpiTile, gauges, and the chart family. **Dashboard** splits the same stable layout from **deferred** tank/thermometer demos so the hub matches this page.

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

## Out of scope

New chart engines, WebGL, replacing Qt Graphs, screenshot diffs, Accessible completeness for every chart (tracked under a11y later).
