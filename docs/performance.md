# Performance handbook (1.25 / 1.39 / 1.86–1.89 / 2.18 / 2.28 / 2.40 / 2.49 / 2.59)

Practical guidance for **large lists**, **DataTable**, **Canvas charts**, and **Gallery cold start**. QWinUI3 virtualizes through Qt Quick Controls `ListView` — there is no separate engine. Prefer these patterns before blaming the kit.

Gallery: **DataTable** (heavy-page callout) · ItemsView · ItemsRepeater · Charts · **Settings → Page Component cache**.

Related: [data-collections.md](data-collections.md) · [charts.md](charts.md) · [animations.md](animations.md) · `python scripts/smoke_gallery.py`.

---

## Quick checklist

| Do | Avoid |
|----|--------|
| `ListView` / `ItemsView` / `DataTable` / `ItemsRepeater` with `reuseItems` | Full-height `Column` + `Repeater` for thousands of rows |
| `QAbstractListModel` (C++) for thousands+ rows | Rebuilding huge JS arrays on every keystroke |
| Stable **role names** on model objects | Deep nested `Qt.binding` trees inside every delegate |
| Cap chart points (see below); one chart per card | Dozens of full-size Canvas charts on one screen |
| Defer heavy pages (`Loader` / StackView push) | Instantiating every Gallery/app page at startup |
| Cap `NavigationView.pageCacheLimit` | Unbounded Component caches after long browse sessions |
| Honor `Theme.reducedMotion` for motion | Animating the whole title bar / shell chrome |

---

## Gallery cold start (1.39)

Expected budget on a Release build (desktop, not a guarantee):

| Phase | What loads | Target |
|-------|------------|--------|
| App + Bootstrap + RHI | `configureEnvironment`, `GraphicsBackend` | Usually **&lt; 200–400 ms** |
| `Main` shell | `StandardWindow` + `NavigationView` + `ControlCatalog` singleton + **Home only** | Usually **&lt; 1–2 s** wall to first paint |
| Other catalog pages | Compiled on **first** `openPage` / smoke create | Not part of cold start |

Measure locally:

```bat
qwinui3_gallery.exe --startup-log
qwinui3_gallery.exe --smoke
```

`--smoke` prints `main=…ms, pages=…ms, total=…ms` after creating the **critical** set only — it does **not** open every control page.

### What Gallery already does

| Technique | Detail |
|-----------|--------|
| On-demand pages | `NavigationView` + `pageModule` → `Qt.createComponent` per page name |
| First paint | `initialPageTransition: "none"` (no enter animation on Home) |
| Component LRU | `pageCacheLimit: 24` (default); `clearPageCache()` from Settings |
| Home shadows | `MultiEffect` deferred one frame; off when `Theme.reducedMotion` |
| Optional hosts | WebView2 / MediaPlayer pages use `Loader` until activated |
| Smoke scope | Critical list only — `python scripts/smoke_gallery.py` |

Heavy pages (prefer not to touch on Home): `ControlCatalog.heavyComponents()` — DataTable, Charts, FontIcon, WebView2, Media, dense chart samples.

### App recipe

```qml
NavigationView {
    pageModule: "MyApp"
    pageCacheLimit: 24          // 0 = unlimited
    initialPageTransition: "none"
    pageTransition: "slide"     // after first page
    // …
}
// After a long session:
nav.clearPageCache(true)        // keep current page Component
```

Do **not** `import` every page type into `Main.qml` — that forces compile at startup.

---

## Virtualization

| Surface | How it scrolls | Notes |
|---------|----------------|-------|
| [`DataTable`](components/DataTable.md) | `ListView` + `reuseItems` + fixed `rowHeight` | Filter/sort rebuild `_viewRows` in JS — **debounced + skip unchanged**; **multi-sort / hiddenColumns / columnWidths (2.66)** |
| [`ItemsView`](components/ItemsView.md) | `ListView` + `reuseItems` | Optional `filterText` on JS arrays (1.88); C++ model at scale |
| [`ListDetailsView`](components/ListDetailsView.md) | `ListView` + `reuseItems` | Optional `filterText` on master list (1.88) |
| [`ItemsRepeater`](components/ItemsRepeater.md) | `ListView` + `reuseItems` (1.25) | Optional `filterText` on JS arrays (1.88) |
| [`ItemsWrapGrid`](components/ItemsWrapGrid.md) | `WrapPanel` + `Repeater` (2.24) | Not virtualized — low hundreds; optional `filterText` |
| Raw QQC `ListView` | Set `reuseItems: true` yourself | Required for delegate pooling |

