# QWinUI3 Roadmap

**Current:** **1.82**
**Next up:** **1.83** — floating OSK / SendInput field harden
**Planned through:** **2.00** (1.xx close-out **1.83…1.90**, then breaking line)
**Still 1.xx until 1.90:** Long-horizon checkpoint — [checkpoint-178.md](checkpoint-178.md). **1.82** floating OSK + Windows system-wide. OSK/IME stays experimental until a named green soak (**1.87**). **Do not implement 2.00 before 1.90.**  
**Qt:** 6.5+ (recommended 6.8 LTS) through 1.xx — [qt-version-compat.md](qt-version-compat.md). **2.00** may raise the floor.

This plan starts from **what 1.00 already was**, then walks **small `1.xx` minors** through a **1.90 close-out**, then a named **2.00** breaking line. **2.00 is not the next tag.**

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
| **`2.00`** | Breaking line (Qt floor / freeze lift / documented remaps). **After 1.90 only.** |

**Rules of thumb**

- One `X.YY` ≈ one primary outcome, not five themes at once.
- Avoid empty releases—but do not wait for “epic” bundles either.
- New controls only when they serve that minor’s slice; otherwise park them.
- After each ship: bump `QWINUI3_VERSION`, update this file.
- Prefer **docs + harden + Gallery recipe** over new product surfaces (pattern of 1.07–1.10).
- **2.00** is one breaking slice, not a dump of the parking lot. Follow-ups are `2.01+`.

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

**Shipped:** [`examples/master-detail`](examples/master-detail/) (`ListDetailsView` LoB tickets) and [`examples/form-settings`](examples/form-settings/) (`FormLayout` + SettingsCard prefs); README / examples README / stable-api / forms / data-collections / window-chrome “start from” tables updated; product version `1.26`. Smoke CI keeps examples off for speed (default local `QWINUI3_BUILD_EXAMPLES=ON`).

### 1.27 — Navigation & TabView deepen (shipped)

**Shipped:** [navigation.md](navigation.md) — pane modes, footer, Back stack, compact/overlay, TabView vs NavigationView; Gallery NavigationView / TabView callouts + `leftMinimal`/`auto`; Accessible names on demo path; [`examples/nav-settings`](examples/nav-settings/) aligned (`paneDisplayMode: auto`, TitleBar Back ↔ `navigateBack`); product version `1.27`.

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

**Shipped:** [`examples/gallery-shell`](examples/gallery-shell/) — `NavigationWindow` + `pageModule` + Settings footer + Bootstrap + `geometryPersistenceKey`; `NavigationWindow` gains `pageModule` / `hostContent` / `navigateBack`; keep-vs-delete README; docs/README/Gallery Example templates; product version `1.50`.

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

**Shipped:** Multi-window recipe (distinct `geometryPersistenceKey`s, shared Theme, `DialogShellWindow.openDialog` / transient parent); [`examples/multi-window`](examples/multi-window/); Gallery **Multi-window** page; [window-shells.md](window-shells.md) / [window-helper.md](window-helper.md) / [window-chrome.md](window-chrome.md) Win+Linux notes; product version `1.56`.

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

Still **1.xx**. **1.70…1.77** shipped OSK → IME → packs → deepen → app hardware input. Long-horizon checkpoint **shipped** as **1.78**. **1.79** Wayland field harden shipped. Plan: [on-screen-keyboard.md](on-screen-keyboard.md).

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
| **1.83** | Floating OSK / SendInput field harden | **Next** |
| **1.84** | Consumer floating-OSK recipe | Planned |
| **1.85** | Accessibility wave 3 | Planned (slipped past 1.69) |
| **1.86** | Leftover field P0s | Planned — skip if empty |
| **1.87** | OSK / IME green soak + promote | Planned |
| **1.88** | Consumer packaging beyond the 1.61 sketch | Planned |
| **1.89** | 1.xx close-out checkpoint | Planned |
| **1.90** | Last 1.xx hold + 2.00 deprecation notices | Planned |
| **2.00** | Breaking baseline | Planned — **after 1.90** |

### 1.83 — Floating OSK field harden (planned)

