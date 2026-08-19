# QWinUI3

Fluent / [WinUI 3](https://learn.microsoft.com/windows/apps/winui/winui3/)-inspired controls for **Qt 6 Quick** — design tokens, a Quick Controls style, window shells, and an Extras catalog for desktop applications.

[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-2ea44f)](https://wuyijing-dev.github.io/QWinui3/)
[![Qt](https://img.shields.io/badge/Qt-6.5%2B-41CD52?logo=qt&logoColor=white)](https://www.qt.io/)

**Distribution:** source-only — build Gallery and libraries from this repository. Pre-built binaries are not published.

[Documentation](https://wuyijing-dev.github.io/QWinui3/) · [Recipes](docs/recipes.md) · [Stable API](docs/stable-api.md) · [Component index](docs/components.md) · [Roadmap](ROADMAP.md)

---

## Overview

QWinUI3 packages a WinUI-like layer on top of Qt Quick:

| Layer | Module | Role |
|-------|--------|------|
| Style | `QtQuick.Controls` + style `QWinUI3` | Fluent chrome for standard controls |
| Theme | `QWinUI3.Theme` | Tokens, density, dark/light, `FluentIcons` |
| Platform | `QWinUI3.Platform` | `StandardWindow`, shells, `WindowHelper`, optional WebView2 |
| Extras | `QWinUI3.Extras` | Navigation, dialogs, data grids, charts, feedback, settings |

Primary target: **Windows** (MSVC). Many controls run on **Linux**; WebView2 is Windows-only.

---

## Quick start

### Requirements

| | |
|--|--|
| **Qt** | 6.5+ (recommended **6.8 LTS**) — Quick, Quick Controls, Labs QML Models |
| **CMake** | ≥ 3.21 for presets |
| **Compiler** | C++17 — MSVC 2022 on Windows, GCC/Clang on Linux |
| **Generator** | Ninja (presets) or Visual Studio / Qt Creator kit |

### Build Gallery

```bat
cmake --preset release
cmake --build --preset release --target qwinui3_gallery
build\qwinui3_gallery.exe
```

Point CMake at your Qt install when presets do not find it:

1. Copy `CMakeUserPresets.json.example` → `CMakeUserPresets.json`
2. Set `CMAKE_PREFIX_PATH` to your Qt prefix (e.g. `D:/Qt/6.8.3/msvc2022_64`)

Or open the repo root in [Qt Creator](docs/qt-creator.md) with a Qt 6.5+ kit and build target `qwinui3_gallery`.

### Enable the style in your app

```cpp
#include "Bootstrap.h"

QWINUI3_IMPORT_QML_PLUGINS

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]); // before QGuiApplication
    QGuiApplication app(argc, argv);
    QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));
    // …
}
```

Minimal shell:

```qml
import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

StandardWindow {
    width: 1100; height: 720; visible: true
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

## Examples

Copy-ready starters under [`examples/`](examples/README.md):

| Target | Demonstrates |
|--------|----------------|
| `qwinui3_example_gallery_shell` | `NavigationWindow` + Settings + persistence |
| `qwinui3_example_nav` | `StandardWindow` + `NavigationView` |
| `qwinui3_example_settings` | Settings cards / expanders |
| `qwinui3_example_master_detail` | `ListDetailsView` shell |
| `qwinui3_example_form` | `FormLayout` + validation |

```bat
cmake --build --preset release --target qwinui3_example_gallery_shell qwinui3_example_nav
```

**Python Gallery** (PySide6 / PyQt6, not CMake): `python examples/python-gallery/main.py` — see [docs/packaging-python.md](docs/packaging-python.md).

---

## CMake options

| Option | Default | Meaning |
|--------|---------|---------|
| `QWINUI3_BUILD_EXAMPLES` | `ON` | Starter apps under `examples/` |
| `QWINUI3_BUILD_SHARED` | `OFF` | Shared libraries (DLL / `.so`) instead of static |
| `QWINUI3_BUILD_MEDIA` | auto | Media player when Qt Multimedia is present |
| `QWINUI3_BUILD_WEBVIEW2` | `ON` (Win) | WebView2 host control |
| `QWINUI3_FETCH_KEYMAN` | `ON` | Fetch Keyman keyboards if vendored copy is missing |

Product version is **`X.YY`** (`QWINUI3_VERSION` in root `CMakeLists.txt`, currently **2.64**).

---

## Local packaging

In-tree defaults are **static** (Gallery-friendly). To produce a shared kit for your own deployment pipeline:

```bat
python scripts/package_release_libs.py --shared --archive
python scripts/package_release_gallery.py
```

Presets: `all` · `core` · `shell` · `extras` — see [`docs/packaging-consumer.md`](docs/packaging-consumer.md) for `find_package`, vcpkg, and Conan.

---

## Repository layout

```
src/compat/      Qt version compatibility (qwinui3_qtcompat)
src/theme/       QWinUI3.Theme
src/style/       Qt Quick Controls style
src/platform/    QWinUI3.Platform
src/extras/      QWinUI3.Extras
src/gallery/     Control catalog (Gallery)
examples/        Starter applications
docs/            Recipes and MkDocs site source
scripts/         Docs generator, packaging, smoke helpers
.github/         CI (smoke, consumer matrix, docs)
```

### CI

Pull requests and `master` run [smoke](.github/workflows/smoke.yml): Release configure, Gallery build, and `python scripts/smoke_gallery.py --smoke`. No release artifacts are attached to GitHub.

---

## Documentation

- **Site:** https://wuyijing-dev.github.io/QWinui3/
- **Python consumer:** [docs/packaging-python.md](docs/packaging-python.md)
- **Recipes / components:** see [`docs/`](docs/) and MkDocs nav

| Resource | Description |
|----------|-------------|
| [Docs site](https://wuyijing-dev.github.io/QWinui3/) | Published recipes and API |
| [`docs/recipes.md`](docs/recipes.md) | How-to index |
| [`docs/stable-api.md`](docs/stable-api.md) | Stable vs experimental surface |
| [`docs/components.md`](docs/components.md) | Control catalog |
| [`docs/packaging-python.md`](docs/packaging-python.md) | PySide6 / PyQt6 + shared kit (**2.64**) |
| [`ROADMAP.md`](ROADMAP.md) | Version themes and planning |

Regenerate API pages from sources:

```bat
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
```

---

## License

[Apache License 2.0](LICENSE) — see [docs/licensing.md](docs/licensing.md) and [NOTICE](NOTICE).

On-screen keyboard layouts use [SIL Keyman Core](https://github.com/keymanapp/keyman/tree/master/core) (MIT), vendored under `third_party/keyman`. Pinyin data: [mozillazg/pinyin-data](https://github.com/mozillazg/pinyin-data) (MIT).
