# FrameStatsBadge

compact FPS readout for TitleBar rightHeader / leftHeader slots.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/FrameStatsBadge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/FrameStatsBadge.qml)

**Category:** Platform · **Library:** v2.51

[← Component index](../components.md)

**Extends** `Label`.

## Example

```qml
TitleBar {
    rightHeader: FrameStatsBadge { }
}

Requires FrameStatsMonitor.attachWindow(window) once (Gallery Main does this on completed).
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `readoutText` | `string` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
