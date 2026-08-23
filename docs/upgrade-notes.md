# Consumer upgrade notes (1.40)

How to move a product app between **QWinUI3 `1.xx` minors** without surprises.

**Compatibility contract:** [compatibility-1xx.md](compatibility-1xx.md).  
**Stable types:** [stable-api.md](stable-api.md).  
**Qt floors:** [qt-version-compat.md](qt-version-compat.md).

---

## Template (copy per release)

Use this block when you ship a tagged `vX.YY` that consumers must react to. Skip rows that are N/A.

```markdown
## Upgrade X.YY → X.ZZ

**Product version:** X.ZZ (`QWINUI3_VERSION`)  
**Date:** YYYY-MM-DD  
**Qt:** still 6.5+ / recommended 6.8 (change only if true)

### Action required
| Area | Change | What to do |
|------|--------|------------|
| … | … | … |

### Optional / polish
- …

### No action (compatible)
- Stable Theme / shell / control APIs unchanged for this slice.
```

Maintainers: append a filled section below when a slice has consumer-visible breaks or important opt-ins. Pure docs / Gallery-only / additive defaults usually need only a one-line **No action** note.

---

## Checklist (every upgrade)

1. Bump / reinstall the kit (`QWINUI3_VERSION` / Release zip / `add_subdirectory` pin).
2. Confirm Qt major/minor still matches your linked kit — [packaging-consumer.md](packaging-consumer.md).
3. Skim [stable-api.md](stable-api.md) changelog for new **promotes** or **defer** notes.
4. Rebuild Release; run your smoke / Gallery `--smoke` if you vendor the Gallery binary.
5. If you fork Theme colors: keep using `customAccent` / packs — do not assign readonly `bgCard` etc.

---

## Recent minors (filled)

### Upgrade 2.64 → 2.65

**Product version:** 2.65
**Date:** 2026-08-23
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Charts + Dashboard Wave A (FL-009):** deepen stable six + dashboard hosts — [charts.md](charts.md) · [charts-dashboard-arc.md](planning/expansion/charts-dashboard-arc.md).
- **LineChart** `zoomEnabled` brush zoom (`viewStart` / `viewEnd` / `resetZoom()`); keep crosshair on hover.
- **ChartCard** `showExportAction` / `exportRequested` / `footerActions`.
- **KpiTile** `compareValue` + `sparklineHeight`; **RingGauge** `valueFormat`; **DonutChart** `legendPosition`.
- **DashboardShell** filter rail (`filterPane`) + **MetricCompareRow** / **ChartEmptyState**.
- Gallery **Dashboard** + [`examples/dashboard`](../examples/dashboard/) refresh.

#### Action required (only if you adopt new APIs)

| Area | Change | What to do |
|------|--------|------------|
| **Dashboard layout** | Prefer **DashboardShell** over ad-hoc `ColumnLayout` + `TwoPaneView` | Copy `examples/dashboard` or Gallery **Dashboard** |
| **LineChart** | Optional `zoomEnabled: true` | Teach drag-to-zoom; call `resetZoom()` for a Reset action |
| **Empty charts** | **ChartEmptyState** inside **ChartCard** | Use `state: "empty" \| "loading" \| "error"` |

#### No action (compatible)

- Existing stable-six dashboards keep working; new properties default off / empty.

### Upgrade 2.63 → 2.64

**Product version:** 2.64
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Python Gallery (early 2.71):** [`examples/python-gallery/`](../examples/python-gallery/) — full Gallery from PySide6 / PyQt6; [`packaging-python.md`](packaging-python.md); `python scripts/verify_python.py --smoke`.
- **Collection perf + a11y sign-off:** **DataTable** pin/group, **ListDetailsView** multi-select toolbar — [collection-perf-264.md](collection-perf-264.md) (**2.64** / **FL-008**, **FL-016**).
- **TreeDataGrid** column resize; **FileTree** `filterText` + column chooser.

#### Action required (only if you adopt new APIs)

| Area | Change | What to do |
|------|--------|------------|
| **DataTable** | `groupRole`, `columns[].pinned`, `columnOrder` | Pin identity columns; group ops rows; persist order in Settings |
| **ListDetailsView** | `multiSelectEnabled`, `detailToolbar`, `selectedItems` | Bulk toolbar instead of separate **ItemsView** master |
| **FileTree** | `filterText`, `hiddenColumnRoles` | Shared table filter; toggle metadata columns |

#### No action (compatible)

- Existing **DataTable** / **ListDetailsView** pages — new properties default off (`groupRole` empty, `multiSelectEnabled` false).

### Upgrade 2.62 → 2.63

**Product version:** 2.63
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Notification center productize:** `NotificationBridge` → `NotificationCenter` — [notification-center-263.md](notification-center-263.md) (**2.63** / **FL-007**).
- Set **`maxHistory`**; pass stable **`id`** for dedupe; use **`bridge.success()`** instead of manual toast + push.

#### Action required (only if you adopt the product stack)

| Area | Change | What to do |
|------|--------|------------|
| **NotificationBridge** | `notificationCenter` + `recordInCenter` | Wire center on bridge; one API for toast + history |
| **NotificationCenter** | `maxHistory`, `dedupeIdRole` | Cap stored rows; dedupe by `id` |
| **ToastHost** | Optional `dedupeId` on `show()` | Skip duplicate transient toasts |

#### No action (compatible)

- Apps using only **ToastHost** / **2.27** manual center — still work; bridge params optional.

### Upgrade 2.61 → 2.62

**Product version:** 2.62
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **SemanticZoom (experimental):** contacts grid ↔ letter index — [semantic-zoom-262.md](semantic-zoom-262.md) (**2.62** / **FL-006**).
- Gallery **SemanticZoom** contacts recipe; **Ctrl+-** / **Ctrl++** keyboard zoom.

#### Action required (only if you adopt SemanticZoom)

| Area | Change | What to do |
|------|--------|------------|
| **SemanticZoom** | New **experimental** Extras type | `import QWinUI3.Extras` · one `model` for both views · `selectGroup()` on index |
| **Selection** | Shared state | Do not duplicate selection across two raw `ItemsView`s |

#### No action (compatible)

- Apps not using **`SemanticZoom`** — no API breaks.

### Upgrade 2.60 → 2.61

**Product version:** 2.61
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **RichEdit (experimental):** mail/template editor — [rich-edit-261.md](rich-edit-261.md) (**2.61** / **FL-005**).
- Gallery **RichEdit** mail-compose recipe; **`sanitizePaste`** on by default.

#### Action required (only if you adopt RichEdit)

| Area | Change | What to do |
|------|--------|------------|
| **RichEdit** | New **experimental** Extras type | `import QWinUI3.Extras` · mark experimental in app docs · wire **`onLinkActivated`** |
| **Paste** | HTML subset | Keep **`sanitizePaste: true`** for user paste; review security-sensitive flows |

#### No action (compatible)

