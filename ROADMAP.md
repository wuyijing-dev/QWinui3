# QWinUI3 Roadmap

**Current:** **1.49**
**Next up:** **1.50** (Extractable Gallery shell template)
**Planned through:** **1.70** (long-horizon 1.xx checkpoint)  
**Qt:** 6.5+ (recommended 6.8 LTS) — [qt-version-compat.md](docs/qt-version-compat.md)

This plan starts from **what 1.00 already was**, then walks **small `1.xx` minors**. Stay on **1.xx for a long time**. **2.00 is not next**—only when we truly need breaking changes.

---

## Version format: `X.YY`

| Field | Meaning |
|-------|---------|
| **X** | Major line (`1` = current kit; `2` = future breaking line) |
| **YY** | Two-digit minor (`00`, `01`, … `99`) — one focused slice each |

Examples: `1.00` → `1.01` → … → `1.10` → `1.11`.

- **Tags / packages:** `v1.01`, archives `qwinui3-1.01-…`
- **CMake:** `QWINUI3_VERSION` in root `CMakeLists.txt` (maps to `major.minor.0` for CMake’s numeric VERSION)
- **No third digit** for product releases. Hotfixes either rebuild the same `X.YY` or bump `YY`.

---

## What you already have (1.00 baseline)

Do not plan as if the kit is empty. Rough inventory today:

| Surface | Rough size |
|---------|------------|
| Public controls | ~208 |
| Gallery demo pages | ~150+ |
| Style QML (Fluent chrome for Controls) | ~55 |
| Extras QML | ~150 |
| Modules | Theme · Style · Platform · Extras |
| Docs | MkDocs + generated component API |
| Ship | LGPL-3.0 · CI Release (Win + Linux) · shared/gallery packaging · Qt compat shims |

**Implication:** Near-term work is mostly **finish, fix, document, and deepen** existing surfaces—not invent a second catalog or jump to a major rewrite.

---

## How we version

| Kind | Meaning |
|------|---------|
| **Same `X.YY` rebuild** | Urgent packaging/docs/CI fixes when needed |
| **Next `X.YY`** | **One focused slice**—small enough to finish, clear enough to name |
| **`2.00`** | **Far future.** Breaking API/ABI or support-floor cuts only |

**Rules of thumb**

- One `X.YY` ≈ one primary outcome, not five themes at once.
- Avoid empty releases—but do not wait for “epic” bundles either.
- New controls only when they serve that minor’s slice; otherwise park them.
- After each ship: bump `QWINUI3_VERSION`, update this file.
- Prefer **docs + harden + Gallery recipe** over new product surfaces (pattern of 1.07–1.10).

---

## Shipped — `1.01` … `1.49`

### 1.01 — Docs & “what’s stable” (shipped)

**Shipped:** [stable-api.md](docs/stable-api.md) (stable vs experimental map), docs/Creator/packaging pointers, component docs lint clean; product version `1.01`.

### 1.02 — Accessibility (high-traffic path) (shipped)

**Shipped:** Settings toggle rows as one CheckBox focus target; NavigationView item/footer/Back names; InfoBar/Toast severity + Close keyboard; [accessibility.md](docs/accessibility.md) + Gallery Accessibility checklist; product version `1.02`.

### 1.03 — Linux shells (practical) (shipped)

**Shipped:** [platform-linux-wayland.md](docs/platform-linux-wayland.md) matrix; `WindowHelper.resolveBackdrop`; shells paint `effectiveBackdrop`; Gallery `run-gallery.sh`; product version `1.03`.

### 1.04 — Window chrome polish (Windows-first) (shipped)

**Shipped:** StandardWindow reapply / DPI hit-test; DWM on `WM_DPICHANGED`; `openDialog(owner)`; [window-chrome.md](docs/window-chrome.md); product version `1.04`.

### 1.05 — WebView2 (Windows) productize (shipped)

**Shipped:** Runtime probe + EmptyState; user-data lifecycle; focus / scroll / DPI; [webview2.md](docs/webview2.md); product version `1.05`. *(Still experimental in stable-api until a later soak slice.)*

### 1.06 — CI smoke (lightweight) (shipped)