**Rule of thumb**

| Row count | Guidance |
|-----------|----------|
| ≤ a few hundred plain objects | JS arrays / `ListModel` are fine |
| Thousands+ | Use `QAbstractListModel` (or similar). Do not filter+sort the full set in JS on every keystroke |
| Tens of thousands | C++ model + keep delegates thin; consider paging / server filter |

Delegates must tolerate **reuse**: avoid storing per-index state on the item root without resetting in `Component.onCompleted` / `ListView.onPooled` / property bindings from `model` / `modelData`.

```qml
ItemsView {
    titleRole: "name"
    subtitleRole: "team"
    model: employeeModel   // prefer QAbstractListModel when large
}
```

---

## Model roles

Prefer **named roles** (or plain object keys matching roles) so delegates stay binding-driven:

```qml
// Good — role-driven
ListTile {
    title: model.name
    subtitle: model.team
}

// DataTable columns
columns: [
    { title: qsTr("Name"), role: "name", width: 160, sortable: true },
    { title: qsTr("Score"), role: "score", width: 90, sortable: true }
]
```

| Tip | Detail |
|-----|--------|
| Stable identity | Selection in DataTable tracks the **row object** — keep object identity when resorting |
| Don’t copy rows | Mutate in place or replace the model; avoid cloning the whole table to change one cell |
| Section lists | `ItemsView.sectionRole` — sectioning still walks visible data; keep section cardinality reasonable |
| Images in rows | Prefer fixed-size icons / async `Image` with `asynchronous: true`; avoid huge decoded bitmaps in every delegate |

---

## Charts & gauges

Canvas charts redraw when data or size changes. Keep series short and surfaces few.

| Guidance | Detail |
|----------|--------|
| Point budget | Prefer **≤ ~200–500** points per series for interactive Line/Area; downsample history for dashboards |
| Cards | One chart inside [`ChartCard`](components/ChartCard.md); scroll the page rather than tiling many full canvases |
| Live updates | Append/trim a capped ring buffer; don’t rebuild a 10k-point array every tick |
| Hover | `interactive: true` adds hit-testing cost — turn off on dense static sparkline walls |
| Stable subset | Production: Line / Bar / Donut / RingGauge / KpiTile / ChartCard — remaining deferred **1.66** — [charts.md](charts.md) |

```qml
ChartCard {
    title: qsTr("CPU")
    LineChart {
        // Keep cpuHistory.length capped (e.g. 120 samples)
        series: [{ name: qsTr("CPU"), values: cpuHistory }]
    }
}
```

---

## Gallery & app shells — heavy pages

| Pattern | Why |
|---------|-----|
| NavigationView page stack | Gallery opens pages **on demand** via `pageModule` + StackView — do the same in apps |
| Defer with `Loader` | Optional Multimedia / WebView2 / huge settings trees: `active: false` until needed |
| DataTable demo | Gallery ships ~200 employee rows plus a **10k load** path (**2.66**); use `maxFilterResults` when filtering huge JS arrays |
| Charts hub | Small synthetic series; don’t paste multi-megabyte CSV into QML properties |
| Page Component cache | Cap with `pageCacheLimit`; clear after demos that thrash the stack |

When a page feels slow: check **delegate cost** and **model rebuilds** first, then chart point counts, then motion (`Theme.reducedMotion`).

---

## Shell & window runtime (1.86)

Gallery and product apps on **`BackdropSolid`** (recommended — [window-chrome.md](window-chrome.md)).

