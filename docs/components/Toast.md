# Toast

Transient toast item.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Toast.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Toast.qml)

**Category:** Dialogs & flyouts · **Library:** v1.75

[← Component index](../components.md)

**Gallery:** `Toast` — [`src/gallery/pages/ToastPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ToastPage.qml)

**Extends** `Control`.

## Example

```qml
Toast {
    id: toast
    title: qsTr("Saved"); message: qsTr("OK")
}

// --- API ---
// signals: onActionClicked, onClosed
// methods: show(msg, sev), open(), close(), hide()
// toast.show(msg, sev)
// toast.open()
// toast.close()
// toast.hide()
```

## Notes

Transient toast content; prefer ToastHost.info/success/warning/error helpers.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `message` | `string` | Body / message text |
| `severity` | `int` | Status severity enum |
| `durationMs` | `int` | Auto-dismiss duration; 0 keeps open |
| `isOpen` | `bool` | Open / visible state |
| `actionText` | `string` | Optional action button label |
| `showProgress` | `bool` | Show progress indicator |
| `pauseOnHover` | `bool` | Pause auto-advance while hovered |
| `slideFromBottom` | `bool` | Slide enter from bottom (false = from top) — set by ToastHost placement |
| `informational` | `int` | Informational severity constant |
| `success` | `int` | Success severity constant |
| `warning` | `int` | Warning severity constant |
| `error` | `int` | Error severity constant |
| `severityName` | `string` | Severity as string name |

### Signals

| Signature | Description |
| --- | --- |
| `actionClicked()` | Emitted when action is clicked |
| `closed()` | Swipe content closed |

### Methods

| Signature | Description |
| --- | --- |
| `show(msg, sev)` | Show the control |
| `open()` | Open / show |
| `close()` | Close / dismiss |
| `hide()` | Hide the control |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
