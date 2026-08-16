# Stable vs experimental API (1.xx)

QWinUI3 ships **~200** public types. Not all of them carry the same compatibility promise.

This page is the **1.xx stable surface** for apps that copy from examples / Gallery. Types **not** listed as stable may still work and stay documented—they are simply **not** covered by the “no silent renames” promise until promoted here.

**Product version:** see `QWINUI3_VERSION` in root `CMakeLists.txt` (`X.YY`).

---

## Compatibility promise (1.xx)

| Class | Promise |
|-------|---------|
| **Stable** | Prefer these in product apps. In 1.xx we avoid removing or silently renaming public properties/signals without a roadmap note and docs update. |
| **Experimental** | Usable, Gallery-backed when marked, but APIs may change in a later `1.xx` with docs callouts. |
| **Internal / support** | Not for app import (see generated [components.md](components.md) “Internal” section). |

Style module (`QT_QUICK_CONTROLS_STYLE=QWinUI3`): treating **standard** `QtQuick.Controls` types with this style is **stable**. Custom Extras that wrap them follow the tables below.

---

## Stable — start here

### Shells & navigation

| Type | Module | Notes |
|------|--------|--------|
| `StandardWindow` | Platform | Primary app window for examples |
| `NavigationView` | Extras | Pane + page stack; used by `examples/nav-settings` |
| `NavigationWindow` | Extras | Shell + NavigationView host |
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

### Dialogs & feedback

| Type | Module | Notes |
|------|--------|--------|
| `ContentDialog` | Extras | Modal primary/secondary/close |
| `ContentDialogQueue` | Extras | Serialize dialogs |
| `InfoBar` / `InfoBarHost` | Extras | Inline severity banners |
| `Toast` / `ToastHost` | Extras | Transient toasts |

### Data (basics)

| Type | Module | Notes |
|------|--------|--------|
| `DataTable` | Extras | Sort/filter/resize + stable selection / keyboard — [data-collections.md](data-collections.md) (1.07) |
| `ListDetailsView` / `ItemsView` / `ListTile` | Extras | Master–detail / list recipes — [data-collections.md](data-collections.md) |

### Theme & style

| Type | Module | Notes |
|------|--------|--------|
| `Theme` singleton | Theme | Tokens, density, dark/light, accent — [theme-overrides.md](theme-overrides.md) (1.09) |
| `FluentIcons` | Theme | Symbol font API |
| Style `QWinUI3` | Style | Drop-in Fluent chrome for Controls |

### Platform helpers (common)

| Type | Module | Notes |
|------|--------|--------|
| `WindowHelper` | Platform | Backdrop, chrome flags, system prefs—**stable for properties already used by shells/examples**. Niche OS helpers may still evolve. |
| `FilePicker` / `TrayIcon` | Platform | Open/save/folder + tray — [system-integration.md](system-integration.md) (1.10) |
| `NotificationBridge` | Extras | ToastHost + OS notify — [system-integration.md](system-integration.md) (1.10) |

---

## Experimental — fine to try, expect change

Promote to stable only after a named `1.xx` slice hardens them.

| Area | Examples | Why experimental |
|------|----------|------------------|
| **WebView2** | `WebView2Host` | Windows-only; 1.05 recipe in [webview2.md](webview2.md) — still soak-tested as experimental |
| **Charts & gauges** | `LineChart`, `BarChart`, `ArcGauge`, `KpiTile`, … | Experimental; **1.11** naming recipe in [charts.md](charts.md) — promote a named subset later (roadmap 1.23) |
| **Advanced chrome** | Snap layouts edge cases, frost/Mica failure modes | Documented gaps; polish in **1.03** / **1.04** |
| **Animations** | `ConnectedAnimation*`, theme transitions | Power-user; less example coverage |
| **Tear-out / exotic shells** | `TabViewTearOutWindow`, compact overlay variants | Niche |
| **Media** | `MediaPlayerElement` | Optional Qt Multimedia |
| **Shell extras** | Taskbar progress, idle inhibit, Snap Layouts demos | Gallery demos; not the 1.10 stable bridge |

If a type is public in [components.md](components.md) but listed in neither table, treat it as **experimental** until added here.

---

## What to copy from the repo

| Starter | Stable pieces it uses |
|---------|------------------------|
| [`examples/nav-settings`](../examples/nav-settings/) | `StandardWindow`, `NavigationView`, settings footer |
| [`examples/settings-cards`](../examples/settings-cards/) | `SettingsCard`, `SettingsExpander` |
| [`examples/dashboard`](../examples/dashboard/) | Shell + KPI/charts (**charts remain experimental**; naming in [charts.md](charts.md)) |

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