| Symptom | Cause | Kit fix (1.86) |
|---------|--------|----------------|
| Thin **white ring** on dark windows (Round corners, D3D12) | DWM default border + `QQuickWindow` clearing white in the round-corner AA seam | Solid hosts clear with **layer fill** (`WindowHelper.solidHostFill` / `Theme.bgLayer`); `DWMWA_BORDER_COLOR` pinned to the same RGB |
| White ring **flashes on restore / refocus** | Focus-in used to queue **80 ms DWM reapply** bursts on every Solid window | Solid: **immediate** `applyBorderColor` + corner on activate; **no** extra timer on focus-in (frosted Mica/Acrylic still deferred) |
| Hitch when alt-tabbing back | Same deferred burst reflowing chrome | Solid focus path is synchronous border/corner only |

**RHI:** Gallery ships **OpenGL** on Windows for frost. **D3D12** can still show a faint seam on transparent/frosted hosts — prefer OpenGL for Mica/Acrylic apps ([graphics-backend.md](graphics-backend.md)).

**Animations:** pane collapse / page transitions unchanged — perf work trims redundant DWM work, not motion (see [navigation.md](navigation.md)).

---

## Navigation & page stack (1.87)

Gallery navigation and `TabView` shells — **motion unchanged**, less per-frame waste.

| Area | Change | Visual impact |
|------|--------|----------------|
| `NavigationView` StackView | Each `pageTransition` mode runs **only its axes** (`_animOpacity` / `_animX` / `_animY` / `_animScale`); `slide` and `fade` skip no-op scale/x/y animators | Slide / fade / drill / cover look the same |
| Compact flyout shadow | `MultiEffect` layer enabled only while flyout is **open** (and not reduced motion) | Shadow still appears on open |
| `TabView` strip | Width/opacity `Behavior` during **reorder** only; color/indicator `Behavior` when tab checked/hovered/focused | Tab select + drag reorder still animate |
| Gallery Settings | **Performance arc (1.86–1.89)** tracker card | — |

**pageCacheLimit:** default **24**; first page uses `initialPageTransition: "none"`. See [NavigationView.md](components/NavigationView.md).

---

## Lists & data collections (1.88)

Virtualized tables and lists — **no visual change**, less work per keystroke.

| Control | Change | App note |
|---------|--------|----------|
| `DataTable` | `filterDebounceMs` (default **120**) before `_viewRows` rebuild; skip when filter query + sort + `rows` ref unchanged | Sort still immediate; call `refresh()` after in-place row edits |
| `ItemsView` | Optional `filterText` + `filterRoles` for **plain JS arrays** only | C++ / `ListModel`: filter app-side (unchanged) |
| `ListDetailsView` | Optional `filterText` on master list (JS arrays) | Selection index is into the filtered list |
| `ItemsRepeater` | Optional `filterText` (JS arrays) | Delegate: bind to `modelData` roles once per row |

**Delegate pooling:** cache role strings in `readonly property` on the delegate root — avoids repeated `_roleValue` / `_cellText` walks when `reuseItems` recycles tiles.

**Animations:** row highlight, selection, and list motion unchanged.

---

## Style, charts & Gallery heavy pages (1.89)

**Animations stay** — hover, press, focus, and chart reveal still run when the user interacts.

| Area | Change | Visual impact |
|------|--------|----------------|
| `ElevatedChrome` | `MultiEffect` enabled after first frame; off when `Theme.reducedMotion` | Shadow on open; flat when reduced motion |
| Style `Button` / `TextField` / `Switch` | `Behavior` only when hovered / focused / pressed / toggled | Same motion on interaction |
| `ListTile` | Color/scale `Behavior` when hovered / selected / pressed | Same row feedback |
| Line / Bar / Donut charts | `revealAnimationPointBudget` (**500**); `requestRedraw` coalesced ~**16 ms** | Reveal skips only on huge series |
| Gallery FontIcon | Filter debounced **120 ms** | Same grid, fewer full-catalog walks |
| Gallery Charts / WebView2 | Deferred `Loader` for heavy/deferred demos | Stable charts paint first |

---

## Performance arc summary (1.86–1.89)