**Shipped:** [`.github/workflows/smoke.yml`](.github/workflows/smoke.yml); `qwinui3_gallery --smoke`; [ci-smoke.md](docs/ci-smoke.md); Windows QPA coerce; product version `1.06`.

### 1.07 — DataTable / master–detail (shipped)

**Shipped:** Stable selection; keyboard; ListDetails Back/Esc; [data-collections.md](docs/data-collections.md); product version `1.07`.

### 1.08 — Forms & settings consistency (shipped)

**Shipped:** FormLayout clear/collect parity; field `errorMessage` chrome; SettingsExpander host; [forms.md](docs/forms.md); product version `1.08`.

### 1.09 — Branding & Theme overrides (shipped)

**Shipped:** [theme-overrides.md](docs/theme-overrides.md); Gallery Theme overrides; Settings custom accent; product version `1.09`.

### 1.10 — System bridge consistency (shipped)

**Shipped:** FilePicker HWND ownership; TrayIcon severity; [system-integration.md](docs/system-integration.md); promote FilePicker / TrayIcon / NotificationBridge; product version `1.10`.

### 1.11 — Charts & gauges API consistency (shipped)

**Shipped:** `interactive`/`isInteractive` and `unit`/`valueUnit` aliases; Pie/Donut `values` convenience; [charts.md](docs/charts.md); Gallery Charts hub callout; charts remain experimental; product version `1.11`.

### 1.12 — Consumer packaging & CMake docs (shipped)

**Shipped:** [packaging-consumer.md](docs/packaging-consumer.md) (Release zip / package script / `add_subdirectory`, Win+Linux runtime, minimal consumer CMake); links from README, qt-creator, examples; product version `1.12`.

### 1.13 — i18n / RTL baseline for samples (shipped)

**Shipped:** [i18n-rtl.md](docs/i18n-rtl.md); Gallery **i18n / RTL** page + Settings RTL toggle; `LayoutMirroring` on Gallery / nav-settings; `AlignLeading` on Headered* left headers; seed `translations/`; product version `1.13`.

### 1.14 — Qt 6.5 / 6.8 / 6.10 compat CI (shipped)

**Shipped:** [`.github/workflows/qt-compat.yml`](.github/workflows/qt-compat.yml) Linux Gallery Release matrix (6.5.3 / 6.8.3 / 6.10.0); [qt-version-compat.md](docs/qt-version-compat.md) CI section; smoke stays on 6.8; product version `1.14`.

### 1.15 — Command surfaces deepen (shipped)

**Shipped:** [commands.md](docs/commands.md); CommandPalette list-item Accessible names; Gallery keyboard callouts (CommandPalette / CommandBar / MenuFlyout / MenuBar); MenuBar `Action.shortcut` demo; product version `1.15`.

### 1.16 — Dialogs & flyouts consistency (shipped)

**Shipped:** [dialogs-flyouts.md](docs/dialogs-flyouts.md); ContentDialog Esc → `requestClose` / Closing cancel; Gallery **Dialogs & flyouts** chooser + page callouts; ContentDialog remains stable; product version `1.16`.

### 1.17 — Shell extras productize (shipped)

**Shipped:** [shell-extras.md](docs/shell-extras.md); promote taskbar progress/overlay, `requestUserAttention`, `revealFileInFolder`, idle inhibit (Win/Linux matrix); Gallery System integration callouts; Snap/power/recent remain experimental; product version `1.17`.

### 1.18 — WebView2 soak → stable (shipped)

**Shipped:** Soak checklist green in [webview2.md](docs/webview2.md); promote `WebView2Host` to stable; Retry force-recreate + async generation guard; Gallery callouts; product version `1.18`.

### 1.19 — Accessibility wave 2 (shipped)

**Shipped:** Wave-2 Done checklist in [accessibility.md](docs/accessibility.md); `accessibleName` on DataTable / ItemsView / ListDetailsView / FormLayout; row names + Drawer/TeachingTip polish; Gallery Accessibility page; product version `1.19`.

### 1.20 — Gallery catalog UX & smoke coverage (shipped)

**Shipped:** Curated `recentlyShipped()` + component search; page favorite star on `PageHeader`; `--smoke` loads critical pages; `smoke_catalog.py` integrity; [ci-smoke.md](docs/ci-smoke.md) coverage set; product version `1.20`.

