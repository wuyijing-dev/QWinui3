# Linux / Wayland notes for QWinUI3 (1.38 / 1.68 / 1.79 / 2.03 / 2.33 / 2.53 / 2.57)

QWinUI3 uses **client-side Fluent chrome** on Linux (`WindowHelper.customFrame`, `FramelessWindowHint`, in-app `PlatformTitleBar`). Compositor server-side decorations stay off by default.

**1.03** established the nav + settings baseline. **1.24** added StatusNotifierItem tray. **1.32** re-soaked shells / geometry. **1.38** documented the field failure matrix. **1.68** hardens FilePicker / portal ownership (no zenity double-dialog after portal timeout; filters + save `current_name`; reveal OpenURI fallback; live Gallery parent readout). **1.79** hardens portal `parent_window` on pure Wayland (Qt `portalWindowIdentifier` when GuiPrivate is available; realize window before export; `WAYLAND_SOCKET` session detect) and Linux CapsLock tracking for experimental OSK hardware input.

Related: [window-shells.md](window-shells.md) · [window-chrome.md](window-chrome.md) · [system-integration.md](system-integration.md) · [shell-extras.md](shell-extras.md) · Gallery **System integration**.

CI Linux Gallery jobs use **offscreen `--smoke`** (build + QML load). They do **not** exercise a real compositor — use this matrix for Wayland field checks.

---

## 1.38 / 1.68 / 1.79 field failure matrix

| Symptom | Likely cause | Fix / expectation |
|---------|--------------|-------------------|
| **Double title bar** (compositor + Fluent) | SSD still on | Keep `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` (Bootstrap default). Debug only: set `=0`. Check `WindowHelper.serverSideDecorations` / `customFrame`. |
| **Hollow / white client** with Mica copy-paste | Transparent host + no DWM | Use `BackdropSolid`; `resolveBackdrop()` coerces on Linux. Prefer [window-shells.md](window-shells.md). |
| **Square bleed at shell corners** | Full-bleed nav/page ignored inset | **Fixed 2.53** — `NavigationWindow` + `nav-settings` use `WindowShellContentClip`; manual wrap for custom shells |
| **Heavy shadow on Sway** | Profile was `other` | **Fixed 2.53** — `shellCompositorProfile` → `sway` (softer shadow) |
| **File dialog not modal** on pure Wayland | Portal `parent_window` empty | Always pass `Window.window`. X11/XWayland → `x11:0x…`. Pure Wayland (**1.79**): prefer Qt `portalWindowIdentifier` (xdg-foreign) when the kit was built with GuiPrivate; else native-resource keys; window is `create()`d first. Still may be empty on some compositors — dialog opens anyway. **2.53:** `qWarning` if `parentWindow` omitted on Wayland. **2.57:** focus/visible window fallback when parent omitted. Live: `WindowHelper.portalParentWindow(Window.window)`. |
| **Second zenity/kdialog after portal** | Portal wait timed out then fallback | **Fixed 1.68** — once FileChooser returns a request path, timeout/cancel does **not** fall back. Empty path = cancel. |
| **Filters ignored on Linux** | Old FilePicker unused `nameFilters` | **Fixed 1.68** — portal `filters` + zenity `--file-filter` / kdialog pattern. |
| **FilePicker falls to zenity/kdialog** | Portal missing / DBus down / OpenFile error | Install `xdg-desktop-portal` + GTK/KDE backend; ensure session bus. Fallbacks remain supported. |
| **Reveal does nothing (GNOME / Flatpak)** | No FileManager1 | **1.68** — `ShowItems` → OpenURI on the parent folder → `QDesktopServices`. **2.57** — pass **`Window.window`** to **`revealFileInFolder`** for portal parent. |
| **No tray icon on GNOME** | No StatusNotifierWatcher | Expected without AppIndicator/SNI extension. `supportsPersistentTray` may be true (capability) while `persistentTrayActive` stays false. KDE Plasma is the reference host (**1.24**). |
| **Tray notify only as toast** | Notifications portal / notify-send path | `notifySystem` still works without SNI; in-app Toast via Gallery wiring. Prefer `NotificationBridge` for dual path. |
| **Stuck on XWayland** | Launch script forced `QT_QPA_PLATFORM=xcb` | Leave unset; Bootstrap sets `wayland;xcb` when session is Wayland (**1.79** also honors `WAYLAND_SOCKET`). Packaged `./run-gallery.sh` already does this. |
| **“Could not find Wayland QPA”** | Missing `qt6-wayland` | Install plugin; Bootstrap falls back to `xcb` with a warning when Wayland plugin absent. |
| **Fractional scale blurry / wrong DPR** | Rounding policy | Bootstrap sets PassThrough; shells track `Theme.devicePixelRatio`. |
| **Snap Layouts / taskbar progress** | Windows-only | No-op on Linux — [shell-extras.md](shell-extras.md). |
| **Idle inhibit ignored** | No ScreenSaver / portal Inhibit | `inhibitIdle` returns `false`; call `releaseIdleInhibit` only after a successful inhibit. |
| **OSK CapsLock ignored on Linux** | No `GetKeyState` | **1.79** — experimental `hardwareInput` tracks CapsLock toggles under Wayland/X11. |

