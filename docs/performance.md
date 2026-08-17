# Performance handbook (1.25 / 1.39 / 1.86 / 1.88)

Practical guidance for **large lists**, **DataTable**, **Canvas charts**, and **Gallery cold start**. QWinUI3 virtualizes through Qt Quick Controls `ListView` — there is no separate engine. Prefer these patterns before blaming the kit.

Gallery: **DataTable** (heavy-page callout) · ItemsView · ItemsRepeater · Charts · **Settings → Page Component cache**.

Related: [data-collections.md](data-collections.md) · [charts.md](charts.md) · [animations.md](animations.md) · [ci-smoke.md](ci-smoke.md).

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
| Smoke scope | Critical list only — [ci-smoke.md](ci-smoke.md) |

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
| [`DataTable`](components/DataTable.md) | `ListView` + `reuseItems` | Filter/sort rebuild `_viewRows` in JS — **debounced + skip unchanged (1.88)** |
| [`ItemsView`](components/ItemsView.md) | `ListView` + `reuseItems` | Optional `filterText` on JS arrays (1.88); C++ model at scale |
| [`ListDetailsView`](components/ListDetailsView.md) | `ListView` + `reuseItems` | Optional `filterText` on master list (1.88) |
| [`ItemsRepeater`](components/ItemsRepeater.md) | `ListView` + `reuseItems` (1.25) | Optional `filterText` on JS arrays (1.88) |
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
| DataTable demo | ~200 employee rows — fine for JS; treat as the **ceiling** for casual arrays |
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
