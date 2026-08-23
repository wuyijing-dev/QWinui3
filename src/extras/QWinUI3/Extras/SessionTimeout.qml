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

QtObject {
    id: root

    property bool enabled: true
    property int idleMs: 5 * 60 * 1000
    property int warningMs: 30 * 1000

    readonly property bool warningActive: _warned
    readonly property int remainingMs: Math.max(0, idleMs - (Date.now() - _lastActivity))

    signal warning()
    signal timedOut()
    signal resumed()

    property bool _warned: false
    property real _lastActivity: Date.now()

    function poke() {
        _lastActivity = Date.now()
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
            var warnAt = Math.max(0, root.idleMs - root.warningMs)
            if (!root._warned && elapsed >= warnAt && root.warningMs > 0) {
                root._warned = true
                root.warning()
            }
            if (elapsed >= root.idleMs) {
                tick.stop()
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
}