- Apps not using **`RichEdit`** — no API breaks.

### Upgrade 2.59 → 2.60

**Product version:** 2.60
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Friction tranche checkpoint:** audit **2.51…2.60** + **3.00 prep draft** — checkpoint-260 (**2.60**).
- Skim slice recipes **2.51…2.59** if jumping from **2.50** ([stable-clarity-251.md](stable-clarity-251.md) … [app-sluggishness-259.md](app-sluggishness-259.md)).

#### No action (compatible)

- Docs-only audit tag; no API breaks.

### Upgrade 2.58 → 2.59

**Product version:** 2.59
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **App-level perf wave 9:** command recents, filter caps, `Button.loading` — [app-sluggishness-259.md](app-sluggishness-259.md) (**2.59**).

#### Action required (only if you use these APIs)

| Area | Change | What to do |
|------|--------|------------|
| **Button** | New **`loading`** property (style) | Async saves: `loading: busy` + `enabled: canSave && !busy` |
| **ItemsView** / **AutoSuggestBox** | **`minFilterLength`** · **`maxFilterResults`** | Set on large JS-array models |
| **CommandPalette** | **`maxRecentCommands`** | Optional **`id`** on commands for recents |

#### No action (compatible)

- Defaults preserve **2.58** behavior when new properties are untouched.

### Upgrade 2.57 → 2.58

**Product version:** 2.58
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **OSK in apps:** embedded dock recipe — copy [`examples/osk-dock/`](../examples/osk-dock/) — [osk-in-apps-258.md](osk-in-apps-258.md) (**2.58**).

#### Action required (only if you embed OSK)

| Area | Change | What to do |
|------|--------|------------|
| **OnScreenKeyboard** | **`sharedEngine`** · focus return · floating candidates | One **`KeyboardEngine`** per window; see [osk-in-apps-258.md](osk-in-apps-258.md) |

#### No action (compatible)

- Floating OSK host unchanged — [`examples/floating-osk/`](../examples/floating-osk/).

### Upgrade 2.49 → 2.50

**Product version:** 2.50
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Tranche-1 checkpoint:** audit **2.00…2.50** + **2.51+** friction queue — checkpoint-250 (**2.50**).

#### No action (compatible)

- Docs-only audit tag; no API breaks.

### Upgrade 2.48 → 2.49

**Product version:** 2.49
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 8:** tranche-1 sign-off + chart/dashboard budgets — [perf-signoff-2xx.md](perf-signoff-2xx.md) (**2.49**).

#### No action (compatible)

- Documentation + Gallery callouts only; no API breaks.

### Upgrade 2.47 → 2.48

**Product version:** 2.48
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Friction slot (FL-009):** dashboard compose decision tree — [dashboard-compose-decision.md](dashboard-compose-decision.md) (**2.48**).

#### No action (compatible)

- Docs + Gallery UX only; stable chart APIs unchanged.

### Upgrade 2.46 → 2.47

**Product version:** 2.47
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Field harden buffer:** packaging **path picker** (**FL-003**) + stable-api **import guard** (**FL-004**) — [field-harden-247.md](field-harden-247.md) (**2.47**).
- **Smoke:** `--smoke` now loads **Recipes hub** + **Performance** pages.

#### No action (compatible)

- Docs + smoke coverage only; stable control APIs unchanged.

### Upgrade 2.45 → 2.46

**Product version:** 2.46
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Docs IA v2:** MkDocs **2.xx** nav regroup + [recipes.md](recipes.md) hub v2 + Gallery **Recipes hub** mirror — [docs-ia-v2.md](docs-ia-v2.md) (**2.46**).

#### No action (compatible)

- Documentation navigation only; no API changes.

### Upgrade 2.44 → 2.45

**Product version:** 2.45
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Experimental sweep (FL-004):** Gallery **Experimental** / **Permanent defer** badges + [experimental-sweep.md](experimental-sweep.md) verdict matrix (**2.45**).

#### No action (compatible)

- Docs + Gallery UX only; stable control APIs unchanged.

### Upgrade 2.43 → 2.44

**Product version:** 2.44
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Developer diagnostics:** `FrameStatsMonitor.retailMode` / `persistSettings` / `applyRetailProfile()`; CLI `--retail-diagnostics`; FrameStats promoted stable — [developer-diagnostics.md](developer-diagnostics.md) (**2.44**).

#### No action (compatible)

- Additive Platform API; call `applyRetailProfile()` only when adopting the retail checklist.

### Upgrade 2.42 → 2.43

