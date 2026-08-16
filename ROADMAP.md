# QWinUI3 Roadmap

**Current:** **1.20**  
**Next up:** **1.21** (Media optional Multimedia)  
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

## Shipped — `1.01` … `1.20`

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

---

## Mid path — planned `1.21` … `1.30`

Start after **1.20** (this band). Same rules: one theme per `YY`, still **not** `2.00`.

### 1.21 — Media (optional Multimedia)

**Why:** `MediaPlayerElement` is experimental; LoB apps need a clear optional-deps story.

**In scope**

- Document Qt Multimedia as **optional**; graceful EmptyState when missing.
- Polish controls chrome, keyboard, and Theme tokens on the Gallery Media page.
- Short `docs/media.md`; decide promote vs remain experimental.

**Out of scope**

- Full media suite (playlist product, codecs matrix); non-Qt backends.

**Exit criteria**

- Recipe doc + stable-api row update; Gallery works with and without Multimedia.

---

### 1.22 — Animations & transitions recipe

**Why:** `ConnectedAnimation*` and theme transitions exist but lack a copy-ready story.

**In scope**

- Document ConnectedAnimation patterns (list → detail, shell page enter).
- Theme light/dark / accent transition guidance; reduce jank on high-traffic shells.
- Gallery demo page polish; `docs/animations.md`.

**Out of scope**

- New animation engine; Fluent motion redesign of every control.

**Exit criteria**

- Recipe doc; demos match documented APIs; experimental note kept or promote if solid.

---

### 1.23 — Charts promote wave 2

**Why:** 1.11 aligns names; apps will want a **named** stable chart subset after soak.

**In scope**

- Promote a small subset (e.g. Line/Bar/Donut + one gauge + `KpiTile`/`ChartCard`) **only if** 1.11 exit criteria held in the field.
- Update [stable-api.md](docs/stable-api.md) + [charts.md](docs/charts.md); leave niche charts experimental.

**Out of scope**

- Promoting the entire chart catalog; new chart types.

**Exit criteria**

- Explicit promote list; dashboard example uses only stable names for those types.

---

### 1.24 — Linux persistent tray (StatusNotifierItem)

**Why:** 1.10 TrayIcon is Windows-strong; Linux often falls back to notify-send only.

**In scope**

- StatusNotifierItem (or equivalent) path for persistent tray + menu actions where DE supports it.
- Failure matrix in [system-integration.md](docs/system-integration.md) / platform-linux docs.
- Gallery System Integration Linux notes.

**Out of scope**

- macOS tray; reinventing every DE’s indicator protocol forever.

**Exit criteria**

- Documented Win vs Linux tray capability table; at least one Linux DE proven in docs.

---

### 1.25 — Performance handbook

**Why:** Large models, DataTable, and chart pages need guidance before apps blame the kit.

**In scope**

- `docs/performance.md`: virtualization, model roles, chart data size, Gallery “heavy page” tips.
- Cheap wins only (e.g. obvious ListView reuse / defer loads)—no rewrite of Extras.

**Out of scope**

- Profiler product; rewriting chart engines for GPU.

**Exit criteria**

- Handbook linked from README/stable-api; one Gallery callout for a heavy page.

---

### 1.26 — Example app templates

**Why:** Beyond nav-settings / settings-cards / dashboard, integrators want more copy-ready shapes.

**In scope**

- One or two extra examples (e.g. master–detail LoB shell, or settings + FormLayout app).
- README “start from” table updated; keep each example small.

**Out of scope**

- Full CRM product; many half-finished templates.

**Exit criteria**

- New example(s) build in Release CI or documented local-only with reason; README links work.

---

### 1.27 — Navigation & TabView deepen

**Why:** `NavigationView` / tab shells are the default app frame but less recipe-documented than forms/tables.

**In scope**

- Pane modes, footer, Back stack, compact/overlay recipes; TabView vs NavigationView when-to-use.
- `docs/navigation.md`; Accessible names on demo path; Gallery polish.