### 1.21 — Media optional Multimedia (shipped)

**Shipped:** [media.md](docs/media.md); `MediaPlayerElement` stub when Multimedia missing (`available === false`); keyboard Space/Enter + mute; Gallery page always present; remain experimental; product version `1.21`.

### 1.22 — Animations & transitions recipe (shipped)

**Shipped:** [animations.md](docs/animations.md); Gallery **Animations** hub + reducedMotion toggles on ConnectedAnimation / Entrance / Theme transitions demos; remain experimental; product version `1.22`.

### 1.23 — Charts promote wave 2 (shipped)

**Shipped:** Promote stable subset `LineChart` / `BarChart` / `DonutChart` / `RingGauge` / `KpiTile` / `ChartCard`; [charts.md](docs/charts.md) + [stable-api.md](docs/stable-api.md); dashboard example uses only stable names; Gallery Charts hub callout; product version `1.23`.

### 1.24 — Linux persistent tray (StatusNotifierItem) (shipped)

**Shipped:** Linux `TrayIcon` registers `org.kde.StatusNotifierItem` when a session `StatusNotifierWatcher` is present (KDE Plasma reference); `supportsPersistentTray` / `persistentTrayActive` / `iconName`; ContextMenu → `trayActivated(2)` for app-owned menus; Win vs Linux matrix in [system-integration.md](docs/system-integration.md) + [platform-linux-wayland.md](docs/platform-linux-wayland.md); Gallery System Integration notes; product version `1.24`.

### 1.25 — Performance handbook (shipped)

**Shipped:** [performance.md](docs/performance.md) — virtualization, model roles, chart point budgets, Gallery heavy-page tips; `ItemsRepeater` enables `ListView.reuseItems`; DataTable Gallery callout; links from README / stable-api / docs index; product version `1.25`.

### 1.26 — Example app templates (shipped)

**Shipped:** [`examples/master-detail`](examples/master-detail/) (`ListDetailsView` LoB tickets) and [`examples/form-settings`](examples/form-settings/) (`FormLayout` + SettingsCard prefs); README / examples README / stable-api / forms / data-collections / window-chrome “start from” tables updated; product version `1.26`. Smoke CI keeps examples off for speed (default local `QWINUI3_BUILD_EXAMPLES=ON`).

### 1.27 — Navigation & TabView deepen (shipped)

**Shipped:** [navigation.md](docs/navigation.md) — pane modes, footer, Back stack, compact/overlay, TabView vs NavigationView; Gallery NavigationView / TabView callouts + `leftMinimal`/`auto`; Accessible names on demo path; [`examples/nav-settings`](examples/nav-settings/) aligned (`paneDisplayMode: auto`, TitleBar Back ↔ `navigateBack`); product version `1.27`.

### 1.28 — Input & pickers consistency (shipped)

**Shipped:** [pickers.md](docs/pickers.md) inventory; DatePicker / CalendarDatePicker / TimePicker gain `description` / `errorMessage` / `hasError` for FormLayout; forms.md pairing notes; Gallery Form validation + picker page cross-links; product version `1.28`.

### 1.29 — Icons & FluentIcons cookbook (shipped)

**Shipped:** [icons.md](docs/icons.md) — FluentIcons API, size ramp, Theme colors, a11y; `FontIcon` no longer names with raw PUA glyph; `CaptionButton` defaults for Chrome* glyphs; Gallery Iconography callout + tile names; product version `1.29`.

### 1.30 — Density, typography & responsive shells (shipped)

**Shipped:** [density.md](docs/density.md) — density/uiScale token table, fixed type scale, NavigationView `auto` / ListDetailsView narrow recipe; Theme overrides Gallery live metrics + uiScale; Settings density note; theme-overrides + navigation cross-links; product version `1.30`.

### 1.31 — Graphics & backend notes (shipped)

**Shipped:** [graphics-backend.md](docs/graphics-backend.md) — per-OS ship table, alpha/backdrop caveats, Settings / `--rhi` / `QSG_RHI_BACKEND` restart story, consumer `Compat::Rhi::apply`; Gallery Settings callout; README pointer; Windows default stays OpenGL; product version `1.31`.