**Theme:** typing into *other* desktop apps must be reliable enough to demo, not a new control family.

**In**

- No-activate soak: first tap, candidate bar, settings flyout must not steal focus from Notepad / browser
- Honest limits in Gallery + [on-screen-keyboard.md](on-screen-keyboard.md): UIPI / elevated targets / UWP / games may ignore `SendInput`
- System-wide IME: preedit stays on OSK bar; commits inject; document Backspace / Enter / arrows
- Gallery checklist: floating + system-wide vs dock (in-app only)

**Out**

- Linux / Wayland system-wide inject (security model — parking lot)
- Full TSF / IMM desktop IME
- Promote OSK to stable (that is **1.87**)

### 1.84 — Consumer floating-OSK recipe (planned)

**Theme:** apps that are not the Gallery can host the same window.

**In**

- Recipe / tiny example: `OnScreenKeyboardWindow` beside `examples/gallery-shell` (not copy the full Gallery tree)
- Packaging note: Keyman Core is **in the clone**; WebView2 still optional NuGet fetch
- Consumer `main`: call `openFloating()`; pin `systemWide` only on Windows

**Out**

- New IME languages / `.kmx` packs
- Official vcpkg/Conan ports (that is **1.88** or parking)

### 1.85 — Accessibility wave 3 (planned)

**Theme:** focus return / live regions — slipped past 1.69 Theme prefs. One a11y slice, not a redesign.

**In** (pick a tight set at start of the minor)

- Dialog / flyout **focus return** to the opener
- Live-region pattern for `InfoBar` / `ImeCandidateBar` where missing
- Gallery Accessibility page checklist refresh

**Out**

- Full catalog audit as a mega-minor
- OSK promote (**1.87**)

### 1.86 — Leftover field P0s (planned)

If 1.83…1.85 land and there is **no** field P0 (DPI / tray / WebView2 / packaging / IME regression): **skip this minor** and go to **1.87**. Do not invent work.

**In (only if a P0 exists)**

- One named field regression, documented in [upgrade-notes.md](upgrade-notes.md)

### 1.87 — OSK / IME green soak + promote (planned)

**Theme:** the promote that **1.74** wrote a checklist for and did **not** ship.

**In**

- Re-run 1.74 Gallery language-matrix + floating / system-wide checklist; record **green** or slip
- If green: list `OnScreenKeyboard` / `OnScreenKeyboardWindow` / `KeyboardEngine` / `ImeCandidateBar` on [stable-api.md](stable-api.md) with honest Windows system-wide limits
- If not green: stay experimental; slip promote — **do not** start 2.00 to “force” it

**Out**

- Japanese kanji / cloud lexicon / handwriting (parking lot)
- Linux system-wide inject

### 1.88 — Consumer packaging (planned)

**Theme:** `find_package` / shared kit beyond the **1.61** sketch — only if we own the promise.

**In**

- Documented `find_package(QWinUI3)` path that a clean clone can follow ([packaging-consumer.md](packaging-consumer.md))
- Optional: owned vcpkg **or** Conan sketch — not both unless one is already used in CI

**Out**

- Official ports as a supported product if nobody will maintain them (keep parking)

### 1.89 — 1.xx close-out checkpoint (planned)

**Theme:** same job as [checkpoint-178.md](checkpoint-178.md), for the **end** of 1.xx.

**In**

- Publish `docs/checkpoint-190.md` (or 1.89 — name at ship time): docs-link OK, Gallery catalog count, freeze still accurate
- Inventory **what 2.00 is allowed to break** (Theme names, shell aliases, Qt floor)
- Confirm OSK promote status from 1.87

**Out**

- Breaking remaps (those wait for **2.00**)

### 1.90 — Last 1.xx hold (planned)

**Theme:** one minor of **warnings and docs**, no silent breaks.

**In**

- [upgrade-notes.md](upgrade-notes.md) draft **1.90 → 2.00** (Qt floor, remaps, removed experimentals)
- Gallery / README: “1.xx freeze ends at 2.00”
- Optional compile-time or runtime notices behind a switch — **defaults stay 1.xx compatible**

**Out**

