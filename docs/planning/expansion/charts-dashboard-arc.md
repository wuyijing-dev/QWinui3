# Charts & dashboard arc (2.51 → 3.00)

Product plan for **new analytics surfaces** and **deeper chart/dashboard APIs** — not only recipes on the stable six.

**Strategy:** [roadmap-strategy.md](../roadmap-strategy.md) · **Compose today:** [dashboard-compose-decision.md](../../dashboard-compose-decision.md) · **Icons:** [icons-dashboard-expansion.md](icons-dashboard-expansion.md) · **Component deepen:** [component-capabilities-expansion.md](component-capabilities-expansion.md)

---

## Principles

| Rule | Detail |
|------|--------|
| **Stable six stays** | `LineChart`, `BarChart`, `DonutChart`, `RingGauge`, `KpiTile`, `ChartCard` remain the product core through **2.73** |
| **New types = friction** | Every **new** chart/gauge/dashboard host needs a [friction-log.md](../friction-log.md) row + Gallery page before stable promote |
| **Deepen before duplicate** | Prefer new properties on existing types (`LineChart` brush, `KpiTile` compare) over sibling chart names |
| **3.00 cleanup** | Permanent-defer siblings may move to `QWinUI3.Experimental` or remove — checkpoint-300 |

---

## Capability waves (by slice)

### Wave A — stable six deepen (**2.65**)

| Control | New / expanded capability | Gallery / example |
|---------|---------------------------|-------------------|
| **LineChart** | Crosshair + nearest-point readout; optional `xAxisLabels`; `zoomEnabled` brush (Canvas, not WebGL) | **Charts** + **Dashboard** |
| **BarChart** | Stacked mode (`stacked: true` on series groups); horizontal layout flag | **Charts** |
| **DonutChart** | Center label + `legendPosition`; slice explode on hover | **Charts** |
| **RingGauge** | `trackColor` / `valueFormat`; dual-threshold bands | **Dashboard** |
| **KpiTile** | `compareValue` + delta vs prior period; `sparklineHeight` | **Dashboard** |
| **ChartCard** | Footer action strip; `subtitle`; export hook (`onExportRequested`) | **Dashboard** |
| **TwoPaneView** | Dashboard filter rail preset (date range slot) | `examples/dashboard` |

**Out of 2.65:** WebGL; new stable type names without friction row.

### Wave B — promoted & conditional analytics (**2.67…2.69**)

| Type | Slice | Gate | Verdict target |
|------|-------|------|----------------|
| **Sparkline** | **2.67** | FL-009 / KPI density apps | Promote to stable **or** permanent defer → `KpiTile.trendValues` only |
| **BulletChart** | **2.69** | FL-014 | Promote as compose on **KpiTile** + **RingGauge** **or** thin stable type |
| **HistogramChart** | **2.69** | FL-015 | **Conditional** — bin API on **BarChart** first |
| **DashboardShell** | **2.65** | FL-009 | Layout host (grid + KPI row + filter rail) — **not** withdrawn `Hub` |

### Wave C — post-3.00 analytics (**3.01…3.10**, friction-only)

| Theme | Example deliverable | Gate |
|-------|---------------------|------|
| **Real-time strip** | `LiveMetricStrip` — rolling KPI + sparkline row | Field app + FL-014 |
| **Chart sync** | Linked crosshair across **ChartCard** hosts | Dashboard app |
| **Export** | CSV/PNG export helpers on stable six | LoB reporting |
| **Theming** | Dashboard accent packs tied to **ThemeOverrides** wave | Branding app |

**3.00** does **not** block Wave C — same friction gate as **2.51+**.

---

## New dashboard surfaces (planned)

| Surface | Role | First slice | Notes |
|---------|------|-------------|-------|
| **DashboardShell** | Opinionated shell: KPI row + chart grid + optional **TwoPaneView** filter | **2.65** | Replaces withdrawn `Hub` — layout only |
| **MetricCompareRow** | Side-by-side **KpiTile** with shared period selector | **2.65** | Compose recipe + optional type |
| **ChartEmptyState** | Fluent empty / error / loading inside **ChartCard** | **2.65** | TeachingTip integration |
| **DateRangeToolbar** | Preset ranges for dashboard filters | **2.69** | Pairs with **CalendarView** / pickers |

---

## Slice map (2.51 → 3.00)

| Slice | Charts & dashboard focus |
|-------|--------------------------|
| **2.52** | Minimal **DashboardShell** in first-app quickstart |
| **2.59** | Named slow dashboard flows (filter + chart refresh) |
| **2.65** | **Wave A** + **DashboardShell** + `examples/dashboard` v2 |
| **2.67** | **Sparkline** promote/defer verdict; experimental cleanup |
| **2.69** | **Wave B** conditional types + field buffer |
| **2.70** | Audit: new types justified vs compose-only |
| **2.73** | Python dashboard minimal example |
| **3.00** | Defer siblings removed/namespaced; stable six contract frozen for **3.xx** |
| **3.01+** | **Wave C** — friction-only |

---

## App checklist

- [ ] Prefer **deepen** stable six APIs before importing deferred Gallery charts
- [ ] Log friction before requesting **HistogramChart** / **BulletChart** stable promote
- [ ] Use **DashboardShell** / **TwoPaneView** — not withdrawn **Hub**
- [ ] Cap live series — [perf-signoff-2xx.md](../../perf-signoff-2xx.md) wave 8

**Related docs:** [charts.md](../../charts.md) · [performance.md](../../performance.md) · [friction-log.md](../friction-log.md)
