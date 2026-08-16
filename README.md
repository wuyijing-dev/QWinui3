# QWinUI3

**v1.0.0** — Fluent / [WinUI 3](https://learn.microsoft.com/windows/apps/winui/winui3/)-inspired controls for **Qt 6.8+** Quick.

LGPL-3.0 · [Documentation](https://wuyijing-dev.github.io/QWinui3/) · [Component API](https://wuyijing-dev.github.io/QWinui3/components/)

## What’s included

| Module | Import | Role |
|--------|--------|------|
| Style | `QtQuick.Controls` + style `QWinUI3` | Fluent chrome for standard Quick Controls |
| Theme | `QWinUI3.Theme` | Tokens, FluentIcons, density / dark / accent |
| Platform | `QWinUI3.Platform` | Title bar, shells, WindowHelper, optional WebView2 |
| Extras | `QWinUI3.Extras` | NavigationView, InfoBar, gauges, charts, settings cards, … |

Apps set:

```bat
set QT_QUICK_CONTROLS_STYLE=QWinUI3
```

## Requirements

- Qt **6.8+** (Quick, QuickControls2, LabsQmlModels; QuickEffects recommended)
- CMake **≥ 3.21** (presets) / **≥ 3.16** (minimum in tree)
- C++17 compiler (MSVC 2022 recommended on Windows)
- Ninja (or another CMake generator)

Optional:

- Qt Multimedia → `MediaPlayerElement` (`QWINUI3_BUILD_MEDIA`)
- Edge WebView2 SDK → `WebView2Host` (`scripts/fetch_webview2.ps1`, `QWINUI3_BUILD_WEBVIEW2`)

## Quick start

```bat
cmake --preset release
cmake --build --preset release --target qwinui3_gallery
build\qwinui3_gallery.exe
```

Or open the **repo root** `CMakeLists.txt` in [Qt Creator](docs/qt-creator.md) with a Qt 6.8+ kit and build `qwinui3_gallery`.

Local Qt path (optional): copy `CMakeUserPresets.json.example` → `CMakeUserPresets.json` and edit `CMAKE_PREFIX_PATH`.

### Shared libraries

Default in-tree builds are **STATIC**. For redistributable DLLs / `.so`:

```bat
python scripts/package_release_libs.py --shared
```

## Repository layout

```
src/theme/      QWinUI3.Theme
src/style/      Qt Quick Controls style
src/platform/  QWinUI3.Platform
src/extras/    QWinUI3.Extras
src/gallery/   Control catalog app
examples/      Small starter apps
docs/          Markdown + MkDocs site source
scripts/       generate_component_docs.py, package_release_libs.py
```

## Examples

See [`examples/README.md`](examples/README.md):

- `qwinui3_example_nav` — NavigationView shell
- `qwinui3_example_settings` — Settings cards
- `qwinui3_example_dashboard` — KPI / charts layout

## Documentation

| Link | Description |
|------|-------------|
| [Docs site](https://wuyijing-dev.github.io/QWinui3/) | MkDocs Material |
| [`docs/components.md`](docs/components.md) | Full control index |
| [`docs/conventions.md`](docs/conventions.md) | Radius, a11y, import rules |
| [`docs/window-shells.md`](docs/window-shells.md) | ShellWindow family |

Regenerate API pages from QML comments:

```bat
python scripts/generate_component_docs.py
```

## License

[LGPL-3.0](LICENSE) (see also [COPYING](COPYING) for GPL-3.0 terms incorporated by LGPL-3.0).

Third-party notes: Fluent icon font licensing under `src/theme/QWinUI3/Theme/fonts/`.
