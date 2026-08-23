import QtQuick

// OperationRetry — Attempt / retry helpers with exponential backoff (2.78).
//
//   OperationRetry {
//       id: op
//       maxAttempts: 4
//       baseDelayMs: 400
//       onAttempt: function (n) { /* start work */ }
//   }
//   op.start()
//   // when work fails: op.fail("timeout") or op.retry()
//   // when work ok: op.succeed()
//
// @notes
//   Pure helper — no network I/O. Apps wire their own request.

QtObject {
    id: root

    property int maxAttempts: 3
    property int baseDelayMs: 500
    property real backoffFactor: 2.0
    property int attemptCount: 0
    property bool running: false
    property string lastError: ""

    signal attempt(int attemptNumber)
    signal retryScheduled(int attemptNumber, int delayMs)
    signal succeeded()
    signal failed(string error)
    signal resetDone()

    function start() {
        backoffTimer.stop()
        attemptCount = 0
        running = true
        lastError = ""
        _doAttempt()
    }

    function succeed() {
        backoffTimer.stop()
        running = false
        lastError = ""
        succeeded()
    }

    function fail(error) {
        lastError = String(error || qsTr("Operation failed"))
        retry()
    }

    function retry() {
        if (!running)
            running = true
        if (attemptCount >= maxAttempts) {
            running = false
            failed(lastError.length ? lastError : qsTr("Max attempts reached"))
            return
        }
        var delay = Math.round(baseDelayMs * Math.pow(backoffFactor, Math.max(0, attemptCount - 1)))
        retryScheduled(attemptCount + 1, delay)
        backoffTimer.interval = Math.max(0, delay)
        backoffTimer.restart()
    }

    function reset() {
        backoffTimer.stop()
        attemptCount = 0
        running = false
        lastError = ""
        resetDone()
    }

    function _doAttempt() {
        attemptCount += 1
        attempt(attemptCount)
    }

    Timer {
        id: backoffTimer
        interval: 500
        repeat: false
        onTriggered: root._doAttempt()
    }
}