Out of scope for 1.79: implementing a full xdg-desktop-portal compositor; guaranteeing `wl_surface` export on every Qt minor without GuiPrivate; layer-shell OSK.

---

## Title bar & backdrop — works / limited / unsupported

| Surface | Wayland | X11 (`xcb`) | Notes |
|---------|---------|-------------|--------|
| Fluent CSD (`PlatformTitleBar` / caption buttons) | **Works** | **Works** | `startSystemMove` / `startSystemResize`; SSD off via `QT_WAYLAND_DISABLE_WINDOWDECORATION=1` |
| **Wayland / Linux rounded corners** | **Works** (client shell) | **Works** (client shell) | `WindowShellDecoration` + `WindowHelper.cornerPreference` — not compositor SSD |
| **Window drop shadow (shell)** | **Works** (client shell) | **Works** (client shell) | `MultiEffect` via `WindowShellDecoration`; **2.03** compositor profile tuning; maximized → square |
| **Shell without QtQuick.Effects** | **Works** (simple fallback) | **Works** (simple fallback) | **2.03** `WindowShellDecoration_Simple` at build time — flat rim, no MultiEffect |
| Double title bar (compositor + Fluent) | **Avoided** (default) | N/A (frameless) | Set `QT_WAYLAND_DISABLE_WINDOWDECORATION=0` only to debug SSD |
| `BackdropSolid` / opaque shells | **Works** | **Works** | **Preferred** for nav + settings apps |
| `BackdropNone` (fully custom fill) | **Works** | **Works** | You own the background |
| DWM Mica / Acrylic / Tabbed / Transient | **Unsupported** | **Unsupported** | `supportsBackdrop === false`; `resolveBackdrop()` → `BackdropSolid` |
| Compositor blur behind translucent window | **Limited** | **Limited** | Desktop-side only (KWin / Hyprland / …); not DWM parity |
| NC hit-test / Snap Layouts | **Unsupported** | **Unsupported** | Windows-only; QML caption handles input |
| Taskbar progress / overlay | **Unsupported** | **Unsupported** | No-op stubs |
| Portal FileChooser `parent_window` | **Improved 1.79** (xdg-foreign via Qt services when GuiPrivate linked; else best-effort) | **Works** (`x11:0x…`) | Live: `portalParentWindow()` (**1.68** / **1.79**) |
| Color scheme / notifications / OpenURI | **Works** (portal) | **Works** | Fallbacks: gsettings / KDE / notify-send |
| Persistent tray (SNI) | **Works** when watcher present | **Works** when watcher present | KDE reference; GNOME needs extension — [system-integration.md](system-integration.md) |

Nav + settings recipe: `StandardWindow { backdrop: WindowHelper.BackdropSolid }` + `NavigationView` (see `examples/nav-settings`). Copying Windows Mica samples is safe — Linux coerces to Solid.

```qml
// Explicit (recommended on Linux docs / examples):
backdrop: WindowHelper.BackdropSolid

// Or let the platform decide:
readonly property int effectiveBackdrop: WindowHelper.resolveBackdrop(backdrop)
```

---

## Required app startup (before `QGuiApplication`)

Prefer the Platform Bootstrap (style + Wayland/DPI + Windows QPA sanitize):

```cpp
#include "Bootstrap.h"

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]); // wraps configurePlatformEnvironment
    QGuiApplication app(argc, argv);
    QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));
    // …
}
```

Manual equivalent (Linux CSD/DPI only):

