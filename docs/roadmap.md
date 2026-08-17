# QWinUI3 Roadmap

**Current:** **1.92** (master; last tagged **1.90** until next release)
**Next up:** **2.00** — breaking baseline (Qt floor / freeze lift / documented remaps). **Gate: 1.90 shipped; 1.91…1.92 are post-close-out polish.**
**Planned through:** **2.50** (… → **2.00** break → **2.01…2.50** horizon; **Windows + Linux** only)
**1.xx close-out:** [checkpoint-190.md](checkpoint-190.md). **1.86…1.89** performance arc **signed off** (**animations stay**). OSK/packaging promote **2.01**. **2.50** closes the **2.xx** horizon (checkpoint draft only).  
**Qt:** 6.5+ (recommended 6.8 LTS) through **1.92** — [qt-version-compat.md](qt-version-compat.md). **2.00** raises the floor to **6.8 LTS**. **Platforms:** **Windows + Linux** — no macOS first-class line.

This plan starts from **what 1.00 already was**, walks **small `1.xx` minors** through **1.90 close-out**, adds **post-close-out 1.91…1.92**, then a named **2.00** breaking line and **2.01…2.50** follow-ups (including **new controls** where each slice names a WinUI gap).

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

**Implication:** Through **1.90**, work was mostly **finish, fix, document, and deepen**. From **2.00** onward, named minors may also ship **new controls** (one WinUI gap per slice — Gallery page + component doc + stable/experimental row in the same tag).

---

## How we version

| Kind | Meaning |
|------|---------|
| **Same `X.YY` rebuild** | Urgent packaging/docs/CI fixes when needed |
| **Next `X.YY`** | **One focused slice**—small enough to finish, clear enough to name |
| **`2.00`** | Breaking line (Qt floor / freeze lift / documented remaps). **After 1.90 only.** |
| **`2.01…2.50`** | Non-breaking minors on the **2.x** floor; **new controls OK** when the slice theme is a single named gap |

**Rules of thumb**

- One `X.YY` ≈ one primary outcome, not five themes at once.
- Avoid empty releases—but do not wait for “epic” bundles either.
- **1.xx:** new controls only when they serve that minor’s slice; otherwise park them.
- **2.xx:** a slice may **add controls** if the tag names one WinUI gap (e.g. FileTree, TreeDataGrid) plus Gallery + docs + stable-api row.
- After each ship: bump `QWINUI3_VERSION`, update this file.
- Prefer **docs + harden + Gallery recipe** for polish slices; use **control slices** for catalog gaps.
- **2.00** is one breaking slice, not a dump of the parking lot. Follow-ups are `2.01+`.
- **Platforms:** **Windows + Linux** ship targets — **macOS first-class is not planned** (Qt macOS apps may still link the kit; no dedicated shell/tray/CI matrix).

---

## Shipped — `1.01` … `1.68`

### 1.01 — Docs & “what’s stable” (shipped)

**Shipped:** [stable-api.md](stable-api.md) (stable vs experimental map), docs/Creator/packaging pointers, component docs lint clean; product version `1.01`.

### 1.02 — Accessibility (high-traffic path) (shipped)

**Shipped:** Settings toggle rows as one CheckBox focus target; NavigationView item/footer/Back names; InfoBar/Toast severity + Close keyboard; [accessibility.md](accessibility.md) + Gallery Accessibility checklist; product version `1.02`.

### 1.03 — Linux shells (practical) (shipped)

**Shipped:** [platform-linux-wayland.md](platform-linux-wayland.md) matrix; `WindowHelper.resolveBackdrop`; shells paint `effectiveBackdrop`; Gallery `run-gallery.sh`; product version `1.03`.

### 1.04 — Window chrome polish (Windows-first) (shipped)

**Shipped:** StandardWindow reapply / DPI hit-test; DWM on `WM_DPICHANGED`; `openDialog(owner)`; [window-chrome.md](window-chrome.md); product version `1.04`.

### 1.05 — WebView2 (Windows) productize (shipped)

**Shipped:** Runtime probe + EmptyState; user-data lifecycle; focus / scroll / DPI; [webview2.md](webview2.md); product version `1.05`. *(Still experimental in stable-api until a later soak slice.)*

### 1.06 — CI smoke (lightweight) (shipped)

**Shipped:** [`.github/workflows/smoke.yml`](.github/workflows/smoke.yml); `qwinui3_gallery --smoke`; [ci-smoke.md](ci-smoke.md); Windows QPA coerce; product version `1.06`.

### 1.07 — DataTable / master–detail (shipped)

**Shipped:** Stable selection; keyboard; ListDetails Back/Esc; [data-collections.md](data-collections.md); product version `1.07`.

### 1.08 — Forms & settings consistency (shipped)

**Shipped:** FormLayout clear/collect parity; field `errorMessage` chrome; SettingsExpander host; [forms.md](forms.md); product version `1.08`.

### 1.09 — Branding & Theme overrides (shipped)

**Shipped:** [theme-overrides.md](theme-overrides.md); Gallery Theme overrides; Settings custom accent; product version `1.09`.

### 1.10 — System bridge consistency (shipped)

**Shipped:** FilePicker HWND ownership; TrayIcon severity; [system-integration.md](system-integration.md); promote FilePicker / TrayIcon / NotificationBridge; product version `1.10`.

### 1.11 — Charts & gauges API consistency (shipped)

**Shipped:** `interactive`/`isInteractive` and `unit`/`valueUnit` aliases; Pie/Donut `values` convenience; [charts.md](charts.md); Gallery Charts hub callout; charts remain experimental; product version `1.11`.

### 1.12 — Consumer packaging & CMake docs (shipped)

**Shipped:** [packaging-consumer.md](packaging-consumer.md) (Release zip / package script / `add_subdirectory`, Win+Linux runtime, minimal consumer CMake); links from README, qt-creator, examples; product version `1.12`.

### 1.13 — i18n / RTL baseline for samples (shipped)

**Shipped:** [i18n-rtl.md](i18n-rtl.md); Gallery **i18n / RTL** page + Settings RTL toggle; `LayoutMirroring` on Gallery / nav-settings; `AlignLeading` on Headered* left headers; seed `translations/`; product version `1.13`.

### 1.14 — Qt 6.5 / 6.8 / 6.10 compat CI (shipped)

**Shipped:** [`.github/workflows/qt-compat.yml`](.github/workflows/qt-compat.yml) Linux Gallery Release matrix (6.5.3 / 6.8.3 / 6.10.0); [qt-version-compat.md](qt-version-compat.md) CI section; smoke stays on 6.8; product version `1.14`.

### 1.15 — Command surfaces deepen (shipped)

**Shipped:** [commands.md](commands.md); CommandPalette list-item Accessible names; Gallery keyboard callouts (CommandPalette / CommandBar / MenuFlyout / MenuBar); MenuBar `Action.shortcut` demo; product version `1.15`.

### 1.16 — Dialogs & flyouts consistency (shipped)

**Shipped:** [dialogs-flyouts.md](dialogs-flyouts.md); ContentDialog Esc → `requestClose` / Closing cancel; Gallery **Dialogs & flyouts** chooser + page callouts; ContentDialog remains stable; product version `1.16`.

### 1.17 — Shell extras productize (shipped)

**Shipped:** [shell-extras.md](shell-extras.md); promote taskbar progress/overlay, `requestUserAttention`, `revealFileInFolder`, idle inhibit (Win/Linux matrix); Gallery System integration callouts; Snap/power/recent remain experimental; product version `1.17`.

### 1.18 — WebView2 soak → stable (shipped)

**Shipped:** Soak checklist green in [webview2.md](webview2.md); promote `WebView2Host` to stable; Retry force-recreate + async generation guard; Gallery callouts; product version `1.18`.

### 1.19 — Accessibility wave 2 (shipped)

**Shipped:** Wave-2 Done checklist in [accessibility.md](accessibility.md); `accessibleName` on DataTable / ItemsView / ListDetailsView / FormLayout; row names + Drawer/TeachingTip polish; Gallery Accessibility page; product version `1.19`.

### 1.20 — Gallery catalog UX & smoke coverage (shipped)

