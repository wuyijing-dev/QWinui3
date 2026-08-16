# ToastHost

Hosts stacked Toasts with WinUI-style corner placement.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToastHost.qml`](../../src/extras/QWinUI3/Extras/ToastHost.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
ToastHost {
    id: toasts
    placement: ToastHost.BottomCenter
}
toasts.info(qsTr("Hello"))
toasts.success(qsTr("Done"))

// --- API ---
// methods: info/success/warning/error (+ *Toast aliases), show, clear
// placement: BottomCenter | BottomRight | TopRight | TopCenter
```

## Notes

Default placement is bottom-center (Gallery / WinUI toast band).
Do not also set anchors when using placement — they conflict.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `maxVisible` | `int` | Max visible items before overflow |
| `durationMs` | `int` | Auto-dismiss duration; 0 keeps open |
| `newestOnTop` | `bool` | Stack newest items on top |
| `placementMargin` | `real` | Edge inset from the overlay parent |
| `placement` | `int` | — |
| `informational` | `int` | Informational severity constant |
| `success` | `int` | Success severity constant |
| `warning` | `int` | Warning severity constant |
| `error` | `int` | Error severity constant |
| `count` | `int` | Item count |

### Signals

| Signature | Description |
| --- | --- |
| `toastClosed(string message)` | Emitted when a toast is closed |
| `toastActionClicked(string message)` | Emitted when a toast action is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `show(message, severity, title, actionText)` | Show the control |
| `info(message, title, actionText)` | Show an informational toast / tip |
| `successToast(message, title, actionText)` | Show a success toast |
| `success(message, title, actionText)` | Docs / WinUI-style alias |
| `warningToast(message, title, actionText)` | Show a warning toast |
| `warning(message, title, actionText)` | — |
| `errorToast(message, title, actionText)` | Show an error toast |
| `error(message, title, actionText)` | — |
| `clear()` | Clear text or selection |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