### 1.32 — Window shells matrix refresh (shipped)

**Shipped:** [window-shells.md](docs/window-shells.md) / [window-chrome.md](docs/window-chrome.md) Win+Linux soak matrix; `geometryPersistenceKey` + multi-monitor clamp recipe in [window-helper.md](docs/window-helper.md); Bootstrap note in Linux docs; Gallery Window shells page + catalog aligned; product version `1.32`.

### 1.33 — Tree & hierarchical data (shipped)

**Shipped:** [tree-data.md](docs/tree-data.md) — TreeView vs ItemsView sections, keyboard ←/→, selection + MenuFlyout recipe; Fluent `TreeViewDelegate` Accessible name/description (expand + level); Gallery TreeView recipe end-to-end + basics page; data-collections cross-link; product version `1.33`.

### 1.34 — Feedback surfaces wave 2 (shipped)

**Shipped:** [feedback.md](docs/feedback.md) — when-to-use matrix, severity, ToastHost pending queue vs InfoBarHost maxVisible, TeachingTip focus return to target, progress vs toast; Gallery callouts (InfoBar / Host / ToastHost / TeachingTip / ProgressBar / InfoTeaching recipe); dialogs-flyouts cross-link; product version `1.34`.

### 1.35 — Creator kit polish (shipped)

**Shipped:** [qt-creator.md](docs/qt-creator.md) — Gallery + example open paths, Win/Linux kit checklists, no `.pro` callout; `CMakePresets.json` `examples` / `example-*` build presets; examples README + nav-settings Creator pointers; packaging-consumer / README cross-links; product version `1.35`.

### 1.36 — Docs site IA (shipped)

**Shipped:** [recipes.md](docs/recipes.md) hub; MkDocs nav regrouped under Recipes (Getting started / shells / data / feedback / platform / quality); slim docs home + README Documentation table (≤2 clicks to recipes); `webview2-future.md` kept as legacy redirect; stable-api cross-link; product version `1.36`.

### 1.37 — Experimental promote sweep (shipped)

**Shipped:** Explicit promote batch (commands, Flyout/Drawer, TabView, ShellWindow/Blank/MenuStatus, pickers, progress, FontIcon/InfoBadge, ItemsRepeater) + defer/won’t-promote list in [stable-api.md](docs/stable-api.md); Gallery catalog + chooser/page badges; recipes hub pointer; product version `1.37`.

### 1.38 — Linux Wayland edge cases (shipped)

**Shipped:** [platform-linux-wayland.md](docs/platform-linux-wayland.md) field failure matrix (SSD, Solid backdrop, portal parent_window, SNI/GNOME tray, XWayland traps, idle/taskbar no-ops); Gallery System integration Linux callout + live SSD/portal/SNI readout; system-integration / window-chrome / ci-smoke / recipes cross-links; product version `1.38`.

### 1.39 — Gallery perf & startup (shipped)

**Shipped:** NavigationView `pageCacheLimit` / LRU / `clearPageCache` / `initialPageTransition`; Gallery Home MultiEffect defer; `--startup-log` + timed `--smoke`; [performance.md](docs/performance.md) cold-start budget; Settings page-cache card; smoke critical list sync; product version `1.39`.

### 1.40 — Compatibility freeze prep (shipped)

**Shipped:** [compatibility-1xx.md](docs/compatibility-1xx.md) will-not-break contract (Theme tokens, shell APIs, stable controls) + gate checklist for 1.41+; [upgrade-notes.md](docs/upgrade-notes.md) consumer template + recent minors; stable-api / recipes / MkDocs / README / Gallery Pitfalls pointers; product version `1.40`.

### 1.41 — Drag-drop & clipboard recipes (shipped)

**Shipped:** [drag-drop.md](docs/drag-drop.md) — FileDropZone + FilePicker browse + CopyButton / WindowHelper clipboard (Win/Linux notes); Gallery FileDropZone / CopyButton pages; stable-api / system-integration / recipes / MkDocs links; product version `1.41`.

### 1.42 — TwoPaneView & adaptive layout (shipped)

**Shipped:** [adaptive-layout.md](docs/adaptive-layout.md) breakpoint cheat sheet (Nav 1008 / TwoPane+ListDetails 720); Gallery TwoPaneView / ListDetailsView polish; density / navigation / data-collections cross-links; `TwoPaneView` on stable-api; product version `1.42`.