```cpp
#include "WindowHelper.h"

WindowHelper::configurePlatformEnvironment(argv[0]); // Wayland-first + CSD + DPI
```

`configurePlatformEnvironment()` (always called from Bootstrap):

| Action | Effect |
|--------|--------|
| `QT_QPA_PLATFORM=wayland;xcb` when session is Wayland | Prefer native Wayland, fall back to X11 (`WAYLAND_DISPLAY` / `WAYLAND_SOCKET` / `XDG_SESSION_TYPE`) |
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

`ElevatedChrome` uses `MultiEffect` for WinUI-like soft shadows. **`WindowShellDecoration`** (Linux client shell) uses the same module for the **window drop shadow** and rounded frame when the kit is built with QuickEffects. Install on distro Qt:

```bash
sudo apt install qml6-module-qtquick-effects libqt6quickeffects6
```

Without Effects at **build** time, Platform ships **`WindowShellDecoration_Simple`** (flat rim + rounded frame — same API, no blur). Cards/flyouts still use `ElevatedChrome_Simple` (see [qt-version-compat.md](qt-version-compat.md)).

### Client shell compositor profiles (**2.03**)

`WindowHelper.shellCompositorProfile` derives from `XDG_CURRENT_DESKTOP` / `DESKTOP_SESSION`:

| Profile | Typical host | Shadow tuning |
|---------|--------------|---------------|
| `kde` | Plasma / KWin | Default opacity + margin (reference) |
| `gnome` | GNOME / Mutter | Lower opacity + margin — avoids double-shadow with compositor CSD |
| `sway` | Sway / wlroots tiling | **2.53** — GNOME-like soft shadow (was `other`) |
| `hyprland` | Hyprland | Slightly softer than KDE |
| `other` | Unknown / generic | KDE-like defaults |

Readouts: `shellShadowMargin()`, `shellShadowOpacity()`, `shellQuickEffectsAvailable`. Gallery **System integration** shows live values.

### Bottom-corner content clip (**2.03**)

Full-bleed pages (solid `NavigationView` / list backgrounds) can show square content through rounded shell corners. Wrap page content:

```qml
import QWinUI3.Platform

WindowShellContentClip {
    targetWindow: window
    anchors.fill: parent
    NavigationView { anchors.fill: parent }
}
```

Or inset manually: `anchors.margins: WindowHelper.shellContentInset(window)` on `StandardWindow` / `ShellWindow` (`shellContentInset` property mirrors the helper). Maximized / fullscreen → inset **0** (`shellChromeExpanded` false).

## Display server / desktop

