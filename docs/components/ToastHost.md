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
- `newestOnTop: bool` — Newest On Top
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

- `toastClosed(string message)` — Toast Closed
- `toastActionClicked(string message)` — Toast Action Clicked

## Methods

- `show(message, severity, title, actionText)` — Show
- `info(message, title, actionText)` — Info
- `successToast(message, title, actionText)` — Success Toast
- `warningToast(message, title, actionText)` — Warning Toast
- `errorToast(message, title, actionText)` — Error Toast
- `clear()` — Clear

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
