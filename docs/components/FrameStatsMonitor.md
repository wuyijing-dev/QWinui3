# FrameStatsMonitor

FPS / frame-time / RHI readout for Gallery and retail diagnostics (singleton).

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/FrameStatsMonitor.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/FrameStatsMonitor.h)

**Category:** Platform · **Library:** v3.56 · **C++ type** · **singleton**

[← Component index](../components.md)

**Gallery:** `Graphics backend` — [`src/gallery/pages/GraphicsBackendPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/GraphicsBackendPage.qml)

**Extends** `QObject`.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `enabled` | `bool` | — |
| `inTitleBar` | `bool` | — |
| `showRhi` | `bool` | — |
| `persistSettings` | `bool` | — |
| `retailMode` | `bool` | — |
| `fps` | `qreal` | — |
| `frameTimeMs` | `qreal` | — |
| `rhiBackend` | `QString` | — |
| `rhiLabel` | `QString` | — |

### Signals

| Signature | Description |
| --- | --- |
| `changed()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `applyRetailProfile()` | — |
| `attachWindow(QQuickWindow *window)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
