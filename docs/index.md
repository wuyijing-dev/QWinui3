# QWinUI3

Fluent / WinUI 3–inspired controls for **Qt 6.8+** Quick.

This site is generated from QML source comments and shipped via GitHub Pages.

## Start here

| Section | Description |
|---------|-------------|
| [Component API](components.md) | Full public + internal control index |
| [Conventions](conventions.md) | Radius, Accessible, Extras import rules |
| [Window shells](window-shells.md) | ShellWindow family vs StandardWindow |
| [WindowHelper](window-helper.md) | Platform chrome singleton |
| [Qt Creator](qt-creator.md) | Open / build the CMake project |

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
