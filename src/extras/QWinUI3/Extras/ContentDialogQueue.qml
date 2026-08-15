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

QtObject {
    id: root

    property var _queue: []
    property var _active: null
    // Dialogs waiting in the queue
    readonly property int pendingCount: _queue.length
    // Busy status constant
    readonly property bool busy: _active !== null

    // Enqueue a dialog / toast
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

    // Show the control
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
    // Pending queue is preserved and resumes after `dialog` closes.
    function replaceCurrent(dialog) {
        if (!dialog)
            return
        cancel(dialog)
        if (_active && _active !== dialog) {
            var prev = _active
            _active = null
            if (prev.visible)
                prev.close()
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
        if (_active || !_queue.length)
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
