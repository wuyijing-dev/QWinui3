# SessionTimeout

Idle timer with warning + timeout signals (2.72).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SessionTimeout.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SessionTimeout.qml)

**Category:** Input & forms · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
SessionTimeout {
    idleMs: 5 * 60 * 1000
    warningMs: 30 * 1000
    onWarning: tip.open()
    onTimedOut: logout()
}
// Call poke() on user activity (mouse/key handlers in the shell).
```

## Notes

Shell owns activity hooks — this type only times out.
remainingMs updates on the tick so QML bindings stay live.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `enabled` | `bool` | — |
| `idleMs` | `int` | — |
| `warningMs` | `int` | — |
| `remainingMs` | `int` | — |
| `warningActive` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `warning()` | — |
| `timedOut()` | — |
| `resumed()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `poke()` | — |
| `reset()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
