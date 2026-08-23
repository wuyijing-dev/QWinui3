# Graphics backend (RHI)

Which Qt Quick RHI API to ship, how Gallery Settings / `--rhi` interact, and what breaks with Mica / Acrylic.

Related: [window-chrome.md](window-chrome.md) · [window-transparency-dwm.md](window-transparency-dwm.md) · [high-dpi.md](high-dpi.md) · [qt-version-compat.md](qt-version-compat.md) · Gallery **Settings → Graphics backend**.

DPI / multi-monitor restore is **not** fixed by swapping RHI — see [high-dpi.md](high-dpi.md). RHI still matters for frost fringe and driver quirks.

---

## Which backend should I ship?

| OS | Ship default | Fallback order (when unsupported) |
|----|--------------|-----------------------------------|
| **Windows** | **`d3d11`** | `d3d11` → `opengl` → `vulkan` → `d3d12` |
| **Linux** | **`vulkan`** | `vulkan` → `opengl` |
| **macOS** | **`metal`** (when listed) | `metal` → `opengl` → `vulkan` |

`QWinUI3::configureEnvironment` / Python `configure_environment` apply this default when `QSG_RHI_BACKEND` is unset (probe + coerce). Gallery `--rhi` / Settings still override.

**Frost / Mica / Acrylic on Windows:** prefer **`opengl`** explicitly if you need the cleanest DWM edge (D3D may show a thin white ring). Defaults favor native APIs; pin OpenGL when shipping frosted shells.

---

## Runtime detection

`Compat::Rhi::isRuntimeSupported` / `coerceAvailable` (and Python `qwinui3.rhi`):

| Check | Behavior |
|-------|----------|
| Vulkan | Skip on headless QPA (`offscreen` / `minimal` / …). Load ICD (`vulkan-1` / `libvulkan.so.1`) and try a null-instance device enum (C++). |
| D3D11 / D3D12 | Soft probe: `d3d11.dll` / `d3d12.dll` + create export present. |
| OpenGL / Metal | Assumed available when listed in `platformBackends()`. |

Set **`QWINUI3_RHI_SKIP_PROBE=1`** to skip probes and use the compile-time platform list only (CI / forced path).

---

## Per-backend notes (Windows)

| Backend | Frost / per-pixel alpha | Typical trade-off |
|---------|-------------------------|-------------------|
| `opengl` | Best path for DWM Mica / Acrylic without a thin edge ring | Pin when frost quality matters |
| `d3d11` / `d3d12` | Materials often work | May show a **thin white edge** around frosted windows |
| `vulkan` | Alpha OK on many GPUs | Border / backdrop workarounds are limited |

`d3d12` needs Qt **6.6+** (`QWINUI3_HAVE_RHI_D3D12`). Gallery lists only backends available in the running build.

Gallery itself stays on **`BackdropSolid`** — see [window-transparency-dwm.md](window-transparency-dwm.md).

---

## Alpha / backdrop caveats

1. **Solid shells** — No system backdrop; RHI is mostly a driver/performance knob.
2. **Mica / Acrylic / transparent host** — Prefer **`opengl`** on Windows. D3D paths can leave a white fringe; Vulkan may not get the same border fixes.
3. **Do not stack** a QML 1px border on a transparent frosted window — [window-chrome.md](window-chrome.md).
4. Compat `Rhi::apply` sets a **non-alpha** default surface format for the Gallery path; shells that need transparency still go through Platform / `WindowHelper`.

---

## Gallery: Settings, restart, CLI

**Settings → Graphics backend** writes `graphics/rhiBackend` under `QSettings("QWinUI3", "Gallery")` and shows **Restart** when preferred ≠ active.

Restart relaunches with `--rhi=<preferred>`.

**Priority at process start** (`GraphicsBackend::applyEarly`):

1. `--rhi` / `-rhi` / `--rhi=`
2. `QSG_RHI_BACKEND` (also set by kit `configureEnvironment` when previously empty)
3. Platform default + probe (`d3d11` / `vulkan` / …)

```text
qwinui3_gallery --rhi opengl
qwinui3_gallery --rhi=d3d11
```

Available ids: `opengl` | `vulkan` | `d3d11` | `d3d12` | `metal` (platform-filtered).

---

## Consumer apps

`configureEnvironment` already pins the platform default. To override **before** `QGuiApplication`:

```cpp
#include <QWinUI3/Compat/QtCompatRhi.h>

int main(int argc, char *argv[])
{
    QWinUI3::Compat::Rhi::apply(QStringLiteral("opengl")); // frost-first Windows
    QWinUI3::configureEnvironment(argv[0]); // keeps existing QSG_RHI_BACKEND
    QGuiApplication app(argc, argv);
    // …
}
```

Helpers: `normalize`, `platformBackends`, `fallbackOrder`, `defaultBackend`, `isRuntimeSupported`, `coerceAvailable`, `apply` — [qt-version-compat.md](qt-version-compat.md).

---

## Fixedsys / DirectWrite warnings

Messages such as:

```text
DirectWrite: CreateFontFaceFromHDC() failed … LOGFONT("Fixedsys", …)
```

come from Windows bitmap fonts that DirectWrite cannot open. They are **harmless** for QWinUI3 — Theme uses Fluent / Segoe-style families, not Fixedsys.
