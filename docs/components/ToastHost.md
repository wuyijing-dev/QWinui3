# ToastHost

Hosts stacked Toasts.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToastHost.qml`](../../src/extras/QWinUI3/Extras/ToastHost.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
ToastHost { id: toasts }
// toasts.show({ title: "Done", message: "OK" })

// --- API ---
// signals: onToastClosed, onToastActionClicked
// methods: show(message, severity, title, actionText), info(message, title, actionText), successToast(message, title, actionText), warningToast(message, title, actionText), errorToast(message, title, actionText), clear()
// toastHost.show(message, severity, title, actionText)
// toastHost.info(message, title, actionText)
// toastHost.successToast(message, title, actionText)
// toastHost.warningToast(message, title, actionText)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `maxVisible` | `int` | Max visible items before overflow |
| `durationMs` | `int` | Auto-dismiss duration; 0 keeps open |
| `newestOnTop` | `bool` | Stack newest items on top |
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
| `warningToast(message, title, actionText)` | Show a warning toast |
| `errorToast(message, title, actionText)` | Show an error toast |
| `clear()` | Clear text or selection |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
