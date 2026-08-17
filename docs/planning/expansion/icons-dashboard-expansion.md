# Icons & dashboard expansion

Recipe track for **FluentIcons** + **stable dashboard** layouts — feeds **2.65** and Gallery, not a new chart engine.

**Strategy context:** [roadmap-strategy.md](../roadmap-strategy.md) · **Charts arc:** [charts-dashboard-arc.md](charts-dashboard-arc.md) · **Friction:** FL-009 (dashboard compose confusion)

Gallery: **Dashboard** · **Iconography** (`FontIconPage`) · **Charts** · [`examples/dashboard`](../../../examples/dashboard/)

---

## Dashboard — stable six (product path)

| Tile / card | Stable control | Icon (`FluentIcons.*`) | Notes |
|-------------|----------------|------------------------|--------|
| KPI metric | **KpiTile** | `Sync`, `Save`, `Clock`, `Important`, `Warning` | `symbol` + `trendValues`; severity tints |
| Time series | **ChartCard** + **LineChart** | `LineChart` / `TrendingUp` | `showArea` replaces deferred AreaChart |
| Compare bars | **ChartCard** + **BarChart** | `BarChartHorizontal` | No WebGL |
| Share / mix | **ChartCard** + **DonutChart** | `PieSingle` / `Bullseye` | Stable six only |
| Headline % | **RingGauge** in **ChartCard** | `SpeedHigh` / `Gauge` | Not Tank/Thermometer in product |
| Filter rail | **TwoPaneView** | `Filter` | Breakpoint 720 — [charts.md](../../charts.md) **2.22** |

**Deferred (Gallery only):** `TankGauge`, `ThermometerGauge`, `Sparkline`, sibling charts — [charts.md](../../charts.md) defer table (**2.08**).

---

## Icon semantics for dashboards

| Severity / state | Prefer symbol | On control |
|------------------|---------------|------------|
| Healthy / OK | `CheckMark`, `CompletedSolid` | KpiTile footer or InfoBadge |
| Warning | `Warning`, `Important` | KpiTile `cautionThreshold` |
| Critical | `ErrorBadge`, `StatusErrorFull` | KpiTile `criticalThreshold` |
| Live / streaming | `Sync`, `Play` | KPI badge text + icon |
| Navigation to detail | `ChevronRight`, `OpenInNewWindow` | ChartCard footer button |

Rules: [icons.md](../../icons.md) — named `FluentIcons.*`, `Theme.fontFamilyIcon`, icon-only needs `accessibleName` / `toolTipText`.

**Named aliases:** `CheckMark`, `LineChart`, `BarChartHorizontal`, `SpeedHigh`, `Ringer`, `Temperature`, `StatusErrorFull`, etc. — registered in `FluentIcons.cpp` for dashboard search (WinSymbols subset; horizontal bar shares vertical glyph when codepoint absent).

---

## Gallery expansion (maintainers)

| Page | Add / keep |
|------|------------|
| **Dashboard** | KPI row with varied symbols; **ChartCard.symbol** on each card; status icon strip; link **Iconography** |
| **FontIconPage** | “Dashboard KPI icons” preset row; filter tags `dashboard` / `kpi` |
| **Charts** | Compose recipes unchanged — cross-link dashboard stable six |
| **RecipesHub** | Icons + Dashboard row |

---

## Roadmap slices

| Slice | Icons & dashboard deliverable |
|-------|------------------------------|
| **2.22** | Responsive dashboard layout (shipped) |
| **2.26** | Charts recipe wave (shipped) |
| **2.39** | Gallery findability includes Dashboard (shipped) |
| **2.48** | Compose decision tree closes FL-009 partial — [dashboard-compose-decision.md](../../dashboard-compose-decision.md) |
| **2.65** | **Wave A** product wave — stable six APIs + **DashboardShell** + Gallery/example v2 — [charts-dashboard-arc.md](charts-dashboard-arc.md) |
| **2.52** | Minimal **DashboardShell** in “first app in an hour” |
| **2.51** | Gallery badges: experimental gauges vs stable KpiTile |

---

## App checklist

- [ ] KPI row uses **KpiTile** + named symbols — not raw `\uE…`
- [ ] Chart cards set **ChartCard.symbol** for scanability
- [ ] Product dashboards use **stable six** only
- [ ] Deferred gauges only in internal tools / Gallery demos
- [ ] Breakpoints: KPI **700**, charts **900**, filter rail **720**
- [ ] Icon-only drill-down buttons have names

Validation: `python scripts/check_icons_dashboard_expansion.py`

**Out:** WebGL; unconditional new stable chart types without friction row; Hub controls; Lottie icon pipeline.
