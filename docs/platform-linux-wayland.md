# Linux / Wayland notes for QWinUI3

QWinUI3 uses **client-side Fluent chrome** on Linux/Wayland (`WindowHelper.customFrame`, `FramelessWindowHint`, in-app `PlatformTitleBar`). The compositor system title bar is disabled by default.

## Required app startup (before `QGuiApplication`)

```cpp
#include "WindowHelper.h"

int main(int argc, char *argv[])
{
    WindowHelper::configurePlatformEnvironment(); // Wayland-first + CSD + icon font
    QGuiApplication app(argc, argv);
    QGuiApplication::setDesktopFileName(QStringLiteral("org.example.myapp"));
    // …
}
```

`configurePlatformEnvironment()`:

| Action | Effect |
|--------|--------|
| `QT_QPA_PLATFORM=wayland;xcb` when session is Wayland | Prefer native Wayland, fall back to X11 |
| `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` if unset | Hide compositor title bar (use Fluent caption) |
| `QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough` | Fractional Wayland scaling |
| `ThemeFonts::ensureLoaded()` | Register embedded Fluent icon font (`WinSymbols3.ttf`) |

To force compositor SSD again: `export QT_WAYLAND_DISABLE_WINDOWDECORATION=0` before launch (and rebuild is not required; env is read at startup). Note: `customFrame` still expects Frameless — prefer the default CSD path.

Gallery and examples already call this.

## Icons (embedded font)

Linux has no “Segoe Fluent Icons”. The theme packs **WinSymbols3.ttf** (MIT, [SymbolIconManager](https://github.com/robloo/SymbolIconManager)) under `src/theme/QWinUI3/Theme/fonts/` and registers it via `ThemeFonts`.

```qml
Theme.fontFamilyIcon   // "Symbols" on Linux; Segoe Fluent Icons on Win11 when installed
ThemeFonts.iconFamily
ThemeFonts.iconFontLoaded
```

## Shadows / elevation (QtQuick.Effects)

`ElevatedChrome` uses `MultiEffect` for WinUI-like soft shadows. Install the QML module on distro Qt:

```bash
sudo apt install qml6-module-qtquick-effects libqt6quickeffects6
```

Without it, cards/flyouts fall back poorly or fail to load Effects — shadows will not match Windows.

## Display server / desktop

```qml
WindowHelper.displayServer
WindowHelper.wayland / x11
WindowHelper.serverSideDecorations   // false when customFrame (default)
WindowHelper.desktopEnvironment       // XDG_CURRENT_DESKTOP
WindowHelper.waylandDisplay           // WAYLAND_DISPLAY
WindowHelper.portalAvailable
WindowHelper.devicePixelRatio         // fractional scale diagnostics
WindowHelper.systemPrefersDark
WindowHelper.refreshColorScheme()
WindowHelper.requestActivateWindow(win)
WindowHelper.setTransientParent(dialog, mainWindow)
WindowHelper.openExternalUrl("https://…")  // portal OpenURI → QDesktopServices
WindowHelper.requestUserAttention(win)
WindowHelper.revealFileInFolder("/path/to/file")
WindowHelper.inhibitIdle("reason") / releaseIdleInhibit()
WindowHelper.copyText / clipboardText / systemBeep
```

```bash
QT_QPA_PLATFORM=wayland ./qwinui3_gallery
QT_QPA_PLATFORM=xcb ./qwinui3_gallery
```

Drag / resize use Qt APIs already wired in QML (`startSystemMove` / `startSystemResize`).

## Idle inhibit

Linux uses `org.freedesktop.ScreenSaver.Inhibit` (cookie) with portal Inhibit as fallback. Windows uses `SetThreadExecutionState`.

Color scheme watches portal `SettingChanged` when DBus is available.

## FilePicker (portal → zenity/kdialog)

When Qt DBus is available (`QWINUI3_HAS_DBUS`), FilePicker tries **xdg-desktop-portal FileChooser** first.

Pass the host window so X11/XWayland portals can set `parent_window` (`x11:0x…`):

```qml
FilePicker.openFile(qsTr("Open"), ["All (*.*)"], function (path) { … }, Window.window)
```

Pure Wayland leaves `parent_window` empty (Qt public API has no `wl_surface` export).

```bash
sudo apt install xdg-desktop-portal xdg-desktop-portal-gtk   # or -kde
sudo apt install zenity kdialog   # fallbacks
```

## Color scheme

`refreshColorScheme()` order on Linux:

1. `org.freedesktop.portal.Settings` (`org.freedesktop.appearance` / `color-scheme`)
2. GNOME `gsettings`
3. KDE `kreadconfig5`
4. `QStyleHints::colorScheme`

```qml
Theme.followSystemColorScheme = true
```

## Notifications / OpenURI

- `TrayIcon.notifySystem` → Notifications DBus → `notify-send`
- `WindowHelper.openExternalUrl` → OpenURI portal → `QDesktopServices`

## Backdrop / blur

- `supportsBackdrop` is **false** on Linux (no DWM).
- Non-solid backdrop clears alpha + requests an 8-bit alpha buffer when possible.
- Compositor blur is desktop-side (KWin / Hyprland / …).

## Packaging

Ship a `.desktop` whose id matches `setDesktopFileName` (e.g. `org.qwinui3.gallery.desktop`).

## Windows parity

| Feature | Windows | Linux / Wayland |
|---------|---------|-----------------|
| Window chrome | Client-side Fluent | Client-side Fluent (CSD) |
| Icon font | Segoe Fluent Icons (or embedded) | Embedded WinSymbols3 (`Symbols`) |
| File dialogs | `IFileDialog` | portal (+ parent_window on X11) → zenity/kdialog |
| Open URL | `QDesktopServices` | OpenURI portal → `QDesktopServices` |
| Notifications | `Shell_NotifyIcon` | Notifications portal → notify-send |
| Color scheme | AppsUseLightTheme | portal Settings → gsettings / KDE |
| Dialog stacking | HWND owner | `setTransientParent` |
| Fractional scale | DPI awareness | `PassThrough` + `devicePixelRatio` |

## Fluent on Linux — product moat

WinUI 3 is Windows-only. QWinUI3 ships the **same Fluent CSD, tokens, and Extras** on Wayland/X11:

| Pillar | Why it matters |
|--------|----------------|
| **Client-side Fluent chrome** | `PlatformTitleBar` + caption buttons match Windows Gallery; compositor SSD stays off via `QT_WAYLAND_DISABLE_WINDOWDECORATION` |
| **xdg-desktop-portal** | FileChooser, OpenURI, Settings (color scheme), Notifications, idle inhibit — no proprietary Windows APIs required |
| **Embedded Fluent icons** | `WinSymbols3.ttf` so `FluentIcons.*` work without Segoe |
| **NotificationBridge** | One API: in-app `ToastHost` + `TrayIcon.notifySystem` → portal / notify-send |
| **ShellWindow + Ctrl+K** | Desktop launcher pattern works identically on Linux |

Positioning tip: market this as **“Fluent desktop that ships on Linux”**, not as a Windows skin. Gallery → **System integration** / **NotificationBridge** and examples under `examples/` are the demo path.

Ship a `.desktop` whose `StartupWMClass` / desktop file id matches `QGuiApplication::setDesktopFileName` so portals and taskbars resolve the app correctly.
