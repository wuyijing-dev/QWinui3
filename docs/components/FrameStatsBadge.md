# FrameStatsBadge

compact FPS readout for StandardTitleChrome.rightHeader (PlatformTitleBar slot before caption buttons — not TitleBar.rightHeader).

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/FrameStatsBadge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/FrameStatsBadge.qml)

**Category:** Platform · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Label`.

## Example

```qml
StandardTitleChrome {
    rightHeader: FrameStatsBadge { }
}

Requires FrameStatsMonitor.attachWindow(window) and FrameStatsMonitor.enabled.
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
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
