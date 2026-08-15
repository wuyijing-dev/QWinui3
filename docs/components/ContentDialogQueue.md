# ContentDialogQueue

Singleton queue so ContentDialogs open one at a time.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentDialogQueue.qml`](../../src/extras/QWinUI3/Extras/ContentDialogQueue.qml)

[← Component index](../components.md)

**Extends** `QtObject`.

## Example

```qml
ContentDialogQueue.show(dialog)
ContentDialogQueue.cancel(dialog)
ContentDialogQueue.replaceCurrent(other)

// --- API ---
// methods: enqueue(dialog), show(dialog), cancel(dialog), clearQueue(), replaceCurrent(dialog)
// contentDialogQueue.enqueue(dialog)
// contentDialogQueue.show(dialog)
// contentDialogQueue.cancel(dialog)
// contentDialogQueue.clearQueue()
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `pendingCount` | `int` | Dialogs waiting in the queue |
| `busy` | `bool` | Busy status constant |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `enqueue(dialog)` | Enqueue a dialog / toast |
| `show(dialog)` | Show the control |
| `cancel(dialog)` | Remove a dialog from the pending queue (no-op if already active). |
| `clearQueue()` | Drop queued dialogs without dismissing the current one |
| `replaceCurrent(dialog)` | Pending queue is preserved and resumes after `dialog` closes. |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
