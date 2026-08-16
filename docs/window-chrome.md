# Window chrome failure modes (Windows-first)

Product shells should follow Gallery: **`BackdropSolid`** + `PlatformTitleBar` / `TitleBar` + `reportHitTest()` after layout. See also [window-shells.md](window-shells.md), [window-helper.md](window-helper.md), [window-transparency-dwm.md](window-transparency-dwm.md).

**1.04** tightens `StandardWindow` / `NavigationWindow` / dialog shells for common DPI and backdrop cases.

---

## Recommended recipe

```qml
StandardWindow {
    backdrop: WindowHelper.BackdropSolid
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

Dialog top-levels:

```qml
DialogWindow {
    id: dlg
    ownerWindow: mainWindow
}
// …
dlg.openDialog()   // setTransientParent + centerOnScreen + visible
```

`NavigationWindow` defaults to `BackdropSolid`. Prefer it (or `ShellWindow`) for product UI; keep `StandardWindow` for Gallery-style hosts.

---

## Failure modes

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| White / hollow client when using Mica/Acrylic | Transparent clear color without working DWM material (or Linux) | Use `BackdropSolid`, or rely on `resolveBackdrop()` / `effectiveBackdrop` |
| Mica missing after show / theme switch | Qt recreated style after `install` | Shells `reapply` on first `visible`; Win filter reapplies on activate / show |
| Mica missing after DPI change (125%↔150%) | DWM attributes cleared on `WM_DPICHANGED` | 1.04 schedules backdrop reapply; QML refreshes hit-test via `screensChanged` |
| Caption buttons miss clicks after maximize / DPI | Stale NC hit-test rects | `PlatformTitleBar.reportHitTest()` on resize, visibility, screen, `screensChanged` |
| Dialog opens behind main / wrong screen | No transient parent / not centered | `DialogWindow.openDialog(owner)` or `setTransientParent` + `centerOnScreen` |
| Double title bar on Wayland | Compositor SSD still on | `configurePlatformEnvironment` / `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` — see [platform-linux-wayland.md](platform-linux-wayland.md) |
| Snap Layouts flyout never appears | Maximize caption not `HTMAXIMIZE` | Ensure `nativeChrome` path + hit-test reports maximize rect; `snapLayoutsEnabled` |
| Binding `flags` to paradigm | HWND recreate loop | Keep `flags: WindowHelper.recommendedFlags` constant; change paradigm via `installParadigmEx` |

---

## DPI checklist

1. `Theme.devicePixelRatio` tracks the window screen (`StandardWindow` / `ShellWindowSupport`).
2. Hit-test rects are **screen-logical** (`mapToGlobal`); native code multiplies by DPR.
3. After monitor / scaling changes, expect `WindowHelper.screensChanged` → re-report hit-test + optional `reapply`.

---

## Backdrop checklist (Windows)

| Mode | Client clear | DWM |
|------|--------------|-----|
| `BackdropSolid` | Opaque `Theme.bgLayer` | `DWMSBT_NONE` (Gallery default) |
| `BackdropMica` / `MicaAlt` / `Acrylic` | Transparent host | System backdrop types |
| `BackdropNone` | You own the fill | None |

Gallery stays on **Solid**. Experiments: Gallery **Window paradigm** page, or set `backdrop` and keep `effectiveBackdrop` for paint.

---

## Examples

| Example | Pattern |
|---------|---------|
| `examples/nav-settings` | Gallery-like `PlatformTitleBar` + `TitleBar` + `NavigationView` |
| `examples/settings-cards` | Same chrome + `SettingsView` |
| `examples/dashboard` | Same chrome + dashboard body |
