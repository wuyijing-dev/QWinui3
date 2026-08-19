# Tranche-1 performance sign-off (2.49)

**Product version:** **2.49** — closes the **2.00…2.49** performance arc for tranche 1. **Animations stay.** Not a GPU chart rewrite.

Related: [performance.md](performance.md) · [friction-log.md](planning/friction-log.md) (**FL-008**) · [developer-diagnostics.md](developer-diagnostics.md) (**2.44**) · checkpoint-250 (**2.50** shipped)


---

## Verdict (2.49)

| Question | Answer |
|----------|--------|
| **2.x perf arc signed off?** | **Yes** — waves **5 → 8** documented + Gallery callouts |
| **Animations removed?** | **No** — trim waste, not motion (**1.90** rule) |
| **FL-008 closed?** | **Partial** — collection + shell paths hardened; **2.64** if field metrics reopen |
| **Retail FPS policy?** | **Yes** — `applyRetailProfile()` (**2.44**) |
| **Next perf slice?** | **2.64** (friction-only) or skip if queue empty |

---

## 2.x wave map

| Wave | Slice | Focus |
|------|-------|--------|
| 5 | **2.18** | DataTable / ItemsView debounce + skip unchanged |
| 6 | **2.28** | NavigationView cache + skip counters + smoke timings |
| 7 | **2.40** | ListDetailsView / TreeDataGrid / FileTree filter paths |
| 8 | **2.49** | Charts/dashboard budgets + ItemsWrapGrid + tranche sign-off (wave 8) |

Full checklists: [performance.md](performance.md).

---

## Wave 8 checklist (2.49)

| # | Surface | Check |
|---|---------|-------|
| 1 | **Stable six charts** | ≤ **~500** points/series; `revealAnimationPointBudget` skips heavy reveal |
| 2 | **Dashboard** | `KpiTile.trendValues` ring capped (~16); one chart per **ChartCard** |
| 3 | **ItemsWrapGrid** | `filterDebounceMs` (**120**); **low hundreds** of tiles — not virtualization |
| 4 | **Experimental grids** | `CalendarView` / `NotificationCenter` — bounded models, no 10k cells |
| 5 | **Shell** | Pair wave **6** cache limits with wave **7** filter debounce |
| 6 | **Diagnostics** | Dev-only FrameStats — retail profile in shipping builds |
| 7 | **Smoke** | `--smoke --startup-log` — relative compare only, not CI ms gate |

---

## Consumer checklist

- [ ] Skim [upgrade-notes.md](upgrade-notes.md) **2.48 → 2.49**
- [ ] Product dashboards: [dashboard-compose-decision.md](dashboard-compose-decision.md) + chart point budgets
- [ ] Large collections: C++ model or paging — not JS filter on thousands+
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build` (Release)

**Out:** Built-in profiler · chart GPU rewrite · lite Gallery binary.
