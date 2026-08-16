# ContentDialogQueue

Singleton queue so ContentDialogs open one at a time.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentDialogQueue.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ContentDialogQueue.qml)

**Category:** Input & forms · **Library:** v1.09

[← Component index](../components.md)

**Extends** `QtObject`.

## Example

```qml
// Show dialogs one-at-a-time through the singleton queue:
ContentDialogQueue.show(confirmDialog)
ContentDialogQueue.replaceCurrent(otherDialog)
ContentDialogQueue.cancel(confirmDialog)
ContentDialogQueue.clearQueue()
// --- API ---
// properties: pendingCount, busy
```

## Notes

Singleton queue for ContentDialog.show().
show / enqueue, cancel, clearQueue, replaceCurrent; pendingCount / busy.

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
