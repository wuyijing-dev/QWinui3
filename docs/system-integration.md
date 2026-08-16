# System integration (1.10)

LoB recipe for **FilePicker**, **TrayIcon**, and **NotificationBridge**. Prefer these over QtQuick.Dialogs / ad-hoc notify scripts.

| Type | Module | Role |
|------|--------|------|
| `FilePicker` | Platform singleton — [`FilePicker.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/FilePicker.h) | Open / save / folder |
| `TrayIcon` | Platform — [`TrayIcon.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/TrayIcon.h) | Tray presence + balloon |
| [`NotificationBridge`](components/NotificationBridge.md) | Extras | In-app `ToastHost` + OS notify |

Gallery: **System integration**, **NotificationBridge**.

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
| Linux | xdg-desktop-portal → zenity/kdialog | Portal parent on **X11** (`x11:0x…`); empty on pure Wayland |
| Cancel | — | `""` or `[]` |

Always pass `Window.window` so the dialog is owned by your shell.

---

## TrayIcon

```qml
TrayIcon {
    id: tray
    trayVisible: true
    tooltip: qsTr("My App")
    onTrayActivated: function (reason) {
        // Windows LOWORD(lParam): WM_LBUTTONUP 0x0202, DBLCLK 0x0203, RBUTTONUP 0x0205
    }
}
tray.notifySystem(qsTr("Saved"), qsTr("Document written."), 0) // 0 info, 1 warning, 2 error
```

| Host | Notes |
|------|-------|
| Windows | `Shell_NotifyIcon` balloon; severity maps to `NIIF_INFO` / `WARNING` / `ERROR` |
| Linux | No persistent StatusNotifierItem yet — `notifySystem` uses Notifications portal → `notify-send` |

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

## Shell extras (1.17)

Taskbar progress, attention flash, reveal-in-folder, and idle inhibit are documented and promoted as a **WindowHelper** subset — see [shell-extras.md](shell-extras.md) (Win/Linux matrix).

Gallery demos for Snap Layouts, battery / online / screens, and recent-docs remain **experimental**.

---

## Related

- [shell-extras.md](shell-extras.md) — taskbar / attention / reveal / idle (1.17)  
- [platform-linux-wayland.md](platform-linux-wayland.md) — portal matrix  
- [webview2.md](webview2.md) — separate Windows browser host
