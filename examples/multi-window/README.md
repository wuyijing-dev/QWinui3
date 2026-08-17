# Multi-window example (1.56)

Main `ShellWindow` + secondary `ToolShellWindow` + owned `DialogShellWindow`. Shared Theme, distinct `geometryPersistenceKey`s, dialog transient parent.

| Related | Role |
|---------|------|
| [`gallery-shell/`](../gallery-shell/) | Single-window app chrome (start here for nav shells) |
| [docs/window-shells.md](../../docs/window-shells.md) | Multi-window recipe + Win/Linux notes |
| [docs/window-helper.md](../../docs/window-helper.md) | `setTransientParent` / geometry API |
| [docs/window-chrome.md](../../docs/window-chrome.md) | Dialog-behind / off-screen failure modes |

## Build / run

```bat
cmake --build build --config Release --target qwinui3_example_multi_window
build\qwinui3_example_multi_window.exe
```

```bash
cmake --build build --target qwinui3_example_multi_window
./build/qwinui3_example_multi_window
```

Preset: `cmake --build --preset example-multi-window`.

## What this demonstrates

| Surface | Key / ownership |
|---------|-----------------|
| Main `ShellWindow` | `MultiWindowExampleMain` |
| `ToolShellWindow` | `MultiWindowExampleTool` (independent top-level) |
| `DialogShellWindow` | `MultiWindowExampleDialog` + `openDialog(main)` → `setTransientParent` |
| Theme | One process — toggle Dark on the tool; main follows |

## Win + Linux notes

- Prefer **`BackdropSolid`** on every shell (Linux coerces Mica/Acrylic anyway).
- Transient parent stacks the dialog with the owner on Windows; Wayland/X11 follow the compositor (still call `setTransientParent` + `centerOnScreen`).
- Do **not** reuse one geometry key for main and tool.
- In-page confirms stay as **`ContentDialog`**; only use a second HWND when you need a real tool/dialog window.

Gallery: **Multi-window** page · **Window shells** spawn demos.
