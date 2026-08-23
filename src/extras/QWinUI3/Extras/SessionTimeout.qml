import QtQuick

// SessionTimeout — Idle timer with warning + timeout signals (2.72).
//
//   SessionTimeout {
//       idleMs: 5 * 60 * 1000
//       warningMs: 30 * 1000
//       onWarning: tip.open()
//       onTimedOut: logout()
//   }
//   // Call poke() on user activity (mouse/key handlers in the shell).
//
// @notes
//   Shell owns activity hooks — this type only times out.
//   remainingMs updates on the tick so QML bindings stay live.

QtObject {
    id: root

    property bool enabled: true
    property int idleMs: 5 * 60 * 1000
    property int warningMs: 30 * 1000

    property bool _warned: false
    property real _lastActivity: Date.now()
    property int remainingMs: idleMs

    readonly property bool warningActive: _warned

    signal warning()
    signal timedOut()
    signal resumed()

    function poke() {
        _lastActivity = Date.now()
        remainingMs = Math.max(0, idleMs)
        if (_warned) {
            _warned = false
            resumed()
        }
        if (enabled && !tick.running)
            tick.start()
    }

    function reset() {
        _warned = false
        poke()
        if (enabled)
            tick.start()
    }

    Timer {
        id: tick
        interval: 250
        repeat: true
        running: root.enabled
        onTriggered: {
            if (!root.enabled)
                return
            var elapsed = Date.now() - root._lastActivity
            root.remainingMs = Math.max(0, root.idleMs - elapsed)
            // warningMs >= idleMs → warn immediately after idle start (still emit once).
            var warnAt = Math.max(0, root.idleMs - Math.max(0, root.warningMs))
            if (!root._warned && elapsed >= warnAt && root.warningMs > 0) {
                root._warned = true
                root.warning()
            }
            if (elapsed >= root.idleMs) {
                tick.stop()
                root.remainingMs = 0
                root.timedOut()
            }
        }
    }

    onEnabledChanged: {
        if (enabled)
            reset()
        else
            tick.stop()
    }

    onIdleMsChanged: {
        if (enabled)
            remainingMs = Math.max(0, idleMs - (Date.now() - _lastActivity))
    }
}
