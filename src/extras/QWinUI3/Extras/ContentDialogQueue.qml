pragma Singleton
import QtQuick

// ContentDialogQueue — Singleton queue so ContentDialogs open one at a time.
//
//   // Show dialogs one-at-a-time through the singleton queue:
//   ContentDialogQueue.show(confirmDialog)
//   ContentDialogQueue.replaceCurrent(otherDialog)
//   ContentDialogQueue.cancel(confirmDialog)
//   ContentDialogQueue.clearQueue()
//   // --- API ---
//   // properties: pendingCount, busy
//
// @notes
//   Singleton queue for ContentDialog.show() (1.48 deepen).
//   FIFO: first show() opens immediately; further show() calls wait in order.
//   cancel drops a pending dialog only (no-op if already open).
//   clearQueue drops pending without dismissing the active dialog.
//   replaceCurrent closes the active dialog without pumping the queue, then opens
//   the replacement; pending FIFO resumes after that dialog closes.
//   Parent each ContentDialog on the owner window Overlay.overlay (transient/modal
//   to that window). Esc → ContentDialog close path (onClosing can cancel).

QtObject {
    id: root

    property var _queue: []
    property var _active: null
    property bool _suppressPump: false
    // Dialogs waiting in the queue
    readonly property int pendingCount: _queue.length
    // True while a dialog is open via the queue
    readonly property bool busy: _active !== null

    // Enqueue a dialog (FIFO). Opens immediately if the queue is idle.
    function enqueue(dialog) {
        if (!dialog)
            return
        if (_active === dialog)
            return
        for (var i = 0; i < _queue.length; ++i) {
            if (_queue[i] === dialog)
                return
        }
        if (!_active) {
            _active = dialog
            _wire(dialog)
            dialog.open()
            return
        }
        _queue = _queue.concat([dialog])
    }

    // Alias for enqueue
    function show(dialog) {
        enqueue(dialog)
    }

    // Remove a dialog from the pending queue (no-op if already active).
    function cancel(dialog) {
        if (!dialog)
            return
        var next = []
        for (var i = 0; i < _queue.length; ++i) {
            if (_queue[i] !== dialog)
                next.push(_queue[i])
        }
        _queue = next
    }

    // Drop queued dialogs without dismissing the current one
    function clearQueue() {
        _queue = []
    }

    // Close the active dialog (if any) and open `dialog` immediately.
    // Does not pump the pending queue while replacing; FIFO resumes after
    // `dialog` closes. Pending entries are preserved (and `dialog` is de-duped).
    function replaceCurrent(dialog) {
        if (!dialog)
            return
        cancel(dialog)
        if (_active && _active !== dialog) {
            var prev = _active
            _suppressPump = true
            _active = null
            if (prev.visible)
                prev.close()
            _suppressPump = false
        }
        _active = dialog
        _wire(dialog)
        dialog.open()
    }

    function _wire(dialog) {
        if (!dialog || dialog.__queueWired)
            return
        dialog.__queueWired = true
        dialog.closed.connect(function () {
            if (root._active === dialog)
                root._active = null
            root._pump()
        })
    }

    function _pump() {
        if (_suppressPump || _active || !_queue.length)
            return
        var next = _queue[0]
        _queue = _queue.slice(1)
        if (!next)
            return
        _active = next
        _wire(next)
        next.open()
    }
}