**Shipped:** Curated `recentlyShipped()` + component search; page favorite star on `PageHeader`; `--smoke` loads critical pages; `smoke_catalog.py` integrity; [ci-smoke.md](ci-smoke.md) coverage set; product version `1.20`.

### 1.21 — Media optional Multimedia (shipped)

**Shipped:** [media.md](media.md); `MediaPlayerElement` stub when Multimedia missing (`available === false`); keyboard Space/Enter + mute; Gallery page always present; remain experimental; product version `1.21`.

### 1.22 — Animations & transitions recipe (shipped)

**Shipped:** [animations.md](animations.md); Gallery **Animations** hub + reducedMotion toggles on ConnectedAnimation / Entrance / Theme transitions demos; remain experimental; product version `1.22`.

### 1.23 — Charts promote wave 2 (shipped)

**Shipped:** Promote stable subset `LineChart` / `BarChart` / `DonutChart` / `RingGauge` / `KpiTile` / `ChartCard`; [charts.md](charts.md) + [stable-api.md](stable-api.md); dashboard example uses only stable names; Gallery Charts hub callout; product version `1.23`.

### 1.24 — Linux persistent tray (StatusNotifierItem) (shipped)

**Shipped:** Linux `TrayIcon` registers `org.kde.StatusNotifierItem` when a session `StatusNotifierWatcher` is present (KDE Plasma reference); `supportsPersistentTray` / `persistentTrayActive` / `iconName`; ContextMenu → `trayActivated(2)` for app-owned menus; Win vs Linux matrix in [system-integration.md](system-integration.md) + [platform-linux-wayland.md](platform-linux-wayland.md); Gallery System Integration notes; product version `1.24`.

### 1.25 — Performance handbook (shipped)

**Shipped:** [performance.md](performance.md) — virtualization, model roles, chart point budgets, Gallery heavy-page tips; `ItemsRepeater` enables `ListView.reuseItems`; DataTable Gallery callout; links from README / stable-api / docs index; product version `1.25`.

### 1.26 — Example app templates (shipped)

**Shipped:** [`examples/master-detail`](../examples/master-detail/) (`ListDetailsView` LoB tickets) and [`examples/form-settings`](../examples/form-settings/) (`FormLayout` + SettingsCard prefs); README / examples README / stable-api / forms / data-collections / window-chrome “start from” tables updated; product version `1.26`. Smoke CI keeps examples off for speed (default local `QWINUI3_BUILD_EXAMPLES=ON`).

### 1.27 — Navigation & TabView deepen (shipped)

**Shipped:** [navigation.md](navigation.md) — pane modes, footer, Back stack, compact/overlay, TabView vs NavigationView; Gallery NavigationView / TabView callouts + `leftMinimal`/`auto`; Accessible names on demo path; [`examples/nav-settings`](../examples/nav-settings/) aligned (`paneDisplayMode: auto`, TitleBar Back ↔ `navigateBack`); product version `1.27`.

### 1.28 — Input & pickers consistency (shipped)

**Shipped:** [pickers.md](pickers.md) inventory; DatePicker / CalendarDatePicker / TimePicker gain `description` / `errorMessage` / `hasError` for FormLayout; forms.md pairing notes; Gallery Form validation + picker page cross-links; product version `1.28`.

### 1.29 — Icons & FluentIcons cookbook (shipped)

**Shipped:** [icons.md](icons.md) — FluentIcons API, size ramp, Theme colors, a11y; `FontIcon` no longer names with raw PUA glyph; `CaptionButton` defaults for Chrome* glyphs; Gallery Iconography callout + tile names; product version `1.29`.

### 1.30 — Density, typography & responsive shells (shipped)

**Shipped:** [density.md](density.md) — density/uiScale token table, fixed type scale, NavigationView `auto` / ListDetailsView narrow recipe; Theme overrides Gallery live metrics + uiScale; Settings density note; theme-overrides + navigation cross-links; product version `1.30`.

### 1.31 — Graphics & backend notes (shipped)

**Shipped:** [graphics-backend.md](graphics-backend.md) — per-OS ship table, alpha/backdrop caveats, Settings / `--rhi` / `QSG_RHI_BACKEND` restart story, consumer `Compat::Rhi::apply`; Gallery Settings callout; README pointer; Windows default stays OpenGL; product version `1.31`.

### 1.32 — Window shells matrix refresh (shipped)

**Shipped:** [window-shells.md](window-shells.md) / [window-chrome.md](window-chrome.md) Win+Linux soak matrix; `geometryPersistenceKey` + multi-monitor clamp recipe in [window-helper.md](window-helper.md); Bootstrap note in Linux docs; Gallery Window shells page + catalog aligned; product version `1.32`.

### 1.33 — Tree & hierarchical data (shipped)

**Shipped:** [tree-data.md](tree-data.md) — TreeView vs ItemsView sections, keyboard ←/→, selection + MenuFlyout recipe; Fluent `TreeViewDelegate` Accessible name/description (expand + level); Gallery TreeView recipe end-to-end + basics page; data-collections cross-link; product version `1.33`.

### 1.34 — Feedback surfaces wave 2 (shipped)

**Shipped:** [feedback.md](feedback.md) — when-to-use matrix, severity, ToastHost pending queue vs InfoBarHost maxVisible, TeachingTip focus return to target, progress vs toast; Gallery callouts (InfoBar / Host / ToastHost / TeachingTip / ProgressBar / InfoTeaching recipe); dialogs-flyouts cross-link; product version `1.34`.

### 1.35 — Creator kit polish (shipped)

**Shipped:** [qt-creator.md](qt-creator.md) — Gallery + example open paths, Win/Linux kit checklists, no `.pro` callout; `CMakePresets.json` `examples` / `example-*` build presets; examples README + nav-settings Creator pointers; packaging-consumer / README cross-links; product version `1.35`.

### 1.36 — Docs site IA (shipped)

**Shipped:** [recipes.md](recipes.md) hub; MkDocs nav regrouped under Recipes (Getting started / shells / data / feedback / platform / quality); slim docs home + README Documentation table (≤2 clicks to recipes); `webview2-future.md` kept as legacy redirect; stable-api cross-link; product version `1.36`.

### 1.37 — Experimental promote sweep (shipped)

**Shipped:** Explicit promote batch (commands, Flyout/Drawer, TabView, ShellWindow/Blank/MenuStatus, pickers, progress, FontIcon/InfoBadge, ItemsRepeater) + defer/won’t-promote list in [stable-api.md](stable-api.md); Gallery catalog + chooser/page badges; recipes hub pointer; product version `1.37`.

### 1.38 — Linux Wayland edge cases (shipped)

**Shipped:** [platform-linux-wayland.md](platform-linux-wayland.md) field failure matrix (SSD, Solid backdrop, portal parent_window, SNI/GNOME tray, XWayland traps, idle/taskbar no-ops); Gallery System integration Linux callout + live SSD/portal/SNI readout; system-integration / window-chrome / ci-smoke / recipes cross-links; product version `1.38`.

### 1.39 — Gallery perf & startup (shipped)

**Shipped:** NavigationView `pageCacheLimit` / LRU / `clearPageCache` / `initialPageTransition`; Gallery Home MultiEffect defer; `--startup-log` + timed `--smoke`; [performance.md](performance.md) cold-start budget; Settings page-cache card; smoke critical list sync; product version `1.39`.

### 1.40 — Compatibility freeze prep (shipped)

**Shipped:** [compatibility-1xx.md](compatibility-1xx.md) will-not-break contract (Theme tokens, shell APIs, stable controls) + gate checklist for 1.41+; [upgrade-notes.md](upgrade-notes.md) consumer template + recent minors; stable-api / recipes / MkDocs / README / Gallery Pitfalls pointers; product version `1.40`.

### 1.41 — Drag-drop & clipboard recipes (shipped)

**Shipped:** [drag-drop.md](drag-drop.md) — FileDropZone + FilePicker browse + CopyButton / WindowHelper clipboard (Win/Linux notes); Gallery FileDropZone / CopyButton pages; stable-api / system-integration / recipes / MkDocs links; product version `1.41`.

### 1.42 — TwoPaneView & adaptive layout (shipped)

**Shipped:** [adaptive-layout.md](adaptive-layout.md) breakpoint cheat sheet (Nav 1008 / TwoPane+ListDetails 720); Gallery TwoPaneView / ListDetailsView polish; density / navigation / data-collections cross-links; `TwoPaneView` on stable-api; product version `1.42`.