**Out of scope**

- Tear-out window productization (stay experimental); new shell frameworks.

**Exit criteria**

- Recipe doc; examples/nav-settings aligned with documented patterns.

---

### 1.28 — Input & pickers consistency

**Why:** NumberBox / Date-Calendar / Color / Time pickers exist across Style + Extras with uneven docs.

**In scope**

- Inventory high-traffic pickers; align headers, validation, Theme density.
- Short `docs/pickers.md`; Gallery cross-links; FormLayout pairing notes.

**Out of scope**

- New picker controls; replacing Qt Calendar entirely.

**Exit criteria**

- Recipe doc; listed pickers behave consistently on the Gallery path.

---

### 1.29 — Icons & FluentIcons cookbook

**Why:** Apps need a reliable symbol story (FluentIcons + Theme) without inventing asset pipelines.

**In scope**

- Document FluentIcons API, sizing, Theme color, Gallery icon browser tips.
- `docs/icons.md`; fix obvious missing names on high-traffic chrome.

**Out of scope**

- Figma token pipeline (parking lot); shipping a second icon font.

**Exit criteria**

- Cookbook + Gallery Icon page matches documented usage.

---

### 1.30 — Density, typography & responsive shells

**Why:** Theme density exists (1.09 branding); LoB apps need compact vs comfortable + narrow-window recipes.

**In scope**

- Document density tokens, type scale, and shell behavior at narrow widths.
- Gallery Theme / Settings density demos tightened; extend [theme-overrides.md](docs/theme-overrides.md) or `docs/density.md`.

**Out of scope**

- Full Fluent 2 visual redesign; mobile-first phone shells.

**Exit criteria**

- Recipe covers density + one responsive shell pattern; no LTR regressions.

---

## Later `1.xx` (after ~1.30)

Still **1.xx**—schedule as `1.31`, `1.32`, … when mid path is mostly done:

| Candidate | Notes |
|-----------|--------|
| **1.31 Graphics & backend notes** | D3D11 / OpenGL / RHI tips for Gallery & consumers — extend [graphics-backend.md](docs/graphics-backend.md) |
| **1.32 Window shells matrix refresh** | Re-soak StandardWindow / Mica / Wayland after 1.03–1.04 drift |
| **1.33 Tree & hierarchical data** | TreeView / nested ItemsView recipes + docs |
| **1.34 Feedback surfaces wave 2** | InfoBar / Toast / TeachingTip / Progress deepen after 1.16 |
| **1.35 Creator kit polish** | Qt Creator wizard / kit docs beyond 1.12 packaging |
| **1.36 Docs site IA** | MkDocs nav / search / “recipe hub” without rewriting the kit |
| **1.37 Experimental promote sweep** | Batch promote long-soaked types; prune dead experimental |
| **1.38 Linux Wayland edge cases** | Portal / backdrop / tray follow-ups from field reports |
| **1.39 Gallery perf & startup** | Cold start, catalog lazy load — pairs with 1.25 |
| **1.40 Compatibility freeze prep** | Document “what we will not break” before any future 2.00 discussion |

Order remains flexible; do not bundle into mega-minors.

---

## Far future — 2.00 (not scheduled)

**Do not start 2.00 work while 1.xx still absorbs polish.**

Consider 2.00 only if several of these become true:

- Need breaking Theme/API renames that cannot stay compatible in 1.xx  
- Need a new packaging/ABI contract that breaks 1.xx consumers  
- Need to drop an old Qt floor or OS policy in a breaking way  

Until then: **stay on 1.xx**, bump `YY` for each slice.

---

## Parking lot

Unscheduled; pick up only inside a named `1.xx` minor (or never):

- macOS first-class  
- Figma / design-token pipeline  
- Full Fluent visual redesign / Fluent 2 Style fork  
- Screenshot diffs for every Gallery page  
- Extra Gallery language packs  
- New chart engines / WebGL  

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
