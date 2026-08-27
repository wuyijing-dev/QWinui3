# Charts & gauges (1.23 / 1.66 / 2.08 / 2.65)

High-traffic Canvas charts and dashboard gauges.

**Import (3.36):** `LineChart` / `BarChart` / `DonutChart` / `ChartEmptyState` / `ChartSeries` live in **`QWinUI3.Extras.Charts`**. Shell apps (`Theme` + `Extras` + `Platform`) do **not** load that module. Add:

```qml
import QWinUI3.Extras          // ChartCard, KpiTile, RingGauge, DashboardShell
import QWinUI3.Extras.Charts   // LineChart, BarChart, DonutChart, …
```

Static C++: `QWINUI3_IMPORT_QML_PLUGINS_CHARTS` + `qwinui3_link_qml_import_set(app charts)` — [packaging-consumer.md](packaging-consumer.md). Example: [`examples/dashboard`](../examples/dashboard/).

**1.23** promoted a **named stable subset**. **1.66** keeps that six-pack frozen and **defers** the rest of the catalog. **2.08** finalizes compose recipes and **permanent defer** for sibling gauges — **no new stable chart names**. **2.65** deepens the stable six and ships **DashboardShell** / **MetricCompareRow** / **ChartEmptyState**. **3.05** adds **LiveMetricStrip** for throttled live KPI rows (**FL-014**).

| Surface | Status | Use when | Prefer |
|---------|--------|----------|--------|
| [`LineChart`](components/LineChart.md) | **Stable (1.23)** | Trends over categories / time | `series` or flat `values`; **`showArea: true`** instead of `AreaChart`; **`zoomEnabled`** for brush zoom (**2.65**) |
| [`BarChart`](components/BarChart.md) | **Stable (1.23)** | Compare magnitudes | `values` or `bars`; `stacked` / `horizontal`; **`samples` + `binCount`** for distributions (**3.06**) |
| [`DonutChart`](components/DonutChart.md) | **Stable (1.23)** | Part-to-whole | `slices` (or convenience `values`); `centerText` + `legendPosition` (**2.65**) |
| [`RingGauge`](components/RingGauge.md) | **Stable (1.23)** | Single metric 0…max (ring) | `value` + `unit` / `valueFormat` — **prefer over extra gauge types** |
| [`KpiTile`](components/KpiTile.md) | **Stable (1.23)** | Dashboard metric tile | `unit`, **`trendValues`**, **`compareValue`** / `sparklineHeight` (**2.65**) |
| [`ChartCard`](components/ChartCard.md) | **Stable (1.23)** | Title/subtitle chrome around one chart | host one chart child; `showExportAction` / `footer` (**2.65**) |
| [`DashboardShell`](components/DashboardShell.md) | **Stable host (2.65)** | Ops / analytics page layout | `kpiRow` + body + optional `filterPane` |
| [`MetricCompareRow`](components/MetricCompareRow.md) / [`ChartEmptyState`](components/ChartEmptyState.md) | **Compose (2.65)** | KPI compare strip / empty card | Prefer over ad-hoc Row + Labels |
| [`LiveMetricStrip`](components/LiveMetricStrip.md) | **Compose (3.05)** | Throttled live KPI + ring buffer + compare lag | Prefer over MetricCompareRow + manual Timer |
| Area / pie / extra gauges / niche | **Permanent defer (2.08)** | Gallery / prototypes only | compose table below |

Example app: [`examples/dashboard`](../examples/dashboard/) — **DashboardShell** + **LiveMetricStrip** + all six stable types. Gallery: **Charts** hub + **Dashboard** + **Ops console** (live strip).

**2.48 / FL-009:** compose decision tree — [dashboard-compose-decision.md](dashboard-compose-decision.md). **2.65** closes the friction row with hosts + deepen APIs.

Related: [stable-api.md](stable-api.md) · [performance.md](performance.md) · [recipes.md](recipes.md).

---

## Stable subset (frozen — 1.23 / 1.66 / 2.08)

Use these in production LoB dashboards when you need the “no silent renames” promise from [stable-api.md](stable-api.md):

