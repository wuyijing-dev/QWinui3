# QWinUI3

Fluent / [WinUI 3](https://learn.microsoft.com/windows/apps/winui/winui3/)-inspired controls for **Qt 6 Quick** — theme tokens, a full Quick Controls style, window shells, and a large Extras catalog you can drop into desktop apps. Supports **Qt 6.5+** (recommended **6.8 LTS**; forward **6.10+**) via a C++ compatibility layer.

[![Release](https://img.shields.io/github/v/release/wuyijing-dev/QWinui3?label=release)](https://github.com/wuyijing-dev/QWinui3/releases/latest)
[![License: LGPL-3.0](https://img.shields.io/badge/license-LGPL--3.0-blue.svg)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-2ea44f)](https://wuyijing-dev.github.io/QWinui3/)
[![Qt](https://img.shields.io/badge/Qt-6.5%2B-41CD52?logo=qt&logoColor=white)](https://www.qt.io/)

**v1.36** · **200+** public controls · Gallery demos for most of them
[Documentation](https://wuyijing-dev.github.io/QWinui3/) · [Recipes hub](docs/recipes.md) · [Stable API](docs/stable-api.md) · [Qt Creator](docs/qt-creator.md) · [Component API](https://wuyijing-dev.github.io/QWinui3/components/) · [Releases](https://github.com/wuyijing-dev/QWinui3/releases) · [Roadmap](ROADMAP.md)

---

## Why QWinUI3

Qt ships excellent primitives; shipping a **Fluent-looking product** still means restyling chrome, inventing navigation shells, and reinventing InfoBars, settings cards, gauges, and charts. QWinUI3 packages that layer as QML modules:

- **Drop-in style** — set `QT_QUICK_CONTROLS_STYLE=QWinUI3` and standard `QtQuick.Controls` pick up Fluent chrome.
- **Design tokens** — density, dark/light, accent, and FluentIcons via `QWinUI3.Theme`.
- **App shells** — title bar, Mica/backdrop helpers, NavigationView windows, optional WebView2.
- **Extras catalog** — NavigationView, DataTable, ContentDialog, charts/gauges, settings cards, CommandPalette, TeachingTip, and more — with Gallery pages to try them.

Primary target: **Windows desktop** (MSVC). Linux builds are supported for many controls; WebView2 is Windows-only.

---

## Modules

| Module | QML import | What you get |
|--------|------------|--------------|
| **Style** | `QtQuick.Controls` + style `QWinUI3` | Fluent look for Button, TextField, ComboBox, Slider, … |
| **Theme** | `QWinUI3.Theme` | Color / typography / spacing tokens, `FluentIcons`, theme switching |
| **Platform** | `QWinUI3.Platform` | `StandardWindow` / shell family, `WindowHelper`, TitleBar, optional `WebView2Host` |
| **Extras** | `QWinUI3.Extras` | WinUI-style composites: nav, dialogs, data, charts, feedback, … |

Enable the style in C++ — **one-call bootstrap** (preferred):

```cpp
#include "Bootstrap.h"   // from qwinui3_platform

QWINUI3_IMPORT_QML_PLUGINS

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]); // BEFORE QGuiApplication
    QGuiApplication app(argc, argv);
    QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));
    // …
}
```

`configureEnvironment` sets the Fluent style env, Wayland/DPI helpers, and clears `QT_IM_MODULE`.  
`configureApplication` applies `QQuickStyle`, loads icon fonts, and optional AppUserModelID / desktop id.

Manual equivalent (still supported):

```cpp
qputenv("QT_QUICK_CONTROLS_STYLE", "QWinUI3");
QQuickStyle::setStyle(QStringLiteral("QWinUI3"));
```

Minimal shell:

```qml
import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

StandardWindow {
    width: 1100
    height: 720
    visible: true
    title: qsTr("My app")
    backdrop: WindowHelper.BackdropSolid

    NavigationView {
        anchors.fill: parent
        headerText: qsTr("My app")
        currentKey: "home"
        model: [
            { type: "item", key: "home", title: qsTr("Home"),
              symbol: FluentIcons.Home, component: "HomePage" }
        ]
    }
}
```

---

## Feature highlights

| Area | Examples |
|------|----------|
| **Navigation & shells** | `NavigationView`, `NavigationWindow`, `TwoPaneView`, TitleBar shells |
| **Commands** | `CommandBar`, `CommandPalette`, AppBar buttons, `SplitButton`, `DropDownButton` |
| **Forms & input** | `NumberBox`, `AutoSuggestBox`, headered fields, `ColorPicker`, `PasswordBox` |
| **Dialogs & tips** | `ContentDialog`, `Flyout`, `MenuFlyout`, `TeachingTip`, `InfoButton` |
| **Feedback** | `InfoBar` / `InfoBarHost`, `Toast` / `ToastHost`, `ProgressRing`, badges |
| **Data & layout** | `DataTable`, `ItemsView`, `ListDetailsView`, settings cards / expanders |
| **Charts & gauges** | Line / bar / donut / heatmap / sparkline, arc / radial / tank gauges, `KpiTile` |
| **Platform extras** | Acrylic surfaces, notification bridge, optional media player & WebView2 |

Full index (with Gallery flags): [docs/components.md](docs/components.md) · [online API](https://wuyijing-dev.github.io/QWinui3/components/).

---

## Try it without building

From [GitHub Releases](https://github.com/wuyijing-dev/QWinui3/releases/latest) (built by CI):

| Asset | Platform | Use |
|-------|----------|-----|
| **`qwinui3-gallery-*-windows-x64.zip`** | Windows x64 | Gallery + Qt runtime (`windeployqt`) — run `qwinui3_gallery.exe` |
| **`qwinui3-*-windows-x64-shared.zip`** | Windows x64 | Shared DLLs + QML (needs Qt **6.5+** MSVC; CI builds with 6.8) |
| **`qwinui3-gallery-*-linux-x64.tar.gz`** | Linux x64 | Gallery AppDir + Qt runtime — run `./run-gallery.sh` (Wayland-first; do not force `xcb`) |
| **`qwinui3-*-linux-x64-shared.tar.gz`** | Linux x64 | Shared `.so` + QML (needs Qt **6.5+** gcc_64; CI builds with 6.8) |

Release packages are produced by [`.github/workflows/release.yml`](.github/workflows/release.yml) on `v*` tags (or manual **Release** workflow dispatch).

---

## Requirements

| | |
|--|--|
| **Qt** | **6.5+** (recommended **6.8+**) — Quick, QuickControls2, LabsQmlModels (QuickEffects recommended) |
| **CMake** | ≥ 3.21 for presets; ≥ 3.16 minimum in tree |
| **Compiler** | C++17 — **MSVC 2022** recommended on Windows |
| **Generator** | Ninja (presets) or Visual Studio / Qt Creator kit |

**Optional**

- Qt Multimedia → `MediaPlayerElement` (`QWINUI3_BUILD_MEDIA`)
- Edge WebView2 SDK + Runtime → `WebView2Host` (`scripts/fetch_webview2.ps1`, `QWINUI3_BUILD_WEBVIEW2`)

---

## Build from source

```bat
cmake --preset release
cmake --build --preset release --target qwinui3_gallery
build\qwinui3_gallery.exe
```

Point CMake at your Qt install if needed:

1. Copy `CMakeUserPresets.json.example` → `CMakeUserPresets.json`
2. Set `CMAKE_PREFIX_PATH` to your Qt 6.5+ prefix (e.g. `D:/Qt/6.8.0/msvc2022_64`)

Or open the **repo root** `CMakeLists.txt` in [Qt Creator](docs/qt-creator.md) (1.35) with a Qt 6.5+ kit (6.8+ recommended). Build `qwinui3_gallery` or an example target (`qwinui3_example_nav`, …) — there is **no** `.pro` / qmake project.

### CMake options

| Option | Default | Meaning |
|--------|---------|---------|
| `QWINUI3_BUILD_EXAMPLES` | `ON` | Small starter apps under `examples/` |
| `QWINUI3_BUILD_SHARED` | `OFF` | Shared libraries (DLL / `.so`) instead of static |
| `QWINUI3_BUILD_MEDIA` | auto | Media player control when Qt Multimedia is present |
| `QWINUI3_BUILD_WEBVIEW2` | `ON` (Win) | WebView2 host control |

### Shared / redistributable package

In-tree defaults are **STATIC** (convenient for Gallery). Package shared libs on demand:

```bat
REM Full kit (version from QWINUI3_VERSION, e.g. 1.12)
python scripts/package_release_libs.py --shared --archive

REM Presets: all | core (theme+style) | shell (+platform) | extras (theme+extras)
python scripts/package_release_libs.py --shared --preset core --archive

REM Explicit modules (dependencies auto-included)
python scripts/package_release_libs.py --shared --modules platform,extras --archive

REM List options
python scripts/package_release_libs.py --list-modules

REM Gallery (always full app)
python scripts/package_release_gallery.py
```

**Consumer apps (third-party CMake, import paths, Win/Linux runtime):**  
[`docs/packaging-consumer.md`](docs/packaging-consumer.md).

Subset archives are named `qwinui3-<ver>-<os>-x64-shared-<modules>.zip` (e.g. `...-shared-theme+style`).  
Product version is **`X.YY`** (`QWINUI3_VERSION` in root `CMakeLists.txt`).  
Which types to build on: [`docs/stable-api.md`](docs/stable-api.md).  
CI **Release** workflow accepts a `modules` input on manual dispatch; tag pushes (`vX.YY`) publish the full kit.

---

## Examples

Copy-ready starters — see [`examples/README.md`](examples/README.md):

| Target | Demonstrates |
|--------|----------------|
| `qwinui3_example_nav` | `StandardWindow` + `NavigationView` + Settings footer |
| `qwinui3_example_settings` | `SettingsCard` / `SettingsExpander` settings page |
| `qwinui3_example_dashboard` | `KpiTile` + charts / gauges layout |
| `qwinui3_example_master_detail` | `ListDetailsView` master–detail LoB shell (1.26) |
| `qwinui3_example_form` | `FormLayout` validation + SettingsCard prefs (1.26) |

```bat
cmake --build --preset release --target qwinui3_example_nav qwinui3_example_settings qwinui3_example_dashboard qwinui3_example_master_detail qwinui3_example_form
```

---

## Repository layout

```
src/compat/      Qt 6.5 / 6.8 / 6.10+ C++ compatibility (qwinui3_qtcompat)
src/theme/       QWinUI3.Theme
src/style/       Qt Quick Controls style (QWinUI3)
src/platform/    QWinUI3.Platform
src/extras/      QWinUI3.Extras
src/gallery/     Control catalog application
examples/        Small starter apps
docs/            Markdown + MkDocs site source
scripts/         Docs generator, shared/gallery packaging, WebView2 fetch
.github/         Docs Pages + Release CI + Smoke CI
```

### CI releases

Push a version tag (or run **Actions → Release → Run workflow**):

```bash
git tag v1.30
git push origin v1.30
```

**PR / master smoke** (build Gallery + `--smoke`, no packages): [`.github/workflows/smoke.yml`](.github/workflows/smoke.yml) — see [`docs/ci-smoke.md`](docs/ci-smoke.md).

GitHub Actions builds Linux + Windows shared libraries and Gallery packages, then attaches them to the GitHub Release. Manual dispatch can re-upload assets for an existing tag (e.g. add Linux packages to `v1.00` / historical `v1.0.0`).

Product versions use **`X.YY`** (see [`ROADMAP.md`](ROADMAP.md)); set `QWINUI3_VERSION` in root `CMakeLists.txt`.

---

## Documentation

| Resource | Description |
|----------|-------------|
| [Docs site](https://wuyijing-dev.github.io/QWinui3/) | MkDocs Material (GitHub Pages) |
| [`docs/recipes.md`](docs/recipes.md) | **Recipes hub** — all LoB how-tos (1.36) |
| [`docs/stable-api.md`](docs/stable-api.md) | Stable vs experimental types for 1.xx |
| [`docs/components.md`](docs/components.md) | Full control index |
| [`docs/qt-creator.md`](docs/qt-creator.md) | Open Gallery / examples (CMake only) |
| [`docs/packaging-consumer.md`](docs/packaging-consumer.md) | Shared zip / CMake / runtime |
| [`ROADMAP.md`](ROADMAP.md) | Version themes — small `X.YY` slices |

Individual recipes (navigation, forms, shells, feedback, …) are listed on the [hub](docs/recipes.md) — reachable in ≤2 clicks from here.

Regenerate API pages from QML comments:

```bat
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
```

---

## License

[LGPL-3.0](LICENSE) (see also [COPYING](COPYING) for the GPL-3.0 terms incorporated by LGPL-3.0).

Fluent icon font licensing notes live under `src/theme/QWinUI3/Theme/fonts/`.