**Product version:** 2.43
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Multi-window + onboarding:** coach-on-main-shell + Settings category vs geometry — [multi-window-onboarding.md](multi-window-onboarding.md) (**2.43**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.41 → 2.42

**Product version:** 2.42
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **SwipeControl deepen:** `dragThreshold` / `nestedScrollFriendly` for list rows + TeachingTip teaching pattern — [touch-pointer.md](touch-pointer.md) (**2.42**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.40 → 2.41

**Product version:** 2.41
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Command/menu wave 3:** large-model CommandPalette (`commandCount` / `filteredCount`, filter matches `shortcut`) + MenuBar accelerator mirror recipe — [commands.md](commands.md) (**2.41**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.39 → 2.40

**Product version:** 2.40
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 7:** collection debounce/filter checklist for DataTable / ListDetailsView / NavigationView / FileTree / TreeDataGrid — [performance.md](performance.md) (**2.40**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.38 → 2.39

**Product version:** 2.39
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Gallery catalog expansion:** 2.21…2.38 findability matrix, Home Recently shipped refresh, Pitfalls 2.xx checklist — [gallery-catalog-expansion.md](gallery-catalog-expansion.md) (**2.39**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.37 → 2.38

**Product version:** 2.38
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Theme overrides wave 2:** accent packs + `ThemePrefs` persist recipe + contrast/density integration — [theme-overrides.md](theme-overrides.md) (**2.38**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.36 → 2.37

**Product version:** 2.37
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Carousel recipes:** FlipView / PipsPager + SwipeView hosts, reducedMotion — [carousel-recipes.md](carousel-recipes.md) (**2.37**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.35 → 2.36

**Product version:** 2.36
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Security & trust wave 3:** FileTree / TreeDataGrid path trust + WebView2 download policy D/E/F — [security-trust.md](security-trust.md) (**2.36**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.34 → 2.35

**Product version:** 2.35
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Localization wave 4:** fourth seed locale **`de_DE`** + **2.21…2.34** Gallery page `qsTr` checker — [i18n-rtl.md](i18n-rtl.md) (**2.35**). Run `lupdate src/gallery` after adding Gallery pages.

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.33 → 2.34

**Product version:** 2.34
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Packaging & CI consumer matrix:** shared/static × Win/Linux table + `consumer-matrix.yml` CI job — [packaging-consumer.md](packaging-consumer.md) (**2.34**).

#### No action (compatible)

- Stable Theme / shell / control APIs unchanged for this slice.

### Upgrade 2.32 → 2.33

**Product version:** 2.33
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Linux portal & tray wave 3:** FilePicker / SNI tray / idle inhibit field regression suite — [platform-linux-wayland.md](platform-linux-wayland.md) (**2.33**).

#### No action (compatible)

- Docs + Gallery callouts only; platform APIs unchanged.

### Upgrade 2.31 → 2.32

**Product version:** 2.32
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Media / WebView2 harden:** Field matrices + WebView2 navigation policy recipes (Pattern A/B/C) — [media.md](media.md) · [webview2.md](webview2.md) (**2.32**).

#### No action (compatible)

- Docs + Gallery callouts only; **MediaPlayerElement** remains experimental defer; **WebView2Host** stable API unchanged.

### Upgrade 2.30 → 2.31

**Product version:** 2.31
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **`CalendarView`** (experimental): always-visible month grid — **single** / **multiple** / **range** selection; distinct from **CalendarDatePicker** / **DatePicker** — [calendar-view.md](calendar-view.md).

#### No action (compatible)

- Style **`MonthGrid`** gains optional multi/range styling; **CalendarDatePicker** unchanged.

### Upgrade 2.29 → 2.30

**Product version:** 2.30
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Mid-2.x checkpoint:** checkpoint-230 — audit **2.21…2.30**; **203** catalog / **225** public types; friction triage for **2.31…2.50** (no slices dropped).

#### No action (compatible)

- Docs-only checkpoint tag; no API breaks vs **2.29**.

### Upgrade 2.28 → 2.29

**Product version:** 2.29
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Accessibility wave 5:** **`TreeDataGrid`** / **`FileTree`** keyboard names + live regions; **`ItemsWrapGrid`** / **`BreadcrumbBar`** `accessibleName` + `announceChanges` — [accessibility.md](accessibility.md) wave 5 checklist.

#### No action (compatible)

- Additive a11y properties; set `announceChanges: false` only when a host already announces the same state.

### Upgrade 2.27 → 2.28

**Product version:** 2.28
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Shell trim diagnostics:** `NavigationView` exposes **`sameKeySkipCount`** / **`samePageSkipCount`**; **`NavigationWindow`** forwards cache aliases + **`clearPageCache()`** — [performance.md](performance.md) wave 6 checklist + advisory smoke timings.

#### No action (compatible)

- Additive counters; navigation behavior unchanged.

### Upgrade 2.26 → 2.27

**Product version:** 2.27
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Notification center:** Experimental **`NotificationCenter`** drawer (grouped history, mark read, clear) + Gallery page with **InfoBadge** bell, **ProgressRing** save path, **TeachingTip** — [feedback.md](feedback.md) wave 3 (FL-007).

#### No action (compatible)

- Additive experimental control; **ToastHost** / **InfoBar** unchanged.

### Upgrade 2.25 → 2.26

**Product version:** 2.26
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Charts recipe wave:** Gallery **Charts** deferred sibling chooser + stacked-area compose; [charts.md](charts.md) **Recipe wave (2.26)** — stable six unchanged.

#### No action (compatible)

- No new stable chart names; deferred types remain experimental.

### Upgrade 2.24 → 2.25

**Product version:** 2.25
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Industry templates:** Gallery **Registration**, **Admin CRUD**, and **Preferences** template pages — [forms.md](forms.md) **2.25** section; **Forms & settings** hub links.
- **MultiSelectComboBox:** `errorMessage` / `hasError` / `formBound` for **FormLayout** validation parity.

#### No action (compatible)

- **MultiSelectComboBox** remains API-compatible; header now renders above the field (not only inside the popup).

### Upgrade 2.23 → 2.24

**Product version:** 2.24
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **ItemsWrapGrid:** Model-driven variable-size wrap (`WrapPanel` + `filterText`) — Gallery **ItemsWrapGrid**, [items-wrap-grid.md](items-wrap-grid.md).

#### No action (compatible)

- New experimental control only; **WrapPanel** / **ItemsRepeater** unchanged.

### Upgrade 2.22 → 2.23

**Product version:** 2.23
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **BreadcrumbBar integration:** `NavigationView.breadcrumbModelForKey` / `selectBreadcrumbIndex` keep crumbs aligned with nav selection; **NavigationWindow** exposes the same helpers and optional `syncSubtitleFromNavigation` — [navigation.md](navigation.md) **2.23** section, Gallery **BreadcrumbBar** page.

#### No action (compatible)

- Additive APIs on **NavigationView**, **NavigationWindow**, and **BreadcrumbBar**; defaults unchanged (`syncSubtitleFromNavigation` stays `false`).

### Upgrade 2.21 → 2.22

**Product version:** 2.22
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Dashboard layout:** Responsive KPI/chart breakpoints + optional `TwoPaneView` filter rail — [`examples/dashboard`](../examples/dashboard/), Gallery **Dashboard**, [charts.md](charts.md) **2.22** section.

#### No action (compatible)

- No new stable chart names; layout recipe only.

---

### Upgrade 2.20 → 2.21

**Product version:** 2.21
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **TreeDataGrid (experimental):** `import QWinUI3.Extras` — hierarchical multi-column grid with sort/filter; Gallery **TreeDataGrid** page; [tree-data.md](tree-data.md).

#### No action (compatible)

- Component QML APIs unchanged except new experimental `TreeDataGrid`.

---

### Upgrade 2.19 → 2.20

**Product version:** 2.20
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Gallery full locale switch:** `GalleryLanguage` — Settings → **Display language** or **i18n / RTL** page; persists `Gallery/uiLocale`; startup `--lang zh_CN`. Release embeds `.qm` via `qt_add_translations`. See [i18n-rtl.md](i18n-rtl.md).
- **Horizon checkpoint:** checkpoint-220 — tranche-1 audit; **2.21+** per friction table.

#### No action (compatible)

- Component QML APIs unchanged; no CMake breaking changes vs **2.19**.

---

### Upgrade 2.18 → 2.19

**Product version:** 2.19
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Docs & catalog refresh:** Regenerate component API — `python scripts/generate_component_docs.py`. Critical smoke adds **MultiWindowPage** / **StyleSpotCheckPage**. `python scripts/smoke_gallery.py` **2.19**.

#### No action (compatible)

- Component QML APIs unchanged; docs index counts may drift until you regenerate locally.

---

### Upgrade 2.17 → 2.18

**Product version:** 2.18
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 5:** `DataTable` / `ListDetailsView` `maxFilterResults`; ListDetailsView selection survives filter by object identity; `NavigationView.pageCacheHits`. [performance.md](performance.md) **2.18** section.

#### No action (compatible)

- Defaults preserve prior filter behavior (`maxFilterResults: 0` = unlimited).

---

### Upgrade 2.16 → 2.17

**Product version:** 2.17
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Style polish:** `Theme.bgControlRest`, `Theme.borderedControlFill()`, `Theme.fillSliderThumb`; Style controls use shared fill tokens. Gallery **Style spot-check**. [style-polish.md](style-polish.md) · [theme-overrides.md](theme-overrides.md).

#### No action (compatible)

- Visual-only Style token migration; public control APIs unchanged.

---

### Upgrade 2.15 → 2.16

**Product version:** 2.16
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Command & search wave 2:** `CommandPalette.filterDebounceMs` / `maxResults`; **AutoSuggestBox** / **SearchBox** `filterDebounceMs` / `maxSuggestionResults` + field-first ↑↓ keyboard. [commands.md](commands.md) · [search.md](search.md) **2.16** sections.

#### No action (compatible)

- Existing palette / suggest callers gain debounced filtering automatically; defaults preserve prior UX timing.

---

### Upgrade 2.14 → 2.15

**Product version:** 2.15
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **High-DPI wave 3:** `WindowHelper.highDpiScaleFactorRoundingPolicy()`; `screensInfo()[].fractionalScale`; Gallery **High-DPI & monitors** per-monitor soak. [high-dpi.md](high-dpi.md) **2.15** section.

#### No action (compatible)

- Existing geometry restore / `screensInfo()` callers gain optional `fractionalScale` field; no schema break.

---

### Upgrade 2.13 → 2.14

**Product version:** 2.14
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Multi-window harden:** `WindowHelper.ensureWindowCreated`, hardened `setTransientParent`, `centerOnOwner`; prefer `DialogShellWindow.openDialog(owner)` / `DialogWindow.openDialog(owner)`. [window-shells.md](window-shells.md) **2.14** checklist.

#### No action (compatible)

- Existing `openDialog` callers gain realize + owner-screen centering automatically.

---

### Upgrade 2.12 → 2.13

**Product version:** 2.13
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Security wave 2:** [security-trust.md](security-trust.md) — WebView2 navigation policy patterns; `FileDropZone.acceptMimeTypes`; Wayland portal regression checklist. Gallery **WebView2** URL field uses demo allowlist.

#### No action (compatible)

- `acceptMimeTypes` defaults empty — behavior unchanged vs **2.12** when unset.

---

### Upgrade 2.11 → 2.12

**Product version:** 2.12
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Localization wave 3:** [i18n-rtl.md](i18n-rtl.md) **Consumer lrelease recipe (2.x)** — `qt_add_translations`, `QTranslator` before QML, package layout. Gallery seed **`ko_KR`**; `examples/gallery-shell` demo with `--lang ko_KR`.

#### No action (compatible)

- No API breaks. Apps without `.ts` / `.qm` stay English.

---

### Upgrade 2.10 → 2.11

**Product version:** 2.11
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **vcpkg / Conan ports:** [packaging-vcpkg-conan.md](packaging-vcpkg-conan.md) — overlay `ports/qwinui3/` (`x64-windows` · `x64-linux`) and Conan 2 recipe; same `find_package(QWinUI3 CONFIG)` layout as shared zips. **FL-003** partial — **2.02** still scheduled for primary Path C productize.

#### No action (compatible)

- Zip / `add_subdirectory` consumers unchanged. Ports do not vendor Qt.

---

### Upgrade 2.09 → 2.10

**Product version:** 2.10
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Mid-2.x checkpoint:** checkpoint-210 audits **2.00…2.10** — confirms **2.03…2.09** shipped on the 1.xx floor; **2.00 / 2.01 / 2.02** remain planned; **no breaking code**.

#### No action (compatible)

- No API, CMake, or Qt floor changes. Stay on **2.09** until ready — this tag is docs-only for consumers.

---

### Upgrade 2.08 → 2.09

**Product version:** 2.09
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Media verdict:** [media.md](media.md) closes the **1.67** promote loop — `MediaPlayerElement` **permanently deferred** (experimental). App-owned Multimedia plugins/codecs. No API break.

#### No action (compatible)

- Apps already gating on `available === false` need no changes.

---

### Upgrade 2.07 → 2.08

**Product version:** 2.08
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Charts compose:** [charts.md](charts.md) finalizes Area→`LineChart.showArea`, Spark→`KpiTile.trendValues`, and **permanent defer** for sibling charts/gauges. Stable six unchanged — no API breaks.

#### No action (compatible)

- Product dashboards on the stable six need no code changes.

---

### Upgrade 2.06 → 2.07

**Product version:** 2.07
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Accessibility wave 4:** `DataTable`, `ListDetailsView`, and `NavigationView` expose `announceChanges` (default **true**) and call `Accessible.announce` on Qt 6.8+ for selection / sort / filter / nav / pane changes. Set `announceChanges: false` to opt out. [accessibility.md](accessibility.md).

#### No action (compatible)

- No breaking API changes.

---

### Upgrade 2.05 → 2.06

**Product version:** 2.06
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **FileTree (experimental):** `import QWinUI3.Extras` — Explorer folder `TreeView` + file `DataTable`; Gallery **FileTree** page; [tree-data.md](tree-data.md).

#### No action (compatible)

- No breaking changes. `FileTree` is experimental — not in stable-api promote table.

---

### Upgrade 2.04 → 2.05

**Product version:** 2.05
**Date:** 2026-08-17
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Title-bar cookbook:** [title-bar-cookbook.md](title-bar-cookbook.md) documents `StandardTitleChrome` / `ShellWindow` header slots, `PlatformTitleBar.rightHeader` placement, and NC hit-test troubleshooting.

#### No action (compatible)

- No API or CMake breaking changes.

---

### Upgrade 2.03 → 2.04

**Product version:** 2.04  
**Date:** 2026-08-17  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Runtime diagnostics:** `FrameStatsMonitor.showRhi` appends active RHI label beside FPS in `FrameStatsBadge` / `FrameStatsOverlay`. Settings **Show RHI**; CLI `--show-rhi`, `--show-diagnostics`. [performance.md](performance.md).

#### No action (compatible)

- Windows / Linux shell paths unchanged. Opt-in only; defaults unchanged (`enabled` false, `showRhi` false).

### Upgrade 2.02 → 2.03

**Product version:** 2.03  
**Date:** 2026-08-17  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Linux client shell wave 2:** compositor profile shadow tuning (`shellCompositorProfile`, `shellShadowOpacity`); `WindowShellDecoration_Simple` when kit built without QuickEffects; **`WindowShellContentClip`** / `shellContentInset()` for bottom-corner content bleed. [platform-linux-wayland.md](platform-linux-wayland.md).

#### No action (compatible)

- Windows DWM path unchanged. Theme / stable control APIs unchanged.

### Upgrade 1.90 → 2.00 (draft)

**Status:** **Draft only** — breaks ship in **2.00**, not in 1.90. Inventory finalized in checkpoint-190.

**Product version target:** 2.00  
**Qt:** floor **6.8 LTS** (drop **6.5**); forward **6.10+** OK — [qt-version-compat.md](qt-version-compat.md)

#### Action required (at 2.00)

| Area | Change | What to do |
|------|--------|------------|
| **Qt** | Minimum **6.8** | Raise CI / installer Qt; rebuild Release; re-run deploy (`windeployqt` / `linuxdeploy`) |
| **Theme tokens** | Collapse duplicate stroke/focus aliases (exact list in 2.00 release notes) | Grep your app for legacy focus/stroke names; apply remap table from 2.00 tag |
| **Shell aliases** | Remove Gallery-era compatibility aliases | Prefer `NavigationWindow` / `StandardWindow` / documented Extras shells — [window-shells.md](window-shells.md) |
| **Experimental types** | Still experimental after **2.01** OSK may be promoted, moved, or removed | Pin 1.90 if you depend on undocumented experimental APIs |

#### Optional / polish

- Skim [performance.md](performance.md) arc (1.86…1.89) before tuning on the new floor.
- OSK / IME promote and consumer packaging: **2.01+**, not 2.00 by default — [ROADMAP.md](../ROADMAP.md).

#### Stay on 1.90 if

- You must keep **Qt 6.5** in production.
- You need the current 2.xx Theme / shell names without a migration window.

### Upgrade 2.60 → 3.00 (draft)

**Status:** **Draft only** — breaks ship in **3.00**, not in **2.60**. Inventory refined at **2.73** + checkpoint-300.

**Product version target:** 3.00  
**Qt:** floor **6.10 LTS** (drop **6.8** shim path); forward **6.12+** OK — [qt-version-compat.md](qt-version-compat.md)

#### Action required (at 3.00)

| Area | Change | What to do |
|------|--------|------------|
| **Qt** | Minimum **6.10** | Raise CI / installer Qt; rebuild Release; re-run deploy |
| **Deferred charts/gauges** | Sibling types removed from default import or moved to experimental module | Migrate to stable six + compose — [charts.md](charts.md) |
| **Media** | **MediaPlayerElement** not on default stable surface | App-owned Multimedia — [media.md](media.md) |
| **Theme** | Remaining 2.x stroke/focus aliases removed | Grep legacy names; apply 3.00 remap table |
| **Shell** | Undocumented Gallery-era window aliases removed | [window-shells.md](window-shells.md) |
| **CMake / PyPI** | **`find_package(QWinUI3 CONFIG)`** primary; PyPI **3.00** if **2.72** shipped | [packaging-consumer.md](packaging-consumer.md) |

#### Optional / polish (plan now — ship later)

- Complete **2.61…2.73** professional + Python tranche before pinning **3.00**.
- Skim [performance.md](performance.md) **2.x** waves before tuning on Qt **6.10**.
- Read [compatibility-3xx.md](compatibility-3xx.md) when it ships.

#### Stay on 2.60 if

- You are mid **2.61…2.73** adoption and cannot absorb a major yet.
- You must keep **Qt 6.8** in production until **2.73**.

### Upgrade 2.73 → 3.00 (draft)

**Status:** **Draft only** — breaks ship in **3.00**, not in **2.73**. Inventory finalized in checkpoint-300.

**Product version target:** 3.00  
**Qt:** floor **6.10 LTS** (drop **6.8** shim path); forward **6.12+** OK — [qt-version-compat.md](qt-version-compat.md)

#### Action required (at 3.00)

| Area | Change | What to do |
|------|--------|------------|
| **Qt** | Minimum **6.10** | Raise CI / installer Qt; rebuild Release; re-run deploy |
| **Deferred charts/gauges** | Sibling types removed from default import or moved to experimental module | Migrate to stable six + compose — [charts.md](charts.md) |
| **Media** | **MediaPlayerElement** not on default stable surface | App-owned Multimedia — [media.md](media.md) |
| **Theme** | Remaining 2.x stroke/focus aliases removed | Grep legacy names; apply 3.00 remap table |
| **Shell** | Undocumented Gallery-era window aliases removed | [window-shells.md](window-shells.md) |
| **CMake / PyPI** | **`find_package(QWinUI3 CONFIG)`** primary; PyPI **3.00** if **2.72** shipped | [packaging-consumer.md](packaging-consumer.md) |

#### Optional / polish

- Skim [performance.md](performance.md) **2.x** summary before tuning on Qt **6.10**.
- Read [compatibility-3xx.md](compatibility-3xx.md) for the **3.xx** freeze.

#### Stay on 2.73 if

- You must keep **Qt 6.8** in production.
- You depend on **permanent defer** chart/gauge siblings without migration time.
- You use experimental APIs not promoted by **2.45** / **2.67**.

### Upgrade 1.89 → 1.90

**Product version:** 1.90  
**Date:** 2026-08-17  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **1.xx close-out:** checkpoint-190 — docs audit, perf arc sign-off, **2.00 prep draft** (no breaking code).
- **Performance arc:** all four waves (1.86…1.89) documented in [performance.md](performance.md); smoke timing remains advisory — `python scripts/smoke_gallery.py`.

#### No action (compatible)

- Theme / shell / stable control APIs unchanged. **1.xx freeze ends at 2.00**, not at 1.90. Next planned major: **2.00** (after this tag).

### Upgrade 1.88 → 1.89

**Product version:** 1.89  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 4 (style/charts):** ElevatedChrome shadow defer; Style idle Behavior trim; chart reveal budget + coalesced redraw; Gallery heavy-page deferrals. [performance.md](performance.md).

#### No action (compatible)

- Theme / shell API unchanged. Interaction animations unchanged. Next: **1.90** close-out.

### Upgrade 1.87 → 1.88

**Product version:** 1.88  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 3 (lists):** `DataTable` debounces filter rebuilds; `ItemsView` / `ListDetailsView` / `ItemsRepeater` optional `filterText` on JS arrays. [performance.md](performance.md).

#### No action (compatible)

- Theme / shell API unchanged. Animations unchanged. Next: **1.89** style/charts perf wave.

### Upgrade 1.86 → 1.87

**Product version:** 1.87  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 2 (navigation):** `NavigationView` StackView transitions skip no-op x/y/scale animators per mode (slide/fade look the same). Compact flyout defers shadow until open. `TabView` idle tab strip behaviors trimmed. Gallery Settings **Performance arc** card. [performance.md](performance.md).

#### No action (compatible)

- Theme / shell API unchanged. Pane collapse animation unchanged. Next: **1.88** lists perf wave.

### Upgrade 1.85 → 1.86

**Product version:** 1.86  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 1 (shell):** Solid `StandardWindow` hosts clear with layer fill (not `Qt::white`); Windows `DWMWA_BORDER_COLOR` matches fill; Solid windows skip focus-in DWM timer bursts (restore feels snappier). [performance.md](performance.md) · [window-chrome.md](window-chrome.md).

#### No action (compatible)

- Theme / shell API unchanged. OSK stays experimental. Next: **1.87** navigation perf wave.

### Upgrade 1.84 → 1.85

**Product version:** 1.85  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- ContentDialog / Flyout / CommandBarFlyout return focus to the opener on close. InfoBar announces on open (`Accessible.announce` on Qt 6.8+). ImeCandidateBar announces candidates without taking focus. Gallery **Accessibility** wave 3 sample. [accessibility.md](accessibility.md).

#### No action (compatible)

- Theme / shell / stable control APIs unchanged. OSK stays experimental.

### Upgrade 1.83 → 1.84

**Product version:** 1.84  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Copy [`examples/floating-osk`](../examples/floating-osk/) for `OnScreenKeyboardWindow` (not the Gallery). Keyman Core is in `third_party/keyman` with the clone. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.82 → 1.83

**Product version:** 1.83  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: floating host no-activate soak (`WM_MOUSEACTIVATE` / no `raise()`); long-press flyout stays in-window on Qt 6.8+. Gallery checklist vs dock. Honest limits: elevated / UIPI / UWP / games may ignore `SendInput`. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental. Docked `systemWide` still defaults **off**.

### Upgrade 1.81 → 1.82

**Product version:** 1.82  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: `OnScreenKeyboardWindow` floating host; Windows `SendInput` into the focused desktop app (`systemWide`, default **on** for the floating window; dock stays off). [on-screen-keyboard.md](on-screen-keyboard.md).
- Gallery: removed unused `--visual-smoke` / `scripts/smoke_visual.py` (1.62 opt-in subset). CI `--smoke` unchanged. `python scripts/smoke_gallery.py`.

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental. Docked `OnScreenKeyboard.systemWide` still defaults **off**.

### Upgrade 1.80 → 1.81

**Product version:** 1.81  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: Windows **11** behavior (not Win10 classic) — long-press digit hints + punctuation alt flyout, `keyboardSize` Small/Default/Large, clipboard strip, emoji category chips, rounder press-scale keys. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.79 → 1.80

**Product version:** 1.80  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: Win11 default touch **layout** chrome (Esc/Tab/dual Shift, lang chip 英/中/あ/한, number hints, settings/grab/close). `navigateKey` / `pasteClipboard` on `KeyboardEngine`. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental. Mic / Win keys remain chrome-only.

### Upgrade 1.78 → 1.79

**Product version:** 1.79  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Linux / Wayland: stronger portal `parent_window` (Qt `portalWindowIdentifier` when GuiPrivate is available; window realized before export); Bootstrap detects `WAYLAND_SOCKET`; experimental OSK CapsLock tracking on Linux. [platform-linux-wayland.md](platform-linux-wayland.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental. Rebuild Linux kits with `qt*-private-dev` / GuiPrivate for the best Wayland parent export.

### Upgrade 1.77 → 1.78

**Product version:** 1.78  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Docs / posture

- Long-horizon checkpoint: checkpoint-178. Prefer **field harden / pause vs new surfaces**; `1.79+` only for field-driven P0s or park. OSK/IME **stays experimental** (not promoted in 1.74 / 1.76 / 1.77).

#### No action (compatible)

- Theme / shell / stable controls unchanged. Freeze (1.40) still active.

### Upgrade 1.76 → 1.77

**Product version:** 1.77  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: `hardwareInput` (default on) routes physical keyboard keys in **this app** through the same engine as the dock. Not OS-wide. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental. Set `hardwareInput: false` to leave keys to the system IME.

### Upgrade 1.75 → 1.76

**Product version:** 1.76  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK IME deepen (MIT-only): pinyin prefix phrases + regenerated tables; hangul compound peel / Space word-break; Japanese stays kana — kanji skipped (no MIT lexicon). [on-screen-keyboard.md](on-screen-keyboard.md) · [NOTICE-pinyin.md](NOTICE-pinyin.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.74 → 1.75

**Product version:** 1.75  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: more Keyman layouts — English (UK), Italiano, Português, Polski, Svenska, Türkçe. Re-fetch with `python scripts/fetch_keyman_keyboards.py`. [on-screen-keyboard.md](on-screen-keyboard.md) · [NOTICE-Keyman.md](NOTICE-Keyman.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.73 → 1.74

**Product version:** 1.74  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK soak: Gallery language-matrix checklist, candidate-bar a11y, romaji trailing-`n` / small kana. Still experimental — not promoted. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.72 → 1.73

**Product version:** 1.73  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: **日本語** (romaji→kana) and **한국어** (2-beolsik hangul) share `ImeCandidateBar`. Emoji layer has no engine. Keyman Core is still layouts only. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.71 → 1.72

**Product version:** 1.72  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: switch to **中文** for in-app pinyin (`ImeCandidateBar`). Lexicon is MIT pinyin-data, not Microsoft Pinyin. [on-screen-keyboard.md](on-screen-keyboard.md) · [NOTICE-pinyin.md](NOTICE-pinyin.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.70 → 1.71

**Product version:** 1.71  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental `OnScreenKeyboard` now feeds **SIL Keyman Core** (MIT, static). Globe / ComboBox switches en/de/fr/es/ru/ar `.kmx`. [on-screen-keyboard.md](on-screen-keyboard.md) · [NOTICE-Keyman.md](NOTICE-Keyman.md).
- Configure fetches Core into gitignored `third_party/keyman` (`scripts/fetch_keyman_core.py`, `QWINUI3_FETCH_KEYMAN`). Without it, `engine.backend` stays `"builtin"`.
- Still not Qt Virtual Keyboard; `QT_IM_MODULE` stays unset.

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.69 → 1.70

**Product version:** 1.70  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental `OnScreenKeyboard` dock + `KeyboardEngine` (en-US). Host in a shell footer / `CatalogPage.footer`. [on-screen-keyboard.md](on-screen-keyboard.md).
- Do not enable Qt Virtual Keyboard; `QT_IM_MODULE` stays unset.

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK is additive and experimental.

### Upgrade 1.68 → 1.69

**Product version:** 1.69  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Theme knobs are kit-wide: drop `ThemeAppearanceSettings` on your Settings page; copy `Theme.recipeText()` into another app. Shells run `ThemeSync` (follow system a11y / color). [theme-overrides.md](theme-overrides.md).
- Persist Theme with `ThemePrefs` (`persist: true`) — keep geometry on `geometryPersistenceKey`.

#### No action (compatible)

- Existing `Theme.dark` / `followSystem*` assignments still work. Gallery Main no longer special-cases OS sync.

### Upgrade 1.67 → 1.68

**Product version:** 1.68  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Linux portal harden: [platform-linux-wayland.md](platform-linux-wayland.md) / [system-integration.md](system-integration.md) — FilePicker no longer falls back to zenity after a portal timeout; filters + save `current_name`; reveal OpenURI fallback; `WindowHelper.portalParentWindow()`.
- Gallery **System integration** live `parent_window` readout.

#### No action (compatible)

- FilePicker QML signatures unchanged. Pass `Window.window` as before.

### Upgrade 1.66 → 1.67

**Product version:** 1.67  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Media cookbook: [media.md](media.md) — soak checklist + **honest defer** for remaining 1.xx (`MediaPlayerElement` stays experimental).
- Gallery **MediaPlayerElement** decision callout.

#### No action (compatible)

- No promote; stub / real player behavior unchanged. Apps already using Multimedia keep the same API.

### Upgrade 1.65 → 1.66

**Product version:** 1.66  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Charts cookbook: [charts.md](charts.md) — remaining siblings/gauges **deferred** for remaining 1.xx (prefer Line/Bar/Donut + RingGauge + KpiTile + ChartCard).
- Gallery **Charts** / **Dashboard** hubs split stable vs deferred; `examples/dashboard` now uses all six stable types.

#### No action (compatible)

- Stable six unchanged; no new chart engine. Deferred types still ship (experimental).

### Upgrade 1.64 → 1.65

**Product version:** 1.65  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Settings persistence cookbook: [settings-persistence.md](settings-persistence.md) — `Settings` / QSettings, portable Ini, honest “roaming”, `schemaVersion`; keep geometry on `geometryPersistenceKey`.
- Gallery **Settings persistence**; examples `form-settings` + `gallery-shell` prefs.

#### No action (compatible)

- Docs + Gallery / example patterns only; no Theme or shell API breaks.

### Upgrade 1.63 → 1.64

**Product version:** 1.64  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Security & trust cookbook: [security-trust.md](security-trust.md) — WebView2 user-data / app-side URL allowlists, FileDropZone filters, FilePicker ownership (not a sandbox product).
- Gallery **Security & trust** + Pitfalls / WebView2 / FileDropZone callouts.

#### No action (compatible)

- Docs + Gallery only; WebView2Host / FileDropZone APIs unchanged.

### Upgrade 1.62 → 1.63

**Product version:** 1.63  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Print / share / export cookbook: [print-share.md](print-share.md) — grabToImage → FilePicker.saveFile → revealFileInFolder; optional app-side PrintSupport.
- Gallery **Print / share / export** interactive demo.

#### No action (compatible)

- Docs + Gallery only; no new kit PrintSupport dependency.

### Upgrade 1.61 → 1.62

**Product version:** 1.62  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Visual smoke subset: `python scripts/smoke_visual.py --build-dir build` (Gallery `--visual-smoke`); `python scripts/smoke_gallery.py`.
- Not part of default `smoke_gallery.py` — keep CI fast. Hash `--compare` is best-effort.

#### No action (compatible)

- Default `--smoke` path unchanged.

### Upgrade 1.60 → 1.61

**Product version:** 1.61  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- `find_package(QWinUI3 CONFIG)` sketch: [packaging-consumer.md](packaging-consumer.md) Path C; shared zips ship `lib/cmake/QWinUI3/` + `include/QWinUI3/Bootstrap.h`.
- Tiny consumer: `examples/find-package-consumer/`; verify with `python scripts/verify_find_package.py`.
- **Not** an official vcpkg/Conan port.

#### No action (compatible)

- Existing Path A / `add_subdirectory` flows unchanged; Config is additive in packages.

### Upgrade 1.59 → 1.60

**Product version:** 1.60  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Mid-horizon checkpoint: checkpoint-160 — still 1.xx; 1.61+ order confirmed.
- Gallery **Pitfalls** mid-horizon checklist; smoke critical pages include Search recipes + High-DPI.

#### No action (compatible)

- Docs / Gallery / smoke list only; APIs unchanged.

### Upgrade 1.58 → 1.59

**Product version:** 1.59  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- In-app search cookbook: [search.md](search.md) — AutoSuggestBox / SearchBox / filter-above vs CommandPalette.
- Gallery **Search recipes** interactive demo; AutoSuggest / SearchBox / commands cross-links.

#### No action (compatible)

- Docs + Gallery only; existing controls unchanged.

### Upgrade 1.57 → 1.58

**Product version:** 1.58  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- High-DPI / multi-monitor cookbook: [high-dpi.md](high-dpi.md); Gallery **High-DPI & monitors** readout.
- Geometry restore now `setScreen`s after clamp so mixed-DPI DPR updates ([window-helper.md](window-helper.md)).

#### No action (compatible)

- Additive restore behavior + docs; existing keys unchanged.

### Upgrade 1.56 → 1.57

**Product version:** 1.57  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Touch / pen cookbook: [touch-pointer.md](touch-pointer.md) — target floors, scroll vs drag, stylus hover notes.
- Gallery **Touch & pointer** page + callouts on Button / Slider / Nav / FileDropZone / SwipeControl; density & a11y cross-links.

#### No action (compatible)

- Docs + Gallery only; no new input stack.

### Upgrade 1.55 → 1.56

**Product version:** 1.56  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Multi-window recipe: secondary `ToolShellWindow` / owned `DialogShellWindow`, distinct `geometryPersistenceKey`s, shared Theme — [window-shells.md](window-shells.md).
- Runnable [`examples/multi-window`](../examples/multi-window/); Gallery **Multi-window** page.

#### No action (compatible)

- Additive example + docs; existing single-window shells unchanged.

### Upgrade 1.54 → 1.55

**Product version:** 1.55  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Gallery **Onboarding coach** — sequenced `TeachingTip`s, focus handoff, “don’t show again” via `QtCore.Settings` — [feedback.md](feedback.md).
- Cross-links in [keyboard.md](keyboard.md) / [dialogs-flyouts.md](dialogs-flyouts.md).

#### No action (compatible)

- Recipe-only; no new required control family.

### Upgrade 1.53 → 1.54

**Product version:** 1.54  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Second Gallery seed locale **`ja_JP`** alongside `zh_CN` — [i18n-rtl.md](i18n-rtl.md); Gallery i18n page locale ComboBox + `--lang` copy.

#### No action (compatible)

- Additive seed + docs; no API breaks.

### Upgrade 1.52 → 1.53

**Product version:** 1.53  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental [`AnimatedIcon`](components/AnimatedIcon.md) for glyph state swaps — [icons.md](icons.md). Use `checked` or `iconState`/`iconStates` (not Qt Quick `Item.state`).
- Gallery **AnimatedIcon** page; honors `Theme.reducedMotion`.

#### No action (compatible)

- Additive experimental type; no Lottie dependency.

### Upgrade 1.51 → 1.52

**Product version:** 1.52  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Local/CI smoke now also loads `FontIconPage` / `PitfallsPage` / `ExamplesTemplatesPage` as critical pages — `python scripts/smoke_gallery.py`.
- No open field P0s were reported after 1.51; this buffer shipped CI/docs harden instead of skipping.

#### No action (compatible)

- Additive smoke coverage only.

### Upgrade 1.50 → 1.51

**Product version:** 1.51  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Read [maturity-1xx.md](maturity-1xx.md) — stay on 1.xx; prefer harden / `gallery-shell` / stable-api.
- Freeze doc revisited: [compatibility-1xx.md](compatibility-1xx.md) (still the merge gate).

#### No action (compatible)

- Docs + Gallery Pitfalls checklist only; no API renames.

### Upgrade 1.49 → 1.50

**Product version:** 1.50  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Prefer [`examples/gallery-shell`](../examples/gallery-shell/) as the product app frame (keep-vs-delete in its README).
- `NavigationWindow` now exposes `pageModule` / `hostContent` / `pageTransition` / `navigateBack()` for Gallery-style StackView pages.

#### No action (compatible)

- Default `hostContent: true` + `content:` slot unchanged for existing NavigationWindow demos.

### Upgrade 1.48 → 1.49

**Product version:** 1.49  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Glyph hover/press micro-motion on `FontIcon` / `IconButton` / `AppBarButton` — see [icons.md](icons.md).
- Opt out with `microMotionEnabled: false`; tune `hoverScale` / `pressScale`.
- Gallery **Iconography** micro-motion strip + IconButton / AppBarButton pages.

#### No action (compatible)

- Defaults are additive; `Theme.reducedMotion` still forces scale `1`.
- IconButton no longer scales the whole control — only the glyph (visual polish).

### Upgrade 1.47 → 1.48

**Product version:** 1.48  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Follow [dialogs-flyouts.md](dialogs-flyouts.md) for 2+ queued dialogs, owner `Overlay.overlay`, and Esc/`onClosing` patterns.
- Gallery ContentDialog page: **Enqueue A → B → C** stress demo (critical smoke).

#### Action required (behavior fix)

| Area | Change | What to do |
|------|--------|------------|
| `ContentDialogQueue.replaceCurrent` | No longer pumps the pending queue while replacing | If you relied on the old race (pending opening mid-replace), switch to explicit `show()` after close |

#### No action (compatible)

- FIFO `show()` / `cancel` / `clearQueue` semantics unchanged for the common path.

### Upgrade 1.46 → 1.47

**Product version:** 1.47  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Follow [shell-extras.md](shell-extras.md) for Snap Layouts toggle, taskbar export loop, and attention/reveal patterns.
- Gallery System integration page hosts the demos (critical smoke).

#### No action (compatible)

- Additive docs + Gallery UX; stable taskbar / attention / reveal / idle APIs unchanged. Snap Layouts remains experimental.

### Upgrade 1.45 → 1.46

**Product version:** 1.46  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Follow [packaging-consumer.md](packaging-consumer.md) shared vs static matrix, windeploy/linuxdeploy, and strip-restricted steps.

#### No action (compatible)

- Additive docs + smoke check; archive layout and CMake targets unchanged.

### Upgrade 1.44 → 1.45

**Product version:** 1.45  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Use [i18n-rtl.md](i18n-rtl.md) for lupdate/lrelease and Gallery `--lang zh_CN` after generating `.qm`.
- Gallery `--lang zh_CN` after generating `.qm` — [i18n-rtl.md](i18n-rtl.md).

#### No action (compatible)

- Additive docs + optional CLI; no default language auto-switch.

### Upgrade 1.43 → 1.44

**Product version:** 1.44  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Follow [keyboard.md](keyboard.md) for Ctrl+K / dialog Esc-Enter / list arrows end-to-end.
- Gallery Accessibility page hosts the keyboard tour checklist.

#### No action (compatible)

- Docs + Gallery callouts; existing CommandPalette / dialog APIs unchanged.

### Upgrade 1.42 → 1.43

**Product version:** 1.43  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Use `Theme.contrastRatio` / `contrastPassesAA` when picking `customAccent` — [color-contrast.md](color-contrast.md).
- Gallery **Theme overrides** shows a live AA table.

#### No action (compatible)

- Additive Theme helpers + docs; existing branding knobs unchanged.

### Upgrade 1.41 → 1.42

**Product version:** 1.42  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Use [adaptive-layout.md](adaptive-layout.md) for TwoPaneView / ListDetailsView / Nav `auto` breakpoints.
- Prefer documented defaults (`minWideWidth: 720`, `autoCompactThreshold: 1008`).

#### No action (compatible)

- Additive docs + Gallery; existing TwoPane / ListDetails APIs unchanged.

### Upgrade 1.40 → 1.41

**Product version:** 1.41  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Prefer [drag-drop.md](drag-drop.md) for FileDropZone + FilePicker browse + CopyButton / `WindowHelper` clipboard.
- Gallery FileDropZone / CopyButton pages updated.

#### No action (compatible)

- Additive docs + Gallery; `FileDropZone` / `CopyButton` / clipboard helpers unchanged in shape.

### Upgrade 1.39 → 1.40

**Product version:** 1.40  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Action required

| Area | Change | What to do |
|------|--------|------------|
| Docs gate | Published [compatibility-1xx.md](compatibility-1xx.md) | Prefer frozen Theme / shell / stable APIs for new code; treat this doc as the 1.4x gate |

#### Optional / polish

- Link your internal “supported kit” page to compatibility-1xx + stable-api.
- Gallery **Pitfalls** page points at the freeze (no API change).

#### No action (compatible)

- No Theme token renames, no shell API removals, no stable control breaks in 1.40.

### Upgrade 1.38 → 1.39

**Product version:** 1.39

#### Optional / polish

- Apps using `NavigationView` page stacks: consider `pageCacheLimit` (default **24**) and `initialPageTransition: "none"` for cold start — [performance.md](performance.md).
- `clearPageCache()` available after long browse sessions.

#### No action (compatible)

- Existing NavigationView call sites keep working; cache limit only evicts least-recently-used **Components** (not a public type rename).

### Upgrade 1.37 → 1.38

**Product version:** 1.38

#### Optional / polish

- Linux field hosts: read [platform-linux-wayland.md](platform-linux-wayland.md) failure matrix (SSD, portal parent, SNI).

#### No action (compatible)

- Docs / Gallery System integration callouts only.

---

## When we would break (2.00 territory)

Examples that **do not** belong in a quiet 1.xx:

- Renaming `Theme.bgCard` or stable `NavigationView.openPage`
- Dropping Qt 6.5 without a named roadmap decision
- Removing a type listed as Stable on stable-api without a deprecation window

Track those under the **2.00** plan in [ROADMAP.md](../ROADMAP.md) (**after 1.90**). Draft remap table: [upgrade-notes.md](upgrade-notes.md) **Upgrade 1.90 → 2.00 (draft)** and checkpoint-190; the breaks land in **2.00**. Apps that cannot leave Qt 6.5 stay on **1.90**.

**3.00 territory (after 2.73):** Qt **6.10** floor, experimental cleanup, final Theme/shell alias removal — draft in [upgrade-notes.md](upgrade-notes.md) **Upgrade 2.73 → 3.00 (draft)** and checkpoint-300. Apps that cannot leave Qt **6.8** stay on **2.73**.
