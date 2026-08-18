# Multi-window example (1.56 · harden 2.14)

Main `ShellWindow` + secondary `ToolShellWindow` + owned `DialogShellWindow`. Shared Theme, distinct `geometryPersistenceKey`s, dialog transient parent + **centerOnOwner**.

| Related | Role |
|---------|------|
| [`gallery-shell/`](../gallery-shell/) | Single-window app chrome (start here for nav shells) |
| [docs/window-shells.md](../../docs/window-shells.md) | Multi-window recipe + **2.14** Wayland harden |
| [docs/window-helper.md](../../docs/window-helper.md) | `setTransientParent` / `centerOnOwner` / geometry API |
| [docs/window-chrome.md](../../docs/window-chrome.md) | Dialog-behind / off-screen failure modes |
| [docs/security-trust.md](../../docs/security-trust.md) | Wayland portal `parent_window` regression |

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
| `DialogShellWindow` | `MultiWindowExampleDialog` + `openDialog(main)` → transient parent + **centerOnOwner** |
| Theme | One process — toggle Dark on the tool; main follows |
| Portal readout | Status line shows `WindowHelper.portalParentWindow(main)` after opening dialog |

## Win + Linux notes

- Prefer **`BackdropSolid`** on every shell (Linux coerces Mica/Acrylic anyway).
- **2.14:** `setTransientParent` realizes child + parent surfaces before parenting (Wayland).
- Use **`openDialog(owner)`** — centers on the **owner monitor**, not always primary.
- Do **not** reuse one geometry key for main and tool.
- In-page confirms stay as **`ContentDialog`**; only use a second HWND when you need a real tool/dialog window.

Gallery: **Multi-window** page · **Window shells** spawn demos.
