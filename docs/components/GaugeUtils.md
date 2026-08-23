# GaugeUtils

Shared pointer → value helpers for interactive gauges.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/GaugeUtils.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/GaugeUtils.qml)

**Category:** Charts & gauges · **Library:** v2.66 · **singleton**

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `QtObject`.

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `mapToItem(dragArea, target, mx, my)` | — |
| `normFromAngle(px, py, cx, cy, startAngle, sweepTotal, previousNorm)` | Optional previousNorm (0..1) keeps an in-progress drag from jumping across the gap. |
| `normFromDeg(ang, startAngle, sweepTotal, previousNorm)` | — |
| `valueFromNorm(norm, minimum, maximum)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
