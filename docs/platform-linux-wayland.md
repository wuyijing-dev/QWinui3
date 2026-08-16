# Linux / Wayland notes for QWinUI3

QWinUI3 uses **client-side Fluent chrome** on Linux (`WindowHelper.customFrame`, `FramelessWindowHint`, in-app `PlatformTitleBar`). Compositor server-side decorations stay off by default.

Product version **1.03** focuses on practical nav + settings shells: clear capability matrix, no hollow “Mica” windows, and accurate Gallery packaging launchers.

---

## Title bar & backdrop — works / limited / unsupported

| Surface | Wayland | X11 (`xcb`) | Notes |
|---------|---------|-------------|--------|
| Fluent CSD (`PlatformTitleBar` / caption buttons) | **Works** | **Works** | `startSystemMove` / `startSystemResize`; SSD off via `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` |
| Double title bar (compositor + Fluent) | **Avoided** (default) | N/A (frameless) | Set `QT_WAYLAND_DISABLE_WINDOWDECORATION=0` only to debug SSD |
| `BackdropSolid` / opaque shells | **Works** | **Works** | **Preferred** for nav + settings apps |
| `BackdropNone` (fully custom fill) | **Works** | **Works** | You own the background |
| DWM Mica / Acrylic / Tabbed / Transient | **Unsupported** | **Unsupported** | `supportsBackdrop === false`; `resolveBackdrop()` → `BackdropSolid` |
| Compositor blur behind translucent window | **Limited** | **Limited** | Desktop-side only (KWin / Hyprland / …); not DWM parity |
| NC hit-test / Snap Layouts | **Unsupported** | **Unsupported** | Windows-only; QML caption handles input |
| Taskbar progress / overlay | **Unsupported** | **Unsupported** | No-op stubs |
| Portal FileChooser `parent_window` | **Limited** (empty) | **Works** (`x11:0x…`) | Pure Wayland has no public `wl_surface` export |
| Color scheme / notifications / OpenURI | **Works** (portal) | **Works** | Fallbacks: gsettings / KDE / notify-send |

Nav + settings recipe: `StandardWindow { backdrop: WindowHelper.BackdropSolid }` + `NavigationView` (see `examples/nav-settings`). Copying Windows Mica samples is safe — Linux coerces to Solid.

```qml
// Explicit (recommended on Linux docs / examples):
backdrop: WindowHelper.BackdropSolid

// Or let the platform decide:
readonly property int effectiveBackdrop: WindowHelper.resolveBackdrop(backdrop)
```

---

## Required app startup (before `QGuiApplication`)

```cpp
#include "WindowHelper.h"

int main(int argc, char *argv[])
{
    WindowHelper::configurePlatformEnvironment(argv[0]); // Wayland-first + CSD + DPI
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
| `ThemeFonts::ensureLoaded()` path | Register embedded Fluent icon font (`WinSymbols3.ttf`) |

Gallery and examples already call this. **Do not** force `QT_QPA_PLATFORM=xcb` in launch scripts unless debugging — that stuck packaged Gallery on XWayland (fixed in 1.03 `run-gallery.sh`).

To force compositor SSD again: `export QT_WAYLAND_DISABLE_WINDOWDECORATION=0` before launch.

```bash
# Debug backends (optional)
QT_QPA_PLATFORM=wayland ./qwinui3_gallery
QT_QPA_PLATFORM=xcb ./qwinui3_gallery
```

---

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

Without it, cards/flyouts fall back to `ElevatedChrome_Simple` (see Qt compat docs).

## Display server / desktop

```qml
WindowHelper.displayServer
WindowHelper.wayland / x11
WindowHelper.serverSideDecorations   // false when customFrame (default)
WindowHelper.desktopEnvironment       // XDG_CURRENT_DESKTOP
WindowHelper.waylandDisplay           // WAYLAND_DISPLAY
WindowHelper.portalAvailable
WindowHelper.devicePixelRatio
WindowHelper.systemPrefersDark
WindowHelper.supportsBackdrop         // false on Linux
WindowHelper.resolveBackdrop(kind)    // coerce unsupported materials → Solid
WindowHelper.refreshColorScheme()
WindowHelper.requestActivateWindow(win)
WindowHelper.setTransientParent(dialog, mainWindow)
WindowHelper.openExternalUrl("https://…")
WindowHelper.requestUserAttention(win)
WindowHelper.revealFileInFolder("/path/to/file")
WindowHelper.inhibitIdle("reason") / releaseIdleInhibit()
```

Drag / resize use Qt APIs already wired in QML (`startSystemMove` / `startSystemResize`).

## Idle inhibit

Linux uses `org.freedesktop.ScreenSaver.Inhibit` (cookie) with portal Inhibit as fallback. Windows uses `SetThreadExecutionState`.

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

## Backdrop / blur (detail)

- `supportsBackdrop` is **false** on Linux (no DWM).
- `install` / `setBackdrop` / shells call `resolveBackdrop()` so Mica-style requests stay **opaque Solid**.
- Prefer in-client `AcrylicSurface` for frosted *content* panes when you want depth without system materials.
- Compositor blur behind a translucent window is desktop-side only.

## Packaging / `run-gallery`

Release Gallery tarball (`qwinui3-gallery-*-linux-x64.tar.gz`):

```bash
./run-gallery.sh
```

- Leaves `QT_QPA_PLATFORM` unset so Gallery’s `configurePlatformEnvironment` can choose **wayland;xcb**.
- Sets `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` when unset.
- Force `QT_QPA_PLATFORM=xcb` or `wayland` only for debugging.

Shared libs: `qwinui3-*-linux-x64-shared.tar.gz` — needs host Qt **6.5+** (CI uses 6.8).

Ship a `.desktop` whose id matches `setDesktopFileName` (e.g. `org.qwinui3.gallery.desktop`).

## Windows parity

| Feature | Windows | Linux / Wayland |
|---------|---------|-----------------|
| Window chrome | Client-side Fluent | Client-side Fluent (CSD) |
| Icon font | Segoe Fluent Icons (or embedded) | Embedded WinSymbols3 (`Symbols`) |
| System backdrop | DWM Mica/Acrylic | Unsupported → Solid |
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
| **Client-side Fluent chrome** | `PlatformTitleBar` + caption buttons match Windows Gallery |
| **xdg-desktop-portal** | FileChooser, OpenURI, Settings, Notifications, idle inhibit |
| **Embedded Fluent icons** | `WinSymbols3.ttf` so `FluentIcons.*` work without Segoe |
| **NotificationBridge** | One API: in-app `ToastHost` + OS notify |
| **ShellWindow + Ctrl+K** | Desktop launcher pattern works on Linux |

Gallery → **System integration** / **NotificationBridge** and `examples/nav-settings` are the demo path.
