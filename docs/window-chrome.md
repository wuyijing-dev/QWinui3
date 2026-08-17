# Window chrome failure modes (Windows-first) (1.32)

Product shells should follow Gallery: **`BackdropSolid`** + `PlatformTitleBar` / `TitleBar` + `reportHitTest()` after layout, plus a stable **`geometryPersistenceKey`** when you want size/pos remembered.

See also [window-shells.md](window-shells.md) (Win/Linux soak matrix) · [window-helper.md](window-helper.md) · [window-transparency-dwm.md](window-transparency-dwm.md) · [graphics-backend.md](graphics-backend.md) · [platform-linux-wayland.md](platform-linux-wayland.md).

**1.04** tightened DPI / backdrop reapply. **1.32** re-soaks the shell matrix and documents multi-monitor geometry clamp as the supported persistence recipe. **1.58** adds mixed-DPI `setScreen` on restore + Gallery **High-DPI & monitors** readout — [high-dpi.md](high-dpi.md).

---

## Recommended recipe

```qml
StandardWindow {
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MainWindow"   // optional but recommended for product apps
    header: PlatformTitleBar {
        id: chrome
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
            // …
            onWidthChanged: chrome.reportHitTest()
            onHeightChanged: chrome.reportHitTest()
        }
    }
    Component.onCompleted: Qt.callLater(chrome.reportHitTest)
}
```

Or ship Extras shells (`NavigationWindow` / `ShellWindow`) with the same Solid + persistence key — [window-shells.md](window-shells.md).

Dialog top-levels:

```qml
DialogWindow {
    id: dlg
    ownerWindow: mainWindow
}
// …
dlg.openDialog()   // setTransientParent + centerOnScreen + visible
```

Or Extras `DialogShellWindow` / `ToolShellWindow` with distinct `geometryPersistenceKey`s — sample [`examples/multi-window`](../examples/multi-window/) (**1.56**).

`NavigationWindow` defaults to `BackdropSolid`. Prefer it (or `ShellWindow`) for product UI; keep `StandardWindow` for Gallery-style hosts.

---

## Host × backdrop matrix (1.32)

| Host | Solid | Mica / Acrylic (Win) | Linux frost |
|------|-------|----------------------|-------------|
| `StandardWindow` (Gallery) | Default | Experiment via Window paradigm page | Coerced → Solid |
| `ShellWindow` / Blank / Nav / MenuStatus | Prefer Solid | Supported on Win DWM | Coerced → Solid |
| Dialog / Tool / Overlay shells | Prefer Solid | Same as ShellWindow | Coerced → Solid |

Always paint with `effectiveBackdrop` / `WindowHelper.resolveBackdrop(backdrop)` when materials may be coerced. For real Mica/Acrylic on Windows, pin **OpenGL** RHI — [graphics-backend.md](graphics-backend.md).

---

## Failure modes

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| White / hollow client when using Mica/Acrylic | Transparent clear color without working DWM material (or Linux) | Use `BackdropSolid`, or rely on `resolveBackdrop()` / `effectiveBackdrop` |
| Mica missing after show / theme switch | Qt recreated style after `install` | Shells `reapply` on first `visible`; Win filter reapplies on activate / show |
| Mica missing after DPI change (125%↔150%) | DWM attributes cleared on `WM_DPICHANGED` | 1.04 schedules backdrop reapply; QML refreshes hit-test via `screensChanged` |
| Caption buttons miss clicks after maximize / DPI | Stale NC hit-test rects | `PlatformTitleBar.reportHitTest()` on resize, visibility, screen, `screensChanged` |
| Dialog opens behind main / wrong screen | No transient parent / not centered | `DialogWindow.openDialog(owner)` or `setTransientParent` + `centerOnScreen` |
| Double title bar on Wayland | Compositor SSD still on | `QWinUI3::configureEnvironment` / `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` — [platform-linux-wayland.md](platform-linux-wayland.md) (**1.38**) |
| Snap Layouts flyout never appears | Maximize caption not `HTMAXIMIZE` | Ensure `nativeChrome` path + hit-test reports maximize rect; `snapLayoutsEnabled` |
| Binding `flags` to paradigm | HWND recreate loop | Keep `flags: WindowHelper.recommendedFlags` constant; change paradigm via `installParadigmEx` |
| Window restores off-screen / wrong monitor | Stale geometry after dock undock | Use `geometryPersistenceKey` — restore clamps to preferred / intersecting / primary `availableGeometry` |
| Wrong DPR after restore to another monitor | Window still bound to old `QScreen` | **1.58** restore calls `setScreen` after clamp — [high-dpi.md](high-dpi.md) |
| Thin white edge with frost | D3D RHI + transparent host | Prefer OpenGL — [graphics-backend.md](graphics-backend.md) |

---

## Geometry persistence checklist

1. Set a **stable unique** `geometryPersistenceKey` per top-level role (`"MainWindow"`, `"Inspector"`, …).
2. Rely on shell debounce-save + close-save; do not invent a second QSettings schema.
3. Expect multi-monitor clamp on restore (min **160×120**, fit inside taskbar-safe area, prefer saved screen name).
4. Call `clearSavedGeometry()` when shipping a “reset layout” action.
5. Gallery Main uses `"GalleryMain"` — see [window-helper.md](window-helper.md#window-geometry-persistence).
6. **Multi-window (1.56):** never reuse one key for main + tool; owned dialogs use `openDialog(owner)` — [window-shells.md](window-shells.md#multi-window--secondary-shells-156).

---

## DPI checklist

1. `Theme.devicePixelRatio` tracks the window screen (`StandardWindow` / `ShellWindowSupport`).
2. Hit-test rects are **screen-logical** (`mapToGlobal`); native code multiplies by DPR.
3. After monitor / scaling changes, expect `WindowHelper.screensChanged` → re-report hit-test + optional `reapply`.
4. Full matrix + Gallery readout: [high-dpi.md](high-dpi.md) (**1.58**).

---

## Backdrop checklist (Windows)

| Mode | Client clear | DWM |
|------|--------------|-----|
| `BackdropSolid` | Opaque `Theme.bgLayer` | `DWMSBT_NONE` (Gallery default) |
| `BackdropMica` / `MicaAlt` / `Acrylic` | Transparent host | System backdrop types |
| `BackdropNone` | You own the fill | None |

Gallery stays on **Solid**. Experiments: Gallery **Window shells** page, or set `backdrop` and keep `effectiveBackdrop` for paint.

---

## Examples

| Example | Pattern |
|---------|---------|
| `examples/nav-settings` | Gallery-like `PlatformTitleBar` + `TitleBar` + `NavigationView` |
| `examples/settings-cards` | Same chrome + `SettingsView` |
| `examples/dashboard` | Same chrome + dashboard body |
| `examples/master-detail` | Same chrome + `ListDetailsView` (1.26) |
| `examples/form-settings` | Same chrome + `FormLayout` / SettingsCard (1.26) |