### 1.43 — Color, contrast & theme diagnostics (shipped)

**Shipped:** [color-contrast.md](color-contrast.md) AA guidance; `Theme.relativeLuminance` / `contrastRatio` / `contrastPassesAA` / `accentContrastRatio`; Gallery Theme overrides live AA table; Accessibility / theme-overrides cross-links; product version `1.43`.

### 1.44 — Keyboard-first app cookbook (shipped)

**Shipped:** [keyboard.md](keyboard.md) end-to-end chords → CommandPalette → dialogs → lists → focus; Gallery Accessibility keyboard tour + CommandPalette pointers; commands / accessibility / recipes / MkDocs links; product version `1.44`.

### 1.45 — Localization packs deepen (shipped)

**Shipped:** Expanded [i18n-rtl.md](i18n-rtl.md) lupdate/lrelease / `--lang` / RTL regression checklist; `zh_CN` seed catalog; `scripts/check_gallery_translations.py` in smoke; Gallery i18n page + translations README; product version `1.45`.

### 1.46 — Shared library redistribute polish (shipped)

**Shipped:** Extended [packaging-consumer.md](packaging-consumer.md) shared vs static matrix, windeploy/linuxdeploy, strip-restricted modules; `scripts/check_shared_package.py` in smoke; MSVC `CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS` for shared; package QML collect keeps Theme/Platform siblings; product version `1.46`.

### 1.47 — Snap layouts & windowing extras (shipped)

**Shipped:** Refreshed [shell-extras.md](shell-extras.md) Snap Layouts toggle UX, taskbar / attention / reveal recipes, honest Linux n/a matrix; Gallery System integration demos (Snap · taskbar · flash continuous); window-helper / system-integration cross-links; product version `1.47`.

### 1.48 — Modal stack & ContentDialogQueue deepen (shipped)

**Shipped:** Extended [dialogs-flyouts.md](dialogs-flyouts.md) FIFO / owner Overlay / Esc recipes; fixed `replaceCurrent` not pumping pending; Gallery ContentDialog A→B→C stress + Dialogs & flyouts pointers; product version `1.48`.

### 1.49 — Icon micro-animations (shipped)

**Shipped:** `FontIcon` / `IconicButton` hover lift + press squash (`microMotionEnabled`, `hoverScale`, `pressScale`); aligned `IconButton` / `AppBarButton` / `AppBarToggleButton`; honors `Theme.reducedMotion`; Gallery Iconography + IconButton + AppBarButton demos; [icons.md](icons.md) + [animations.md](animations.md) pointer; product version `1.49`.

### 1.50 — Extractable Gallery shell template (shipped)

**Shipped:** [`examples/gallery-shell`](../examples/gallery-shell/) — `NavigationWindow` + `pageModule` + Settings footer + Bootstrap + `geometryPersistenceKey`; `NavigationWindow` gains `pageModule` / `hostContent` / `navigateBack`; keep-vs-delete README; docs/README/Gallery Example templates; product version `1.50`.

### 1.51 — 1.xx maturity checkpoint (shipped)

**Shipped:** [maturity-1xx.md](maturity-1xx.md) verdict (stay on 1.xx; harden-first); revisited [compatibility-1xx.md](compatibility-1xx.md); stable-api starters + changelog through 1.51; Gallery Pitfalls maturity checklist; recipe hub + README links; `scripts/check_docs_links.py` (0 broken recipe/roadmap links); product version `1.51`.

### 1.52 — Field polish buffer (shipped)

**Shipped:** No open GitHub field P0s after 1.51 — used the buffer for CI/docs harden: `check_docs_links.py` in `smoke_gallery.py`; critical smoke pages + `FontIconPage` / `PitfallsPage` / `ExamplesTemplatesPage`; `smoke_catalog` syncs QML `smokeCriticalComponents()`; packaging-consumer must mention `gallery-shell`; [ci-smoke.md](ci-smoke.md) updated; product version `1.52`.

### 1.53 — Thin AnimatedIcon path (shipped)

**Shipped:** Experimental `AnimatedIcon` (glyph state swap, not Lottie) with `checked` / `iconState`+`iconStates`, reduced-motion snap; Gallery **AnimatedIcon** demos (play/pause · expand · favorite); [icons.md](icons.md) + [animations.md](animations.md) + stable-api experimental note; product version `1.53`.

### 1.54 — Extra locale pack (shipped)

**Shipped:** Gallery seed `ja_JP` (same demo subset as `zh_CN`); `check_gallery_translations.py` requires three seeds; Gallery i18n page Language ComboBox + `--lang` copy; [i18n-rtl.md](i18n-rtl.md) + translations README; product version `1.54`.

### 1.55 — TeachingTip & onboarding coach marks (shipped)

**Shipped:** Gallery **Onboarding coach** (3-step sequenced `TeachingTip`, focus handoff, don’t-show-again via `QtCore.Settings`); [feedback.md](feedback.md) recipe + when-to-use vs Toast/InfoBar/ContentDialog; keyboard / dialogs cross-links; product version `1.55`.

### 1.56 — Multi-window & secondary shells (shipped)

**Shipped:** Multi-window recipe (distinct `geometryPersistenceKey`s, shared Theme, `DialogShellWindow.openDialog` / transient parent); [`examples/multi-window`](../examples/multi-window/); Gallery **Multi-window** page; [window-shells.md](window-shells.md) / [window-helper.md](window-helper.md) / [window-chrome.md](window-chrome.md) Win+Linux notes; product version `1.56`.

### 1.57 — Touch, pen & pointer recipes (shipped)

**Shipped:** [touch-pointer.md](touch-pointer.md) cookbook (target floors, scroll vs drag, stylus hover notes); Gallery **Touch & pointer** page + callouts on Button / Slider / NavigationView / FileDropZone / SwipeControl; density / accessibility / drag-drop cross-links; product version `1.57`.

### 1.58 — High-DPI & multi-monitor matrix (wave 2) (shipped)

**Shipped:** [high-dpi.md](high-dpi.md) Win+Linux matrix; geometry restore `setScreen` after clamp (mixed-DPI DPR); Gallery **High-DPI & monitors** readout + `GalleryMain` clear; window-chrome / window-helper / graphics-backend cross-links; product version `1.58`.

### 1.59 — In-app search & AutoSuggest recipes (shipped)

**Shipped:** [search.md](search.md) cookbook (AutoSuggestBox / SearchBox / filter-above vs CommandPalette); Gallery **Search recipes** (catalog AutoSuggest jump + filtered ItemsView); AutoSuggest / SearchBox / commands / data-collections cross-links; product version `1.59`.

### 1.60 — Mid-horizon checkpoint (shipped)

**Shipped:** [checkpoint-160.md](checkpoint-160.md) mid-horizon audit (stable-api / defer list / doc links OK; parking lot clarified); “still 1.xx” note in README/ROADMAP; smoke critical pages + `SearchRecipesPage` / `HighDpiPage`; `scripts/check_docs_links.py`; 1.61+ order confirmed (CMake `find_package` sketch next); product version `1.60`.

### 1.61 — CMake package / find_package sketch (shipped)

**Shipped:** `cmake/package/QWinUI3Config*.cmake.in` installed into shared zips as `lib/cmake/QWinUI3/`; `include/QWinUI3/Bootstrap.h`; [packaging-consumer.md](packaging-consumer.md) Path C; `examples/find-package-consumer/`; `scripts/verify_find_package.py`; honest not-vcpkg/Conan banner; product version `1.61`.

### 1.62 — Gallery visual smoke (subset) (shipped)

**Shipped:** Gallery `--visual-smoke` grabs Home + Button + ContentDialog + Pitfalls + ExamplesTemplates to PNG/sha256; `scripts/smoke_visual.py` (opt-in, not default smoke); [ci-smoke.md](ci-smoke.md) docs; optional workflow_dispatch; product version `1.62`.

### 1.63 — Print, share & export recipes (shipped)

**Shipped:** [print-share.md](print-share.md) cookbook (grabToImage → FilePicker.saveFile → reveal; optional app-side QPrinter/PrintSupport); Gallery **Print / share / export**; system-integration / drag-drop / shell-extras / recipes / MkDocs cross-links; product version `1.63`.

