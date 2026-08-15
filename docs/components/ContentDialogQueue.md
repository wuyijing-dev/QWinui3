# ContentDialogQueue

Singleton queue so ContentDialogs open one at a time.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentDialogQueue.qml`](../../src/extras/QWinUI3/Extras/ContentDialogQueue.qml)

[← Component index](../components.md)

## Usage

```qml
ContentDialogQueue.show(dialog)
ContentDialogQueue.cancel(dialog)
ContentDialogQueue.replaceCurrent(other)
```

## Properties

- `pendingCount: int` — Dialogs waiting in the queue
- `busy: bool` — Busy status constant

## Methods

- `enqueue(dialog)` — Enqueue
- `show(dialog)` — Show
- `cancel(dialog)` — Remove a dialog from the pending queue (no-op if already active).
- `clearQueue()` — Clear Queue
- `replaceCurrent(dialog)` — Pending queue is preserved and resumes after `dialog` closes.

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