### 1.43 — Color, contrast & theme diagnostics (shipped)

**Shipped:** [color-contrast.md](docs/color-contrast.md) AA guidance; `Theme.relativeLuminance` / `contrastRatio` / `contrastPassesAA` / `accentContrastRatio`; Gallery Theme overrides live AA table; Accessibility / theme-overrides cross-links; product version `1.43`.

### 1.44 — Keyboard-first app cookbook (shipped)

**Shipped:** [keyboard.md](docs/keyboard.md) end-to-end chords → CommandPalette → dialogs → lists → focus; Gallery Accessibility keyboard tour + CommandPalette pointers; commands / accessibility / recipes / MkDocs links; product version `1.44`.

### 1.45 — Localization packs deepen (shipped)

**Shipped:** Expanded [i18n-rtl.md](docs/i18n-rtl.md) lupdate/lrelease / `--lang` / RTL regression checklist; `zh_CN` seed catalog; `scripts/check_gallery_translations.py` in smoke; Gallery i18n page + translations README; product version `1.45`.

### 1.46 — Shared library redistribute polish (shipped)

**Shipped:** Extended [packaging-consumer.md](docs/packaging-consumer.md) shared vs static matrix, windeploy/linuxdeploy, strip-restricted modules; `scripts/check_shared_package.py` in smoke; MSVC `CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS` for shared; package QML collect keeps Theme/Platform siblings; product version `1.46`.

### 1.47 — Snap layouts & windowing extras (shipped)

**Shipped:** Refreshed [shell-extras.md](docs/shell-extras.md) Snap Layouts toggle UX, taskbar / attention / reveal recipes, honest Linux n/a matrix; Gallery System integration demos (Snap · taskbar · flash continuous); window-helper / system-integration cross-links; product version `1.47`.

### 1.48 — Modal stack & ContentDialogQueue deepen (shipped)

**Shipped:** Extended [dialogs-flyouts.md](docs/dialogs-flyouts.md) FIFO / owner Overlay / Esc recipes; fixed `replaceCurrent` not pumping pending; Gallery ContentDialog A→B→C stress + Dialogs & flyouts pointers; product version `1.48`.

### 1.49 — Icon micro-animations (shipped)

**Shipped:** `FontIcon` / `IconicButton` hover lift + press squash (`microMotionEnabled`, `hoverScale`, `pressScale`); aligned `IconButton` / `AppBarButton` / `AppBarToggleButton`; honors `Theme.reducedMotion`; Gallery Iconography + IconButton + AppBarButton demos; [icons.md](docs/icons.md) + [animations.md](docs/animations.md) pointer; product version `1.49`.

---

## Horizon — planned `1.50` … `1.70`

Still **1.xx**. Aim for maturity of the 1.line—not a soft 2.00. One theme per `YY`. Order can flex if field P0s force a swap; do not merge themes into mega-minors.

### 1.50 — Extractable Gallery shell template

**Why:** Integrators copy Gallery chrome; make a thin “app shell” example from proven Gallery patterns.

**In scope**

- Small example: NavigationWindow + settings + one content page, Bootstrap main, persistence key.
- README “start from Gallery shell” row; keep it smaller than Gallery itself.

**Out of scope**

- Splitting Gallery into a multi-crate monorepo; removing Gallery.

**Exit criteria**

- Example builds in Release; docs say what to delete vs keep.

---

### 1.51 — 1.xx maturity checkpoint

**Why:** Cap the first post-1.40 arc with a deliberate “where we are” release—not 2.00.

**In scope**

- Audit stable-api vs Gallery; refresh ROADMAP shipped vs deferred; compatibility doc (1.40) revisited.
- Fix P0 doc/link rot; optional “LTS-style” note: prefer harden over new surfaces for a while.

**Out of scope**

- Declaring 2.00; freezing all experimental forever.

**Exit criteria**

- Published checkpoint notes in ROADMAP/README; continue through planned `1.52`…`1.70` (or pause explicitly).

---

### 1.52 — Field polish buffer

**Why:** After the checkpoint, keep one named slot for regressions and small harden passes without inventing a new product surface.

