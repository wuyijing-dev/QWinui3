# Developer diagnostics (dev vs retail)

Ship-safe guidance for **`FrameStatsMonitor`** / **`FrameStatsBadge`** / **`FrameStatsOverlay`** — FPS + frame time + optional RHI readout (**1.91** / **2.04** / **2.44**).

**Not a profiler.** Advisory rolling FPS only. For perf tuning see [performance.md](performance.md). For RHI backend selection see [graphics-backend.md](graphics-backend.md).

Gallery: **Performance** · **Settings** (Show FPS) · **Graphics backend** · Pitfalls **2.44** checklist.

---

## Surfaces

| Piece | Module | Role |
|-------|--------|------|
| **`FrameStatsMonitor`** | Platform singleton | Samples `QQuickWindow::frameSwapped` **only when** `enabled` or `showRhi` (**3.38 S15**); QSettings + CLI |
| **`FrameStatsBadge`** | Platform | Title-bar **rightHeader** / **leftHeader** slot |
| **`FrameStatsOverlay`** | Platform | Floating badge when `inTitleBar` is false |

Defaults: **`enabled` false** · **`retailMode` false** · **`persistSettings` true** (Gallery dev profile).

---

## Dev profile (Gallery / internal builds)

```cpp
#include "FrameStatsMonitor.h"

int main(int argc, char *argv[])
{
    // … QGuiApplication …
    FrameStatsMonitor::applyCli(argc, argv);
    // attach after root QQuickWindow exists (or when enabling FPS in Settings):
    // FrameStatsMonitor connects frameSwapped only while enabled/showRhi (3.38).
    FrameStatsMonitor::instance()->attachWindow(win);
}
```

```qml
TitleBar {
    rightHeader: FrameStatsBadge { }
}
FrameStatsOverlay { } // when inTitleBar is false
```

| CLI | Effect |
|-----|--------|
| `--show-fps` | Enable badge/overlay |
| `--fps-overlay` | Enable + floating overlay |
| `--show-rhi` | Enable + append RHI label |
| `--show-diagnostics` | FPS + RHI |
| `--retail-diagnostics` | **Retail profile** (see below) — smoke / CI |

Gallery Settings persist toggles under `performance/showFps`, `performance/fpsInTitleBar`, `performance/showRhiInBadge`.

---

## Retail profile (shipping apps)

**Rule:** never leave FPS/RHI visible for end users in production builds.

### C++ (recommended)

Call **before** `applyCli` if you still want dev CLI overrides on internal builds:

```cpp
FrameStatsMonitor::instance()->applyRetailProfile();
FrameStatsMonitor::applyCli(argc, argv); // optional dev override
```

`applyRetailProfile()`:

- Sets **`retailMode`** + **`persistSettings: false`**
- Forces **`enabled`** / **`showRhi`** off
- Clears persisted `performance/*` keys from QSettings

### QML-only apps

From `main.cpp` after `configureApplication`:

```cpp
FrameStatsMonitor::instance()->setRetailMode(true);
FrameStatsMonitor::instance()->setPersistSettings(false);
```

Do **not** embed `FrameStatsBadge` in retail title chrome unless gated by `#ifdef QT_DEBUG` or an explicit internal flag.

### Checklist

- [ ] `applyRetailProfile()` (or `retailMode: true`) in Release `main`
- [ ] No `FrameStatsBadge` in retail **TitleBar** slots
- [ ] Do not ship with Gallery QSettings org/name copying dev toggles
- [ ] CLI `--show-fps` only on internal builds (optional)
- [ ] Document internal QA path: `--show-diagnostics` on nightly builds

---

## Promote status (**2.44**)

| Type | Status | Notes |
|------|--------|--------|
| **`FrameStatsMonitor`** | **Stable** (dev tooling) | Opt-in; retail API contract |
| **`FrameStatsBadge`** | **Stable** | Dev / internal builds |
| **`FrameStatsOverlay`** | **Stable** | Dev / internal builds |

See [stable-api.md](stable-api.md) Platform helpers.

---

## Related diagnostics (not FrameStats)

| Surface | Doc |
|---------|-----|
| Navigation skip counters | [performance.md](performance.md) wave 6 — `sameKeySkipCount` / `samePageSkipCount` |
| Theme contrast | [color-contrast.md](color-contrast.md) (**1.43**) |
| High-DPI readout | [high-dpi.md](high-dpi.md) |

**Out:** Always-on FPS in retail apps · built-in QML profiler · telemetry SaaS.

