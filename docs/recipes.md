# Recipes hub (2.46 v2)

LoB how-tos for shipping with QWinUI3. Prefer these over inventing a second stack. Generated **control** pages live under [Component API](components.md). **Gallery:** last pane group **Recipes** → **Recipes hub** (also motion, a11y, system, media how-tos).

**Docs IA v2 (2.46):** [docs-ia-v2.md](docs-ia-v2.md) — MkDocs **Planning** + **Recipes** regroup; this hub mirrors Gallery rows.

---

## Planning & product expansion

| Doc | One-liner |
|-----|-----------|
| [Planning hub](planning/index.md) | Friction gate + expansion tracks (**2.51→3.00**) |
| [Friction log](planning/friction-log.md) | Open P0/P1 rows — post-**2.50** gate |
| [Roadmap strategy](planning/roadmap-strategy.md) | Phases through **3.00** |
| [Charts & dashboard arc](planning/expansion/charts-dashboard-arc.md) | New types + stable six deepen |
| [Component capabilities](planning/expansion/component-capabilities-expansion.md) | **All modules** — existing control API deepen |
| [Icons & dashboard](planning/expansion/icons-dashboard-expansion.md) | KPI / ChartCard symbols |

---

## 2.xx developer & stability

| Recipe | One-liner |
|--------|-----------|
| [Tranche-1 perf sign-off (2.49)](perf-signoff-2xx.md) | FL-008 partial — 2.x wave 5→8 summary |
| [Stable vs experimental clarity (2.51)](stable-clarity-251.md) | FL-004 queue closed — `lint_qml_imports.py` + Pitfalls |
| [First app in an hour (2.52)](first-app-252.md) | `examples/first-app/` + preview **DashboardShell** |
| [Linux top-3 parity (2.53)](linux-top3-253.md) | Nav shell clip + **sway** profile + FilePicker guard |
| [Files on Linux (2.57)](files-linux-257.md) | Portal parent fallback + reveal + drop reject UX |
| [Navigation mental model (2.56)](navigation-mental-model-256.md) | Back vs pane vs stack guardrails |
| [Forms unlike WinUI (2.55)](forms-unlike-winui-255.md) | Async validate + dialog queue priority |
| [Window chrome footguns (2.54)](window-chrome-footguns-254.md) | Geometry v2 + maximize hit-test refresh |
| [Field harden buffer (2.47)](field-harden-247.md) | Checkpoint P0/P1 triage — packaging picker + import guard |
| [Docs IA v2](docs-ia-v2.md) | MkDocs + hub regroup for **2.xx** docs (**2.46**) |
| [Developer diagnostics](developer-diagnostics.md) | FrameStats dev vs retail · `--retail-diagnostics` (**2.44**) |
| [Experimental sweep](experimental-sweep.md) | FL-004 verdict matrix + Gallery badges (**2.45**) |

---

## 2.xx controls & Gallery

| Recipe | One-liner |
|--------|-----------|
| [Dashboard compose decision (2.48)](dashboard-compose-decision.md) | FL-009 — deferred chart → stable six tree |
| [Gallery catalog expansion](gallery-catalog-expansion.md) | 2.21…2.38 findability matrix (**2.39**) |
| [Calendar view](calendar-view.md) | Experimental month grid (**2.31**) |
| [Items wrap grid](items-wrap-grid.md) | Experimental wrap layout (**2.24**) |
| [Style polish](style-polish.md) | Spot-check + polish notes (**2.32**) |
| [Multi-window onboarding](multi-window-onboarding.md) | Second-window recipe (**2.14** harden) |

**Stable API:** prefer types on [stable-api.md](stable-api.md). **1.xx freeze:** [compatibility-1xx.md](compatibility-1xx.md) · [upgrade-notes.md](upgrade-notes.md).

---

## Start building

| Recipe | One-liner |
|--------|-----------|
| [Qt Creator](qt-creator.md) | Open root CMakeLists → Gallery or example (no `.pro`) |
| [Consumer packaging](packaging-consumer.md) | Shared vs static / windeploy / strip (1.46) · `find_package` (1.61) |
| [vcpkg / Conan](packaging-vcpkg-conan.md) | Overlay port + Conan 2 recipe (**2.11**) |
| [1.xx compatibility](compatibility-1xx.md) | Will-not-break Theme / shells / stable controls (1.40 / 1.51) |
| [1.xx maturity checkpoint](maturity-1xx.md) | Where we are; harden-first posture (**1.51**) |
| [Upgrade notes](upgrade-notes.md) | Consumer checklist + template (1.40) |
| [Qt version compat](qt-version-compat.md) | 6.5+ / 6.8 LTS / CI matrix |
| [Conventions](conventions.md) | Radius, Accessible, Extras import |

---

## App shells & chrome

| Recipe | One-liner |
|--------|-----------|
| [Window shells](window-shells.md) | ShellWindow vs StandardWindow · multi-window (**1.56** · **2.14** harden) |
| [Window chrome](window-chrome.md) | DPI / backdrop / geometry failure modes |
| [High-DPI & multi-monitor](high-dpi.md) | DPR matrix · geometry clamp + setScreen (**1.58**) |
| [WindowHelper](window-helper.md) | Geometry persistence, backdrop, platform APIs |
| [AppWindow](window-appwindow.md) | Presenters / title-bar height |
| [Linux / Wayland](platform-linux-wayland.md) | CSD, Solid, portals, field matrix (1.38 / 1.68 / **1.79**) |
| [Graphics backend](graphics-backend.md) | RHI ship table · OpenGL for frost |
| [Transparency / DWM](window-transparency-dwm.md) | Gallery Solid policy · Mica notes |