### 1.64 — Security & trust boundaries (shipped)

**Shipped:** [security-trust.md](security-trust.md) cookbook (WebView2 user-data + app-side allowlists, FileDropZone filters, FilePicker ownership — not a sandbox product); Gallery **Security & trust** + Pitfalls / WebView2 / FileDropZone callouts; webview2 / drag-drop / system-integration / recipes / MkDocs links; product version `1.64`.

### 1.65 — Settings persistence & roaming recipes (shipped)

**Shipped:** [settings-persistence.md](settings-persistence.md) cookbook (`Settings` / QSettings, portable Ini, honest “roaming”, `schemaVersion`); Gallery **Settings persistence**; `examples/form-settings` + `gallery-shell` prefs; forms / window-helper / recipes / MkDocs links; product version `1.65`.

### 1.66 — Charts & dashboard polish (wave 3) (shipped)

**Shipped:** [charts.md](charts.md) defer table for remaining siblings/gauges (stable six unchanged); Gallery **Charts** / **Dashboard** hubs match docs; `examples/dashboard` uses all six stable types; stable-api / recipes / Pitfalls; product version `1.66`.

### 1.67 — Media soak or honest defer (shipped)

**Shipped:** [media.md](media.md) soak checklist + **defer** for remaining 1.xx (`MediaPlayerElement` stays experimental — optional Multimedia, codecs/backends, app-owned deploy); Gallery **MediaPlayerElement** decision callout + pause-when-hidden; stable-api / recipes / Pitfalls / compatibility; product version `1.67`.

### 1.68 — Linux portal & file-dialog harden (shipped)

**Shipped:** FilePicker portal timeout no longer falls back to zenity (P0 double-dialog); `nameFilters` / save `current_name`; reveal FileManager1 → OpenURI → folder; `WindowHelper.portalParentWindow()`; [platform-linux-wayland.md](platform-linux-wayland.md) / [system-integration.md](system-integration.md) matrix refresh; Gallery **System integration** live parent readout; product version `1.68`.

### 1.69 — Theme prefs for any app (shipped)

**Shipped:** `Theme.snapshot` / `apply` / `recipeText`; `ThemeSync` on `StandardWindow` / `ShellWindow`; drop-in `ThemeAppearanceSettings` + `ThemePrefs`; Gallery Settings uses the kit group (copy recipe); `examples/gallery-shell` same cards; [theme-overrides.md](theme-overrides.md); product version `1.69`.

### 1.70 — Win11 on-screen keyboard (MIT engine path, our UI) (shipped)

**Shipped:** Experimental `OnScreenKeyboard` + `KeyboardEngine` inject (en-US letters / Shift-Caps / symbols, Win11 dock). Builtin backend this minor (`engine.backend === "builtin"`); Keyman Core `.kmx` remains **1.71+**. Gallery **On-screen keyboard** footer dock; [on-screen-keyboard.md](on-screen-keyboard.md); not Qt Virtual Keyboard; product version `1.70`.

### 1.71 — Extra keyboard layouts (not IME yet) (shipped)

**Shipped:** SIL Keyman Core (**MIT**) linked statically (`KMN_NO_ICU`, Qt NFC/NFD shim). Community `.kmx` en-US / de / fr / es / ru / ar. Globe + Gallery ComboBox. `engine.backend === "keyman"` when Core sources are present (`scripts/fetch_keyman_core.py`). Chrome stays ours. Not Qt Virtual Keyboard. Product version `1.71`.

### 1.72 — Chinese IME (pinyin + candidates) (shipped)

**Shipped:** zh-Hans pinyin preedit + `ImeCandidateBar` (our chrome). Lexicon from mozillazg pinyin-data / phrase-pinyin-data (MIT) — not Keyman IMX, not GPL libpinyin. Gallery 中文 mode. Honest in-app IME. Product version `1.72`.

### 1.73 — Full in-app IME (shipped)

**Shipped:** ja-JP Hepburn romaji→kana (hiragana/katakana candidates) + ko-KR 2-beolsik hangul compositor (Unicode syllables, not a lexicon). Shared `ImeCandidateBar`. Emoji layer (no engine). Keyman Core still layouts only — ja/ko are not `.kmx` IMX. Gallery language matrix. Still experimental. Product version `1.73`.

### 1.74 — OSK / IME soak (shipped)

**Shipped:** Gallery language-matrix soak checklist; `ImeCandidateBar` a11y (composition / candidates / page buttons + Space/1–9 notes); romaji trailing-`n` finalize + small-kana map; BYO `.kmx` recipe in `keyboards/README.md`. **Stay experimental** — soak is written for manual Gallery verification, not promote-green. Product version `1.74`.

### 1.75 — Extra Keyman layout packs (shipped)

**Shipped:** Named MIT `.kmx` subset: en-GB (`basic_kbduk`), it-IT, pt-PT, pl-PL, sv-SE, tr-TR (`basic_kbdtuq`). Globe / ComboBox; `scripts/fetch_keyman_keyboards.py` re-fetches the subset; `keyboards/README.md` lists shipped vs BYO. Still layouts only — not every community keyboard, not CJK IMX. Product version `1.75`.

### 1.76 — IME deepen (MIT-only) (shipped)

**Shipped:** zh — regenerated MIT pinyin tables (phrases up to 6 chars) + **prefix phrase** candidates (`niha` → 你好) with correct consume length. ko — Backspace peels compound vowels (ㅘ/ㅢ…) and finals; Space commits syllable + word break; Shift (not Caps) doubles. ja — extra romaji (thi/dhi/ts*/wh*); **kanji skipped** — no MIT reading lexicon (JMdict/KANJIDIC are CC-BY-SA). Still experimental; not promote-green. Product version `1.76`.

### 1.77 — App hardware keyboard input (shipped)

**Shipped:** KeyboardEngine.hardwareInput (default on) routes physical keys in this process through the same engine as the OSK dock — pinyin / romaji / hangul / Keyman (incl. AltGr). 1–9 pick candidates; Esc cancels; PageUp/PageDown page the bar; Ctrl/Meta shortcuts pass through. **Not** OS-wide: no SendInput into other apps. Toggle in Gallery. Product version 1.77.

---

## Horizon — closed at `1.78` (field continues)

Still **1.xx**. **1.70…1.77** shipped OSK → IME → packs → deepen → app hardware input. Long-horizon checkpoint **shipped** as **1.78**. **1.79** Wayland field harden shipped. Plan: [docs/on-screen-keyboard.md](on-screen-keyboard.md).

| Slice | Keyboard theme |
|-------|----------------|
| **1.70 shipped** | Win11 OSK (en-US builtin) |
| **1.71 shipped** | Keyman Core + de/fr/es/ru/ar |
| **1.72 shipped** | zh-Hans pinyin + candidate bar |
| **1.73 shipped** | ja romaji/kana + ko hangul + emoji |
| **1.74 shipped** | Soak / harden (still experimental) |
| **1.75 shipped** | Extra documented Keyman `.kmx` (named subset) |
| **1.76 shipped** | IME deepen, MIT-only (ja kanji gap documented) |
| **1.77 shipped** | App-scoped hardware input (not OS-wide) |
| **1.78 shipped** | Long-horizon 1.xx checkpoint |
| **1.79 shipped** | Linux / Wayland field harden |
| **1.80 shipped** | Win11 OSK layout chrome |
| **1.81 shipped** | Win11 OSK behavior (vs Win10) |
| **1.82 shipped** | Floating OSK + Windows system-wide (`SendInput`) |
| **1.83 shipped** | Floating OSK / SendInput field harden |
| **1.84 shipped** | Consumer floating-OSK recipe |
| **1.85 shipped** | Accessibility wave 3 |

### 1.78 — Long-horizon 1.xx checkpoint (shipped)

**Shipped:** [checkpoint-178.md](checkpoint-178.md) long-horizon audit (docs links OK; ~196 Gallery pages; 214 public / 225 component docs). **Posture:** prefer field harden / pause vs new surfaces; open `1.79+` only for field-driven P0s or park. **OSK/IME:** stayed experimental through 1.74 / 1.76 / 1.77 — **not** promoted. Freeze (1.40) still active. Still not 2.00. Product version `1.78`.

