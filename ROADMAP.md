# QWinUI3 Roadmap

**Current:** **1.10**  
**Next up:** **1.11** (charts & gauges API consistency)  
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

## Shipped — `1.01` … `1.10`

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

---

## Near path — planned `1.11` … `1.20`

Order is intentional but **flexible**: if a soak or customer pain appears, swap two adjacent minors—do not merge five themes into one `YY`.

### 1.11 — Charts & gauges API consistency

**Why:** Large experimental set powers `examples/dashboard`; LoB apps need one naming/docs story before any promote-to-stable.

**In scope**

- Inventory chart/gauge public props (`values` / `series` / `bars`, `unit` / `valueUnit`, `interactive` / `isInteractive`, …).
- Align **naming + docs** on the high-traffic subset (Line/Bar/Area/Donut/Pie + Arc/Radial/Linear gauges + `KpiTile` / `ChartCard` / `ChartLegend`).
- Short recipe doc (e.g. `docs/charts.md`): when to use which chart; Theme accent usage; performance caveats.
- Gallery: one “API consistency” callout or tightened dashboard page—no new chart engines.

**Out of scope**

- New chart types; WebGL/custom engines; promoting the whole set to stable in one shot (promote a **named subset** only if exit criteria are met).

**Exit criteria**

- Recipe doc + stable-api note (which charts remain experimental vs any newly promoted).
- Dashboard / Gallery demos use the aligned names.

---

### 1.12 — Consumer packaging & CMake docs

**Why:** Integrators need a copy-paste path beyond “open this monorepo.”

**In scope**

- Document shared-lib / static consume paths (`package_release_libs.py`, `CMAKE_PREFIX_PATH`, QML import).
- Minimal consumer `CMakeLists.txt` / qmake-or-Qt Creator kit notes; link from README + [qt-creator.md](docs/qt-creator.md).
- Clarify what Release CI already ships on `v*` tags.

**Out of scope**

- New packaging formats; rewriting the entire export graph; macOS packages.

**Exit criteria**

- One page (e.g. `docs/packaging-consumer.md`) a third-party app can follow end-to-end on Windows + Linux.

---

### 1.13 — i18n / RTL baseline for samples

**Why:** Gallery/examples already use `qsTr`; apps need a known LayoutMirroring / RTL baseline.

**In scope**

- Document `qsTr` + `.ts` workflow for Gallery/examples.
- One RTL / `LayoutMirroring.enabled` Gallery page or Settings toggle that exercises shells + forms + nav.
- Fix obvious hard-coded LTR assumptions on the high-traffic path (nav, settings cards, FormLayout left headers).

**Out of scope**

- Full translation of every Gallery string; shipping many language packs; BiDi for every chart label.

**Exit criteria**

- Recipe note in docs + one demo page; no regressions on LTR default.

---

### 1.14 — Qt 6.5 / 6.8 / 6.10 compat CI

**Why:** Floor is 6.5; CI is pinned to 6.8. Catch shim drift early without turning smoke into a matrix forever.

**In scope**

- Extra workflow or matrix job: configure + build Gallery (Release) on **6.5** and **6.10** (or latest 6.10.x) in addition to 6.8.
- Document failures against [qt-version-compat.md](docs/qt-version-compat.md); fix only blockers in Compat shims.

**Out of scope**

- Supporting every patch of every Qt; Debug builds; expanding smoke to screenshot suites.

**Exit criteria**

- Documented CI job green (or known allowed-fail with issue link); compat doc updated.

---

### 1.15 — Command surfaces deepen

**Why:** `CommandBar` / `CommandPalette` / menus are LoB-critical and Gallery-backed but less recipe-documented than forms/tables.

**In scope**

- Keyboard / focus recipes for CommandPalette + CommandBar + MenuFlyout / MenuBar.
- Short `docs/commands.md`; align Accessible names on the demo path.
- Gallery polish only—no new command framework.

**Out of scope**