`LineChart` · `BarChart` · `DonutChart` · `RingGauge` · `KpiTile` · `ChartCard`

**Redraw coalesce (**3.54** C25):** Canvas members (`LineChart` / `BarChart` / `DonutChart`) and `KpiTile` trends (via `Sparkline`) use `ChartUtils.redrawCoalesceMs`. `RingGauge` / `ChartCard` are non-Canvas — see [performance.md](performance.md#chart-coalesce-inventory-284-c6--290-audit--349-c20--354-c25).

Do **not** expand this list without a later named soak. Compose paths below replace deferred siblings without adding stable names.

---

## Compose recipes (2.08)

Copy these instead of deferred chart/gauge types. Gallery **Charts** and **Dashboard** demonstrate each path.

### Filled trend — `AreaChart` → `LineChart { showArea: true }`

```qml
ChartCard {
    title: qsTr("Throughput")
    LineChart {
        anchors.fill: parent
        showArea: true
        showLegend: true
        series: [
            { name: qsTr("In"), color: Theme.accent, values: inboundSeries },
            { name: qsTr("Out"), color: Theme.systemCaution, values: outboundSeries }
        ]
    }
}
```

Single series: `values: history` + `showArea: true`. Stacked areas: multiple `series` entries (same as deferred `AreaChart.stacked`).

### Inline trend — `Sparkline` → `KpiTile.trendValues` or compact `LineChart`

**Dashboard KPI row (preferred):**

```qml
KpiTile {
    title: qsTr("CPU")
    value: cpuPercent
    unit: "%"
    trendValues: cpuHistory   // inline sparkline strip inside the tile
    delta: 1.2
}
```

**Table / list row (compact line, no KPI chrome):**

```qml
LineChart {
    width: 120
    height: 28
    showArea: false
    showLegend: false
    showGrid: false
    interactive: false
    values: row.history
}
```

### Part-to-whole — `PieChart` → `DonutChart`

Same `slices` / `values` API. Use `centerText` / `centerSubText` for the hole label.

### Single metric — extra gauges → `RingGauge`

| Deferred gauge | Stable compose |
|----------------|----------------|
| `ArcGauge` · `RadialGauge` · `LinearGauge` | `RingGauge { value; minimum; maximum; unit }` |
| `TankGauge` · `ThermometerGauge` · `ZoneGauge` · `SegmentedGauge` | `RingGauge` + thresholds; or keep deferred type in Gallery-only demos |

**Verdict (2.08):** sibling gauges stay **experimental permanently** unless a future friction row proves a distinct LoB need. Product dashboards use **`RingGauge`**.

### Niche charts — permanent defer

`RadarChart` · `ScatterChart` · `HeatmapChart` · `WaterfallChart` · `StackedBarChart` · `HorizontalBarChart` · `BulletChart` — Gallery demos; compose with stable types or app-owned visuals when possible.

**Professional extras (Gallery, experimental — not stable six):** `ComboChart`, `FunnelChart`, `CandlestickChart`, `HistogramChart`, `BoxPlotChart`, `ParetoChart`, `BandChart`, `TreemapChart`, `PolarAreaChart`, `ViolinChart`, `ErrorBarChart`, `WaffleChart`, `LollipopChart`, `DumbbellChart`, `SunburstChart`, `CompassGauge`, `VuMeter`, `DualRingGauge`, `TachometerGauge`, `BatteryGauge`, `FuelGauge`, `QuarterGauge`, `DigitGauge`, `CylinderGauge`, `LedRingGauge`, `PressureGauge`, `SpeedometerGauge`, `CoolantGauge`, `BoostGauge`, `VoltageGauge`, `GearIndicator`, `OdometerGauge`, `TelltaleBar`, `TpmsGauge`, `GMeterGauge`, `AutomotiveCluster`. `RadialGauge.value2` / `RingGauge.value2` draw a second needle or inner ring. Stable six deepen: `LineChart.xAxisLabels` / `stepMode`, `BarChart.stacked` / `horizontal` / `series` / **`samples`+`binCount`** (**3.06**), `KpiTile.compareValue`.

---

## Deferred catalog (Gallery only — permanent defer 2.08)

Kept in the kit and Gallery. APIs may still change. **Do not** ship these names in product dashboards.

| Keep experimental | Prefer instead | Verdict |
|-------------------|----------------|---------|
| [`AreaChart`](components/AreaChart.md) | `LineChart { showArea: true }` | **Permanent defer** — compose recipe above |
| [`HorizontalBarChart`](components/HorizontalBarChart.md) | [`BarChart`](components/BarChart.md) | **Permanent defer** |
| [`PieChart`](components/PieChart.md) | [`DonutChart`](components/DonutChart.md) | **Permanent defer** |
| [`Sparkline`](components/Sparkline.md) | `KpiTile.trendValues` / compact `LineChart` | **Permanent defer** — compose recipe above |
| [`HistogramChart`](components/HistogramChart.md) | [`BarChart`](components/BarChart.md) `{ samples; binCount }` (**3.06**) | **Permanent defer** — experimental Gallery only |
| `ArcGauge` · `RadialGauge` · `LinearGauge` · `TankGauge` · `ThermometerGauge` · `ZoneGauge` · `SegmentedGauge` · `CompassGauge` · `VuMeter` · `DualRingGauge` · `TachometerGauge` · `BatteryGauge` · `FuelGauge` · `QuarterGauge` · `DigitGauge` · `CylinderGauge` · `LedRingGauge` · `PressureGauge` · `SpeedometerGauge` · `CoolantGauge` · `BoostGauge` · `VoltageGauge` · `GearIndicator` · `OdometerGauge` · `TelltaleBar` · `TpmsGauge` · `GMeterGauge` · `AutomotiveCluster` | [`RingGauge`](components/RingGauge.md) | **Permanent defer** |
| `ChartLegend` · `ChartUtils` | Usable helpers | Not in the freeze promise |

---

## Dashboard recipe

Copy [`examples/dashboard`](../examples/dashboard/): **LiveMetricStrip** (or a static **MetricCompareRow** of `KpiTile`) + `ChartCard` hosts for `LineChart` / `BarChart` / `DonutChart` + one `RingGauge`. One chart per card; live series stay short ([performance.md](performance.md)).

Gallery **Charts** hosts compose recipes (2.08) plus deferred demos. **Dashboard** splits stable layout from deferred tank/thermometer gauges.

---

## Recipe wave (2.26)

Gallery **Charts** hub refresh — every deferred sibling gets an explicit **compose path** or **Gallery-only** verdict. **No new stable chart names** (stable six unchanged).

| Deferred (Gallery) | Product compose | Open in Gallery |
|------------------|-----------------|-----------------|
| `AreaChart` | `LineChart { showArea: true }` | AreaChart · **LineChart** |
| `Sparkline` | `KpiTile.trendValues` or compact `LineChart` | Sparkline · **KpiTile** |
| `PieChart` | `DonutChart` (same `slices` / `values`) | PieChart · **DonutChart** |
| `StackedBarChart` | `LineChart { showArea: true; series: […] }` stacked areas | StackedBarChart · **Charts** demo |
| `HorizontalBarChart` | `BarChart { bars: [{ value, label }] }` ranked columns | HorizontalBarChart · **BarChart** |
| `HistogramChart` | `BarChart { samples; binCount }` (**3.06**) | HistogramChart · **BarChart** |
| `BulletChart` | `KpiTile` + thresholds / `RingGauge` for single metric | BulletChart · **KpiTile** |
| `WaterfallChart` | Precompute bridge steps → `BarChart` bars, or keep deferred in Gallery | WaterfallChart |
| `RadarChart` · `ScatterChart` · `HeatmapChart` | **Gallery-only** — app-owned visuals or stable six approximations | respective pages |
| Extra gauges (`Tank`, `Thermometer`, `Arc`, …) | `RingGauge` | **Dashboard** deferred section |

```qml
// StackedBarChart → LineChart (2.26)
ChartCard {
    title: qsTr("Weekly mix")
    LineChart {
        anchors.fill: parent
        showArea: true
        showLegend: true
        series: [
            { name: qsTr("Apps"), color: Theme.accent, values: appsWeek },
            { name: qsTr("Media"), color: Theme.systemCaution, values: mediaWeek }
        ]
    }
}

// HorizontalBarChart → ranked BarChart (2.26)
BarChart {
    showValueLabels: true
    unit: "%"
    bars: [
        { value: 92, label: qsTr("Design"), color: Theme.accent },
        { value: 78, label: qsTr("Eng"), color: Theme.systemSuccess }
    ]
}

// BulletChart → KpiTile (2.26)
KpiTile {
    title: qsTr("Revenue")
    value: revenue
    unit: "%"
    delta: revenue - 80
    cautionThreshold: 75
    criticalThreshold: 90
    badgeText: revenue >= 80 ? qsTr("On target") : qsTr("Below target")
}
```

Smoke: `python scripts/smoke_gallery.py`. Hub: Gallery **Charts** · **Dashboard** · **Ops console** · [`examples/dashboard`](../examples/dashboard/).

---

## Dashboard layout (2.22)

Responsive ops layout using **stable six only** — no `Hub` / `HubSection` controls.

| Breakpoint | Width | Layout |
|------------|-------|--------|
| KPI row | `> 700` | `GridLayout` **3** columns; else **1** (stack) |
| Chart grid | `> 900` | `GridLayout` **2** columns; else **1** |
| Filter rail | `≥ 720` (`TwoPaneView.minWideWidth`) | Filters in **pane1**, charts in **pane2**; below → **SinglePane** |

```qml
// KPI row — bind columns to content width
GridLayout {
    columns: root.width > 700 ? 3 : 1
    rowSpacing: Theme.spacingLoose
    columnSpacing: Theme.spacingLoose
    KpiTile { Layout.fillWidth: true; trendValues: cpuHistory; … }
}

// Charts + optional filter rail
TwoPaneView {
    Layout.fillWidth: true
    preferredMode: TwoPaneView.Wide
    minWideWidth: 720
    pane1: filterSidebar   // ComboBox, toggles — not a Hub control
    pane2: GridLayout {
        columns: root.width > 900 ? 2 : 1
        ChartCard { … LineChart … }
        ChartCard { … RingGauge … }
    }
}
```

**Example app:** [`examples/dashboard`](../examples/dashboard/) ships live breakpoint readout + filter `TwoPaneView`. Gallery **Dashboard** mirrors the same KPI/chart column math.

Related: [icons-dashboard-expansion.md](planning/expansion/icons-dashboard-expansion.md) (**KpiTile** / **ChartCard.symbol** matrix).

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

- **Source vs draw (**3.45** H14):** cap live history at the source (`LiveMetricStrip.maxPoints`, `KpiTile.pushTrend`, `ChartSeries.capacity`, `ChartUtils.trimRing`); Canvas still uses **LOD** (`autoLod`, `maxPoints`, `lodFactor`) — defaults unchanged.
- Line / Area: large `values` use **LOD**. Prefer mutating data then `invalidateLod()` / `requestRedraw()` over rebuilding the whole control.
- Avoid binding `ChartUtils.makeWave(…)` in property bindings — call from a button or timer once.
- Prefer `ChartCard` around one chart; do not nest many full-size canvases in a single view without scroll virtualization.
- Point budgets, ring tables, and Gallery tips: **[performance.md](performance.md#source-ring-caps-vs-draw-lod-345-h14)**.

---

## Empty & interaction

- Charts expose `isEmpty` + `emptyText`. Clear data with `values: []` / `slices: []` / `series: []`.
- `playReveal()` replays enter animation (honors `Theme.reducedMotion`).
- Clicks: `barClicked` / `sliceClicked` / gauge `valueEdited` when interactive.

---

## Out of scope

New chart engines, WebGL, replacing Qt Graphs, screenshot diffs, Accessible completeness for every chart (tracked under a11y later).
