# Dashboard compose decision (2.48 / FL-009)

**Friction row:** **FL-009** — teams guess deferred chart/gauge names vs stable compose paths.

**Rule:** Product dashboards use the **stable six** only. Every deferred sibling has a **compose path** or **Gallery-only** verdict — [charts.md](charts.md) recipe wave (**2.26**). Icons: [icons-dashboard-expansion.md](planning/expansion/icons-dashboard-expansion.md).

Validation: `python scripts/check_friction_slot_248.py`

---

## Decision tree

```
Need a dashboard visual?
├─ Single headline metric + trend spark?
│  └─ YES → KpiTile { trendValues }          (NOT Sparkline in product)
├─ Time series / area under line?
│  └─ YES → ChartCard + LineChart { showArea: true }   (NOT AreaChart)
├─ Category share / donut?
│  └─ YES → ChartCard + DonutChart           (NOT PieChart)
├─ Ranked bars / horizontal compare?
│  └─ YES → ChartCard + BarChart             (NOT HorizontalBarChart)
├─ One % on a ring?
│  └─ YES → ChartCard + RingGauge            (NOT Tank/Thermometer/Arc)
├─ Multi-series stacked area?
│  └─ YES → LineChart { showArea; series: […] }        (NOT StackedBarChart)
├─ Radar / scatter / heatmap / waterfall?
│  └─ YES → App-owned visual OR Gallery-only demo      (NOT stable-api)
└─ Layout + filter rail?
   └─ YES → TwoPaneView + stable six tiles    (see examples/dashboard)
```

---

## Stable six (ship these)

| Need | Control | Avoid in product |
|------|---------|------------------|
| KPI + inline trend | **KpiTile** | `Sparkline`, `BulletChart` |
| Line / area series | **LineChart** in **ChartCard** | `AreaChart` |
| Bars | **BarChart** in **ChartCard** | `HorizontalBarChart`, `StackedBarChart` |
| Share / mix | **DonutChart** in **ChartCard** | `PieChart` |
| Headline % ring | **RingGauge** in **ChartCard** | `TankGauge`, `ThermometerGauge`, `ArcGauge` |
| Card chrome + icon | **ChartCard** + `symbol` | Raw chart without header |

Copy [`examples/dashboard`](../examples/dashboard/) — all six stable types wired.

---

## Gallery map (learn, don’t copy deferred into product)

| Gallery page | Learn |
|--------------|-------|
| **Dashboard** | Stable layout + icon strip + breakpoints |
| **Charts** | Deferred sibling chooser + live compose snippets |
| **Iconography** | KPI / status symbol presets |

Gallery **Pitfalls** — **2.48 / FL-009** checklist.

---

## App checklist

- [ ] Dashboard uses **stable six** — deferred gauges only in internal tools
- [ ] Every **ChartCard** sets **`symbol`** for scanability (**2.43** track)
- [ ] Breakpoints: KPI **700**, charts **900**, filter rail **720**
- [ ] Read [experimental-sweep.md](experimental-sweep.md) before importing Extras chart types

**Next:** **2.65** closes icon semantics + full FL-009 recipe pack.