### 1.79 — Linux / Wayland field harden (shipped)

**Shipped:** Stronger portal `parent_window` on pure Wayland (`portalWindowIdentifier` when GuiPrivate available; realize window before export; native-resource fallback); Bootstrap honors `WAYLAND_SOCKET`; experimental OSK CapsLock tracking on Linux; [platform-linux-wayland.md](platform-linux-wayland.md) + Gallery System integration soak refresh. OSK/IME still experimental. Product version `1.79`.

### 1.80 — Win11 OSK layout chrome (shipped)

**Shipped:** `OnScreenKeyboard` matches Windows 11 default touch layout (Esc/Tab/dual Shift, `&123` · Ctrl · Win · Alt · lang chip · Space · mic · arrows, top-row number hints, settings/grab/close + emoji/paste tools). `KeyboardEngine.navigateKey` / `pasteClipboard`. Layout packs unchanged. Still experimental. Product version `1.80`.

### 1.81 — Win11 OSK behavior vs Win10 (shipped)

**Shipped:** Long-press digit hints + punctuation alt flyout; `keyboardSize` Small/Default/Large; clipboard paste strip; emoji category chips; rounder keys + press scale (not Win10 classic flat full keyboard). `clipboardText()` peek. Still experimental. Product version `1.81`.

### 1.82 — Floating OSK + Windows system-wide (shipped)

**Shipped:** `OnScreenKeyboardWindow` (always-on-top, grab-drag, `WS_EX_NOACTIVATE`); `KeyboardEngine.systemWide` Windows `SendInput`; compose stays on the candidate bar. Floating host **defaults `systemWide` on** (Windows); dock stays off. SIL Keyman Core **vendored** in `third_party/keyman` (clone includes sources). Gallery `--visual-smoke` removed (CI `--smoke` kept). Linux: floating only (`supportsSystemWide === false`). Still experimental. Product version `1.82`.

---

## After `1.82` — planned through `2.00`

Finish **1.xx** as named slices (**1.83…1.90**), then a **breaking 2.00**. Do not treat 1.70…1.82 as permission to start 2.00 code. Prefer **one theme per minor**.

| Slice | Theme | Status |
|-------|--------|--------|
| **1.83** | Floating OSK / SendInput field harden | **Shipped** |
| **1.84** | Consumer floating-OSK recipe | **Shipped** |
| **1.85** | Accessibility wave 3 | **Shipped** |
| **1.86** | Performance wave 1 — shell & window runtime | **Shipped** |
| **1.87** | Performance wave 2 — navigation & page stack | **Shipped** |
| **1.88** | Performance wave 3 — lists & data collections | **Shipped** |
| **1.89** | Performance wave 4 — style, charts & Gallery heavy pages | **Shipped** |
| **1.90** | 1.xx close-out + perf sign-off + 2.00 prep | **Shipped** |
| **2.00** | Breaking baseline | **Next** (after 1.90) |

### 1.83 — Floating OSK field harden (shipped)

**Shipped:** `WindowHelper.setNoActivate` also eats `WM_MOUSEACTIVATE` (`MA_NOACTIVATE`) and click `WM_ACTIVATE` so the first tap / settings / candidate bar do not steal the target app. Floating host skips `raise()`. Long-press `Popup` stays `Popup.Item` on Qt 6.8+ (no extra HWND). Gallery soak checkboxes + honest UIPI / UWP / games limits. IME preedit stays on the OSK bar; commits / Backspace / Enter / arrows still `SendInput`. Still experimental. Product version `1.83`.

### 1.84 — Consumer floating-OSK recipe (shipped)

**Shipped:** [`examples/floating-osk`](../examples/floating-osk/) — `OnScreenKeyboardWindow` + `openFloating()`; `systemWide` pinned to Windows. Docs: Keyman Core **in the clone** (`third_party/keyman`); WebView2 still optional NuGet. Do not copy the Gallery tree. Still experimental. Product version `1.84`.

### 1.85 — Accessibility wave 3 (shipped)

**Shipped:** ContentDialog / Flyout / CommandBarFlyout return focus to the opener on close. InfoBar announces title + message + severity on open (`Accessible.announce` on Qt 6.8+; AlertMessage + description on 6.5). ImeCandidateBar announces paged candidates without taking focus. Gallery **Accessibility** wave 3 sample. [docs/accessibility.md](accessibility.md). OSK still experimental. Product version `1.85`.

**Out**

- Full catalog audit as a mega-minor
- OSK promote (**2.01+**, after perf arc)

### Performance arc (1.86…1.89)

Four consecutive minors; **each ships only performance work** (Platform / Extras / Style / Gallery + [performance.md](performance.md) rows). Not a fifth handbook — extends **1.25** / **1.39**.

| Rule | Detail |
|------|--------|
| **Animations stay** | Pane collapse, page transitions, control press/hover motion unchanged to the user — trim no-op animators, defer shadows, debounce model rebuilds |
| **Measure** | Gallery `--startup-log` / `--smoke` timings stay advisory; optional heavy-page checklist grows each wave |
| **Out for the arc** | Chart GPU rewrite, custom virtualization engine, built-in profiler, changing Gallery default RHI off OpenGL |

### 1.86 — Performance wave 1: shell & window runtime (shipped)

**Shipped:** Solid hosts use `WindowHelper.solidHostFill` for `QQuickWindow` clear color (never `Qt::white`). Windows pins `DWMWA_BORDER_COLOR` to that fill when `borderVisible` is false. Solid shells reapply border/corner **immediately** on activate; frosted hosts keep deferred DWM reapply. One 80 ms post-show reapply remains for Solid (Qt 6.8 overwrite). [performance.md](performance.md) shell section; [window-chrome.md](window-chrome.md). Product version `1.86`.

**Out**

- NavigationView / DataTable / Style (**1.87…1.89**)

### 1.87 — Performance wave 2: navigation & page stack (shipped)

**Shipped:** StackView page transitions run **only the axes each mode needs** (`slide`/`fade` skip no-op x/y/scale animators; drill/center/up/down unchanged visually). Compact-pane flyout defers `MultiEffect` until open; honors `Theme.reducedMotion`. `TabView` tab strip: width/opacity `Behavior` only during reorder; color/indicator `Behavior` when tab is active/hovered/focused. Gallery Settings **Performance arc** card. [performance.md](performance.md) navigation section. Product version `1.87`.

**Out**

- DataTable filter path (**1.88**)
- Style-wide sweep (**1.89**)

### 1.88 — Performance wave 3: lists & data collections (shipped)

**Shipped:** `DataTable` debounces filter keystrokes (`filterDebounceMs`, default 120) and skips `_viewRows` rebuild when query/sort/rows unchanged. `ItemsView` / `ListDetailsView` / `ItemsRepeater` gain optional `filterText` for plain JS arrays (debounced, skip unchanged). Thinner role bindings under `reuseItems`. Gallery DataTable / ItemsView / ListDetailsView pages call out 1.88. [performance.md](performance.md) lists section. Product version `1.88`.

**Out**

- Canvas chart engines (**1.89**)
- C++ model requirement for apps (document only)

### 1.89 — Performance wave 4: style, charts & Gallery heavy pages (shipped)

**Shipped:** `ElevatedChrome` defers `MultiEffect` one frame; skips shadow when `Theme.reducedMotion`. Style hot path: Button / TextField / Switch / ListTile idle `Behavior` bindings gated on hover/focus/press (motion unchanged when interacting). Stable charts (Line/Bar/Donut): `ChartUtils.revealAnimationPointBudget` (500) + coalesced canvas redraw (~16 ms). Gallery: FontIcon filter debounce; Charts deferred Pie/Sparkline `Loader`; WebView2 host deferred one frame. [performance.md](performance.md) style/charts section + arc summary. Product version `1.89`.

**Out**

- Full catalog perf audit (every Gallery page) as one tag
- Chart GPU rewrite

### 1.90 — 1.xx close-out (shipped)

**Shipped:** [checkpoint-190.md](checkpoint-190.md) — docs-link OK, Gallery catalog **195**, freeze accurate, **1.86…1.89 perf checklist green**. [upgrade-notes.md](upgrade-notes.md) draft **1.90 → 2.00** (Qt floor, remaps, experimental posture). [ci-smoke.md](ci-smoke.md) perf timing advisory from the arc. README / Gallery: **1.xx freeze ends at 2.00**. Product version `1.90`.