**In scope**

- Portal / DPI / tray / WebView2 / packaging field fixes reported after 1.51.
- Doc/link rot and Gallery recipe gaps only when cheap.

**Out of scope**

- New control families; AnimatedIcon/Lottie productization; starting 2.00.

**Exit criteria**

- At least one shipped harden notes block (or explicitly “no field P0 — skip / defer”).

---

### 1.53 — Thin AnimatedIcon path

**Why:** After 1.49 micro-motion, some chrome needs play-on-state glyphs without adopting a full Lottie product.

**In scope**

- Optional thin `AnimatedIcon`-style wrapper (or documented recipe) over existing glyph/scale transitions; 2–3 Gallery state demos (e.g. play/pause, expand/collapse).
- Docs in [icons.md](docs/icons.md) / [animations.md](docs/animations.md); honor reduced motion.

**Out of scope**

- Shipping a Lottie runtime as a hard dependency; full WinUI AnimatedIcon visual tree parity.

**Exit criteria**

- One documented path + Gallery demos; honest “not Lottie” callout.

---

### 1.54 — Extra locale pack

**Why:** 1.45 proved the workflow; one more seed locale keeps i18n from rotting.

**In scope**

- One additional Gallery seed locale (pick by demand: e.g. `ja_JP` or `de_DE`) + lupdate/lrelease notes in [i18n-rtl.md](docs/i18n-rtl.md).
- Smoke translation check extended; Gallery language switcher coverage.

**Out of scope**

- Full professional translation of every string; community translation portal.

**Exit criteria**

- Second locale builds/loads via `--lang`; checklist green in smoke or docs.

---

### 1.55 — TeachingTip & onboarding coach marks

**Why:** Feedback wave (1.34) covered hosts; first-run coach paths still need a cookbook.

**In scope**

- Recipes for sequenced TeachingTips, focus return, “don’t show again” persistence; Gallery onboarding demo.
- Extend [feedback.md](docs/feedback.md) (+ keyboard/a11y cross-links).

**Out of scope**

- A separate product “tour” framework; forced Spotlight overlays as a new control family.

**Exit criteria**

- End-to-end Gallery recipe + docs when-to-use vs Toast/InfoBar.

---

### 1.56 — Multi-window & secondary shells

**Why:** Integrators open settings/preview windows; shell docs are still single-window-first.

**In scope**

- Recipes for secondary `StandardWindow` / dialog-owner HWND, shared Theme, geometry persistence keys.
- Gallery or small example: main + tool window; [window-shells.md](docs/window-shells.md) / [window-helper.md](docs/window-helper.md) updates.

**Out of scope**

- Full MDI framework; macOS Spaces integration.

**Exit criteria**

- Documented Win+Linux notes; at least one runnable sample path.

---

### 1.57 — Touch, pen & pointer recipes

**Why:** Gallery and LoB apps need honest touch targets and pen notes without a new input stack.

**In scope**

- Density/touch target guidance; scroll/drag vs click; optional stylus hover notes where Qt exposes them.
- Gallery touch checklist page section; [density.md](docs/density.md) / [accessibility.md](docs/accessibility.md) pointers.

**Out of scope**

- Custom ink canvas product; handwriting recognition.

**Exit criteria**

- Published touch cookbook + Gallery callouts on high-traffic controls.

---

### 1.58 — High-DPI & multi-monitor matrix (wave 2)

**Why:** 1.32 / 1.04 covered shells; field still hits mixed-DPI restore and per-monitor quirks.

**In scope**

- Refresh Win+Linux DPI matrix; geometry clamp / reopen recipes; Gallery DPI readout polish.
- Cross-link [window-chrome.md](docs/window-chrome.md), [graphics-backend.md](docs/graphics-backend.md).

**Out of scope**

- Per-monitor awareness rewrite of the Qt platform plugin.

**Exit criteria**

- Matrix + at least one fixed or documented P0 restore path.

---

### 1.59 — In-app search & AutoSuggest recipes

**Why:** CommandPalette (1.15/1.44) covers chords; content filter / suggest patterns need a home.

**In scope**

- Recipes for AutoSuggestBox / filtered Lists / catalog search patterns; Gallery demo page deepen.
- Docs under recipes + [commands.md](docs/commands.md) / navigation cross-links.

