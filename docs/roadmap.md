# QWinUI3 Roadmap

**Current:** **1.38**
**Next up:** **1.31** (Graphics & backend notes)
**Planned through:** **1.50** (1.xx maturity checkpoint)  
**Qt:** 6.5+ (recommended 6.8 LTS) — [qt-version-compat.md](qt-version-compat.md)

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

## Shipped — `1.01` … `1.38`

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

**Shipped:** [`.github/workflows/smoke.yml`](../.github/workflows/smoke.yml); `qwinui3_gallery --smoke`; [ci-smoke.md](ci-smoke.md); Windows QPA coerce; product version `1.06`.

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

**Shipped:** [`.github/workflows/qt-compat.yml`](../.github/workflows/qt-compat.yml) Linux Gallery Release matrix (6.5.3 / 6.8.3 / 6.10.0); [qt-version-compat.md](qt-version-compat.md) CI section; smoke stays on 6.8; product version `1.14`.

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

---

## Late path — planned `1.39` … `1.40`

Still **1.xx**. Schedule after mid path is mostly done; order can flex.

### 1.39 — Gallery perf & startup

**Why:** Cold start and catalog weight grow with every page—pairs with 1.25 handbook.

**In scope**

- Catalog lazy load / defer heavy pages; measure and document cold-start tips.
- Keep `--smoke` coverage without loading the world.

**Out of scope**

- Rewriting Gallery as a separate product; binary size obsession.

**Exit criteria**

- Measurable startup improvement or documented “expected” budget; smoke still covers critical pages.

---

### 1.40 — Compatibility freeze prep

**Why:** Before any future 2.00 talk, publish what 1.xx will keep compatible.

**In scope**

- “Will not break” contract for Theme tokens, shell APIs, and stable controls.
- Consumer upgrade notes template; link from README/stable-api.

**Out of scope**

- Starting 2.00; cutting Qt floors.

**Exit criteria**

- Compatibility doc published; used as the gate for later 1.4x changes.

---

## Horizon — planned `1.41` … `1.50`

Still **1.xx**. Aim for maturity of the 1.line—not a soft 2.00. One theme per `YY`.

### 1.41 — Drag-drop & clipboard recipes

**Why:** FileDropZone / clipboard helpers exist; apps need copy-ready DnD + paste patterns.

**In scope**

- Document FileDropZone, drag mime, and `WindowHelper` clipboard helpers; Gallery demos tightened.
- `docs/drag-drop.md` (or system-integration chapter).

**Out of scope**

- Full OLE/complex Windows shell DnD productization.

**Exit criteria**

- Recipe covers file drop + text clipboard on Win/Linux notes.

---

### 1.42 — TwoPaneView & adaptive layout

**Why:** TwoPaneView / responsive shells need a LoB recipe beside density (1.30).

**In scope**

- Narrow/wide breakpoints, list–detail with TwoPaneView; Gallery page polish.
- Extend navigation or density docs with adaptive layout section.

**Out of scope**

- Phone/tablet OS shells; new layout engine.

**Exit criteria**

- One documented adaptive pattern; Gallery demo matches it.

---

### 1.43 — Color, contrast & theme diagnostics

**Why:** Branding (1.09) and a11y need a stronger “is my accent OK?” story.

**In scope**

- Contrast guidance, accent preview diagnostics, high-contrast callouts.
- Gallery Theme overrides / Accessibility cross-links.

**Out of scope**

- Automated WCAG certification product.

**Exit criteria**

- Diagnostic recipe in docs; Gallery shows at least one contrast check path.

---

### 1.44 — Keyboard-first app cookbook

**Why:** Shortcuts, CommandPalette (1.15), and focus rings need one end-to-end keyboard app story.

**In scope**

- Cookbook: global shortcuts, palette, dialog Esc/Enter, list roving tabindex notes.
- Gallery keyboard tour page or Settings + Commands cross-links.

**Out of scope**

- Custom shortcut editor control as a product.

**Exit criteria**

- Cookbook published; critical Gallery flows keyboard-completable per checklist.

---

### 1.45 — Localization packs deepen

**Why:** 1.13 seeded translations; apps need Gallery/string extraction guidance and one extra locale path.

**In scope**

- Expand `translations/` workflow docs; optional second Gallery language pack if maintainable.
- RTL regression pass on shells after string growth.

**Out of scope**

- Translating every component string into many languages.

**Exit criteria**

- Documented lupdate/lrelease path; at least the seed locale builds in CI or documented manual step.

---

### 1.46 — Shared library redistribute polish

