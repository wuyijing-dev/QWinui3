# Window / AppWindow mapping (WinUI 3 ↔ QWinUI3)

| WinUI 3 | QWinUI3 |
|---------|---------|
| `Window` + `AppWindow` | `StandardWindow` (`DialogWindow` / `ToolWindow` / `CompactOverlayWindow`) |
| `AppWindow.Presenter` Overlapped / FullScreen / CompactOverlay | `WindowHelper.Presenter*` + `StandardWindow.presenter` |
| `SystemBackdrop` Mica / Acrylic | `WindowHelper.Backdrop*` + `StandardWindow.backdrop` |
| `AppWindowTitleBar` | `PlatformTitleBar` + `CaptionButton` |
| `TitleBar` (LeftHeader / Icon / Title / Subtitle / Content / RightHeader / Back / PaneToggle) | `QWinUI3.Extras.TitleBar` |
| `ExtendsContentIntoTitleBar` | `StandardWindow.extendsContentIntoTitleBar` (custom frame) |
| `PreferredHeightOption` Standard / Tall | `WindowHelper.TitleBarHeight*` |
| ContentDialog (in-app modal) | `ContentDialog` + `ContentDialogQueue` (not a top-level HWND) |
| Dialog / Tool / CompactOverlay app windows | `DialogShellWindow` / `ToolShellWindow` / `CompactOverlayShellWindow` |
| System reduce animations / high contrast | `WindowHelper.systemReducedMotion` / `systemHighContrast` → `Theme.*` |

Composition:

```text
StandardWindow
  └── header: PlatformTitleBar          // caption buttons + hit-test
        └── TitleBar { embedded: true } // WinUI TitleBar content
```

See also `window-transparency-dwm.md` for Solid vs Mica/Acrylic gallery policy.
