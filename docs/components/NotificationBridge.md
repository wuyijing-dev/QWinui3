# NotificationBridge

Mirror in-app ToastHost to OS notifications (Win balloon / Linux portal).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NotificationBridge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/NotificationBridge.qml)

**Category:** Status & feedback · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `NotificationBridge` — [`src/gallery/pages/NotificationBridgePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/NotificationBridgePage.qml)

**Extends** `Control`.

## Example

```qml
NotificationBridge {
    id: bridge
    toastHost: toasts
    notificationCenter: center
    recordInCenter: true
    mirrorToSystem: true
}
bridge.info(qsTr("Saved"), qsTr("Document"))

// --- API ---
// toastHost, notificationCenter, recordInCenter, defaultCategory
// mirrorToSystem, appName, trayVisible
// methods: show/info/success/warning/error, notifySystem(title, message, icon)
// signals: systemNotified(string, string)
```

## Notes

Uses TrayIcon.notifySystem → Windows balloon / org.freedesktop.Notifications /
notify-send. When toastHost is set, show() also enqueues an in-app toast.
When notificationCenter is set (2.63), show() also appends grouped history.
Prefer bridge.info/success/warning/error for LoB apps. See docs/notification-center-263.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `toastHost` | `var` | — |
| `notificationCenter` | `var` | — |
| `recordInCenter` | `bool` | — |
| `defaultCategory` | `string` | — |
| `mirrorToSystem` | `bool` | — |
| `toastInApp` | `bool` | — |
| `appName` | `string` | — |
| `trayVisible` | `alias` | — |
| `tooltip` | `alias` | — |
| `iconSource` | `alias` | — |
| `supportsMessages` | `alias` | — |
| `severityInformational` | `int` | — |
| `severitySuccess` | `int` | — |
| `severityWarning` | `int` | — |
| `severityError` | `int` | — |

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
| `show(message, severity, title, actionText, dedupeId)` | — |
| `info(message, title, actionText, dedupeId)` | — |
| `success(message, title, actionText, dedupeId)` | — |
| `warning(message, title, actionText, dedupeId)` | — |
| `error(message, title, actionText, dedupeId)` | — |
| `mirrorHostShow(message, severity, title)` | by calling bridge.mirrorFromHost after host show — prefer bridge.show(). |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
