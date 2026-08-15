# ToastHost

Hosts stacked Toasts.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToastHost.qml`](../../src/extras/QWinUI3/Extras/ToastHost.qml)

[← Component index](../components.md)

## Usage

```qml
ToastHost { id: toasts }
// toasts.show({ title: "Done", message: "OK" })
```

## Properties

- `maxVisible: int` — Max visible items before overflow
- `durationMs: int` — Auto-dismiss duration; 0 keeps open
- `newestOnTop: bool` — Stack newest items on top
- `informational: int` — Informational severity constant
- `success: int` — Success severity constant
- `warning: int` — Warning severity constant
- `error: int` — Error severity constant
- `count: int` — Item count
- `index: int`
- `key: string`
- `message: string` — Body / message text
- `severity: int` — Status severity enum
- `title: string` — Primary title text
- `actionText: string` — Optional action button label

## Signals

- `toastClosed(string message)` — Emitted when a toast is closed
- `toastActionClicked(string message)` — Emitted when a toast action is clicked

## Methods

- `show(message, severity, title, actionText)` — Show the control
- `info(message, title, actionText)` — Show an informational toast / tip
- `successToast(message, title, actionText)` — Show a success toast
- `warningToast(message, title, actionText)` — Show a warning toast
- `errorToast(message, title, actionText)` — Show an error toast
- `clear()` — Clear text or selection

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