| Wave | Version | Theme |
|------|---------|--------|
| 1 | **1.86** | Shell & window runtime — solid host fill, DWM focus path |
| 2 | **1.87** | Navigation & page stack — per-axis transitions, flyout shadow defer |
| 3 | **1.88** | Lists & data collections — debounced filter, skip unchanged rebuilds |
| 4 | **1.89** | Style, charts & Gallery heavy pages — idle Behavior trim, chart budgets |

Rule for the arc: **trim waste, not motion**. Sign-off: checkpoint-190 (**1.90**).

---

## Collection controls wave 5 (2.18)

Deepens **1.88** list/table perf on the **2.x** floor — **animations stay**.

| Control | Change | App note |
|---------|--------|----------|
| `DataTable` | `maxFilterResults` (default **0** = unlimited) caps JS filter walk | Pair with `filterDebounceMs`; selection still tracks row **object** |
| `ListDetailsView` | `_selectedItemRef` — selection survives filter rebuild when item still visible | `filteredCount` readout; same object-identity model as DataTable |
| `ListDetailsView` | `maxFilterResults` cap on master filter | C++ / `ListModel`: filter app-side |
| `NavigationView` | `pageCacheHits` diagnostics; `ensureComponent` LRU unchanged | Same-key nav still skips StackView replace; set `pageCacheLimit` |

**Virtualization:** all three use `ListView` + `reuseItems` — no second engine. For thousands of rows, filter/sort in C++ and bind a model.

---

## Shell & navigation wave 6 (2.28)

Deepens **1.39** / **2.18** on **NavigationView** / **NavigationWindow** — **animations stay**. Focus: real apps with `pageModule` shells, not micro-benchmarks.

### Real-app checklist

| # | Check | API / pattern | Why |
|---|--------|---------------|-----|
| 1 | Lazy pages | `NavigationWindow` + `pageModule` + `hostContent: false` | Page QML compiles on first open — not at shell startup |
| 2 | Tune cache | `pageCacheLimit` (default **24**); `clearPageCache()` after major locale/theme swaps | LRU evicts cold `Component`s; Settings card exposes live count |
| 3 | Same destination | `selectKey` when `key === currentKey` | Skips history push + `openPage` — see `sameKeySkipCount` |
| 4 | Same component | `openPage` when `_openedPageName` matches | Skips StackView replace + enter/exit — see `samePageSkipCount` |
| 5 | First paint | `initialPageTransition: "none"` | Gallery default; pair with `pageTransition` for later nav |
| 6 | Heavy destinations | `Loader` / deferred sibling (Charts **2.26**) | Avoid compiling optional surfaces until selected |
| 7 | Breadcrumb subtitle | `syncSubtitleFromNavigation: true` only when needed | Avoid extra string work on every nav tick |
| 8 | Diagnostics | `pageCacheHits`, `sameKeySkipCount`, `samePageSkipCount` | Log in dev; compare before/after trim passes |
| 9 | Frame budget | `FrameStatsBadge` / `--show-fps` (2.04) | Advisory FPS — not a profiler |

**NavigationWindow** forwards cache + skip counters and `clearPageCache()` so product shells do not reach through `NavigationView` internals.

### Advisory smoke timings

Gallery `--smoke` prints wall-clock splits (machine-dependent — **do not CI-gate on absolute ms**):

```
QWinUI3 Gallery startup: app=…ms main=…ms (pages still on-demand)
QWinUI3 Gallery smoke OK (… main=…ms, pages=…ms, total=…ms)
```

| Field | Meaning | Use |
|-------|---------|-----|
| `app` | Through `QGuiApplication` + engine setup | Baseline Qt / import cost |
| `main` | Through `Main.qml` root load | Shell + module graph |
| `pages` | Critical page `QQmlComponent` instantiate loop | On-demand compile cost proxy |
| `total` | Wall clock to exit | Local regression hint after perf edits |

Run locally: `qwinui3_gallery --smoke --startup-log` (Release build, same machine). Compare **relative** deltas — see `python scripts/smoke_gallery.py` (**2.28**). Smoke validates **instantiate**, not navigation frame time.