**Out**

- Actually dropping Qt 6.5 or renaming Theme tokens (**2.00**)
- OSK promote / packaging (**2.01**)

---

## Post close-out — `1.91` … `1.92` (shipped on master)

Small **non-breaking** slices after [checkpoint-190.md](checkpoint-190.md). Ship as tags before **2.00** when ready.

| Slice | Theme | Status |
|-------|--------|--------|
| **1.91** | Real-time FPS + title-bar custom slots | **Shipped** (master) |
| **1.92** | Linux Wayland client shell (corners + DWM-like shadow) | **Shipped** (master) |

### 1.91 — Real-time FPS + title-bar slots (shipped)

**Shipped:** `FrameStatsMonitor` singleton (`frameSwapped` rolling FPS / frame time, QSettings, CLI `--show-fps` / `--fps-overlay`); `FrameStatsBadge` + `FrameStatsOverlay`; `StandardTitleChrome` exposes `leftHeader` / `titleBarContent` / `rightHeader` on `StandardWindow`; Gallery Settings toggles + badge in title `rightHeader`; `TitleBar.notifyChromeHitTest()` on slot layout changes. Opt-in (`enabled` default **false**). Product version target `1.91`.

### 1.92 — Linux Wayland client shell (shipped)

**Shipped:** `WindowHelper.clientShellDecoration` + `shellCornerRadius()` / `shellShadowMargin()` / `shellChromeExpanded()`; `WindowShellDecoration` (`MultiEffect` drop shadow + rounded frame from `cornerPreference`); `StandardWindow` / `ShellWindow` transparent host + decoration background; Linux alpha buffer when CSD active; Settings **Window corners** enabled on Linux; [platform-linux-wayland.md](platform-linux-wayland.md) Effects dependency note. Windows DWM path unchanged. Product version target `1.92`.

**Out (2.03+)**

- Compositor-native KWin/GNOME rounding hooks
- `WindowShellDecoration_Simple` fallback without QtQuick.Effects

---

## 2.00 — Breaking baseline (planned, after 1.92)

**Gate:** **1.90 shipped**; **1.91…1.92** tagged or explicitly folded into **2.00** release notes. Do not mix undocumented breaking remaps into 1.91/1.92.

**Theme:** lift the [1.xx freeze](compatibility-1xx.md) in **one** named major. Small enough to finish. Follow-ups are `2.01+`.

### Breaks (in)

| Area | 2.00 intent |
|------|-------------|
| **Qt floor** | Drop **Qt 6.5**. Floor **6.8 LTS** (forward 6.10+). Update [qt-version-compat.md](qt-version-compat.md) + CI matrix. |
| **Theme** | Only remaps listed in the **1.90** inventory (example: collapse duplicate stroke/focus aliases). **Not** a Fluent 2 redesign. |
| **Shell** | Remove Gallery-era aliases that 1.xx kept for compatibility; keep `StandardWindow` / `NavigationWindow` / `WindowHelper` as the contract. |
| **Experimental leftover** | Types still experimental after **2.01** OSK slice either promote, move to an explicit experimental module, or **remove** with an upgrade-notes row. |
| **Packaging** | `QWINUI3_VERSION` `2.00`; shared/static defaults only change if **2.01+** documents the new contract. |

### Does not ship in 2.00 (out)

- **Fluent 2 / separate Style fork — withdrawn** (not in **2.01…2.50**; **WinUI 3 Style** only)
- Linux system-wide OSK inject
- **macOS first-class** — **withdrawn** (not in **2.01…2.50**)
- Full Lottie, Figma tokens, every-locale portal
- Qt Virtual Keyboard (never)
- Re-adding Gallery visual-smoke as a default CI gate

### Consumer upgrade (sketch)

Apps on **1.90** read [upgrade-notes.md](upgrade-notes.md) **1.90 → 2.00**, raise Qt to 6.8+, apply the remap table, rebuild Release. Apps that cannot leave Qt 6.5 **stay on 1.90**.

## Planned through `2.50` — `2.01` … `2.50`

After **2.00**, ordinary **2.xx** minors — **one theme each**. Order may shift for field P0s. **New-control slices** must ship Gallery page + component doc + stable-api decision in the **same tag**.

| Slice | Theme | Status |
|-------|--------|--------|
| **2.00** | Breaking baseline (Qt 6.8 floor, freeze lift, remaps) | **Next** |
| **2.01** | OSK / IME green soak + promote | Planned |
| **2.02** | Consumer `find_package` productize | Planned |
| **2.03** | Linux Wayland shell wave 2 | Planned |
| **2.04** | Runtime diagnostics (FPS / frame stats deepen) | Planned |
| **2.05** | Title-bar & shell chrome cookbook | Planned |
| **2.06** | **New controls:** `FileTree` + directory recipe | Planned |
| **2.07** | Accessibility wave 4 | Planned |
| **2.08** | Charts experimental promote sweep | Planned |
| **2.09** | Media final promote or honest defer | Planned |
| **2.10** | 2.x mid-horizon checkpoint | Planned |
| **2.11** | vcpkg / Conan official port | Planned |
| **2.12** | Localization wave 3 | Planned |
| **2.13** | Security & trust wave 2 | Planned |
| **2.14** | Multi-window & modal stack harden | Planned |
| **2.15** | High-DPI & multi-monitor wave 3 | Planned |
| **2.16** | Command & search surfaces deepen | Planned |
| **2.17** | Theme & Style polish (WinUI 3) | Planned |
| **2.18** | Performance wave 5 (2.x floor) | Planned |
| **2.19** | Component docs & Gallery catalog refresh | Planned |
| **2.20** | First 2.x horizon checkpoint | Planned |
| **2.21** | **New controls:** `TreeDataGrid` (hierarchical grid) | Planned |
| **2.22** | Dashboard layout recipes (`ChartCard` / `KpiTile`) | Planned |
| **2.23** | Navigation — `BreadcrumbBar` + shell integration | Planned |
| **2.24** | **New controls:** `ItemsWrapGrid` / variable wrap layouts | Planned |
| **2.25** | Input & validation wave (`NumberBox` / `PasswordBox`) | Planned |
| **2.26** | Charts wave — area / sparkline siblings | Planned |
| **2.27** | Feedback — `InfoBadge` / teaching / progress polish | Planned |
| **2.28** | Performance wave 6 | Planned |
| **2.29** | Accessibility wave 5 | Planned |
| **2.30** | Mid-2.x checkpoint (`checkpoint-230`) | Planned |
| **2.31** | **New controls:** `CalendarView` month surface | Planned |
| **2.32** | Media + WebView2 harden | Planned |
| **2.33** | Linux portal & tray wave 3 | Planned |
| **2.34** | Packaging & CI consumer matrix | Planned |
| **2.35** | Localization wave 4 | Planned |
| **2.36** | Security & trust wave 3 | Planned |
| **2.37** | **New controls:** `PipsPager` + carousel shell recipes | Planned |
| **2.38** | Theme overrides & branding wave 2 | Planned |
| **2.39** | Gallery catalog expansion | Planned |
| **2.40** | Performance wave 7 | Planned |
| **2.41** | Command palette + menu bar wave 3 | Planned |
| **2.42** | **New controls:** `SwipeControl` / gesture hosts deepen | Planned |
| **2.43** | Multi-window + onboarding coach marks | Planned |
| **2.44** | Developer diagnostics productize (`FrameStats` stable?) | Planned |
| **2.45** | Experimental promote sweep (2.x) | Planned |
| **2.46** | Docs IA + recipes hub v2 | Planned |
| **2.47** | Field harden buffer | Planned |
| **2.48** | **New controls:** WinUI gap backlog (pick 1–2) | Planned |
| **2.49** | Performance wave 8 + 2.x perf sign-off | Planned |
| **2.50** | 2.xx horizon checkpoint + 3.00 prep | Planned |

### 2.01 — OSK / IME green soak + promote (planned)

**Goal:** Manual soak checklist **green** on Windows + Linux floating path; promote `OnScreenKeyboard` / `KeyboardEngine` / `ImeCandidateBar` subset to **stable**; [on-screen-keyboard.md](on-screen-keyboard.md) + [stable-api.md](stable-api.md) promote rows; honest limits (UIPI, no Linux system-wide inject).

