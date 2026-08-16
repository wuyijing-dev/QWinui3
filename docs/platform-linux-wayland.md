# Linux / Wayland notes for QWinUI3

QWinUI3 keeps **server-side decorations (SSD)** on Linux/Wayland. Custom frameless chrome is Windows-only (`WindowHelper.customFrame` / `serverSideDecorations`).

## Required app startup (before `QGuiApplication`)

```cpp
#include "WindowHelper.h"

int main(int argc, char *argv[])
{
    WindowHelper::configurePlatformEnvironment(); // Wayland-first + SSD + fractional scale
    QGuiApplication app(argc, argv);
    QGuiApplication::setDesktopFileName(QStringLiteral("org.example.myapp"));
    // …
}
```

`configurePlatformEnvironment()` (no-op on Windows):

| Action | Effect |
|--------|--------|
| `QT_QPA_PLATFORM=wayland;xcb` when session is Wayland | Prefer native Wayland, fall back to X11 |
| `QT_WAYLAND_DECORATION=material` if unset | Prefer compositor SSD |
| `QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough` | Fractional Wayland scaling |
| Does **not** set `QT_WAYLAND_DISABLE_WINDOWDECORATION` | Client undecorated chrome stays off |

Gallery and examples already call this.

## Display server / desktop

```qml
WindowHelper.displayServer
WindowHelper.wayland / x11
WindowHelper.serverSideDecorations
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
| Window chrome | Client-side Fluent | Compositor SSD |
| File dialogs | `IFileDialog` | portal (+ parent_window on X11) → zenity/kdialog |
| Open URL | `QDesktopServices` | OpenURI portal → `QDesktopServices` |
| Notifications | `Shell_NotifyIcon` | Notifications portal → notify-send |
| Color scheme | AppsUseLightTheme | portal Settings → gsettings / KDE |
| Dialog stacking | HWND owner | `setTransientParent` |
| Fractional scale | DPI awareness | `PassThrough` + `devicePixelRatio` |
