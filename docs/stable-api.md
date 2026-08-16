# Stable vs experimental API (1.xx)

QWinUI3 ships **~200** public types. Not all of them carry the same compatibility promise.

This page is the **1.xx stable surface** for apps that copy from examples / Gallery. Types **not** listed as stable may still work and stay documented—they are simply **not** covered by the “no silent renames” promise until promoted here.

**1.xx freeze gate (1.40):** [compatibility-1xx.md](compatibility-1xx.md) — Theme / shell / stable “will not break”.  
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
| `MediaPlayerElement` | Optional Multimedia; backends vary — [media.md](media.md) |
| `ConnectedAnimation*`, entrance / theme transition helpers | Motion APIs still settling — [animations.md](animations.md) |
| `TabView` tear-out (`canTearOutTabs`, tear-out windows) | Niche; may change — [navigation.md](navigation.md) |
| Niche charts / gauges (`AreaChart`, `PieChart`, `ArcGauge`, `RadarChart`, …) | Stable six already named — [charts.md](charts.md) |
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
| `NavigationWindow` | Extras | Shell + NavigationView host |
| `TabView` | Extras | Document tabs (tear-out remains experimental) — [navigation.md](navigation.md) (**1.37**) |
| `PlatformTitleBar` / caption chrome | Platform | Via shells; prefer shell APIs over reinventing |

### Settings & forms

| Type | Module | Notes |
|------|--------|--------|
| `SettingsCard` | Extras | `examples/settings-cards` |
| `SettingsExpander` | Extras | `header` alias + ColumnLayout host (1.08) |
| `SettingsView` | Extras | Settings page host |
| `SettingsToggleCard` / `SettingsComboCard` / `SettingsSliderCard` | Extras | Common settings rows |
| `FormLayout` | Extras | Form stack + field errors — [forms.md](forms.md) (1.08) |
| `HeaderedTextBox` / `HeaderedComboBox` / `ValidationSummary` | Extras | `errorMessage` → `validate()` — [forms.md](forms.md) |
| `NumberBox` / `DatePicker` / `CalendarDatePicker` / `TimePicker` / `ColorPicker` | Extras | Form-friendly pickers — [pickers.md](pickers.md) (**1.37**) |

### Dialogs & feedback

| Type | Module | Notes |
|------|--------|--------|
| `ContentDialog` | Extras | Modal primary/secondary/close — [dialogs-flyouts.md](dialogs-flyouts.md) (1.16 Esc/default) |
| `ContentDialogQueue` | Extras | Serialize dialogs — [dialogs-flyouts.md](dialogs-flyouts.md) |
| `Flyout` / style `Drawer` | Extras / Style | Light-dismiss / edge panel — [dialogs-flyouts.md](dialogs-flyouts.md) (**1.37**) |
| `InfoBar` / `InfoBarHost` | Extras | Inline severity banners — [feedback.md](feedback.md) (1.34) |
| `Toast` / `ToastHost` | Extras | Transient toasts + pending queue — [feedback.md](feedback.md) |
| `TeachingTip` | Extras | Coach marks; focus returns to target — [feedback.md](feedback.md) (1.34) |
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
| `Theme` singleton | Theme | Tokens, density, dark/light, accent — [theme-overrides.md](theme-overrides.md) (1.09); contrast helpers — [color-contrast.md](color-contrast.md) (**1.43**) |
| `FluentIcons` / `FontIcon` | Theme / Extras | Symbol font + glyph control — [icons.md](icons.md) (**1.37** FontIcon) |
| `InfoBadge` | Extras | Counts / status dots on nav — (**1.37**) |
| Style `QWinUI3` | Style | Drop-in Fluent chrome for Controls |

### Platform helpers (common)