---

## Collection controls wave 7 (2.40)

Second collection pass on the **2.x** floor — **DataTable** / **ListDetailsView** / **NavigationView** debounce-filter field paths, plus **FileTree** / **TreeDataGrid** when shipped. Builds on **2.18** (wave 5) and **2.28** (wave 6). **Animations stay.**

### Real-app checklist

| # | Surface | Check | API / pattern | Why |
|---|---------|-------|---------------|-----|
| 1 | **DataTable** | Debounced filter | `filterDebounceMs` (default **120**) | Avoid `_viewRows` rebuild on every key |
| 2 | **DataTable** | Skip unchanged | `_lastRefreshKey` (query + sort + rows ref) | **1.88** / **2.18** — identical filter/sort skips walk |
| 3 | **DataTable** | Cap filter walk | `maxFilterResults` > 0 on huge JS arrays | **2.18** — stop after N matches |
| 4 | **DataTable** | Stable selection | `_selectedRowRef` object identity | Selection survives sort/filter when row still visible |
| 5 | **ListDetailsView** | Master filter | `filterText` + `filterDebounceMs` + `filteredCount` readout | Same debounce model as DataTable |
| 6 | **ListDetailsView** | Cap master list | `maxFilterResults` | C++ / `ListModel`: filter app-side instead |
| 7 | **NavigationView** | Pane search | Debounce in `paneSearchTextEdited` handler (~80–120 ms) | Type exposes text + model — no built-in debounce |
| 8 | **NavigationView** | Shell trim | Wave 6: `pageCacheLimit`, `sameKeySkipCount`, `samePageSkipCount` | Pair collection filter trim with nav skip metrics |
| 9 | **TreeDataGrid** | Branch filter | `filterDebounceMs`, `maxFilterResults`, `expandOnFilter` | Tree walk is O(branches) — cap + debounce |
| 10 | **TreeDataGrid** | Skip unchanged | `_lastRefreshKey` + rows ref | Same skip pattern as DataTable |
| 11 | **FileTree** | Table side | Embedded **DataTable** inherits filter debounce / caps | Tree side: filter `treeModel` app-side — do not rebuild whole tree per key |
| 12 | **All lists** | Virtualize | `ListView` + `reuseItems` | No `Column` + `Repeater` for long collections |
| 13 | **Large apps** | Model-side filter | `QAbstractItemModel` + query | JS filter+sort on thousands+ rows is not a product path |

**Named paths:** filter keystroke → debounce timer → `refresh()` → skip if key unchanged → cap walk → `ListView` reuse. Navigation pane search: app-owned Timer on `paneSearchTextEdited` before rebuilding `paneSearchModel`.

---

## Charts & dashboard wave 8 (2.49)

Third **2.x** pass on **stable six** + wrap grids + dashboard live series — closes tranche-1 perf sign-off with [perf-signoff-2xx.md](perf-signoff-2xx.md). Builds on **2.26** compose recipes and **2.48** dashboard decision tree. **Animations stay.**

### Real-app checklist

| # | Surface | Check | API / pattern | Why |
|---|---------|-------|---------------|-----|
| 1 | **LineChart / BarChart / DonutChart** | Point budget | `revealAnimationPointBudget` (**500**); coalesced redraw ~**16 ms** | Skip reveal + batch paint on huge series |
| 2 | **Dashboard KPI** | Trend ring | `KpiTile.trendValues` capped (e.g. **16** samples) | Replaces deferred Sparkline without unbounded arrays |
| 3 | **Dashboard layout** | Card count | One chart per **ChartCard**; scroll page | Avoid tiling many full canvases |
| 4 | **ItemsWrapGrid** | Debounced filter | `filterDebounceMs` (default **120**) | Wrap uses `Repeater` — not virtualized |
| 5 | **ItemsWrapGrid** | Tile count | **Low hundreds** max | Use **ItemsView** / **DataTable** at scale |
| 6 | **CalendarView** | Month cells | Bounded month model only | Experimental — no year-long virtualized grid |
| 7 | **NotificationCenter** | History list | Cap stored rows; group categories | Experimental drawer — not a sync engine |
| 8 | **All** | Motion policy | `Theme.reducedMotion` honored | Perf trims DWM/debounce waste, not navigation motion |

