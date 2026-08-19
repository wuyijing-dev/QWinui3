# Stable vs experimental API (1.xx)

QWinUI3 ships **~200** public types. Not all of them carry the same compatibility promise.

This page is the **1.xx stable surface** for apps that copy from examples / Gallery. Types **not** listed as stable may still work and stay documented—they are simply **not** covered by the “no silent renames” promise until promoted here.

**1.xx freeze gate (1.40):** [compatibility-1xx.md](compatibility-1xx.md) — Theme / shell / stable “will not break”.  
**1.xx maturity checkpoint (1.51):** [maturity-1xx.md](maturity-1xx.md) — prefer harden; not 2.00.  
**Mid-horizon (1.60):** checkpoint-160 — defer list unchanged; next is packaging sketch.  
**Consumer upgrades:** [upgrade-notes.md](upgrade-notes.md).  
**Product version:** see `QWINUI3_VERSION` in root `CMakeLists.txt` (`X.YY`).  
**How-to recipes:** [recipes.md](recipes.md).

---

## Compatibility promise (1.xx)

| Class | Promise |
|-------|---------|
| **Stable** | Prefer these in product apps. In 1.xx we avoid removing or silently renaming public properties/signals without a roadmap note and docs update. See also [compatibility-1xx.md](compatibility-1xx.md). |
| **Experimental** | Usable, Gallery-backed when marked, but APIs may change in a later `1.xx` with docs callouts. |
| **Won’t promote (for now)** | Explicitly deferred — see [1.37 defer list](#137-defer--wont-promote-for-now). Still usable; do not assume 1.xx rename freeze. |
| **Internal / support** | Not for app import (see generated [components.md](components.md) “Internal” section). |

Style module (`QT_QUICK_CONTROLS_STYLE=QWinUI3`): treating **standard** `QtQuick.Controls` types with this style is **stable**. Custom Extras that wrap them follow the tables below.

---

## 1.37 promote batch

Promoted this slice (Gallery + recipe soak). Status flips are **named here** — not silent.

| Promote | Evidence |
|---------|----------|
| `CommandPalette`, `CommandBar`, `AppBarButton`, `CommandBarFlyout`, `MenuFlyout`, `MenuFlyoutItem`, style `MenuBar` | [commands.md](commands.md) (1.15) |
| `Flyout`, style `Drawer` | [dialogs-flyouts.md](dialogs-flyouts.md) (1.16); `ContentDialog` / `TeachingTip` already stable |
| `TabView` (**not** tear-out) | [navigation.md](navigation.md) (1.27) |
| `ShellWindow`, `BlankWindow`, `MenuStatusWindow` | [window-shells.md](window-shells.md) (1.32); `NavigationWindow` already stable |
| `NumberBox`, `DatePicker`, `CalendarDatePicker`, `TimePicker`, `ColorPicker` | [pickers.md](pickers.md) (1.28) |
| Style `ProgressBar`, `ProgressRing`, `ProgressButton` | [feedback.md](feedback.md) (1.34) |
| `FontIcon`, `InfoBadge` | [icons.md](icons.md) (1.29); nav badges |
| `ItemsRepeater` | [performance.md](performance.md) (1.25) |

### 1.37 defer / won’t promote (for now)

| Keep experimental | Why |
|-------------------|-----|
| `MediaPlayerElement` | Optional Multimedia; **permanent defer 2.09** — [media.md](media.md) |
| `ConnectedAnimation*`, entrance / theme transition helpers | Motion APIs still settling — [animations.md](animations.md) |
| `AnimatedIcon` | Thin glyph state swap (**1.53**); not Lottie — [icons.md](icons.md) |
| `TabView` tear-out (`canTearOutTabs`, tear-out windows) | Niche; may change — [navigation.md](navigation.md) |
| Niche charts / gauges (`AreaChart`, `PieChart`, `ArcGauge`, `RadarChart`, …) | Stable six frozen; **permanent defer 2.08** — compose in [charts.md](charts.md) |
| WebView2 custom Environment / multi-profile | Base host stable (1.18); advanced options not |
| Snap Layouts / battery / online / screens / recent-docs helpers | Gallery demos only — [shell-extras.md](shell-extras.md) |
| Compact overlay / dialog-tool exotic shell variants beyond Blank/Nav/MenuStatus | Prefer `ShellWindow` / `NavigationWindow` for LoB |

---

## Stable — start here

### Shells & navigation

| Type | Module | Notes |
|------|--------|--------|
| `StandardWindow` | Platform | Primary app window for examples |
| `ShellWindow` / `BlankWindow` / `MenuStatusWindow` | Extras | Product shells — [window-shells.md](window-shells.md) (**1.37**) |
| `NavigationView` | Extras | Pane + page stack; used by `examples/nav-settings` — [navigation.md](navigation.md) (1.27) |
| `NavigationWindow` | Extras | Shell + NavigationView host; `pageModule` shell — [examples/gallery-shell](../examples/gallery-shell/) (**1.50**) |
| `TabView` | Extras | Document tabs (tear-out remains experimental) — [navigation.md](navigation.md) (**1.37**) |
| `PlatformTitleBar` / caption chrome | Platform | Via shells; prefer shell APIs over reinventing |

### Settings & forms

| Type | Module | Notes |
|------|--------|--------|
| `SettingsCard` | Extras | `examples/settings-cards` |
| `SettingsExpander` | Extras | `header` alias + ColumnLayout host (1.08) |
| `SettingsView` | Extras | Settings page host |
| `ThemeAppearanceSettings` / `ThemePrefs` | Extras | Drop-in Theme cards + QSettings — [theme-overrides.md](theme-overrides.md) (**1.69**) |
| `SettingsToggleCard` / `SettingsComboCard` / `SettingsSliderCard` | Extras | Common settings rows |
| `FormLayout` | Extras | Form stack + field errors — [forms.md](forms.md) (1.08) |
| `HeaderedTextBox` / `HeaderedComboBox` / `ValidationSummary` | Extras | `errorMessage` → `validate()` — [forms.md](forms.md) |
| `NumberBox` / `DatePicker` / `CalendarDatePicker` / `TimePicker` / `ColorPicker` | Extras | Form-friendly pickers — [pickers.md](pickers.md) (**1.37**) |

### Dialogs & feedback

| Type | Module | Notes |
|------|--------|--------|
| `ContentDialog` | Extras | Modal primary/secondary/close — [dialogs-flyouts.md](dialogs-flyouts.md) (1.16 Esc/default) |
| `ContentDialogQueue` | Extras | Serialize dialogs — [dialogs-flyouts.md](dialogs-flyouts.md) (**1.48**) |
| `Flyout` / style `Drawer` | Extras / Style | Light-dismiss / edge panel — [dialogs-flyouts.md](dialogs-flyouts.md) (**1.37**) |
| `InfoBar` / `InfoBarHost` | Extras | Inline severity banners — [feedback.md](feedback.md) (1.34) |
| `Toast` / `ToastHost` | Extras | Transient toasts + pending queue — [feedback.md](feedback.md) |
| `TeachingTip` | Extras | Coach marks; focus returns to target — [feedback.md](feedback.md) (1.34 / **1.55** sequence) |
| Style `ProgressBar` / `ProgressRing` / `ProgressButton` | Style / Extras | In-place progress — [feedback.md](feedback.md) (**1.37**) |

### Commands & menus

| Type | Module | Notes |
|------|--------|--------|
| `CommandPalette` | Extras | Ctrl+K launcher — [commands.md](commands.md) (**1.37**) |
| `CommandBar` / `AppBarButton` / `CommandBarFlyout` | Extras | Page tool strip — [commands.md](commands.md) (**1.37**) |
| `MenuFlyout` / `MenuFlyoutItem` | Extras | Context / overflow — [commands.md](commands.md) (**1.37**) |
| Style `MenuBar` | Style | Classic menu bar — [commands.md](commands.md) (**1.37**) |

### Data (basics)

| Type | Module | Notes |
|------|--------|--------|
| `DataTable` | Extras | Sort/filter/resize + stable selection / keyboard — [data-collections.md](data-collections.md) (1.07); scale tips [performance.md](performance.md) (1.25) |
| `ListDetailsView` / `ItemsView` / `ListTile` | Extras | Master–detail / list recipes — [data-collections.md](data-collections.md); adaptive [adaptive-layout.md](adaptive-layout.md) (**1.42**) |
| `TwoPaneView` | Extras | Dual pane Wide/Tall/SinglePane — [adaptive-layout.md](adaptive-layout.md) (**1.42**) |
| `ItemsRepeater` | Extras | Virtualizing list wrapper — [performance.md](performance.md) (**1.37**) |
| `TreeView` + Fluent `TreeViewDelegate` | Style / QQC | Hierarchy LoB — [tree-data.md](tree-data.md) (1.33) |

### Theme & style

| Type | Module | Notes |
|------|--------|--------|
| `Theme` singleton | Theme | Tokens, density, dark/light, accent — [theme-overrides.md](theme-overrides.md) (1.09 / **1.69** `snapshot` / `apply` / `recipeText`); contrast helpers — [color-contrast.md](color-contrast.md) (**1.43**) |
| `FluentIcons` / `FontIcon` | Theme / Extras | Symbol font + glyph control — [icons.md](icons.md) (**1.37** FontIcon) |
| `InfoBadge` | Extras | Counts / status dots on nav — (**1.37**) |
| Style `QWinUI3` | Style | Drop-in Fluent chrome for Controls |

### Platform helpers (common)

| Type | Module | Notes |
|------|--------|--------|
| `WindowHelper` | Platform | Backdrop, chrome flags, system prefs—**stable for properties already used by shells/examples**. |
| `ThemeSync` | Platform | Follow-system a11y / color → Theme; attached by shells (**1.69**) |
| `QWinUI3::configureEnvironment` / `configureApplication` | Platform C++ (`Bootstrap.h`) | One-call main setup — [packaging-consumer.md](packaging-consumer.md) |
| `WindowHelper` shell extras | Platform | Taskbar progress/overlay, `requestUserAttention`, `revealFileInFolder`, idle inhibit — [shell-extras.md](shell-extras.md) (1.17 / **1.47**) |
| `WindowHelper` geometry persistence | Platform | `saveWindowGeometry` / `restoreWindowGeometry` / `geometryPersistenceKey` on shells — [window-helper.md](window-helper.md#window-geometry-persistence) |
| `FilePicker` / `TrayIcon` | Platform | Open/save/folder + tray — [system-integration.md](system-integration.md) (1.10; **1.68** Linux portal) |
| `WindowHelper.copyText` / `clipboardText` | Platform | Text clipboard R/W — [drag-drop.md](drag-drop.md) (**1.41**) |
| `FrameStatsMonitor` / `FrameStatsBadge` / `FrameStatsOverlay` | Platform | Opt-in FPS/RHI dev diagnostics — **`applyRetailProfile()`** for retail — [developer-diagnostics.md](developer-diagnostics.md) (**2.44**) |
| `FileDropZone` / `CopyButton` | Extras | Drop target + copy affordance — [drag-drop.md](drag-drop.md) (**1.41**) |
| `NotificationBridge` | Extras | ToastHost + OS notify — [system-integration.md](system-integration.md) (1.10) |
| `WebView2Host` | Platform | Windows Edge WebView2 HWND host — [webview2.md](webview2.md) (1.18 soak green) |
| `LineChart` / `BarChart` / `DonutChart` | Extras | Trend / columns / part-to-whole — [charts.md](charts.md) (1.23; **1.66** dashboard polish) |
| `RingGauge` / `KpiTile` / `ChartCard` | Extras | Dashboard gauge + KPI chrome — [charts.md](charts.md) (1.23; **1.66**) |

---

## Experimental — fine to try, expect change

Promote to stable only after a named `1.xx` slice hardens them. See also [1.37 defer](#137-defer--wont-promote-for-now).

| Area | Examples | Why experimental |
|------|----------|------------------|
| **WebView2 advanced** | Custom Environment / multi-profile | Base `WebView2Host` is **stable (1.18)** — [webview2.md](webview2.md) |
| **Charts & gauges (remaining)** | `AreaChart`, `PieChart`, `ArcGauge`, `RadarChart`, … | **Permanent defer 2.08** — [charts.md](charts.md) compose recipes; stable six unchanged |
| **Animations** | `ConnectedAnimation*`, theme transitions, `AnimatedIcon` | Recipe [animations.md](animations.md) / [icons.md](icons.md) — deferred / experimental |
| **Tear-out / exotic shells** | `canTearOutTabs`, compact-overlay / dialog-tool shell variants | Niche — deferred in **1.37** |
| **Media** | `MediaPlayerElement` | Optional Qt Multimedia — **permanent defer 2.09** — [media.md](media.md); app-owned codecs/deploy |
| **Collections compose** | `FileTree` (folder tree + file table) | Explorer LoB — [tree-data.md](tree-data.md) (**2.06**); `TreeDataGrid` hierarchical grid (**2.21**); `ItemsWrapGrid` wrap grid (**2.24**) |
| **Dashboard layout** | `DashboardShell` | Preview host (**2.52**) — full grid in **2.65** — [first-app-252.md](first-app-252.md) |
| **On-screen keyboard** | `OnScreenKeyboard` / `OnScreenKeyboardWindow` / `KeyboardEngine` / `ImeCandidateBar` | Win11 floating OSK + Windows system-wide (**1.83** harden); **still experimental** — [on-screen-keyboard.md](on-screen-keyboard.md) |
| **Shell extras (remaining)** | Snap Layouts, battery/online/screens, recent-docs | Gallery demos; taskbar/attention/reveal/idle already stable (**1.17**) |

If a type is public in [components.md](components.md) but listed in neither table, treat it as **experimental** until added here.

**2.45 sweep:** Gallery **Experimental** / **Permanent defer** badges on catalog pages; full verdict matrix — [experimental-sweep.md](experimental-sweep.md). **2.51** closes clarity queue — [stable-clarity-251.md](stable-clarity-251.md).

### Import guard (2.47 / 2.51)

Before copying a Gallery page into product code, check **badge + module**:

| If you need… | Import | Verdict |
|--------------|--------|---------|
| Buttons, dialogs, shells, stable six charts | `QWinUI3.Style` / `Theme` / documented stable module | **Ship** |
| OSK, `CalendarView`, `TreeDataGrid`, `NotificationCenter`, `RichEdit`, `SemanticZoom`, … | `QWinUI3.Extras` (or page-specific) | **Experimental** — friction row or internal only |
| `AreaChart`, `MediaPlayerElement`, deferred gauges | Do not import for shipping UI | **Permanent defer** — compose per [charts.md](charts.md) / [media.md](media.md) |

**Rule:** If a type is not listed under **Stable** on this page, assume **experimental** until [experimental-sweep.md](experimental-sweep.md) says otherwise. Gallery **Pitfalls** + **2.51** lint: [stable-clarity-251.md](stable-clarity-251.md) · [field-harden-247.md](field-harden-247.md).

Run before copying an example:

```bash
python scripts/lint_qml_imports.py
```

---

## What to copy from the repo

| Starter | Stable pieces it uses |
|---------|------------------------|
| [`examples/gallery-shell`](../examples/gallery-shell/) | **Prefer for apps** — `NavigationWindow` + Settings + persistence — [window-shells.md](window-shells.md) (**1.50**) |
| [`examples/nav-settings`](../examples/nav-settings/) | `StandardWindow`, `NavigationView`, settings footer — [navigation.md](navigation.md) (1.27) |
| [`examples/settings-cards`](../examples/settings-cards/) | `SettingsCard`, `SettingsExpander` |
| [`examples/first-app`](../examples/first-app/) | Smallest `NavigationWindow` + **`DashboardShell`** preview — [first-app-252.md](first-app-252.md) (**2.52**) |
| [`examples/dashboard`](../examples/dashboard/) | Shell + **all six stable** KPI/charts (`LineChart`, `BarChart`, `DonutChart`, `RingGauge`, `KpiTile`, `ChartCard`) — [charts.md](charts.md) (**1.66**) |
| [`examples/master-detail`](../examples/master-detail/) | `ListDetailsView` LoB shell — [data-collections.md](data-collections.md) (1.26) |
| [`examples/form-settings`](../examples/form-settings/) | `FormLayout` + `ValidationSummary` + SettingsCard prefs — [forms.md](forms.md) (1.26) |

Always set:

```cpp
qputenv("QT_QUICK_CONTROLS_STYLE", "QWinUI3");
QQuickStyle::setStyle(QStringLiteral("QWinUI3"));
```

---

## Packaging reminder

- Shared libs: `python scripts/package_release_libs.py --shared --archive`
- Gallery: `python scripts/package_release_gallery.py`
- **Consumer recipe (Win + Linux):** [packaging-consumer.md](packaging-consumer.md) (1.46)
- Version string: `QWINUI3_VERSION` (`X.YY`) in root `CMakeLists.txt`
- CI Release on `vX.YY` tags — see [ROADMAP.md](../ROADMAP.md)

---

## Changelog for this page

| Version | Change |
|---------|--------|
| **1.01** | Initial stable vs experimental map |
| **1.10** | Promote `FilePicker` / `TrayIcon` / `NotificationBridge`; recipe [system-integration.md](system-integration.md) |
| **1.11** | Charts/gauges naming aliases + [charts.md](charts.md); still experimental |
| **1.12** | Consumer packaging recipe [packaging-consumer.md](packaging-consumer.md) |
| **1.13** | i18n / RTL baseline [i18n-rtl.md](i18n-rtl.md); LayoutMirroring + AlignLeading |
| **1.14** | Qt 6.5 / 6.8 / 6.10 Gallery CI matrix [qt-version-compat.md](qt-version-compat.md) |
| **1.15** | Command surfaces keyboard recipe [commands.md](commands.md) |
| **1.16** | Dialogs/flyouts recipe [dialogs-flyouts.md](dialogs-flyouts.md); ContentDialog Esc → Closing |
| **1.17** | Shell extras promote [shell-extras.md](shell-extras.md); taskbar / attention / reveal / idle |
| **1.18** | Promote `WebView2Host` — soak green [webview2.md](webview2.md); Retry recreate + async generation |
| **1.19** | Accessibility wave 2 — [accessibility.md](accessibility.md); DataTable/lists/forms names |
| **1.20** | Gallery catalog UX + smoke critical pages — `python scripts/smoke_gallery.py` |
| **1.21** | Media optional Multimedia recipe [media.md](media.md); stub when missing |
| **1.22** | Animations & transitions recipe [animations.md](animations.md); Gallery hub + reducedMotion demos |
| **1.23** | Promote chart subset Line/Bar/Donut + RingGauge + KpiTile + ChartCard — [charts.md](charts.md) |
| **1.24** | Linux persistent tray (StatusNotifierItem) — [system-integration.md](system-integration.md) |
| **1.25** | Performance handbook — [performance.md](performance.md); ItemsRepeater `reuseItems` |
| **1.26** | Example templates — master-detail + form-settings — [examples/README.md](../examples/README.md) |
| **1.27** | Navigation & TabView recipes — [navigation.md](navigation.md); nav-settings Back/`auto` |
| **1.28** | Input & pickers consistency — [pickers.md](pickers.md); date/time `errorMessage` |
| **1.29** | Icons & FluentIcons cookbook — [icons.md](icons.md); FontIcon / CaptionButton a11y |
| **1.30** | Density & responsive shells — [density.md](density.md); Theme overrides metrics |
| **1.31** | Graphics backend handbook — [graphics-backend.md](graphics-backend.md); Gallery Settings / `--rhi` |
| **1.32** | Window shells matrix — [window-shells.md](window-shells.md) / [window-chrome.md](window-chrome.md); geometry clamp |
| **1.33** | Tree & hierarchical data — [tree-data.md](tree-data.md); TreeViewDelegate a11y |
| **1.34** | Feedback surfaces — [feedback.md](feedback.md); TeachingTip focus return |
| **1.55** | Onboarding coach — sequenced TeachingTips + don’t-show-again; [feedback.md](feedback.md) |
| **1.56** | Multi-window — secondary shells + geometry keys; [window-shells.md](window-shells.md); `examples/multi-window` |
| **1.57** | Touch / pen — [touch-pointer.md](touch-pointer.md); Gallery Touch & pointer + high-traffic callouts |
| **1.58** | High-DPI / multi-monitor — [high-dpi.md](high-dpi.md); restore `setScreen` after clamp |
| **1.59** | In-app search — [search.md](search.md); Gallery Search recipes |
| **1.60** | Mid-horizon checkpoint — checkpoint-160; smoke + SearchRecipes / HighDpi |
| **1.61** | CMake `find_package` sketch — [packaging-consumer.md](packaging-consumer.md) Path C; `examples/find-package-consumer` |
| **1.62** | Gallery visual smoke subset — `--visual-smoke` + `scripts/smoke_visual.py`; `python scripts/smoke_gallery.py` |
| **1.63** | Print / share / export — [print-share.md](print-share.md); Gallery PrintSharePage |
| **1.64** | Security & trust — [security-trust.md](security-trust.md); Gallery SecurityTrustPage |
| **1.65** | Settings persistence — [settings-persistence.md](settings-persistence.md); Gallery SettingsPersistencePage |
| **1.66** | Charts & dashboard polish — defer remaining charts/gauges; [charts.md](charts.md); Gallery Charts/Dashboard |
| **2.08** | Charts compose recipes + permanent defer table — stable six frozen; Area→LineChart showArea, Spark→KpiTile; [charts.md](charts.md) |
| **2.09** | Media permanent defer — `MediaPlayerElement` stays experimental; [media.md](media.md) verdict; Gallery/Pitfalls/stable-api aligned |
| **2.21** | `TreeDataGrid` experimental — hierarchical multi-column grid; [tree-data.md](tree-data.md) |
| **2.24** | `ItemsWrapGrid` experimental — variable-size wrap grid; [items-wrap-grid.md](items-wrap-grid.md) |
| **2.26** | Charts recipe wave — deferred sibling compose table; stable six unchanged; [charts.md](charts.md) |
| **2.27** | `NotificationCenter` experimental — grouped in-app history; [feedback.md](feedback.md) wave 3 |
| **2.28** | Navigation trim diagnostics — `sameKeySkipCount` / `samePageSkipCount`; [performance.md](performance.md) wave 6 |
| **2.29** | Tree + wrap + breadcrumb a11y — `accessibleName` / `announceChanges` on **2.21…2.24** surfaces; [accessibility.md](accessibility.md) wave 5 |
| **2.30** | Mid-2.x checkpoint — checkpoint-230; audit **2.21…2.30** |
| **2.31** | `CalendarView` experimental — month grid selection modes; [calendar-view.md](calendar-view.md) |
| **2.32** | Media + WebView2 field matrix + policy recipes — [media.md](media.md) · [webview2.md](webview2.md) |
| **2.33** | Linux portal & tray wave 3 regression suite — [platform-linux-wayland.md](platform-linux-wayland.md) |
| **2.34** | Packaging consumer matrix + CI — [packaging-consumer.md](packaging-consumer.md) |
| **2.35** | Localization wave 4 — `de_DE` seed + control page qsTr rules — [i18n-rtl.md](i18n-rtl.md) |
| **2.36** | Security & trust wave 3 — path trust + WebView2 download policy — [security-trust.md](security-trust.md) |
| **2.37** | Carousel recipes — FlipView / PipsPager + reducedMotion — [carousel-recipes.md](carousel-recipes.md) |
| **2.38** | Theme overrides wave 2 — accent packs + ThemePrefs + contrast/density — [theme-overrides.md](theme-overrides.md) |
| **2.39** | Gallery catalog expansion — 2.21…2.38 findability matrix + recentlyShipped — [gallery-catalog-expansion.md](gallery-catalog-expansion.md) |
| **2.40** | Performance wave 7 — collection debounce/filter paths — [performance.md](performance.md) wave 7 |
| **2.41** | Command/menu wave 3 — large palette + shortcut discovery — [commands.md](commands.md) wave 3 |
| **2.42** | SwipeControl deepen — thresholds + nested scroll + teaching — [touch-pointer.md](touch-pointer.md) |
| **2.50** | Tranche-1 checkpoint — checkpoint-250; friction-only **2.51+** |
| **2.51** | Stable vs experimental clarity — [stable-clarity-251.md](stable-clarity-251.md); `lint_qml_imports.py`; **FL-004** queue closed |
| **2.61** | `RichEdit` experimental — mail/template rich text; [rich-edit-261.md](rich-edit-261.md); **FL-005** closed |
| **2.62** | `SemanticZoom` experimental — grid ↔ index; [semantic-zoom-262.md](semantic-zoom-262.md); **FL-006** closed |
| **2.63** | Notification center productize — bridge wiring; [notification-center-263.md](notification-center-263.md); **FL-007** closed |
| **2.52** | First app in an hour — [first-app-252.md](first-app-252.md); `examples/first-app/` + preview **DashboardShell** |
| **2.53** | Linux top-3 parity — [linux-top3-253.md](linux-top3-253.md); **NavigationWindow** clip + **sway** profile + FilePicker guard |
| **2.54** | Window chrome footguns — [window-chrome-footguns-254.md](window-chrome-footguns-254.md); geometry schema v2 + hit-test refresh |
| **2.49** | Performance wave 8 + tranche-1 sign-off — [perf-signoff-2xx.md](perf-signoff-2xx.md); FL-008 partial |
| **2.48** | Friction slot **FL-009** — dashboard compose decision tree — [dashboard-compose-decision.md](dashboard-compose-decision.md) |
| **2.46** | Docs IA v2 — MkDocs **2.xx** regroup + recipes hub mirror — [docs-ia-v2.md](docs-ia-v2.md) |
| **2.43** | Multi-window + onboarding — coach + z-order + Settings — [multi-window-onboarding.md](multi-window-onboarding.md) |
| **2.22** | Dashboard layout recipes — responsive breakpoints + `TwoPaneView` filter rail; [charts.md](charts.md) |
| **1.67** | Media honest defer — soak checklist, stay experimental; [media.md](media.md); Gallery MediaPlayerElement |
| **1.68** | Linux portal / FilePicker harden — no zenity double-dialog; [platform-linux-wayland.md](platform-linux-wayland.md) |
| **1.69** | Theme knobs for any app — `ThemeSync` / `ThemeAppearanceSettings` / `Theme.recipeText()`; [theme-overrides.md](theme-overrides.md) |
| **1.70** | Win11 OSK (en-US) — `OnScreenKeyboard` / `KeyboardEngine` builtin inject; experimental; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.71** | Keyman Core (MIT) static + extra layouts (de/fr/es/ru/ar); still experimental; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.72** | In-app pinyin IME + `ImeCandidateBar`; MIT pinyin-data; still experimental; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.73** | In-app ja romaji/kana + ko hangul + emoji layer; still experimental; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.74** | OSK / IME soak checklist + a11y + romaji fixes; still experimental (not promote-green); [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.75** | Extra Keyman `.kmx` (en-GB/it/pt/pl/sv/tr); still experimental; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.76** | IME deepen (MIT): pinyin prefix phrases, hangul peel/Space; ja kanji gap documented; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.77** | App-scoped hardware input (`hardwareInput`); not OS-wide; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.78** | Long-horizon 1.xx checkpoint — checkpoint-178; OSK stays experimental; prefer field harden / pause |
| **1.79** | Linux / Wayland field harden — [platform-linux-wayland.md](platform-linux-wayland.md) |
| **1.80** | Win11 OSK layout chrome; still experimental; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.81** | Win11 OSK behavior vs Win10; still experimental |
| **1.82** | Floating `OnScreenKeyboardWindow` + Windows `systemWide` SendInput; still experimental |
| **1.83** | Floating OSK no-activate soak; still experimental; [on-screen-keyboard.md](on-screen-keyboard.md) |
| **1.84** | `examples/floating-osk` consumer host; still experimental |
| **1.85** | Accessibility wave 3 — dialog/flyout focus return; InfoBar / ImeCandidateBar live region |
| **1.86** | Performance wave 1 — shell / window runtime ([performance.md](performance.md)) |
| **1.87** | Performance wave 2 — navigation & page stack ([performance.md](performance.md)) |
| **1.88** | Performance wave 3 — lists & data collections ([performance.md](performance.md)) |
| **1.89** | Performance wave 4 — style, charts & Gallery heavy pages ([performance.md](performance.md)) |
| **1.90** | 1.xx close-out — perf arc sign-off + 2.00 prep draft (checkpoint-190) |
| **1.35** | Qt Creator kit polish — [qt-creator.md](qt-creator.md); example build presets |
| **1.36** | Docs site IA — [recipes.md](recipes.md) hub; MkDocs Recipes sections |
| **1.37** | Promote sweep — commands / Flyout / TabView / ShellWindow / pickers / progress / FontIcon / ItemsRepeater; explicit defer list |
| **1.38** | Linux Wayland field matrix — [platform-linux-wayland.md](platform-linux-wayland.md); Gallery System integration |
| **1.39** | Gallery cold start — [performance.md](performance.md); NavigationView page cache / `--startup-log` |
| **1.40** | 1.xx compatibility freeze — [compatibility-1xx.md](compatibility-1xx.md); [upgrade-notes.md](upgrade-notes.md) |
| **1.41** | Drag-drop & clipboard — [drag-drop.md](drag-drop.md); FileDropZone / CopyButton / WindowHelper |
| **1.42** | Adaptive layout — [adaptive-layout.md](adaptive-layout.md); TwoPaneView / ListDetailsView breakpoints |
| **1.43** | Color & contrast diagnostics — [color-contrast.md](color-contrast.md); `Theme.contrastRatio` / AA helpers |
| **1.44** | Keyboard-first cookbook — [keyboard.md](keyboard.md); Gallery Accessibility tour |
| **1.45** | Localization deepen — [i18n-rtl.md](i18n-rtl.md); zh_CN seed; Gallery `--lang`; translation smoke check |
| **1.54** | Extra locale pack — `ja_JP` seed; Gallery language ComboBox; translation check extended |
| **1.46** | Shared redistribute polish — [packaging-consumer.md](packaging-consumer.md); windeploy/linuxdeploy + strip |
| **1.47** | Snap Layouts / shell extras polish — [shell-extras.md](shell-extras.md); Gallery System integration demos |
| **1.48** | ContentDialogQueue deepen — [dialogs-flyouts.md](dialogs-flyouts.md); `replaceCurrent` pump fix; Gallery A→B→C stress |
| **1.49** | Icon micro-motion — [icons.md](icons.md); `FontIcon` / `IconicButton` hover/press scales |
| **1.50** | Extractable Gallery shell — [examples/gallery-shell](../examples/gallery-shell/); `NavigationWindow` `pageModule` |
| **1.51** | 1.xx maturity checkpoint — [maturity-1xx.md](maturity-1xx.md); freeze revisit [compatibility-1xx.md](compatibility-1xx.md) |
| **1.52** | Field polish buffer — docs-link smoke + critical pages FontIcon/Pitfalls/ExamplesTemplates — `python scripts/smoke_gallery.py` |
| **1.53** | Thin `AnimatedIcon` glyph state swap (experimental, not Lottie) — [icons.md](icons.md) |