```qml
WindowHelper.displayServer
WindowHelper.wayland / x11
WindowHelper.serverSideDecorations   // false when customFrame (default)
WindowHelper.desktopEnvironment       // XDG_CURRENT_DESKTOP
WindowHelper.waylandDisplay           // WAYLAND_DISPLAY
WindowHelper.portalAvailable
WindowHelper.portalParentWindow(win)  // 1.68 live parent_window string
WindowHelper.devicePixelRatio
WindowHelper.systemPrefersDark
WindowHelper.supportsBackdrop         // false on Linux
WindowHelper.clientShellDecoration    // true on Linux CSD — QML corners + shadow
WindowHelper.shellCompositorProfile   // kde | gnome | hyprland | other (2.03)
WindowHelper.shellQuickEffectsAvailable // build-time QuickEffects (2.03)
WindowHelper.shellCornerRadius()      // px radius from cornerPreference
WindowHelper.shellShadowMargin()      // padding for drop shadow (normal state)
WindowHelper.shellShadowOpacity()     // compositor-tuned (2.03)
WindowHelper.shellContentInset(win)   // bottom/side inset for content clip (2.03)
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

Full LoB recipe (Win + Linux): **[system-integration.md](system-integration.md)**.

When Qt DBus is available (`QWINUI3_HAS_DBUS`), FilePicker tries **xdg-desktop-portal FileChooser** first.

Pass the host window so X11/XWayland portals can set `parent_window` (`x11:0x…`):

```qml
FilePicker.openFile(qsTr("Open"), ["All (*.*)"], function (path) { … }, Window.window)
```

**1.68:** once the portal request starts, timeout/cancel returns `""` / `[]` — no second zenity dialog. `nameFilters` go to portal / zenity / kdialog. Save uses `current_name` from `defaultSuffix`.

Pure Wayland: `parent_window` is `wayland:HANDLE` when Qt exports xdg-foreign (**1.79** prefers `portalWindowIdentifier`; builds without GuiPrivate keep native-resource fallback); otherwise empty — see [field matrix](#138--168--179-field-failure-matrix). Check `WindowHelper.portalParentWindow(Window.window)` in Gallery.

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

## Notifications / OpenURI / tray

- `TrayIcon.notifySystem` → Notifications DBus → `notify-send`
- `TrayIcon` persistent icon → **StatusNotifierItem** (`org.kde.StatusNotifierItem`) when `StatusNotifierWatcher` is on the session bus (proven on **KDE Plasma**; GNOME needs an AppIndicator/SNI extension). See [system-integration.md](system-integration.md).
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
| File dialogs | `IFileDialog` | portal (+ parent_window on X11; Wayland export when available) → zenity/kdialog |
| Open URL | `QDesktopServices` | OpenURI portal → `QDesktopServices` |
| Notifications | `Shell_NotifyIcon` | Notifications portal → notify-send |
| Persistent tray | `Shell_NotifyIcon` | StatusNotifierItem (KDE / SNI hosts) |
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

---

## Portal & tray wave 3 regression suite (2.33)

Manual field checklist — **not** covered by CI offscreen `--smoke`. Run on **KDE Plasma Wayland** (reference) and spot-check **GNOME** when tray/portal behavior differs.


### FilePicker / portal

| # | Step | Pass criteria |
|---|------|----------------|
| 1 | `FilePicker.openFile(…, Window.window)` | Dialog modal to app; path or cancel |
| 2 | Cancel / Esc | Returns `""` — **no** zenity/kdialog follow-up (**1.68**) |
| 3 | `saveFile` + `nameFilters` + `defaultSuffix` | Filter + `current_name` honored on portal path |
| 4 | `openFolder` | Directory path or cancel |
| 5 | Live readout | `WindowHelper.portalParentWindow(Window.window)` — `x11:0x…` on X11; `wayland:…` when xdg-foreign export works (**1.79**) |
| 6 | `revealFileInFolder` after save | FileManager1 `ShowItems` → OpenURI folder → `QDesktopServices` (**1.68**) |

### Tray (StatusNotifierItem)

| # | Step | Pass criteria |
|---|------|----------------|
| 1 | Enable tray on KDE Plasma | `persistentTrayActive === true`; icon visible |
| 2 | `notifySystem(title, body, severity)` | OS notification (portal / notify-send) |
| 2b | `NotificationBridge.systemActions: ["default", "Open"]` (**2.69**) | Action buttons appear on Plasma / GNOME notify (portal path) |
| 3 | GNOME without SNI / AppIndicator | No persistent icon is **OK**; `notifySystem` still works |
| 4 | Click tray icon | `trayActivated(reason)` — wire app menu / restore window |

### Dialog / z-order wave 3 soak (2.69 F5)

Manual on **pure Wayland** (KDE Plasma reference; spot-check GNOME):

| # | Step | Pass criteria |
|---|------|----------------|
| 1 | Open `ContentDialog` from Gallery while a second `ApplicationWindow` is open | Dialog stays above owner; Esc / light-dismiss closes |
| 2 | Nested modal: dialog → flyout / second dialog | Focus returns to previous surface (1.85); no orphaned modal layer |
| 3 | `WindowHelper.setTransientParent(child, owner)` then show | Child stacks with owner; activate owner raises chain |
| 4 | FilePicker portal with `Window.window` parent | Modal to app; cancel returns empty path |

See [system-integration.md](system-integration.md) tray matrix.

### Idle inhibit

| # | Step | Pass criteria |
|---|------|----------------|
| 1 | `WindowHelper.inhibitIdle(reason)` | `idleInhibited === true` when ScreenSaver or portal Inhibit succeeds |
| 2 | `releaseIdleInhibit()` | Property returns false; cookie released on Linux |
| 3 | Session without inhibitor backend | `inhibitIdle` returns false — app shows status, no crash |
| 4 | App exit while inhibited | Release on shutdown (Gallery toggle off before quit in manual soak) |

Cross-links: [security-trust.md](security-trust.md) Wayland portal regression (**2.13** / **2.33**) · [shell-extras.md](shell-extras.md) idle / attention.