**Named paths:** live metric tick → append/trim ring buffer → chart `values` replace; filter keystroke → `filterDebounceMs` → filter walk on small arrays only.

---

## Tranche-1 performance sign-off (2.49)

Summary for **2.00…2.49** — full verdict doc: [perf-signoff-2xx.md](perf-signoff-2xx.md).

| Area | Tranche-1 posture |
|------|-------------------|
| **Lists / tables** | Waves **5** + **7** — debounce, skip unchanged, `maxFilterResults`, `reuseItems` |
| **Shell / nav** | Wave **6** — `pageCacheLimit`, skip counters, deferred heavy `Loader`s |
| **Charts / dashboard** | Wave **8** — stable six point budgets + capped KPI trends |
| **Wrap grids** | Wave **8** — `ItemsWrapGrid` debounce + low hundreds cap |
| **Diagnostics** | **2.44** — FrameStats dev-only; `applyRetailProfile()` in retail |
| **FL-008** | **Closed** — wave 10 sign-off — [collection-perf-264.md](collection-perf-264.md); GPU million-row still out |
| **Animations** | **Stay** — no motion removal in perf waves |

**Out for 2.49:** GPU chart rewrite · built-in profiler · always-on retail FPS.

---

## App-level flows wave 9 (2.59)

Fourth **2.x** pass on **command / search / carousel / async chrome** — named product paths, not collection tables. Full slice doc: [app-sluggishness-259.md](app-sluggishness-259.md). Builds on **2.16** debounce on **CommandPalette** / **AutoSuggestBox** and **2.37** carousel recipes.

### Real-app checklist

| # | Surface | Check | API / pattern | Why |
|---|---------|-------|---------------|-----|
| 1 | **CommandPalette** | Debounce + cap | `filterDebounceMs` (**80**); `maxResults` (**64**); `maxRecentCommands` (**5**) | Avoid scanning full command tree every key |
| 2 | **AutoSuggestBox** | Min length + cap | `minFilterLength` (**2** on huge lists); `filterDebounceMs`; `maxSuggestionResults` | Skip 1-char full-array walks |
| 3 | **ItemsView** | Section filter | `minFilterLength`; `maxFilterResults` (**256**); `filterDebounceMs` | JS-array filter is not a C++ model |
| 4 | **Button** | Async save | `loading: true`; `enabled: !busy`; `preserveWidthWhileLoading` | Block double-submit + toolbar reflow |
| 5 | **FlipView** | Reduced motion | Swipe off when `Theme.reducedMotion`; use buttons / **PipsPager** | Avoid heavy swipe transitions |
| 6 | **Theme** | Compact kiosk | `Theme.applyDensityPreset("compact")` | Smaller controls without per-page hacks |
| 7 | **All** | Scale path | **DataTable** / **ItemsRepeater** for 1k+ rows | **ItemsView** filter stays for hundreds, not thousands |

**Named paths:** palette keystroke → debounce → capped filter + recent pin; typeahead → min length → debounce → capped suggestions; Save click → `loading` until promise resolves.

**Out for 2.59:** **FL-008** collection wave 10 (**2.64** shipped); GPU chart rewrite.

---

## Collection controls wave 10 (2.64)

Fifth **2.x** pass on **DataTable** / **ListDetailsView** / tree file surfaces — ops LoB paths. Full slice doc: [collection-perf-264.md](collection-perf-264.md). Builds on waves **5** / **7** debounce + **2.49** tranche-1 sign-off.

### Real-app checklist

