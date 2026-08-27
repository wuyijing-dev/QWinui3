# TrayIcon

System tray icon + balloon / notify-send bridge.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/TrayIcon.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/TrayIcon.h)

**Category:** Platform · **Library:** v3.56 · **C++ type**

[← Component index](../components.md)

**Gallery:** `System integration` — [`src/gallery/pages/SystemIntegrationPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SystemIntegrationPage.qml)

**Extends** `QObject`.

## Example

```qml
TrayIcon { trayVisible: true; tooltip: qsTr("App"); iconName: "dialog-information" }
tray.notifySystem(title, body, icon)  // icon: 0 info, 1 warning, 2 error
onTrayActivated: (reason) => { … }
  Windows: WM_LBUTTONUP / DBLCLK / RBUTTONUP
  Linux SNI: 1=Activate, 2=ContextMenu, 3=SecondaryActivate

See docs/system-integration.md.
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `trayVisible` | `bool` | — |
| `tooltip` | `QString` | — |
| `iconSource` | `QUrl` | — |
| `iconName` | `QString` | — |
| `supportsMessages` | `bool` | — |
| `supportsPersistentTray` | `bool` | — |
| `persistentTrayActive` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `trayVisibleChanged()` | — |
| `tooltipChanged()` | — |
| `iconSourceChanged()` | — |
| `iconNameChanged()` | — |
| `persistentTrayActiveChanged()` | — |
| `trayActivated(int reason)` | — |
| `notified(const QString &title, const QString &message)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `notifySystem(const QString &title, const QString &message, int icon = 0)` | — |
| `notifySystemWithActions(const QString &title, const QString &message,
                                             const QStringList &actions, int icon = 0)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