| Type | Module | Notes |
|------|--------|--------|
| `WindowHelper` | Platform | Backdrop, chrome flags, system prefs—**stable for properties already used by shells/examples**. |
| `QWinUI3::configureEnvironment` / `configureApplication` | Platform C++ (`Bootstrap.h`) | One-call main setup — [packaging-consumer.md](packaging-consumer.md) |
| `WindowHelper` shell extras | Platform | Taskbar progress/overlay, `requestUserAttention`, `revealFileInFolder`, idle inhibit — [shell-extras.md](shell-extras.md) (1.17) |
| `WindowHelper` geometry persistence | Platform | `saveWindowGeometry` / `restoreWindowGeometry` / `geometryPersistenceKey` on shells — [window-helper.md](window-helper.md#window-geometry-persistence) |
| `FilePicker` / `TrayIcon` | Platform | Open/save/folder + tray — [system-integration.md](system-integration.md) (1.10) |
| `WindowHelper.copyText` / `clipboardText` | Platform | Text clipboard R/W — [drag-drop.md](drag-drop.md) (**1.41**) |
| `FileDropZone` / `CopyButton` | Extras | Drop target + copy affordance — [drag-drop.md](drag-drop.md) (**1.41**) |
| `NotificationBridge` | Extras | ToastHost + OS notify — [system-integration.md](system-integration.md) (1.10) |
| `WebView2Host` | Platform | Windows Edge WebView2 HWND host — [webview2.md](webview2.md) (1.18 soak green) |
| `LineChart` / `BarChart` / `DonutChart` | Extras | Trend / columns / part-to-whole — [charts.md](charts.md) (1.23) |
| `RingGauge` / `KpiTile` / `ChartCard` | Extras | Dashboard gauge + KPI chrome — [charts.md](charts.md) (1.23) |

---

## Experimental — fine to try, expect change

Promote to stable only after a named `1.xx` slice hardens them. See also [1.37 defer](#137-defer--wont-promote-for-now).

| Area | Examples | Why experimental |
|------|----------|------------------|
| **WebView2 advanced** | Custom Environment / multi-profile | Base `WebView2Host` is **stable (1.18)** — [webview2.md](webview2.md) |
| **Charts & gauges (remaining)** | `AreaChart`, `PieChart`, `ArcGauge`, `RadarChart`, … | Niche / siblings — [charts.md](charts.md); **stable subset** Line/Bar/Donut + RingGauge + KpiTile + ChartCard (**1.23**) |
| **Animations** | `ConnectedAnimation*`, theme transitions | Recipe [animations.md](animations.md) (1.22) — deferred in **1.37** |
| **Tear-out / exotic shells** | `canTearOutTabs`, compact-overlay / dialog-tool shell variants | Niche — deferred in **1.37** |
| **Media** | `MediaPlayerElement` | Optional Qt Multimedia — [media.md](media.md) (1.21) — deferred in **1.37** |
| **Shell extras (remaining)** | Snap Layouts, battery/online/screens, recent-docs | Gallery demos; taskbar/attention/reveal/idle already stable (**1.17**) |

If a type is public in [components.md](components.md) but listed in neither table, treat it as **experimental** until added here.

---

## What to copy from the repo

| Starter | Stable pieces it uses |
|---------|------------------------|
| [`examples/nav-settings`](../examples/nav-settings/) | `StandardWindow`, `NavigationView`, settings footer — [navigation.md](navigation.md) (1.27) |
| [`examples/settings-cards`](../examples/settings-cards/) | `SettingsCard`, `SettingsExpander` |
| [`examples/dashboard`](../examples/dashboard/) | Shell + **stable** KPI/charts (`LineChart`, `RingGauge`, `KpiTile`, `ChartCard`) — [charts.md](charts.md) (1.23) |
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
- **Consumer recipe (Win + Linux):** [packaging-consumer.md](packaging-consumer.md) (1.12)
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
| **1.20** | Gallery catalog UX + smoke critical pages — [ci-smoke.md](ci-smoke.md) |
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
| **1.35** | Qt Creator kit polish — [qt-creator.md](qt-creator.md); example build presets |
| **1.36** | Docs site IA — [recipes.md](recipes.md) hub; MkDocs Recipes sections |
| **1.37** | Promote sweep — commands / Flyout / TabView / ShellWindow / pickers / progress / FontIcon / ItemsRepeater; explicit defer list |
| **1.38** | Linux Wayland field matrix — [platform-linux-wayland.md](platform-linux-wayland.md); Gallery System integration |
| **1.39** | Gallery cold start — [performance.md](performance.md); NavigationView page cache / `--startup-log` |
| **1.40** | 1.xx compatibility freeze — [compatibility-1xx.md](compatibility-1xx.md); [upgrade-notes.md](upgrade-notes.md) |
| **1.41** | Drag-drop & clipboard — [drag-drop.md](drag-drop.md); FileDropZone / CopyButton / WindowHelper |
| **1.42** | Adaptive layout — [adaptive-layout.md](adaptive-layout.md); TwoPaneView / ListDetailsView breakpoints |
| **1.43** | Color & contrast diagnostics — [color-contrast.md](color-contrast.md); `Theme.contrastRatio` / AA helpers |