| # | Surface | Check | API / pattern | Why |
|---|---------|-------|---------------|-----|
| 1 | **DataTable** | Pin identity column | `columns[].pinned: true` | Name/id stays visible while scrolling metrics |
| 2 | **DataTable** | Group rows | `groupRole` | Team/status section headers for ops scan |
| 3 | **DataTable** | Persist order | `columnOrder` + `moveColumn()` | Restore user layout from Settings |
| 4 | **ListDetailsView** | Bulk actions | `multiSelectEnabled` + `detailToolbar` | Mail/archive without second **ItemsView** |
| 5 | **ListDetailsView** | Multi keyboard | Ctrl+click · Shift+range · Ctrl+A | Matches desktop mail selection |
| 6 | **TreeDataGrid** | Resize + freeze | Header splitters; `freezeFirstColumn` | Wide hierarchies keep name column |
| 7 | **FileTree** | Filter + columns | `filterText`; `hiddenColumnRoles` | Explorer LoB without custom chrome |
| 8 | **All** | Scale path unchanged | `maxFilterResults` + debounce | JS arrays — not million-row GPU grid |

**Named paths:** ops table → pin name → group by team; mail master → multi-select → archive toolbar; file explorer → filter table → hide Modified column.

**Out for 2.64:** Million-row GPU grid rewrite.

---

### Runtime diagnostics (2.04)

`FrameStatsMonitor` (Platform singleton) samples `QQuickWindow::frameSwapped` and exposes rolling **FPS** + **frame time**. Optional **RHI backend** readout (`showRhi`) appends the active Qt Quick graphics API (OpenGL, Vulkan, D3D11, …) from `QQuickWindow::rendererInterface()` or `QSG_RHI_BACKEND`.

| Surface | Usage |
|---------|--------|
| Title bar | `FrameStatsBadge` in `TitleBar` / `ShellWindow` **rightHeader** |
| Overlay | `FrameStatsOverlay` when `inTitleBar` is false |
| Gallery Settings | **Show FPS**, **Show RHI**, placement |
| CLI | `--show-fps`, `--fps-overlay`, `--show-rhi`, `--show-diagnostics` |

Opt-in only (`enabled` default **false**). Not a full profiler — advisory only. For RHI restart / backend selection see [graphics-backend.md](graphics-backend.md) (Gallery `GraphicsBackend` singleton).

**1.91 baseline:** FPS + frame time only. **2.04** adds RHI beside FPS when `showRhi` is on.

### Developer diagnostics productize (2.44)

**Retail vs dev:** shipping apps call **`FrameStatsMonitor.applyRetailProfile()`** (or `retailMode: true` + `persistSettings: false`) so FPS/RHI never persist from Gallery QSettings. Dev/internal builds keep CLI `--show-fps` / `--show-diagnostics`. Full cookbook: [developer-diagnostics.md](developer-diagnostics.md).

| API | Role |
|-----|------|
| `retailMode` | Skip loading/saving enabled + RHI from QSettings |
| `persistSettings` | When false, toggles are session-only |
| `applyRetailProfile()` | One-shot retail setup + clear `performance/*` keys |
| `--retail-diagnostics` | CLI retail profile (smoke / CI) |

**Promoted to stable** (dev tooling): `FrameStatsMonitor`, `FrameStatsBadge`, `FrameStatsOverlay` — [stable-api.md](stable-api.md).

**Out:** Always-on FPS in retail builds.

---

## Cheap wins (1.25 / 1.39)

Already applied / recommended in-tree:

1. **`ItemsRepeater` enables `reuseItems`** — matches DataTable / ItemsView.
2. Prefer **role-based** delegates over `JSON.parse` / deep copies in `delegate`.
3. **Defer** optional surfaces (`MediaPlayerElement` / WebView2 Gallery pages use `Loader`).
4. Drive animations with `Theme.duration(...)` so reduced motion collapses work.
5. Wide DataTables: use the horizontal scrollbar; don’t nest a second flickable that fights the row `ListView`.
6. **`pageCacheLimit` + `initialPageTransition: "none"`** on Gallery NavigationView (1.39).
7. **Defer Home card shadows** one frame; honor reduced motion (1.39).

---

## Out of scope

- Built-in profiler product
- GPU rewrite of Canvas chart engines
- Custom virtualization engine beyond QQC `ListView`
- Shipping a separate “lite” Gallery binary