---

## Navigation, forms, data

| Recipe | One-liner |
|--------|-----------|
| [Navigation & TabView](navigation.md) | Pane modes, Back, footer |
| [Carousel / FlipView](carousel-recipes.md) | PipsPager + SwipeView hosts · reducedMotion (**2.37**) |
| [Forms & settings](forms.md) | FormLayout validation + SettingsCard |
| [Settings persistence](settings-persistence.md) | QSettings / Settings · portable Ini · schemaVersion (**1.65**) |
| [Data collections](data-collections.md) | DataTable / ItemsView / ListDetailsView |
| [Tree & hierarchical](tree-data.md) | TreeView expand / a11y |
| [Input & pickers](pickers.md) | Number / date / time / color |
| [Density & responsive](density.md) | Compact metrics, narrow shells |
| [Touch, pen & pointer](touch-pointer.md) | Targets · scroll vs drag · pen notes (**1.57**) |
| [Adaptive layout](adaptive-layout.md) | TwoPaneView / ListDetailsView breakpoints (1.42) |
| [Theme overrides](theme-overrides.md) | Accent / density / branding · copy recipe (**1.69**) · wave 2 packs + ThemePrefs (**2.38**) |
| [Color & contrast](color-contrast.md) | AA diagnostics / high contrast (1.43) |
| [Icons & FluentIcons](icons.md) | Symbol font + micro-motion + AnimatedIcon (1.53) |
| [i18n / RTL](i18n-rtl.md) | qsTr + seed locales + LayoutMirroring · consumer lrelease (**2.12**) |

---

## Feedback, dialogs, commands

| Recipe | One-liner |
|--------|-----------|
| [Feedback surfaces](feedback.md) | InfoBar / Toast / TeachingTip / onboarding coach / Progress |
| [Dialogs & flyouts](dialogs-flyouts.md) | ContentDialogQueue FIFO / Esc (1.48) |
| [Commands & menus](commands.md) | CommandPalette / CommandBar / MenuFlyout |
| [Keyboard-first](keyboard.md) | Global chords → palette → dialogs → lists (1.44) |
| [On-screen keyboard](on-screen-keyboard.md) | Floating Win11 OSK + Windows system-wide (**1.83** harden); still experimental |
| [In-app search & AutoSuggest](search.md) | Suggest · filter-above · catalog jump (**1.59**) |
| [Accessibility](accessibility.md) | Focus return / live regions (**1.85**); names checklist |

---

## Platform & media

| Recipe | One-liner |
|--------|-----------|
| [System integration](system-integration.md) | FilePicker / Tray / NotificationBridge (**1.68** / **1.79** portal) |
| [Print, share & export](print-share.md) | grabToImage · save · reveal · PrintSupport notes (**1.63**) |
| [Security & trust](security-trust.md) | WebView2 / drop / picker / path trust · wave 2 (**2.13**) · wave 3 (**2.36**) |
| [Drag-drop & clipboard](drag-drop.md) | FileDropZone / CopyButton / WindowHelper (1.41) |
| [Shell extras](shell-extras.md) | Snap / taskbar / attention / reveal (1.47) |
| [WebView2](webview2.md) | Stable Edge host (Windows) |
| [Media](media.md) | Optional Multimedia — **permanent defer 2.09** |
| [Charts & gauges](charts.md) | Stable six + deferred remaining (**1.66**) |
| [Animations](animations.md) | ConnectedAnimation / reducedMotion |
| [Carousel](carousel-recipes.md) | FlipView / PipsPager hosts (**2.37**) |
| [Performance](performance.md) | Lists, models, chart budgets, Gallery cold start (1.39) |

---

## Quality

| Recipe | One-liner |
|--------|-----------|
| [Gallery CatalogPage](gallery-catalog-page.md) | Page host slots (Item not Page) |
| [Collection perf (2.64)](collection-perf-264.md) | DataTable pin/group · ListDetailsView bulk toolbar |
| [Notification center (2.63)](notification-center-263.md) | Toast + history **`NotificationBridge`** stack |
| [Semantic zoom (2.62)](semantic-zoom-262.md) | Contacts **`SemanticZoom`** (**experimental**) |
| [Rich edit (2.61)](rich-edit-261.md) | Mail / template **`RichEdit`** (**experimental**) |
| [3.xx compatibility (draft)](compatibility-3xx.md) | Breaking close-out notes |

---

## Examples (in repo)

| Example | Recipe pair |
|---------|-------------|
| [`examples/gallery-shell`](../examples/gallery-shell/) | [window-shells.md](window-shells.md) / [navigation.md](navigation.md) (**1.50**) |
| [`examples/multi-window`](../examples/multi-window/) | [window-shells.md](window-shells.md) multi-window (**1.56**) |
| [`examples/nav-settings`](../examples/nav-settings/) | [navigation.md](navigation.md) |
| [`examples/settings-cards`](../examples/settings-cards/) | [forms.md](forms.md) / theme |
| [`examples/dashboard`](../examples/dashboard/) | [charts.md](charts.md) (**1.66** stable six) |
| [`examples/master-detail`](../examples/master-detail/) | [data-collections.md](data-collections.md) |
| [`examples/form-settings`](../examples/form-settings/) | [forms.md](forms.md) |
| [`examples/floating-osk`](../examples/floating-osk/) | [on-screen-keyboard.md](on-screen-keyboard.md) (**1.84**) |

Build from Creator or presets: [qt-creator.md](qt-creator.md) · [examples/README.md](../examples/README.md).
