# OperationRetry

Attempt / retry helpers with exponential backoff (2.78).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OperationRetry.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OperationRetry.qml)

**Category:** Other · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
OperationRetry {
    id: op
    maxAttempts: 4
    baseDelayMs: 400
    onAttempt: function (n) { /* start work */ }
}
op.start()
// when work fails: op.fail("timeout") or op.retry()
// when work ok: op.succeed()
```

## Notes

Pure helper — no network I/O. Apps wire their own request.
fail()/retry() while a backoff is pending are coalesced (no overlapping timers).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `maxAttempts` | `int` | — |
| `baseDelayMs` | `int` | — |
| `backoffFactor` | `real` | — |
| `attemptCount` | `int` | — |
| `running` | `bool` | — |
| `lastError` | `string` | — |

### Signals

| Signature | Description |
| --- | --- |
| `attempt(int attemptNumber)` | — |
| `retryScheduled(int attemptNumber, int delayMs)` | — |
| `succeeded()` | — |
| `failed(string error)` | — |
| `resetDone()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `start()` | — |
| `succeed()` | — |
| `fail(error)` | — |
| `retry()` | — |
| `reset()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
