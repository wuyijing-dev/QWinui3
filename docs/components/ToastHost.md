# ToastHost

Hosts stacked Toasts with WinUI-style corner placement.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToastHost.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ToastHost.qml)

**Category:** Dialogs & flyouts · **Library:** v1.53

[← Component index](../components.md)

**Gallery:** `ToastHost` — [`src/gallery/pages/ToastHostPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ToastHostPage.qml)

**Extends** `Control`.

## Example

```qml
ToastHost {
    id: toasts
    placement: ToastHost.BottomRight
}
toasts.info(qsTr("Hello"))
toasts.success(qsTr("Done"))

// --- API ---
// methods: info/success/warning/error (+ *Toast aliases), show, clear, setPlacementName
// placement: BottomCenter | BottomRight | BottomLeft | TopRight | TopLeft | TopCenter
```

## Notes

Reparents to the window Overlay so placement is full-window (not page-local).
Visible stack up to maxVisible; extras wait in a pending queue and drain as slots free.
Do not also set anchors when using placement — they conflict.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `maxVisible` | `int` | Max toasts shown at once; further show() calls wait in pendingQueue |
| `durationMs` | `int` | Auto-dismiss duration; 0 keeps open |
| `newestOnTop` | `bool` | Stack newest items on top of the visible column |
| `placementMargin` | `real` | Edge inset from the window overlay |
| `placement` | `int` | — |
| `informational` | `int` | — |
| `success` | `int` | — |
| `warning` | `int` | — |
| `error` | `int` | — |
| `count` | `int` | Visible toast count |
| `pendingCount` | `int` | Waiting behind maxVisible |
| `totalCount` | `int` | Visible + pending |

### Signals

| Signature | Description |
| --- | --- |
| `toastClosed(string message)` | Emitted when a toast is closed |
| `toastActionClicked(string message)` | Emitted when a toast action is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `setPlacementName(name)` | — |
| `show(message, severity, title, actionText)` | Enqueue a toast (shows immediately if under maxVisible, else waits) |
| `info(message, title, actionText)` | — |
| `successToast(message, title, actionText)` | — |
| `success(message, title, actionText)` | — |
| `warningToast(message, title, actionText)` | — |
| `warning(message, title, actionText)` | — |
| `errorToast(message, title, actionText)` | — |
| `error(message, title, actionText)` | — |
| `clear()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
