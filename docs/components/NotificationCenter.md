# NotificationCenter

In-app notification drawer with grouping (2.27).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NotificationCenter.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/NotificationCenter.qml)

**Category:** Status & feedback · **Library:** v2.52

[← Component index](../components.md)

**Gallery:** `Notification center` — [`src/gallery/pages/NotificationCenterPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/NotificationCenterPage.qml)

**Extends** `Control`.

## Example

```qml
NotificationCenter {
    id: center
    model: notifications
    onNotificationClicked: (index, item) => { … }
}
center.addNotification({
    title: qsTr("Build finished"),
    message: qsTr("Release 2.27 succeeded."),
    category: qsTr("CI"),
    severity: center.success
})
center.open()

// --- API ---
// properties: model, groupRole, isOpen, unreadCount
// methods: open(), close(), markRead(i), markAllRead(), clear(), clearRead(),
//          addNotification(item), push(item)
// signals: notificationClicked, notificationActionClicked, cleared
```

## Notes

Experimental — dismissible history + category groups (FL-007). Complements
ToastHost (transient) and InfoBarHost (inline). Not an OS notification center.
See docs/feedback.md wave 3.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | — |
| `groupRole` | `string` | — |
| `edge` | `alias` | — |
| `drawerWidth` | `alias` | — |
| `informational` | `int` | — |
| `success` | `int` | — |
| `warning` | `int` | — |
| `error` | `int` | — |
| `isOpen` | `bool` | — |
| `unreadCount` | `int` | — |
| `groupedModel` | `var` | — |

### Signals

| Signature | Description |
| --- | --- |
| `notificationClicked(int index, var item)` | — |
| `notificationActionClicked(int index, var item)` | — |
| `cleared()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `open()` | — |
| `close()` | — |
| `markRead(index)` | — |
| `markAllRead()` | — |
| `clear()` | — |
| `clearRead()` | — |
| `addNotification(item)` | — |
| `push(item)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
