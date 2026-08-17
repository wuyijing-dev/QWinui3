# Experimental → stable sweep (2.45)

**FL-004** close-out — verdict table for types teams confuse with stable. Gallery shows **Experimental** / **Permanent defer** badges on catalog pages (PageHeader + Home Recently shipped).

Related: [stable-api.md](stable-api.md) · [friction-log.md](planning/friction-log.md) · [gallery-catalog-expansion.md](gallery-catalog-expansion.md)


---

## Verdict legend

| Badge | Meaning | Ship in product? |
|-------|---------|------------------|
| *(none)* | **Stable** — on [stable-api.md](stable-api.md) | Yes |
| **Experimental** | Gallery-backed; API may change | Only with eyes open + friction row |
| **Permanent defer** | Do not promote; use compose recipe | **No** — use stable alternative |

---

## Sweep matrix (2.45)

| Area | Verdict | Stable alternative / doc |
|------|---------|--------------------------|
| **Stable six charts** | **Stable** | `LineChart`, `BarChart`, `DonutChart`, `RingGauge`, `KpiTile`, `ChartCard` — [charts.md](charts.md) |
| **Sibling charts/gauges** | **Permanent defer** (2.08) | Area→`LineChart.showArea`; Spark→`KpiTile.trendValues`; Pie→`DonutChart`; gauges→`RingGauge` |
| **Media** | **Permanent defer** (2.09) | App-owned Multimedia — [media.md](media.md) |
| **OSK / IME** | **Experimental** | Promote path **2.01** — [on-screen-keyboard.md](on-screen-keyboard.md) |
| **FileTree / TreeDataGrid / ItemsWrapGrid** | **Experimental** | [tree-data.md](tree-data.md) · [items-wrap-grid.md](items-wrap-grid.md) |
| **CalendarView** | **Experimental** | Date pickers stable — [calendar-view.md](calendar-view.md) |
| **NotificationCenter** | **Experimental** | Toast/InfoBar stable — [feedback.md](feedback.md) |
| **RichEdit** | **Experimental** | Mail/template rich text — [rich-edit-261.md](rich-edit-261.md) |
| **SemanticZoom** | **Experimental** | Grid ↔ index shared selection — [semantic-zoom-262.md](semantic-zoom-262.md) |
| **SwipeControl** | **Experimental** | [touch-pointer.md](touch-pointer.md) |
| **DashboardShell** | **Experimental** (2.52 preview) | `examples/first-app` — promote **2.65** — [first-app-252.md](first-app-252.md) |
| **AnimatedIcon / motion helpers** | **Experimental** | [icons.md](icons.md) · [animations.md](animations.md) |
| **FrameStats** | **Stable dev tooling** (2.44) | `applyRetailProfile()` in retail — [developer-diagnostics.md](developer-diagnostics.md) |
| **Shell extras (Snap/battery/…)** | **Gallery demo** | Taskbar/attention/reveal stable — [shell-extras.md](shell-extras.md) |
| **TabView tear-out** | **Experimental** | Core TabView stable — [navigation.md](navigation.md) |

---

## Gallery implementation (2.45)

| Mechanism | Location |
|-----------|----------|
| `ControlCatalog.apiStabilityForComponent(id)` | `src/gallery/ControlCatalog.qml` |
| `ApiStabilityBadge` | Page title + Home Recently shipped |
| Pitfalls checklist | Gallery **Pitfalls** — FL-004 |
| Catalog descriptions | Still mention defer/experimental in prose |

**Out:** Removing experimental types from the kit (→ **3.00** cleanup). Zero experimental types (unrealistic).

---

## App checklist

- [ ] Product code imports only [stable-api.md](stable-api.md) types unless documented experimental
- [ ] Dashboard uses **stable six** — not deferred gauges in shipping UI
- [ ] No `MediaPlayerElement` without reading [media.md](media.md) permanent defer
- [ ] OSK path gated — not enabled for all users until **2.01** promote
- [ ] Read Gallery badge before copying a demo page wholesale

**Next:** **2.67** experimental promote wave 2