- Ribbon redesign; VS-style tool windows product.

**Exit criteria**

- Recipe doc + Gallery pages match the documented keyboard model.

---

### 1.16 — Dialogs & flyouts consistency

**Why:** ContentDialog / queues / TeachingTip / Flyout / Drawer already exist; apps need one modal vs light-dismiss story.

**In scope**

- Document when to use ContentDialog vs Flyout vs TeachingTip vs Drawer.
- Harden queue + Esc / default button patterns if gaps remain after 1.02/1.08.
- Gallery cross-links; small recipe doc.

**Out of scope**

- New dialog engine; replacing QQC Dialog entirely.

**Exit criteria**

- Recipe doc; stable-api unchanged unless a type is explicitly promoted.

---

### 1.17 — Shell extras productize (taskbar / idle / attention)

**Why:** System Integration Gallery demos these; 1.10 left them experimental.

**In scope**

- Productize a **small** WindowHelper subset: taskbar progress overlay, idle inhibit, requestUserAttention, reveal-in-folder—docs + failure matrix.
- Extend [system-integration.md](docs/system-integration.md) or add `docs/shell-extras.md`.
- Promote only APIs that meet exit criteria.

**Out of scope**

- Full taskbar thumbnail toolbars; Jump Lists redesign; Snap Layouts deep promote (keep demo unless cheap).

**Exit criteria**

- Documented Win/Linux matrix; listed stable helpers with Gallery proof.

---

### 1.18 — WebView2 soak → stable candidate

**Why:** 1.05 shipped the recipe; still experimental. LoB apps need a promote-or-keep decision.

**In scope**

- Soak checklist (focus, DPI, missing Runtime, lifecycle) against current Edge WebView2.
- Fill gaps from soak; update [webview2.md](docs/webview2.md).
- Promote `WebView2Host` to stable **only if** checklist is green; otherwise keep experimental with dated notes.

**Out of scope**

- Qt WebEngine; multi-profile browser product; non-Windows ports.

**Exit criteria**

- Explicit stable-api row update (promote or “remain experimental until …”).

---

### 1.19 — Accessibility wave 2

**Why:** 1.02 covered the high-traffic path; [accessibility.md](docs/accessibility.md) still tracks Medium/Low gaps.

**In scope**

- Second wave: DataTable / ListDetails / ItemsView / Form fields / CommandPalette / dialogs—names, keyboard, severity docs.
- Update accessibility checklist + Gallery Accessibility page.

**Out of scope**

- Charts Accessible completeness (unless cheap); Orca-specific engineering beyond Qt.

**Exit criteria**

- Checklist items for wave-2 surfaces marked Done or severity-tracked with owners.

---

### 1.20 — Gallery catalog UX & smoke coverage

**Why:** ~150+ pages; discovery and regression gate should grow without a screenshot farm.

**In scope**

- Catalog search / favorites / “recently shipped” affordances if missing.
- Expand smoke or a lightweight page-load list for critical pages (still no pixel diffs).
- Docs index hygiene for recipe pages.

**Out of scope**

- Screenshot diffs for every page (parking lot); rewriting Gallery architecture.

**Exit criteria**

- Measurable catalog improvement + documented smoke coverage set.

---

## Later `1.xx` (after ~1.20)

Parked for when the near path is mostly done—still **not** `2.00`:

| Candidate | Notes |
|-----------|--------|
| **Media** | `MediaPlayerElement` optional Multimedia polish + docs |
| **Animations** | ConnectedAnimation / theme transitions recipe pass |
| **Charts promote wave 2** | Promote more chart types after 1.11 soak |
| **Linux tray StatusNotifierItem** | Persistent tray beyond notify-send |
| **Performance handbook** | Virtualization / large models / Gallery heavy pages |
| **Example app templates** | Extra copy-ready apps beyond nav/settings/dashboard |

Schedule as `1.21`, `1.22`, … — one slice per minor.

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