- Actually dropping Qt 6.5 or renaming `Theme.bgCard` (that is **2.00**)

---

## 2.00 — Breaking baseline (planned, after 1.90)

**Gate:** **1.90 shipped**. Do not open 2.00 PRs while 1.83…1.90 are unfinished.

**Theme:** lift the [1.xx freeze](compatibility-1xx.md) in **one** named major. Small enough to finish. Follow-ups are `2.01+`.

### Breaks (in)

| Area | 2.00 intent |
|------|-------------|
| **Qt floor** | Drop **Qt 6.5**. Floor **6.8 LTS** (forward 6.10+). Update [qt-version-compat.md](qt-version-compat.md) + CI matrix. |
| **Theme** | Only remaps listed in the 1.89 inventory (example: collapse duplicate stroke/focus aliases). **Not** a Fluent 2 redesign. |
| **Shell** | Remove Gallery-era aliases that 1.xx kept for compatibility; keep `StandardWindow` / `NavigationWindow` / `WindowHelper` as the contract. |
| **Experimental leftover** | Types still experimental after 1.87 either promote, move to an explicit experimental module, or **remove** with an upgrade-notes row. |
| **Packaging** | `QWINUI3_VERSION` `2.00`; shared/static defaults only change if 1.88 already documented the new contract. |

### Does not ship in 2.00 (out)

- Fluent 2 / full visual redesign → parking / **2.01+**
- macOS first-class → parking / **2.01+**
- Linux system-wide OSK inject
- Full Lottie, Figma tokens, every-locale portal
- Qt Virtual Keyboard (never)
- Re-adding Gallery visual-smoke as a default CI gate

### Consumer upgrade (sketch)

Apps on **1.90** read [upgrade-notes.md](upgrade-notes.md) **1.90 → 2.00**, raise Qt to 6.8+, apply the remap table, rebuild Release. Apps that cannot leave Qt 6.5 **stay on 1.90**.

### After `2.00`

`2.01+` are ordinary minors again (one theme each). Candidates, not a dump:

| Slice | Notes |
|-------|--------|
| **2.01+** | Field harden on the new floor |
| **2.01+** | macOS first-class — only if scheduled |
| **2.01+** | Fluent 2 Style fork — only if scheduled |
| **2.01+** | Official vcpkg/Conan if 1.88 did not own them |

---

## Parking lot

Unscheduled; pick up only inside a named `1.xx` or `2.xx` minor (or never). Clarified at **1.60** ([checkpoint-160.md](checkpoint-160.md)):

- macOS first-class (**not** 2.00 by default)
- Figma / design-token pipeline
- Full Fluent visual redesign / Fluent 2 Style fork (**not** 2.00 by default)
- Screenshot diffs for **every** Gallery page (1.62 subset **removed** in 1.82; not a default CI gate)
- Community translation portal / every-locale coverage (seeds `zh_CN` / `ja_JP` enough for 1.xx)
- Full Lottie runtime as a hard product dependency (thin glyph path shipped in 1.53)
- New chart engines / WebGL
- Official vcpkg/Conan ports as supported products (sketch may ship in 1.61 / productize in **1.88**)
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
| [stable-api.md](stable-api.md) | Stable vs experimental |
| [maturity-1xx.md](maturity-1xx.md) | 1.51 maturity checkpoint |
| [checkpoint-160.md](checkpoint-160.md) | 1.60 mid-horizon checkpoint |
| [checkpoint-178.md](checkpoint-178.md) | 1.78 long-horizon checkpoint |
| [compatibility-1xx.md](compatibility-1xx.md) | 1.xx will-not-break freeze (ends at **2.00**) |
| [upgrade-notes.md](upgrade-notes.md) | Consumer upgrades; 2.00 sketch after 1.90 |
| [components.md](components.md) | Control index |
| [conventions.md](conventions.md) | A11y / QML rules |
| [qt-version-compat.md](qt-version-compat.md) | Qt multi-version shims |
| [on-screen-keyboard.md](on-screen-keyboard.md) | 1.70…1.82 OSK → IME → floating / system-wide |
| [ROADMAP.md](../ROADMAP.md) | Canonical plan (repo root) |
