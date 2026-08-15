# QWinUI3 documentation

## Component API

| Doc | Description |
|-----|-------------|
| [`components.md`](components.md) | Index of all controls |
| [`components/`](components/) | One markdown page per control (generated) |

Source of truth is the `//` comment header in each `.qml` file. Regenerate:

```bash
python scripts/generate_component_docs.py
python scripts/generate_component_docs.py --lint
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
| [`window-shells.md`](window-shells.md) | ShellWindow family vs StandardWindow |
| [`window-helper.md`](window-helper.md) | `WindowHelper` singleton API |
| [`window-appwindow.md`](window-appwindow.md) | AppWindow presenters / title-bar height |
| [`window-transparency-dwm.md`](window-transparency-dwm.md) | DWM / Mica / Acrylic notes |
