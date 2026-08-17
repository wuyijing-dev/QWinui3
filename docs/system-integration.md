# System integration (1.10 / 1.68)

LoB recipe for **FilePicker**, **TrayIcon**, and **NotificationBridge**. Prefer these over QtQuick.Dialogs / ad-hoc notify scripts.

| Type | Module | Role |
|------|--------|------|
| `FilePicker` | Platform singleton — [`FilePicker.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/FilePicker.h) | Open / save / folder |
| `TrayIcon` | Platform — [`TrayIcon.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/TrayIcon.h) | Tray presence + balloon |
| [`NotificationBridge`](components/NotificationBridge.md) | Extras | In-app `ToastHost` + OS notify |

Gallery: **System integration**, **NotificationBridge**.

In-app only (no OS mirror): [feedback.md](feedback.md) (1.34).

---

## FilePicker

```qml
import QWinUI3.Platform

FilePicker.openFile(qsTr("Open"), ["Text (*.txt)", "All (*.*)"], function (path) {
    if (!path.length)
        return // cancelled
    // …
}, Window.window)

FilePicker.openFiles(qsTr("Open"), ["All (*.*)"], function (paths) {
    // paths is [] on cancel
}, Window.window)

FilePicker.saveFile(qsTr("Save"), ["Text (*.txt)"], function (path) { … }, "txt", Window.window)
FilePicker.openFolder(qsTr("Folder"), function (path) { … }, Window.window)
```

| Host | Backend | `parentWindow` |
|------|---------|----------------|
| Windows | `IFileDialog` | HWND owner from `Window` / Item (falls back to first visible window) |
| Linux | xdg-desktop-portal → zenity/kdialog | `x11:0x…` on X11/XWayland; `wayland:HANDLE` when Qt exports xdg-foreign; else empty — [platform-linux-wayland.md](platform-linux-wayland.md) (**1.68**) |
| Cancel | — | `""` or `[]` |

Always pass `Window.window` so the dialog is owned by your shell.

**1.68:** if the portal FileChooser request starts, timeout/cancel does **not** open zenity as a second dialog. `nameFilters` are forwarded. `saveFile` `defaultSuffix` becomes portal `current_name`. Reveal: FileManager1 `ShowItems` → OpenURI on the folder → `QDesktopServices`.

Live Linux check: `WindowHelper.portalParentWindow(Window.window)` (Gallery **System integration**).

Pair with drag-drop: [drag-drop.md](drag-drop.md) (**1.41**) — `FileDropZone` + the same ingest function as `FilePicker.openFiles`.

---

## TrayIcon

```qml
TrayIcon {
    id: tray
    trayVisible: true
    tooltip: qsTr("My App")
    iconName: "dialog-information" // Linux themed icon (SNI IconName)
    onTrayActivated: function (reason) {
        // Windows: WM_LBUTTONUP 0x0202, DBLCLK 0x0203, RBUTTONUP 0x0205
        // Linux SNI: 1 = Activate, 2 = ContextMenu, 3 = SecondaryActivate
        // Show a MenuFlyout / CommandBarFlyout from ContextMenu (reason === 2) when needed.
    }
}
tray.notifySystem(qsTr("Saved"), qsTr("Document written."), 0) // 0 info, 1 warning, 2 error
```

### Capability matrix

| Capability | Windows | Linux |
|------------|---------|-------|
| Persistent tray icon | `Shell_NotifyIcon` | **StatusNotifierItem** via session D-Bus (`supportsPersistentTray`) |
| Balloon / toast mirror | `NIIF_*` on tray | Notifications portal → `notify-send` (`supportsMessages`) |
| Click / activate | `trayActivated` (Win mouse msgs) | `trayActivated` (SNI Activate / ContextMenu / SecondaryActivate) |
| Themed icon name | — (uses app icon) | `iconName` → SNI `IconName` |
| Built-in DBusMenu | N/A (app owns menu) | Not shipped — handle `reason === 2` in QML |

`persistentTrayActive` is true when the icon is actually registered with the OS / watcher.

### Linux desktop notes (1.24)

| Desktop | Persistent tray | Notes |
|---------|-----------------|-------|
| **KDE Plasma** | Yes (reference host) | Ships `org.kde.StatusNotifierWatcher`; Gallery tray toggle should show an icon in the system tray |
| GNOME Shell | Only with AppIndicator / SNI extension | Without a watcher, `trayVisible` stays best-effort; `notifySystem` still works |
| Other SNI hosts (Unity, XFCE plugins, …) | When watcher is present | Same D-Bus path |

Requires Qt **DBus** at build time (`QWINUI3_HAS_DBUS`). Without DBus, Linux falls back to notifications only.

| Host | Notes |
|------|-------|
| Windows | `Shell_NotifyIcon` balloon; severity maps to `NIIF_INFO` / `WARNING` / `ERROR` |
| Linux | Persistent SNI when a watcher is available; `notifySystem` uses Notifications portal → `notify-send` |

---

## NotificationBridge (preferred LoB API)

```qml
ToastHost { id: toasts }
NotificationBridge {
    id: bridge
    toastHost: toasts
    mirrorToSystem: true
    appName: qsTr("My App")
}
bridge.success(qsTr("All checks passed"), qsTr("Ready"))
bridge.warning(qsTr("Disk low"), qsTr("Storage"))
```

`show` / `info` / `success` / `warning` / `error` enqueue an in-app toast (when `toastHost` is set) and mirror to the OS with the matching tray icon int. Use `notifySystem` for OS-only.

---

## Shell extras (1.47)

Taskbar progress, attention flash, reveal-in-folder, and idle inhibit are **stable** WindowHelper APIs. Snap Layouts toggle UX is documented (Win11 experimental; Linux n/a) — see [shell-extras.md](shell-extras.md).

Gallery **System integration** demos: Snap · taskbar recipe · attention / reveal / idle (critical smoke page).

Battery / online / screens / recent-docs remain **experimental**.

---

## Related

- [shell-extras.md](shell-extras.md) — Snap / taskbar / attention / reveal / idle (**1.47**)  
- [print-share.md](print-share.md) — grab → save → reveal · PrintSupport notes (**1.63**)  
- [security-trust.md](security-trust.md) — picker ownership / path validation (**1.64**)  
- [drag-drop.md](drag-drop.md) — FileDropZone / clipboard / FilePicker pairing (**1.41**)  
- [platform-linux-wayland.md](platform-linux-wayland.md) — portal / SSD / tray / backdrop field matrix (**1.38** / **1.68**)  
- [webview2.md](webview2.md) — separate Windows browser host
