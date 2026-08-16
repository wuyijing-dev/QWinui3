# QWinUI3 Roadmap

**Current:** **1.22**  
**Next up:** **1.23** (charts promote wave 2)  
**Planned through:** **1.50** (1.xx maturity checkpoint)  
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

## Shipped — `1.01` … `1.22`

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

---

## Mid path — planned `1.23` … `1.30`

Same rules: one theme per `YY`, still **not** `2.00`.

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

## Late path — planned `1.31` … `1.40`

Still **1.xx**. Schedule after mid path is mostly done; order can flex.

### 1.31 — Graphics & backend notes

**Why:** Gallery RHI preference and consumer GPUs still surprise integrators (OpenGL vs D3D11/12).

**In scope**

- Extend [graphics-backend.md](docs/graphics-backend.md): recommended backends per OS, alpha/backdrop caveats, `--rhi` / Settings restart story.
- Gallery Settings callouts; one consumer README pointer.

**Out of scope**

- New RHI backends; rewriting Scene Graph.

**Exit criteria**

- Handbook answers “which backend should I ship?”; no silent default regressions on Windows.

---

### 1.32 — Window shells matrix refresh

**Why:** Geometry persistence, Bootstrap, and Wayland drift since 1.03–1.04 need a re-soak.

**In scope**

- Re-test StandardWindow / ShellWindow / Mica / Acrylic / Solid on Win + Linux; refresh [window-chrome.md](docs/window-chrome.md) / [window-shells.md](docs/window-shells.md).
- Document `geometryPersistenceKey` + multi-monitor clamp as the supported recipe.

**Out of scope**

- New shell paradigms; macOS title-bar productization.

**Exit criteria**

- Matrix table updated; Gallery Window paradigm page matches docs.

---

### 1.33 — Tree & hierarchical data

**Why:** TreeView / nested lists ship but lack a LoB recipe next to DataTable (1.07).

**In scope**

- TreeView / nested ItemsView selection, expand/collapse keyboard, Accessible names.
- `docs/tree-data.md` (or extend [data-collections.md](docs/data-collections.md)); Gallery polish.

**Out of scope**

- Virtualized million-node trees; new tree control family.

**Exit criteria**

- Recipe + one Gallery page that follows it end-to-end.

---

### 1.34 — Feedback surfaces wave 2

**Why:** InfoBar / Toast / TeachingTip / Progress exist; 1.16 covered dialogs—feedback needs the same depth.

**In scope**

- Queueing, severity, focus return, and when-to-use matrix; Gallery callouts.
- Short `docs/feedback.md` or extend existing tips docs.

**Out of scope**

- Redesigning Toast chrome; OS notification center replacement (see 1.10).

**Exit criteria**

- Documented patterns; listed surfaces consistent on Gallery demos.

---

### 1.35 — Creator kit polish

**Why:** 1.12 packaging helps CMake consumers; Creator wizards/kits still feel secondary.

**In scope**

- Qt Creator kit / import docs beyond packaging-consumer; example “open in Creator” path.
- Fix stale `.pro` / kit screenshots if any.

**Out of scope**

- Shipping a full Creator plugin product.

**Exit criteria**

- New engineer can open Gallery or an example from Creator using only docs.

---

### 1.36 — Docs site IA

**Why:** Recipe count grows; MkDocs nav/search need a “start here” hub without rewriting the kit.

**In scope**

- Recipe hub index, clearer MkDocs sections, cross-links from README/stable-api.
- Prune duplicate or orphan pages discovered in the pass.

**Out of scope**

- New docs product (Storybook); translating the whole site.

**Exit criteria**

- Hub page live; top recipes reachable in ≤2 clicks from README.

---

### 1.37 — Experimental promote sweep

**Why:** Long-soaked experimental types accumulate; stable-api should reflect reality.

**In scope**

- Batch promote candidates with soak evidence; prune or document “won’t promote” items.
- Update [stable-api.md](docs/stable-api.md) + Gallery badges.

**Out of scope**

- Promoting everything; breaking renames (that’s 2.00 territory).

**Exit criteria**

- Explicit promote/defer list shipped; no silent status flips.

---

### 1.38 — Linux Wayland edge cases

**Why:** Field reports after 1.03/1.24/1.32 will need a focused Wayland/portal pass.

**In scope**

- Portal file/open, backdrop, SSD, tray follow-ups; extend [platform-linux-wayland.md](docs/platform-linux-wayland.md).
- Gallery System Integration Linux notes.

**Out of scope**

- Supporting every compositor forever; X11-only new features.

**Exit criteria**

- Documented failure matrix for the issues taken in-scope; CI/smoke still green on Linux.

---

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
- Extend [packaging-consumer.md](docs/packaging-consumer.md).

**Out of scope**

- Conan/vcpkg official ports as a commitment (parking lot unless trivial).

**Exit criteria**

- Shared Release artifact documented and smoke-tested on Win + Linux.

---

### 1.47 — Snap layouts & windowing extras

**Why:** Win11 snap layouts / shell extras (1.17) deserve a focused polish pass with Gallery demos.

**In scope**

- Snap layouts toggle UX, taskbar progress recipes, attention/reveal callouts.
- Refresh [shell-extras.md](docs/shell-extras.md); Linux “n/a” matrix kept honest.

**Out of scope**

- Implementing snap layouts on Wayland compositors.

**Exit criteria**

- Documented Win-only extras with Gallery System Integration demos green.

---

### 1.48 — Modal stack & ContentDialogQueue deepen

**Why:** Queued dialogs (1.16) need multi-dialog / owner-window recipes for LoB apps.

**In scope**

- Queue ordering, owner/transient rules, Esc cancel patterns; Gallery stress demos.
- Extend [dialogs-flyouts.md](docs/dialogs-flyouts.md).

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
| [README.md](README.md) | Overview |
| [docs/stable-api.md](docs/stable-api.md) | Stable vs experimental |
| [docs/components.md](docs/components.md) | Control index |
| [docs/conventions.md](docs/conventions.md) | A11y / QML rules |
| [docs/qt-version-compat.md](docs/qt-version-compat.md) | Qt multi-version shims |
| [docs/roadmap.md](docs/roadmap.md) | Site copy of this plan |