**Why:** `QWINUI3_BUILD_SHARED` and consumer zips need a cleaner DLL/.so story after 1.12.

**In scope**

- Shared vs static matrix, windeploy/linuxdeploy notes, strip-restricted modules reminder.
- Extend [packaging-consumer.md](packaging-consumer.md).

**Out of scope**

- Conan/vcpkg official ports as a commitment (parking lot unless trivial).

**Exit criteria**

- Shared Release artifact documented and smoke-tested on Win + Linux.

---

### 1.47 — Snap layouts & windowing extras

**Why:** Win11 snap layouts / shell extras (1.17) deserve a focused polish pass with Gallery demos.

**In scope**

- Snap layouts toggle UX, taskbar progress recipes, attention/reveal callouts.
- Refresh [shell-extras.md](shell-extras.md); Linux “n/a” matrix kept honest.

**Out of scope**

- Implementing snap layouts on Wayland compositors.

**Exit criteria**

- Documented Win-only extras with Gallery System Integration demos green.

---

### 1.48 — Modal stack & ContentDialogQueue deepen

**Why:** Queued dialogs (1.16) need multi-dialog / owner-window recipes for LoB apps.

**In scope**

- Queue ordering, owner/transient rules, Esc cancel patterns; Gallery stress demos.
- Extend [dialogs-flyouts.md](dialogs-flyouts.md).

**Out of scope**

- Replacing Qt Quick Dialog entirely; non-modal sheet redesign.

**Exit criteria**

- Recipe for 2+ queued dialogs; smoke or Gallery path covers the happy case.

---

### 1.49 — Extractable Gallery shell template

**Why:** Integrators copy Gallery chrome; make a thin “app shell” example from proven Gallery patterns.

**In scope**

- Small example: NavigationWindow + settings + one content page, Bootstrap main, persistence key.
- README “start from Gallery shell” row; keep it smaller than Gallery itself.

**Out of scope**

- Splitting Gallery into a multi-crate monorepo; removing Gallery.

**Exit criteria**

- Example builds in Release; docs say what to delete vs keep.

---

### 1.50 — 1.xx maturity checkpoint

**Why:** Cap the planned 1.line with a deliberate “where we are” release—not 2.00.

**In scope**

- Audit stable-api vs Gallery; refresh ROADMAP shipped vs deferred; compatibility doc (1.40) revisited.
- Fix P0 doc/link rot; optional “LTS-style” note: prefer harden over new surfaces for a while.

**Out of scope**

- Declaring 2.00; freezing all experimental forever.

**Exit criteria**

- Published checkpoint notes in ROADMAP/README; open 1.51+ only for field-driven slices or park work.

---

## After `1.50`

Still **1.xx** if field needs dictate (`1.51`…)—or pause on polish. **Do not** treat 1.50 as permission to start **2.00**.

Unscheduled follow-ups (pick only inside a named minor):

| Candidate | Notes |
|-----------|--------|
| **1.51+ field fixes** | Portal / DPI / tray / WebView2 regressions from users |
| **Extra locale packs** | Only if 1.45 workflow stays cheap |
| **vcpkg / Conan sketches** | Packaging experiments—not a product promise |

Order remains flexible; do not bundle into mega-minors.

---

## Far future — 2.00 (not scheduled)

**Do not start 2.00 work while 1.xx still absorbs polish.**

Consider 2.00 only if several of these become true:

- Need breaking Theme/API renames that cannot stay compatible in 1.xx  
- Need a new packaging/ABI contract that breaks 1.xx consumers  
- Need to drop an old Qt floor or OS policy in a breaking way  

Until then: **stay on 1.xx**, bump `YY` for each slice. Prefer finishing through **1.50** before even drafting 2.00 scope.

---

## Parking lot

Unscheduled; pick up only inside a named `1.xx` minor (or never):

- macOS first-class  
- Figma / design-token pipeline  
- Full Fluent visual redesign / Fluent 2 Style fork  
- Screenshot diffs for every Gallery page  
- Extra Gallery language packs (beyond 1.45 seed path)  
- New chart engines / WebGL  
- Official vcpkg/Conan ports as supported products  

---

## Related

| Doc | Role |
|-----|------|
| [README.md](../README.md) | Overview |
| [stable-api.md](stable-api.md) | Stable vs experimental |
| [components.md](components.md) | Control index |
| [conventions.md](conventions.md) | A11y / QML rules |
| [qt-version-compat.md](qt-version-compat.md) | Qt multi-version shims |
| [ROADMAP.md](../ROADMAP.md) | Canonical plan (repo root) |
