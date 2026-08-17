# NotificationBridge

Mirror in-app ToastHost to OS notifications (Win balloon / Linux portal).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NotificationBridge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/NotificationBridge.qml)

**Category:** Status & feedback · **Library:** v2.61

[← Component index](../components.md)

**Gallery:** `NotificationBridge` — [`src/gallery/pages/NotificationBridgePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/NotificationBridgePage.qml)

**Extends** `Control`.

## Example

```qml
NotificationBridge {
    id: bridge
    toastHost: toasts
    mirrorToSystem: true
}
bridge.info(qsTr("Saved"), qsTr("Document"))
// or: toasts.info(...); bridge.mirrorLast(...) via show()

// --- API ---
// mirrorToSystem, appName, trayVisible
// methods: show/info/success/warning/error, notifySystem(title, message, icon)
// signals: systemNotified(string, string)
```

## Notes

Uses TrayIcon.notifySystem → Windows balloon (icon 0/1/2) / org.freedesktop.Notifications /
notify-send. When toastHost is set, show() also enqueues an in-app toast.
Prefer bridge.info/success/warning/error for LoB apps. See docs/system-integration.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `toastHost` | `var` | — |
| `mirrorToSystem` | `bool` | — |
| `toastInApp` | `bool` | — |
| `appName` | `string` | — |
| `trayVisible` | `alias` | — |
| `tooltip` | `alias` | — |
| `iconSource` | `alias` | — |
| `supportsMessages` | `alias` | — |
| `informational` | `int` | — |
| `success` | `int` | — |
| `warning` | `int` | — |
| `error` | `int` | — |

### Signals

| Signature | Description |
| --- | --- |
| `systemNotified(string title, string message)` | — |
| `toastClosed(string message)` | — |
| `toastActionClicked(string message)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `notifySystem(title, message, icon)` | — |
| `show(message, severity, title, actionText)` | — |
| `info(message, title, actionText)` | — |
| `success(message, title, actionText)` | — |
| `warning(message, title, actionText)` | — |
| `error(message, title, actionText)` | — |
| `mirrorHostShow(message, severity, title)` | by calling bridge.mirrorFromHost after host show — prefer bridge.show(). |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
