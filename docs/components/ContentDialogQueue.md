# ContentDialogQueue

Singleton queue so ContentDialogs open one at a time.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentDialogQueue.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ContentDialogQueue.qml)

**Category:** Input & forms · **Library:** v2.61

[← Component index](../components.md)

**Extends** `QtObject`.

## Example

```qml
// Show dialogs one-at-a-time through the singleton queue:
ContentDialogQueue.show(confirmDialog)
ContentDialogQueue.showFront(urgentDialog)
ContentDialogQueue.replaceCurrent(otherDialog)
ContentDialogQueue.cancel(confirmDialog)
ContentDialogQueue.clearQueue()
// --- API ---
// properties: pendingCount, busy
```

## Notes

Singleton queue for ContentDialog.show() (1.48 deepen).
FIFO: first show() opens immediately; further show() calls wait in order.
cancel drops a pending dialog only (no-op if already open).
clearQueue drops pending without dismissing the active dialog.
replaceCurrent closes the active dialog without pumping the queue, then opens
the replacement; pending FIFO resumes after that dialog closes.
Parent each ContentDialog on the owner window Overlay.overlay (transient/modal
to that window). Esc → ContentDialog close path (onClosing can cancel).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `pendingCount` | `int` | Dialogs waiting in the queue |
| `busy` | `bool` | True while a dialog is open via the queue |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `enqueue(dialog)` | Enqueue a dialog (FIFO). Opens immediately if the queue is idle. |
| `show(dialog)` | Alias for enqueue |
| `enqueueFront(dialog)` | Prepend to pending queue — opens next after the active dialog (2.55 priority) |
| `showFront(dialog)` | Alias for enqueueFront |
| `cancel(dialog)` | Remove a dialog from the pending queue (no-op if already active). |
| `clearQueue()` | Drop queued dialogs without dismissing the current one |
| `replaceCurrent(dialog)` | `dialog` closes. Pending entries are preserved (and `dialog` is de-duped). |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
