# WindowHelper (QML singleton)

Platform chrome helper exposed as `WindowHelper` from `QWinUI3.Platform`.
Source: [`src/platform/QWinUI3/Platform/WindowHelper.h`](../src/platform/QWinUI3/Platform/WindowHelper.h).

Related: [window shells](window-shells.md) · [AppWindow presenters](window-appwindow.md) · [component index](components.md).

## Install / paradigm

```qml
import QWinUI3.Platform

WindowHelper.install(window, Theme.dark, WindowHelper.BackdropMica)
WindowHelper.installParadigm(window, WindowHelper.ParadigmDialog, Theme.dark,
                             WindowHelper.BackdropSolid)
WindowHelper.centerOnScreen(window)
WindowHelper.reapply(window)
```

| Method | Role |
|--------|------|
| `install(window, dark, backdrop)` | Attach native chrome + backdrop to a `Window` |
| `installParadigm(window, paradigm, dark, backdrop)` | Install with Standard / Dialog / Tool flags |
| `installParadigmEx(...)` | Paradigm + presenter + always-on-top |
| `flagsForParadigm(paradigm)` / `flagsForConfig(...)` | Recommended `Qt.WindowFlags` |
| `paradigmName(paradigm)` | `"standard"` / `"dialog"` / `"tool"` |
| `centerOnScreen(window)` | Center on the current screen |
| `setDarkMode(window, dark)` | Toggle dark title-bar / DWM attributes |
| `setBackdrop(window, backdrop)` | Change backdrop mode |
| `setCornerStyle(window, corner)` | Rounded corner preference |
| `reapply(window?)` | Re-apply chrome to the tracked / given window |
| `backdropName(backdrop)` | Human-readable backdrop name |

## Presenter / title bar

WinUI-aligned `AppWindowPresenterKind` and title-bar height options.

| Method | Role |
|--------|------|
| `setPresenter(window, kind)` | Overlapped / FullScreen / CompactOverlay |
| `presenterKind(window)` / `presenterName(kind)` | Query presenter |
| `setAlwaysOnTop(window, on)` / `isAlwaysOnTop(window)` | Stay-on-top |
| `titleBarHeightForOption(option)` | `32` (standard) or `48` (tall) |
| `titleBarHeightName(option)` | `"standard"` / `"tall"` |

## Hit-test layout

Caption drag vs client content uses **screen-logical** rectangles (`mapToGlobal`), so maximize / fullscreen caption buttons stay clickable.

```qml
WindowHelper.updateHitTestLayout(
    window,
    titleBar.mapToGlobal(0, 0).x, … // prefer QRect from QML helper
    minimizeRect, maximizeRect, closeRect,
    clientRects)  // non-draggable areas inside the title bar
```

`PlatformTitleBar` / `TitleBar` call this whenever layout changes.

## Properties (QML)

| Property | Role |
|----------|------|
| `platformName` / `windows` / `linux` | Host OS |
| `customFrame` / `nativeChrome` / `supportsBackdrop` | Capability flags |
| `recommendedFlags` | Default window flags for custom chrome |
| `windowColor` / `contentTint` / `titleBarTint` | Chrome tints |
| `backdrop` / `cornerPreference` / `borderVisible` | Material + chrome |
| `windowActive` | Active state |
| `captionHover` / `captionPressed` | Caption button feedback (`CaptionMinimize`…) |
| `frostEnabled` / `frostBlur` / `frostSaturation` | Qt-side frost when DWM can't composite |
| `desktopWallpaperUrl` / `virtualDesktopGeometry` | Wallpaper sampling |
| `systemReducedMotion` / `systemHighContrast` | OS a11y (`refreshAccessibility()`) |

## Enums

- **Backdrop:** `BackdropAuto`, `None`, `Mica`, `Acrylic`, `MicaAlt`, `Transparent`, `Solid`
- **CornerPreference:** `CornerDefault`, `DoNotRound`, `Round`, `RoundSmall`
- **CaptionButton:** `CaptionNone`, `Minimize`, `Maximize`, `Close`
- **WindowParadigm:** `ParadigmStandard`, `Dialog`, `Tool`
- **PresenterKind:** `PresenterOverlapped`, `FullScreen`, `CompactOverlay`
- **TitleBarHeightOption:** `TitleBarHeightStandard` (32), `Tall` (48)

## Accessibility

```qml
WindowHelper.refreshAccessibility()
Theme.reducedMotion = WindowHelper.systemReducedMotion
Theme.highContrast = WindowHelper.systemHighContrast
```

When `Theme.followSystemAccessibility` is true, Gallery / shells mirror these SPI values.
