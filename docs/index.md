# QWinUI3

Fluent / WinUI 3–inspired controls for **Qt 6.5+** Quick (recommended **6.8 LTS**; forward **6.10+**).

This site is generated from QML source comments and shipped via GitHub Pages.

## Start here

| | |
|--|--|
| **[Recipes hub](recipes.md)** | All LoB how-tos — also Gallery **Recipes** category |
| [Stable API](stable-api.md) | What to rely on in 1.xx apps (promote/defer **1.37**) |
| [1.xx maturity](maturity-1xx.md) | Checkpoint verdict — harden-first (**1.51**) |
| [1.xx compatibility](compatibility-1xx.md) | Will-not-break Theme / shells / stable (**1.40** / **1.51**) |
| [Upgrade notes](upgrade-notes.md) | Consumer checklist + template (**1.40**) |
| [Drag-drop & clipboard](drag-drop.md) | FileDropZone / CopyButton / WindowHelper (**1.41**) |
| [Adaptive layout](adaptive-layout.md) | TwoPaneView / ListDetailsView breakpoints (**1.42**) |
| [Color & contrast](color-contrast.md) | AA diagnostics / `Theme.contrastRatio` (**1.43**) |
| [Keyboard-first](keyboard.md) | Global chords → palette → dialogs → lists (**1.44**) |
| [On-screen keyboard](on-screen-keyboard.md) | Win11 OSK + MIT IME deepen (**1.76**; still experimental) |
| [i18n / RTL](i18n-rtl.md) | qsTr + zh_CN seed + LayoutMirroring (**1.45**) |
| [Consumer packaging](packaging-consumer.md) | Shared vs static / windeploy / strip (**1.46**) |
| [Shell extras](shell-extras.md) | Snap Layouts · taskbar · attention (**1.47**) |
| [Dialogs & flyouts](dialogs-flyouts.md) | ContentDialogQueue FIFO · Esc (**1.48**) |
| [Component API](components.md) | Full public + internal control index |
| [Qt Creator](qt-creator.md) | Open Gallery / examples (CMake only) |
| [Roadmap](roadmap.md) | Small `1.xx` slices |

Top recipes (also on the hub): [Window shells](window-shells.md) · [Navigation](navigation.md) · [Forms](forms.md) · [Data collections](data-collections.md) · [Feedback](feedback.md) · [System integration](system-integration.md) · [Performance](performance.md) (cold start **1.39**).

Platform note: [Linux / Wayland edge cases](platform-linux-wayland.md) (field failure matrix, **1.38**).

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
