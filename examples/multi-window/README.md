# Multi-window example

Main `ShellWindow` + secondary `ToolShellWindow` + owned `DialogShellWindow`, plus **3.08**:

- **W7** — `WindowMessageBus` channel `appearance` (theme / accent / layoutDirection)
- **W8** — `PanelFloatHost` detaches a filter pane into a `ToolShellWindow`

Shared Theme (same process). Distinct `geometryPersistenceKey`s. Dialog transient parent + **centerOnOwner**.

Recipes: [`docs/window-shells.md`](../../docs/window-shells.md) · [`docs/app-platform-3xx.md`](../../docs/app-platform-3xx.md)

```bat
cmake --build build --config Release --target qwinui3_example_multi_window
build\qwinui3_example_multi_window.exe
```

| Shell | Persistence key |
|-------|-----------------|
| Main | `MultiWindowExampleMain` |
| `ToolShellWindow` | `MultiWindowExampleTool` (independent top-level) |
| Filter float | `MultiWindowExampleFilterFloat` |
| Dialog | `MultiWindowExampleDialog` |
