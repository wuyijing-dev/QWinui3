# QWinUI3

Fluent / WinUI 3–inspired controls for **Qt 6.5+** Quick (recommended **6.8 LTS**; forward **6.10+**).

This site is generated from QML source comments and shipped via GitHub Pages.

## Start here

| Section | Description |
|---------|-------------|
| [Component API](components.md) | Full public + internal control index |
| [Conventions](conventions.md) | Radius, Accessible, Extras import rules |
| [Window shells](window-shells.md) | ShellWindow family vs StandardWindow |
| [WindowHelper](window-helper.md) | Platform chrome singleton |
| [Roadmap](roadmap.md) | Version themes — small `1.xx` slices |
| [Stable API](stable-api.md) | What to rely on in 1.xx apps |
| [Accessibility](accessibility.md) | 1.02 + wave 2 checklist (1.19) |
| [Linux / Wayland](platform-linux-wayland.md) | Title bar & backdrop matrix for shells |
| [Window chrome](window-chrome.md) | DPI / backdrop / dialog failure modes |
| [WebView2](webview2.md) | Windows WebView2Host — stable recipe (1.18) |
| [CI smoke](ci-smoke.md) | Gallery `--smoke` + catalog integrity (1.20) |
| [Media](media.md) | Optional Qt Multimedia / MediaPlayerElement (1.21) |
| [Animations & transitions](animations.md) | ConnectedAnimation, entrance, theme transitions (1.22) |
| [Data collections](data-collections.md) | DataTable / ItemsView / ListDetailsView (1.07) |
| [Forms & settings](forms.md) | FormLayout validation + settings recipes (1.08) |
| [Theme overrides](theme-overrides.md) | Accent / density / branding knobs (1.09) |
| [System integration](system-integration.md) | FilePicker / TrayIcon / NotificationBridge (1.10) |
| [Shell extras](shell-extras.md) | Taskbar / attention / reveal / idle (1.17) |
| [Charts & gauges](charts.md) | Stable Line/Bar/Donut + RingGauge + KpiTile + ChartCard (1.23) |
| [Performance](performance.md) | Virtualization, models, chart budgets, Gallery heavy pages (1.25) |
| [Navigation & TabView](navigation.md) | Pane modes, footer, Back, TabView vs NavigationView (1.27) |
| [Input & pickers](pickers.md) | Number / date / time / color + FormLayout (1.28) |
| [Consumer packaging](packaging-consumer.md) | Shared zip / CMake / runtime for third-party apps (1.12) |
| [i18n / RTL](i18n-rtl.md) | qsTr workflow + LayoutMirroring baseline (1.13) |
| [Commands & menus](commands.md) | CommandPalette / CommandBar / MenuFlyout keyboard (1.15) |
| [Dialogs & flyouts](dialogs-flyouts.md) | ContentDialog vs Flyout / TeachingTip / Drawer (1.16) |
| [Qt Creator](qt-creator.md) | Open / build the CMake project |
| [Qt version compat](qt-version-compat.md) | C++ shims + CI matrix Qt 6.5 / 6.8 / 6.10 (1.14) |

## Install / build

```bash
cmake --preset release   # or use a Qt Creator Kit
cmake --build --preset release --target qwinui3_gallery
```

Shared libraries:

```bash
python scripts/package_release_libs.py --shared
```

## Regenerate docs

```bash
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
```

Machine-readable catalog: [`components.json`](components.json).

## License

QWinUI3 is licensed under the **[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.html)** (`LGPL-3.0`). See [`LICENSE`](https://github.com/wuyijing-dev/QWinui3/blob/master/LICENSE) and [`COPYING`](https://github.com/wuyijing-dev/QWinui3/blob/master/COPYING) (GPL-3.0 terms incorporated by LGPL-3.0).