**Out:** Every community `.kmx`; dictation / cloud lexicon.

### 2.02 — Consumer find_package productize (planned)

**Goal:** Productize the **1.61** sketch — installed `QWinUI3Config.cmake` as the supported consumer path; `verify_find_package.py` in default smoke; [packaging-consumer.md](packaging-consumer.md) Path C as primary; optional CI consumer build.

**Out:** Replacing `add_subdirectory` for in-tree kit dev.

### 2.03 — Linux Wayland shell wave 2 (planned)

**Goal:** Compositor-specific polish on the **2.0** floor — KWin/GNOME client-side decoration hints where available; `WindowShellDecoration_Simple` when QtQuick.Effects missing; bottom-corner content clip recipe; field matrix refresh in [platform-linux-wayland.md](platform-linux-wayland.md).

**Out:** SSD-only compositors pretending to be Win11 DWM.

### 2.04 — Runtime diagnostics deepen (planned)

**Goal:** Build on **1.91** — Gallery discoverability; optional GPU/RHI readout beside FPS; [performance.md](performance.md) diagnostics section; Settings + CLI parity.

**Out:** Built-in QML profiler; always-on FPS in consumer apps by default.

### 2.05 — Title-bar & shell chrome cookbook (planned)

**Goal:** Document `StandardTitleChrome` / `ShellWindow` slots (`PlatformTitleBar.rightHeader` before captions); Gallery **TitleBar** + **Window shells** cross-links; hit-test troubleshooting.

**Out:** Replacing `PlatformTitleBar`.

### 2.06 — New controls: FileTree (planned)

**Goal:** Add **`FileTree`** (WinUI tree + file metadata columns) — Theme/Style wiring, keyboard, selection; Gallery page; [tree-data.md](tree-data.md) extension; experimental → promote decision in tag notes.

**Out:** Full File Explorer replacement; cloud drive backends.

### 2.07 — Accessibility wave 4 (planned)

**Goal:** Post-**2.0** floor a11y pass — high-traffic 2.x controls + shell chrome; live-region coverage for title-bar slot actions; [accessibility.md](accessibility.md) wave 4 checklist.

**Out:** Full 200+ control audit as one tag.

### 2.08 — Charts experimental promote sweep (planned)

**Goal:** Promote or **defer** remaining chart/gauge siblings beyond the stable six; [charts.md](charts.md) defer table final for 2.x.

**Out:** WebGL / new chart engines.

### 2.09 — Media final promote or defer (planned)

**Goal:** Close the **1.67** defer loop — promote `MediaPlayerElement` with soak green or permanent experimental + app-owned codecs; [media.md](media.md) verdict.

**Out:** Bundling FFmpeg; cloud streaming SDKs.

### 2.10 — 2.x mid-horizon checkpoint (planned)

**Goal:** [checkpoint-210.md](checkpoint-210.md) — audit **2.00…2.10**; confirm OSK / packaging / first control slice landed or rescheduled; no breaking code.

**Out:** Starting **3.00** implementation.

### 2.11 — vcpkg / Conan official port (planned)

**Goal:** Supported community port(s) with documented triplets; README consumer path.

**Out:** Qt itself vendored through the port.

### 2.12 — Localization wave 3 (planned)

**Goal:** Extra seed locale(s); [i18n-rtl.md](i18n-rtl.md) consumer lrelease recipe for 2.x apps.

**Out:** Community translation portal; every-locale coverage.

### 2.13 — Security & trust wave 2 (planned)

**Goal:** Extend [security-trust.md](security-trust.md) — WebView2 navigation policy examples; FileDropZone MIME hardening; portal parent_window regression on Wayland.

**Out:** App sandbox product.

### 2.14 — Multi-window & modal stack harden (planned)

**Goal:** Field harden **1.56** / **1.48** on 2.x floor — transient parent on Wayland; [`examples/multi-window`](../examples/multi-window/) refresh.

**Out:** MDI / tabbed document interface product.

### 2.15 — High-DPI & multi-monitor wave 3 (planned)

**Goal:** Extend [high-dpi.md](high-dpi.md) — fractional scale on Wayland; per-monitor geometry soak; Gallery readout.

**Out:** Per-monitor Theme packs as a product feature.

### 2.16 — Command & search surfaces deepen (planned)

**Goal:** [commands.md](commands.md) + [search.md](search.md) wave 2 — CommandPalette perf; AutoSuggest keyboard polish.

**Out:** Spotlight clone; cloud search backends.

### 2.17 — Theme & Style polish (WinUI 3) (planned)

**Goal:** Deepen the existing **Style** module on the **2.x** floor — control chrome consistency, token usage audits, Gallery Style spot-check pages; [theme-overrides.md](theme-overrides.md) cross-links. **No** separate Fluent 2 import/module.

**Out:** Fluent 2 fork; full visual redesign.

### 2.18 — Performance wave 5 (planned)

**Goal:** Second perf arc on **Qt 6.8+** — shell/Navi/lists/style rows in [performance.md](performance.md); **animations stay**.

**Out:** Chart GPU rewrite; default RHI change off OpenGL (Windows).

### 2.19 — Component docs & Gallery catalog refresh (planned)

**Goal:** Regenerate component API index; catalog audit; smoke critical list sync.

**Out:** MkDocs theme redesign.

### 2.20 — First 2.x horizon checkpoint (planned)

**Goal:** [checkpoint-220.md](checkpoint-220.md) — verdict on **2.00…2.20**; parking-lot triage for **2.21…2.50**; perf + a11y sign-off for tranche 1.

**Out:** Shipping **3.00** breaks.

### 2.21 — New controls: TreeDataGrid (planned)

**Goal:** **`TreeDataGrid`** — hierarchical rows + sort/filter hooks; pairs with **2.06** FileTree recipe; Gallery master-detail demo; experimental first.

**Out:** Excel-scale grid engine; GPU virtualization rewrite.

### 2.22 — Dashboard layout recipes (planned)

**Goal:** Deepen [`examples/dashboard`](../examples/dashboard/) and Gallery **Dashboard** hub using existing **`ChartCard`** / **`KpiTile`** / stable charts — layout, responsive breakpoints, [charts.md](charts.md) recipe. **No** `Hub` / `HubSection` controls.

**Out:** **`Hub` / `HubSection` WinUI controls** (withdrawn); dynamic tile store / cloud hub backend.

### 2.23 — Navigation: BreadcrumbBar integration (planned)

**Goal:** Deepen existing **`BreadcrumbBar`** — NavigationView / ShellWindow title sync, overflow flyout, keyboard; not a new type unless overflow sub-control is required.

**Out:** File system watcher integration.

### 2.24 — New controls: ItemsWrapGrid (planned)

**Goal:** **`ItemsWrapGrid`** (variable-sized wrap) — WinUI wrap panel for ItemsRepeater/ItemsView; touch floors from [touch-pointer.md](touch-pointer.md).

**Out:** Virtualizing wrap for million items.

### 2.25 — Input & validation wave (planned)

**Goal:** **`NumberBox`** / **`PasswordBox`** / FormLayout error parity; Gallery form validation refresh.

**Out:** Masked input engine for every locale.

### 2.26 — Charts wave (planned)

**Goal:** **AreaChart** / **Sparkline** promote or defer; stable-api row; dashboard example optional siblings.

**Out:** WebGL chart backend.

### 2.27 — Feedback polish (planned)

**Goal:** **InfoBadge** / **ProgressRing** / TeachingTip recipes; [feedback.md](feedback.md) wave 3.

**Out:** Toast notification center product.

### 2.28 — Performance wave 6 (planned)

**Goal:** Shell + navigation trim on real apps checklist; advisory smoke timings.

**Out:** Removing animations globally.

### 2.29 — Accessibility wave 5 (planned)

**Goal:** New **2.21…2.24** controls + FileTree/TreeDataGrid keyboard names; wave 5 checklist.

**Out:** Mega audit single tag.

### 2.30 — Mid-2.x checkpoint (planned)

**Goal:** [checkpoint-230.md](checkpoint-230.md) — audit **2.21…2.30**; control count + doc links; reschedule **2.31…2.50** if needed.

