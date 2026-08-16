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
| [Accessibility](accessibility.md) | 1.02 high-traffic checklist + tracked gaps |
| [Linux / Wayland](platform-linux-wayland.md) | Title bar & backdrop matrix for shells |
| [Qt Creator](qt-creator.md) | Open / build the CMake project |
| [Qt version compat](qt-version-compat.md) | C++ shims for Qt 6.5 / 6.8 / 6.10+ |

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
