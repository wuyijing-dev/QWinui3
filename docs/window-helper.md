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
// Preferred (one-call):
#include "Bootstrap.h"
QWinUI3::configureEnvironment(argv[0]); // before QGuiApplication
QGuiApplication app(argc, argv);
QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));

// Or call WindowHelper directly:
WindowHelper::configurePlatformEnvironment(); // before QGuiApplication
QGuiApplication app(argc, argv);
QGuiApplication::setDesktopFileName(QStringLiteral("org.example.app"));
```

```qml
WindowHelper.requestActivateWindow(window)
WindowHelper.setTransientParent(dialogWindow, mainWindow)
WindowHelper.openExternalUrl("https://example.com")
Theme.followSystemColorScheme = true
```

**Secondary shells (1.56):** use `DialogShellWindow.openDialog(owner)` / `DialogWindow.openDialog(owner)` so transient parenting + center run together. Give each top-level a unique `geometryPersistenceKey` (`"Main"`, `"Tool"`, …). Shared Theme is automatic in-process. Full recipe: [window-shells.md](window-shells.md#multi-window--secondary-shells-156) · sample [`examples/multi-window`](../examples/multi-window/).

See [platform-linux-wayland.md](platform-linux-wayland.md).

## Snap Layouts (Win11)

```qml
WindowHelper.snapLayoutsEnabled = true   // default; hover maximize caption
```

Full recipe + Linux n/a: [shell-extras.md](shell-extras.md) (**1.47**).

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

Full drop + copy/paste recipes (FileDropZone / CopyButton): [drag-drop.md](drag-drop.md) (**1.41**).
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

**Supported recipe (1.32):** set `geometryPersistenceKey` on `StandardWindow` / `ShellWindow` (or call the low-level APIs). Do not invent a parallel QSettings layout.

**App prefs (1.65):** keep theme / toggles / coach flags in a separate `Settings` / `QSettings` category — do not overload `WindowGeometry/<key>`. Cookbook: [settings-persistence.md](settings-persistence.md).

Stores **normal** frame geometry (and maximized vs windowed) under the application `QSettings` path as `WindowGeometry/<key>`, plus the screen **name** when known. Missing or unusable values are ignored / clamped.

```qml
import QWinUI3.Platform

// Low-level API
WindowHelper.restoreWindowGeometry(window, "MainWindow")
WindowHelper.saveWindowGeometry(window, "MainWindow")
WindowHelper.clearWindowGeometry("MainWindow")

// Built into StandardWindow / ShellWindow (empty key = off)
StandardWindow {
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MainWindow"
}
ShellWindow {
    geometryPersistenceKey: "MainWindow"
}
```

Shells debounce-save on resize/move and always save on close. Call `clearSavedGeometry()` to forget the stored frame. Gallery Main uses `"GalleryMain"`.

### Multi-monitor clamp

On restore, `WindowHelper` fits the saved rect into a real screen’s `availableGeometry` (taskbar insets):

1. Prefer the saved screen **name** when that display is still connected.
2. Else the first screen whose available rect **intersects** the saved geometry.
3. Else center on the **primary** screen.
4. Reject frames smaller than **160×120**; shrink width/height to fit the available area; clamp x/y inside it.
5. **`setScreen`** to the monitor that owns the clamped frame (or saved name) so mixed-DPI `devicePixelRatio` updates (**1.58**).

Undocking a laptop / rearranging monitors therefore cannot leave the window permanently off-screen.

Cookbook + Gallery readout: [high-dpi.md](high-dpi.md). See also [window-shells.md](window-shells.md) · [window-chrome.md](window-chrome.md) · [Linux / Wayland](platform-linux-wayland.md).

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

When `Theme.followSystemAccessibility` is true, **ThemeSync** on `StandardWindow` / `ShellWindow` copies these SPI values. Not Gallery-only — [theme-overrides.md](theme-overrides.md) (**1.69**).
