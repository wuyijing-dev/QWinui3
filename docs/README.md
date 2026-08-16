# QWinUI3 documentation

Published site: **https://wuyijing-dev.github.io/QWinui3/**

## Conventions

| Doc | Description |
|-----|-------------|
| [`index.md`](index.md) | Docs site home |
| [`conventions.md`](conventions.md) | Radius/clip pitfalls, Accessible rules, Extras import rule |
| [`gallery-catalog-page.md`](gallery-catalog-page.md) | Gallery `CatalogPage` host — **Item not Page**, footer/overlay slots |
| [`graphics-backend.md`](graphics-backend.md) | RHI ship table, frost caveats, `--rhi` / Settings (1.31) |
| [`tree-data.md`](tree-data.md) | TreeView hierarchy, keyboard, a11y (1.33) |
| [`feedback.md`](feedback.md) | InfoBar / Toast / TeachingTip / Progress (1.34) |
| [`webview2-future.md`](webview2-future.md) | Why WebEngine is stripped; WebView2 as future Windows path |
| [`platform-linux-wayland.md`](platform-linux-wayland.md) | Linux Wayland/X11, FilePicker, tray, **Fluent-on-Linux moat** |

## Component API

| Doc | Description |
|-----|-------------|
| [`components.md`](components.md) | Index of all controls |
| [`components/`](components/) | One markdown page per control (generated) |
| [`components.json`](components.json) | Machine-readable catalog (generated) |

Source of truth is the `//` comment header in each `.qml` file. Regenerate:

```bash
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
```

Build the MkDocs site locally:

```bash
pip install -r requirements-docs.txt
python scripts/generate_component_docs.py
mkdocs serve
```

Header convention:

```qml
// Name — one-line summary.
//
//   Name {
//       /* example + // --- API --- call notes */
//   }
//
// @notes
//   Optional free-form notes rendered as ## Notes.
```

## Window / chrome

| Doc | Description |
|-----|-------------|
| [`window-shells.md`](window-shells.md) | ShellWindow vs StandardWindow · Win/Linux soak matrix (1.32) |
| [`window-helper.md`](window-helper.md) | `WindowHelper` singleton API |
| [`window-appwindow.md`](window-appwindow.md) | AppWindow presenters / title-bar height |
| [`window-transparency-dwm.md`](window-transparency-dwm.md) | DWM / Mica / Acrylic notes |

## Tooling

| Doc | Description |
|-----|-------------|
| [`qt-creator.md`](qt-creator.md) | Open the CMake project in Qt Creator (presets, kits, Ninja) |