**Out of scope**

- Full-text search engine; cloud search backends.

**Exit criteria**

- Cookbook + Gallery interactive filter/suggest demo.

---

### 1.60 — Mid-horizon checkpoint

**Why:** Halfway through the 1.49–1.70 plan—audit before the second half.

**In scope**

- Re-audit stable-api, experimental defer list, doc link rot; trim parking lot.
- Short “still 1.xx” note in README/ROADMAP; optional smoke coverage bump.

**Out of scope**

- Starting 2.00; mass new controls.

**Exit criteria**

- Checkpoint notes published; 1.61+ plan confirmed or reordered.

---

### 1.61 — CMake package / find_package sketch

**Why:** 1.12/1.46 cover zips and `add_subdirectory`; some consumers want a sketch `find_package` story.

**In scope**

- Optional install + `QWinUI3Config.cmake` sketch (or documented experimental layout); consumer CMake snippet in [packaging-consumer.md](docs/packaging-consumer.md).
- Honest “not an official vcpkg/Conan port” banner.

**Out of scope**

- Maintaining official vcpkg/Conan ports as supported products.

**Exit criteria**

- One documented install → `find_package` path that builds a tiny consumer in Release.

---

### 1.62 — Gallery visual smoke (subset)

**Why:** `--smoke` loads pages; a small golden-frame set catches theme/chrome regressions earlier.

**In scope**

- Subset of Gallery pages (Home + few chrome/control pages) screenshot or hash smoke; docs in [ci-smoke.md](docs/ci-smoke.md).
- Opt-in CI job or local script; keep default smoke fast.

**Out of scope**

- Pixel diffs for every Gallery page; flaky full-catalog visual CI.

**Exit criteria**

- Subset script documented; runs locally (CI optional).

---

### 1.63 — Print, share & export recipes

**Why:** LoB apps need “send this view somewhere” without a print subsystem rewrite.

**In scope**

- Recipes: `QPrinter` / grab-to-image / share file via reveal/picker; Gallery or docs-only sample.
- Cross-link system-integration / drag-drop.

**Out of scope**

- Built-in PDF engine product; cloud share providers.

**Exit criteria**

- Published recipe with Win+Linux caveats.

---

### 1.64 — Security & trust boundaries

**Why:** WebView2, FileDropZone, and pickers need a single “what we promise / what apps must do” page.

**In scope**

- Trust boundary doc: navigation allowlists, user-data dirs, drop validation, picker ownership.
- Gallery Pitfalls / WebView2 callouts; links from [webview2.md](docs/webview2.md) / [drag-drop.md](docs/drag-drop.md).

**Out of scope**

- Claiming a hardened sandbox product; rewriting WebView2 host.

**Exit criteria**

- One security cookbook page + Gallery pointers.

---

### 1.65 — Settings persistence & roaming recipes

**Why:** Geometry keys exist; app settings sync patterns are still ad hoc.

**In scope**

- Cookbook for `QSettings` / JSON prefs, per-user vs portable, migration keys; example alignment with form-settings.
- Docs + Gallery Settings persistence callout.

**Out of scope**

- Cloud roaming service; encrypted vault product.

**Exit criteria**

- Recipe + at least one example or Gallery path using the pattern.

---

### 1.66 — Charts & dashboard polish (wave 3)

**Why:** 1.23 promoted a stable subset; remaining chart surfaces and dashboard recipes still need a harden pass.

**In scope**

- Polish leftover experimental charts or document defer; dashboard example / Gallery hub refresh.
- Update [charts.md](docs/charts.md) + stable-api notes.

**Out of scope**

- New chart engines / WebGL; replacing Qt Graphs wholesale.

**Exit criteria**

- Clear stable vs deferred chart list; Gallery hub matches docs.

---

### 1.67 — Media soak or honest defer

**Why:** 1.21 left Multimedia optional/experimental; decide promote vs stay experimental with a soak checklist.

**In scope**

- Soak checklist in [media.md](docs/media.md); either promote a thin stable subset or explicitly defer with reasons.
- Gallery Media page aligned.

**Out of scope**

- New codecs; streaming CDN integration.

**Exit criteria**

