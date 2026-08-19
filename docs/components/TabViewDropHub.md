# TabViewDropHub

same-process registry so torn-out tabs can dock back.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TabViewDropHub.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TabViewDropHub.qml)

**Category:** Navigation · **Library:** v2.64 · **singleton**

[← Component index](../components.md)

**Extends** `QtObject`.

## Example

```qml
TabView registers on Completed; tear-out / drag-release asks hit(gx, gy).
```

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `register(view)` | — |
| `unregister(view)` | — |
| `hit(gx, gy, except)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
