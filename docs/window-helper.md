# WindowHelper (QML singleton)

Platform chrome helper exposed as `WindowHelper` from `QWinUI3.Platform`.
Source: [`src/platform/QWinUI3/Platform/WindowHelper.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/WindowHelper.h).

Related: [window shells](window-shells.md) · [AppWindow presenters](window-appwindow.md) · [component index](components.md) · **C++ bootstrap** [`Bootstrap.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/Bootstrap.h) (`QWinUI3::configureEnvironment` / `configureApplication`).

## Install / paradigm

```qml
import QWinUI3.Platform

WindowHelper.install(window, Theme.dark, WindowHelper.BackdropMica)
WindowHelper.installParadigm(window, WindowHelper.ParadigmDialog, Theme.dark,
                             WindowHelper.BackdropSolid)
WindowHelper.installParadigmEx(window, WindowHelper.ParadigmTool, Theme.dark,
                               WindowHelper.BackdropSolid,
                               WindowHelper.PresenterCompactOverlay, true)
WindowHelper.centerOnScreen(window)
WindowHelper.reapply(window)
```

Shell windows expose the same roles as QML properties and helpers:

```qml
ShellWindow {
    paradigm: WindowHelper.ParadigmDialog
    presenter: WindowHelper.PresenterOverlapped
    isAlwaysOnTop: true
    // runtime:
    // setWindowParadigm(...); setPresenterKind(...); setAlwaysOnTopEnabled(true)
    // applyWindowRole(); centerOnScreen()
}
```

| Method | Role |
|--------|------|
| `install(window, dark, backdrop)` | Attach native chrome + backdrop to a `Window` |
| `installParadigm(window, paradigm, dark, backdrop)` | Install with Standard / Dialog / Tool flags |
| `installParadigmEx(...)` | Paradigm + presenter + always-on-top |
| `resolveBackdrop(backdrop)` | Coerce unsupported materials (Linux → Solid) |
| `flagsForParadigm(paradigm)` / `flagsForConfig(...)` | Recommended `Qt.WindowFlags` |
| `paradigmName(paradigm)` | `"standard"` / `"dialog"` / `"tool"` |
| `centerOnScreen(window)` | Center on the current screen |
| `saveWindowGeometry(window, key?)` | Persist normal geometry + maximized state (`QSettings` → `WindowGeometry/<key>`) |
| `restoreWindowGeometry(window, key?)` | Restore if stored; clamps to available screens; returns `bool` |
| `clearWindowGeometry(key?)` | Remove stored geometry for `key` (default `"MainWindow"`) |
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
| `displayServer` / `wayland` / `x11` | QPA name (`wayland`, `xcb`, …) |
| `serverSideDecorations` | `!customFrame` (false on Win/Linux with Fluent CSD) |
| `desktopEnvironment` / `waylandDisplay` | `XDG_CURRENT_DESKTOP` / `WAYLAND_DISPLAY` |
| `portalAvailable` | xdg-desktop-portal session bus reachable |
| `devicePixelRatio` | Primary screen DPR (fractional scale) |
| `systemPrefersDark` | OS light/dark (`refreshColorScheme()`) |
| `snapLayoutsEnabled` | Win11 Snap Layouts via `HTMAXBUTTON` (default on) |

## Linux / Wayland startup

```cpp
```cpp
// Preferred (one-call):
#include "Bootstrap.h"
QWinUI3::configureEnvironment(argv[0]); // before QGuiApplication
QGuiApplication app(argc, argv);
QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));

// Or call WindowHelper directly:
WindowHelper::configurePlatformEnvironment(); // before QGuiApplication
```
QGuiApplication app(argc, argv);
QGuiApplication::setDesktopFileName(QStringLiteral("org.example.app"));
```

```qml
WindowHelper.requestActivateWindow(window)
WindowHelper.setTransientParent(dialogWindow, mainWindow)
WindowHelper.openExternalUrl("https://example.com")
Theme.followSystemColorScheme = true
```

See [platform-linux-wayland.md](platform-linux-wayland.md).

## Taskbar progress (Windows)

```qml
WindowHelper.setTaskbarProgress(window, 0.4)           // 0…1
WindowHelper.setTaskbarProgressState(window, WindowHelper.TaskbarPaused)
WindowHelper.clearTaskbarProgress(window)
WindowHelper.setTaskbarOverlayText(window, "3")      // badge
WindowHelper.clearTaskbarOverlay(window)
```

Uses `ITaskbarList3`. No-op on Linux / other platforms.

## Attention / files / idle / clipboard

```qml
WindowHelper.requestUserAttention(window)            // FlashWindowEx / raise+alert
WindowHelper.revealFileInFolder(path)                // Explorer /select or FileManager1
WindowHelper.copyText("hello")
WindowHelper.clipboardText()
WindowHelper.systemBeep()
WindowHelper.inhibitIdle("Rendering")
WindowHelper.releaseIdleInhibit()
WindowHelper.idleInhibited
```

## Power / network / screens / shell

```cpp
WindowHelper::setAppUserModelId("org.example.app"); // early in main (Windows AUMID)
```

```qml
WindowHelper.refreshPowerStatus()
WindowHelper.batteryLevel   // 0–100 or -1
WindowHelper.onBattery
WindowHelper.refreshOnlineStatus()
WindowHelper.isOnline
WindowHelper.screenCount
WindowHelper.screensInfo()  // [{name, geometry, dpr, primary, …}]
WindowHelper.addToRecentDocuments(path)
WindowHelper.clearRecentDocuments() // Windows
```

## Window geometry persistence

Stores **normal** frame geometry (and maximized vs windowed) under the application `QSettings` path as `WindowGeometry/<key>`. Missing or off-screen values are ignored / clamped.

```qml
import QWinUI3.Platform

// Low-level API
WindowHelper.restoreWindowGeometry(window, "MainWindow")
WindowHelper.saveWindowGeometry(window, "MainWindow")
WindowHelper.clearWindowGeometry("MainWindow")

// Built into StandardWindow / ShellWindow (empty key = off)
StandardWindow {
    geometryPersistenceKey: "MainWindow"
}
ShellWindow {
    geometryPersistenceKey: "MainWindow"
}
```

Shells debounce-save on resize/move and always save on close. Call `clearSavedGeometry()` to forget the stored frame.

See also [Linux / Wayland](platform-linux-wayland.md).

## Enums

- **Backdrop:** `BackdropAuto`, `None`, `Mica`, `Acrylic`, `MicaAlt`, `Transparent`, `Solid`
- **CornerPreference:** `CornerDefault`, `DoNotRound`, `Round`, `RoundSmall`
- **CaptionButton:** `CaptionNone`, `Minimize`, `Maximize`, `Close`
- **WindowParadigm:** `ParadigmStandard`, `Dialog`, `Tool`
- **PresenterKind:** `PresenterOverlapped`, `FullScreen`, `CompactOverlay`
- **TitleBarHeightOption:** `TitleBarHeightStandard` (32), `Tall` (48)
- **TaskbarProgressState:** `TaskbarNoProgress`, `Indeterminate`, `Normal`, `Error`, `Paused`

## Accessibility

```qml
WindowHelper.refreshAccessibility()
Theme.reducedMotion = WindowHelper.systemReducedMotion
Theme.highContrast = WindowHelper.systemHighContrast
```

When `Theme.followSystemAccessibility` is true, Gallery / shells mirror these SPI values.
