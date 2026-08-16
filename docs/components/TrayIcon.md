# TrayIcon

System tray icon + balloon / notify-send bridge (C++ `QML_ELEMENT`, no `Qt.labs.platform`).

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/TrayIcon.h`](../../src/platform/QWinUI3/Platform/TrayIcon.h)

[← Component index](../components.md)

## Example

```qml
TrayIcon {
    id: tray
    tooltip: qsTr("My app")
    trayVisible: true
}
tray.notifySystem(qsTr("Saved"), qsTr("Document written."))
```

## Notes

- **Windows:** `Shell_NotifyIcon` tray icon + balloon (`NIIF_*`).
- **Linux:** `notify-send` for messages; no StatusNotifierItem icon yet.
- Emits `notified` so Gallery can also show an in-app `ToastHost`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `tooltip` | `string` | Tray tooltip text |
| `trayVisible` | `bool` | Show / hide the tray entry (Windows) |
| `iconSource` | `url` | Optional icon URL |
| `supportsMessages` | `bool` | Whether system notifications are available |

### Signals

| Signature | Description |
| --- | --- |
| `trayActivated(int reason)` | User activated the tray icon |
| `notified(string title, string message)` | After `notifySystem` |

### Methods

| Signature | Description |
| --- | --- |
| `notifySystem(title, message, icon = 0)` | Balloon (Win) or notify-send (Linux) |