**Out:** **3.00** code.

### 2.31 — New controls: CalendarView (planned)

**Goal:** **`CalendarView`** month grid (distinct from date pickers); selection modes; Gallery page.

**Out:** Outlook sync; recurring events engine.

### 2.32 — Media + WebView2 harden (planned)

**Goal:** Field matrix on **2.x** floor; WebView2 policy recipes; Multimedia deploy notes.

**Out:** Bundled browser engine.

### 2.33 — Linux portal & tray wave 3 (planned)

**Goal:** FilePicker / tray / idle inhibit regression suite; [platform-linux-wayland.md](platform-linux-wayland.md) refresh.

**Out:** macOS portal work.

### 2.34 — Packaging & CI consumer matrix (planned)

**Goal:** Shared/static × Win/Linux consumer builds in CI; [packaging-consumer.md](packaging-consumer.md) v2.

**Out:** Hosted artifact store product.

### 2.35 — Localization wave 4 (planned)

**Goal:** Fourth seed locale; translation checker rules for new control pages.

**Out:** Crowdin portal.

### 2.36 — Security & trust wave 3 (planned)

**Goal:** FileTree / TreeDataGrid path trust notes; WebView2 download policy examples.

**Out:** Code signing service.

### 2.37 — New controls: PipsPager + carousel recipes (planned)

**Goal:** Deepen **`PipsPager`** + **`FlipView`** / carousel hosts; Gallery motion + reducedMotion demos.

**Out:** Full-screen carousel product.

### 2.38 — Theme overrides & branding wave 2 (planned)

**Goal:** Extend **1.09** branding — custom accent packs, `ThemePrefs` recipes for 2.x apps, contrast/density integration; Gallery Settings + [color-contrast.md](color-contrast.md) refresh.

**Out:** Fluent 2 tokens; Figma pipeline.

### 2.39 — Gallery catalog expansion (planned)

**Goal:** Every **2.xx** new control has catalog entry + smoke consideration; Pitfalls updated.

**Out:** Screenshot diff every page.

### 2.40 — Performance wave 7 (planned)

**Goal:** Lists + new grids (FileTree / TreeDataGrid) debounce/filter perf rows.

**Out:** Custom scene graph.

### 2.41 — Command palette + menu bar wave 3 (planned)

**Goal:** Large-model CommandPalette; MenuBar accelerators on 2.x floor.

**Out:** OS global shortcuts.

### 2.42 — New controls: SwipeControl deepen (planned)

**Goal:** **`SwipeControl`** thresholds, teaching, nested scroll; Gallery [touch-pointer.md](touch-pointer.md) cross-links.

**Out:** Full edge-gesture OS hooks.

### 2.43 — Multi-window + onboarding (planned)

**Goal:** **1.55** coach marks + multi-window z-order; Settings persistence for tours.

**Out:** Analytics-backed onboarding SaaS.

### 2.44 — Developer diagnostics productize (planned)

**Goal:** Promote or defer **`FrameStatsMonitor`** / badge / overlay; dev-vs-ship guidance.

**Out:** Always-on FPS in retail apps.

### 2.45 — Experimental promote sweep (planned)

**Goal:** Final 2.x pass on experimental inventory — promote, module-ize, or remove with upgrade-notes.

**Out:** Zero experimental types (unrealistic — document honest deferrals).

### 2.46 — Docs IA + recipes hub v2 (planned)

**Goal:** MkDocs nav regroup for **2.xx** controls; [recipes.md](recipes.md) hub v2.

**Out:** Full site redesign.

### 2.47 — Field harden buffer (planned)

**Goal:** Open P0/P1 from **2.30** / **2.45** audits only — no new surfaces.

**Out:** Feature creep.

### 2.48 — New controls: WinUI gap backlog (planned)

**Goal:** Pick **1–2** remaining WinUI gaps (e.g. **`AppNotification`** builder chrome, **`AnimatedIcon`** Lottie path, **`InkCanvas`** sketch) — **one tag, one primary control**.

**Out:** Shipping all three in one minor.

### 2.49 — Performance wave 8 + 2.x perf sign-off (planned)

**Goal:** Final perf checklist for **2.00…2.49**; [performance.md](performance.md) 2.x summary; **animations stay**.

**Out:** Chart GPU rewrite.

### 2.50 — 2.xx horizon checkpoint + 3.00 prep (planned)

**Goal:** [checkpoint-250.md](checkpoint-250.md) — verdict on **2.00…2.50**; [upgrade-notes.md](upgrade-notes.md) draft **2.50 → 3.00** (if ever); catalog size audit; parking-lot triage.

**Out:** Actually shipping **3.00** in the same tag; macOS or Fluent 2 Style fork revival.

---

## Parking lot

Unscheduled; pick up only inside a named `1.xx` or `2.xx` minor (or never). Clarified at **1.60** ([checkpoint-160.md](checkpoint-160.md)):

- **macOS first-class — withdrawn** (not in **2.01…2.50**; Qt-on-macOS may still consume the kit unofficially)
- **Fluent 2 Style fork / separate Style module — withdrawn** (WinUI 3 Style only)
- **`Hub` / `HubSection` controls — withdrawn** (use `ChartCard` / dashboard layouts instead)
- Figma / design-token pipeline
- Full Fluent visual redesign (**not** scheduled in **2.01…2.50**)
- Screenshot diffs for **every** Gallery page (1.62 subset **removed** in 1.82; not a default CI gate)
- Community translation portal / every-locale coverage (seeds `zh_CN` / `ja_JP` enough for 1.xx)
- Full Lottie runtime as a hard product dependency (thin glyph path shipped in 1.53)
- New chart engines / WebGL
- Official vcpkg/Conan ports as supported products (sketch in **1.61**; productize **2.02+**)
- OSK / IME promote green soak → **2.01** (perf arc **1.86…1.89** done)
- Consumer `find_package` productize → **2.02**
- Wayland compositor-native chrome → **2.03** (client shell in **1.92**)
- **New controls** (FileTree, TreeDataGrid, ItemsWrapGrid, …) → **2.06**, **2.21**, **2.24**, **2.31**, **2.37**, **2.42**, **2.48**
- Official vcpkg/Conan → **2.11**
- Custom ink / handwriting canvas (out of 1.57 touch cookbook; out of 1.70…1.73 IME)
- Dictation / cloud IME lexicon (out of 1.73 full in-app IME)
- Qt Virtual Keyboard (GPL/commercial — **never**)
- Cloud settings roaming / share backends (out of 1.65 recipes scope)
- Linux / Wayland system-wide inject

---

## Related

| Doc | Role |
|-----|------|
| [README.md](../README.md) | Overview |
| [docs/stable-api.md](stable-api.md) | Stable vs experimental |
| [docs/maturity-1xx.md](maturity-1xx.md) | 1.51 maturity checkpoint |
| [docs/checkpoint-160.md](checkpoint-160.md) | 1.60 mid-horizon checkpoint |
| [docs/checkpoint-178.md](checkpoint-178.md) | 1.78 long-horizon checkpoint |
| [checkpoint-190.md](checkpoint-190.md) | 1.90 1.xx close-out + perf arc sign-off |
| [checkpoint-210.md](checkpoint-210.md) (planned) | 2.10 mid-2.x audit |
| [checkpoint-220.md](checkpoint-220.md) (planned) | 2.20 first 2.x horizon checkpoint |
| [checkpoint-230.md](checkpoint-230.md) (planned) | 2.30 mid-2.x audit |
| [checkpoint-250.md](checkpoint-250.md) (planned) | 2.50 2.xx horizon close-out + 3.00 prep draft |
| [docs/compatibility-1xx.md](compatibility-1xx.md) | 1.xx will-not-break freeze (ends at **2.00**) |
| [docs/upgrade-notes.md](upgrade-notes.md) | Consumer upgrades; 2.00 sketch after 1.90 |
| [docs/components.md](components.md) | Control index |
| [docs/conventions.md](conventions.md) | A11y / QML rules |
| [docs/qt-version-compat.md](qt-version-compat.md) | Qt multi-version shims |
| [docs/on-screen-keyboard.md](on-screen-keyboard.md) | 1.70…1.82 OSK → IME → floating / system-wide |
| [docs/roadmap.md](roadmap.md) | Site copy of this plan |
