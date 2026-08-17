# App-level sluggishness (2.59)

Targeted fixes for **named slow flows** in product apps — command/search filter stalls, unbounded list filters, and async button churn — not a synthetic FPS-only pass.

Related: [performance.md](performance.md) · [search.md](search.md) · [commands.md](commands.md) · [carousel-recipes.md](carousel-recipes.md) · [theme-overrides.md](theme-overrides.md)

---

## Goal

Consumer apps report “feels slow” on **specific paths** (palette open, typeahead, section lists, save buttons, carousels) while collection waves **5–8** already cover tables and charts. **2.59** closes the top three **app-level** footguns with small control fixes + **performance.md wave 9**.

---

## Top 3 footguns (fixed in 2.59)

| # | Symptom | Cause | Fix |
|---|---------|-------|-----|
| **1** | Ctrl+K / search stutters on large command lists | Filter runs on every key with no recents / caps | **`CommandPalette`**: `maxRecentCommands` pin + existing `filterDebounceMs` / `maxResults` |
| **2** | ItemsView / AutoSuggest “hangs” on first letters | Full-array filter with no min length or cap | **`minFilterLength`** + **`maxFilterResults`** on **ItemsView**; **`minFilterLength`** on **AutoSuggestBox** |
| **3** | Save toolbar jumps / double-submit | No loading affordance on **Button** | **`Button.loading`** + **`preserveWidthWhileLoading`** (style) |

**Also:** **`FlipView`** disables swipe when **`Theme.reducedMotion`** (use buttons / pips); **`Theme.applyDensityPreset()`** for compact shells.

**Out:** GPU rewrite · built-in profiler · collection **FL-008** wave 9 (**2.64** if field metrics return).

---

## Deliverables

| Item | Location |
|------|----------|
| Command recents | **`CommandPalette.maxRecentCommands`** · **`recentKeyRole`** |
| List filter caps | **`ItemsView.minFilterLength`** · **`maxFilterResults`** |
| Search debounce | **`AutoSuggestBox.minFilterLength`** (with **`filterDebounceMs`**) |
| Async button UX | **`Button.loading`** · **`preserveWidthWhileLoading`** |
| Carousel reduced motion | **`FlipView`**: swipe off when **`Theme.reducedMotion`** |
| Density preset | **`Theme.applyDensityPreset("compact"\|"standard")`** |
| Perf wave 9 | [performance.md](performance.md) **2.59** table |
| Gallery refresh | **Performance** · **Command palette** · **Pitfalls** **2.59** |

---

## App checklist

- [ ] **CommandPalette**: set **`id`** on hot commands · tune **`filterDebounceMs`** (80–120 ms) · **`maxResults`**
- [ ] **AutoSuggestBox** / **ItemsView** on **1000+** JS rows: **`minFilterLength: 2`** · **`maxFilterResults`** / **`maxSuggestionResults`**
- [ ] Long save: **`Button { loading: busy; enabled: canSave && !busy }`** — or **`ProgressButton`** for determinate work
- [ ] **FlipView** / **PipsPager**: honor **`Theme.reducedMotion`** · pause auto-advance — [carousel-recipes.md](carousel-recipes.md)
- [ ] Touch-heavy kiosks: **`Theme.applyDensityPreset("compact")`** early in **`Component.onCompleted`**
- [ ] Tables at scale: still use **DataTable** / **ListView.reuseItems** — wave **7** — not **ItemsView** filter on 10k rows
- [ ] Measure named paths with **`FrameStatsMonitor`** (dev only) — [developer-diagnostics.md](developer-diagnostics.md)

**Next:** **2.60** friction checkpoint · **3.00** prep
