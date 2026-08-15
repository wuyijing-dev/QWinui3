# Toast

Transient toast item.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Toast.qml`](../../src/extras/QWinUI3/Extras/Toast.qml)

[← Component index](../components.md)

## Usage

```qml
Toast { title: qsTr("Saved"); message: qsTr("OK") }
```

## Properties

- `title: string` — Primary title text
- `message: string` — Body / message text
- `severity: int` — Status severity enum
- `durationMs: int` — Auto-dismiss duration; 0 keeps open
- `isOpen: bool` — Open / visible state
- `actionText: string` — Optional action button label
- `showProgress: bool` — Show progress indicator
- `pauseOnHover: bool` — Pause On Hover
- `informational: int` — Informational severity constant
- `success: int` — Success severity constant
- `warning: int` — Warning severity constant
- `error: int` — Error severity constant
- `severityName: string` — Severity as string name

## Signals

- `actionClicked()` — Emitted when action is clicked
- `closed()` — Swipe content closed

## Methods

- `show(msg, sev)` — Show
- `open()` — Open
- `close()` — Close
- `hide()` — Hide

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