- Published promote-or-defer decision + Gallery callout.

---

### 1.68 — Linux portal & file-dialog harden

**Why:** 1.38 covered Wayland edges; portal parent_window / FilePicker still generate field bugs.

**In scope**

- Portal ownership matrix refresh; FilePicker / folder reveal harden; Gallery Linux system-integration live checks.
- Update [platform-linux-wayland.md](docs/platform-linux-wayland.md) / [system-integration.md](docs/system-integration.md).

**Out of scope**

- Implementing a full xdg-desktop-portal compositor.

**Exit criteria**

- Matrix + at least one fixed or documented P0 portal path.

---

### 1.69 — Accessibility wave 3

**Why:** Waves 1–2 covered names and high-traffic paths; live regions / focus restore / dialog stacks need another pass.

**In scope**

- Focus return audits (dialogs, TeachingTip, drawers); live-region guidance; Gallery Accessibility checklist wave 3.
- Extend [accessibility.md](docs/accessibility.md) / [keyboard.md](docs/keyboard.md).

**Out of scope**

- Automated full-catalog a11y CI as a hard gate.

**Exit criteria**

- Wave-3 Done checklist published; Gallery page updated.

---

### 1.70 — Long-horizon 1.xx checkpoint

**Why:** Close the planned `1.49`…`1.70` arc with a deliberate “where we are”—still not 2.00.

**In scope**

- Full stable-api vs Gallery audit; ROADMAP shipped/deferred refresh; compatibility-1xx revisit.
- Publish “prefer field harden / pause vs new surfaces” guidance; open `1.71+` only for field-driven slices or park.

**Out of scope**

- Declaring 2.00; freezing experimental forever.

**Exit criteria**

- Checkpoint notes in ROADMAP/README; explicit next posture (continue 1.xx / pause / draft 2.00 criteria only).

---

## After `1.70`

Still **1.xx** if field needs dictate (`1.71`…)—or pause on polish. **Do not** treat 1.70 as permission to start **2.00**.

Unscheduled follow-ups (pick only inside a named minor):

| Candidate | Notes |
|-----------|-------|
| **1.71+ field fixes** | Portal / DPI / tray / WebView2 / packaging regressions |
| **More locale packs** | Only if 1.45/1.54 workflow stays cheap |
| **Deeper Lottie / AnimatedIcon** | Only if 1.53 thin path proves valuable |
| **Official vcpkg/Conan ports** | Beyond the 1.61 sketch—product promise only if owned |
| **macOS first-class** | Remains parking-lot until deliberately scheduled |

Order remains flexible; do not bundle into mega-minors.

---

## Far future — 2.00 (not scheduled)

**Do not start 2.00 work while 1.xx still absorbs polish.**

Consider 2.00 only if several of these become true:

- Need breaking Theme/API renames that cannot stay compatible in 1.xx  
- Need a new packaging/ABI contract that breaks 1.xx consumers  
- Need to drop an old Qt floor or OS policy in a breaking way  

Until then: **stay on 1.xx**, bump `YY` for each slice. Prefer finishing through **1.70** (long-horizon checkpoint) before even drafting 2.00 scope.

---

## Parking lot

Unscheduled; pick up only inside a named `1.xx` minor (or never):

- macOS first-class  
- Figma / design-token pipeline  
- Full Fluent visual redesign / Fluent 2 Style fork  
- Screenshot diffs for **every** Gallery page (subset may ship in 1.62)  
- Community translation portal / every-locale coverage  
- Full Lottie runtime as a hard product dependency (thin path planned in 1.53)  
- New chart engines / WebGL  
- Official vcpkg/Conan ports as supported products (sketch may ship in 1.61)  
- Custom ink / handwriting canvas  
- Cloud settings roaming / share backends 

---

## Related

| Doc | Role |
|-----|------|
| [README.md](README.md) | Overview |
| [docs/stable-api.md](docs/stable-api.md) | Stable vs experimental |
| [docs/components.md](docs/components.md) | Control index |
| [docs/conventions.md](docs/conventions.md) | A11y / QML rules |
| [docs/qt-version-compat.md](docs/qt-version-compat.md) | Qt multi-version shims |
| [docs/roadmap.md](docs/roadmap.md) | Site copy of this plan |
