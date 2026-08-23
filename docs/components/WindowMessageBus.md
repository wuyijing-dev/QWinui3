# WindowMessageBus

Process-local typed channels between windows (2.72).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/WindowMessageBus.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/WindowMessageBus.qml)

**Category:** Shells & windows · **Library:** v2.81 · **singleton**

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
WindowMessageBus.post("theme", { dark: true })
WindowMessageBus.subscribe("theme", function (payload) { … })
```

## Notes

Same QGuiApplication only — not cross-process IPC.
post() snapshots the handler list so unsubscribe during delivery is safe.

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `post(channel, payload)` | — |
| `subscribe(channel, handler)` | — |
| `unsubscribe(channel, handler)` | — |
| `clear(channel)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
