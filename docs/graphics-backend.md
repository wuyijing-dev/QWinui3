# Graphics backend (RHI) (1.31)

Which Qt Quick RHI API to ship, how Gallery Settings / `--rhi` interact, and what breaks with Mica / Acrylic.

Related: [window-chrome.md](window-chrome.md) · [window-transparency-dwm.md](window-transparency-dwm.md) · [qt-version-compat.md](qt-version-compat.md) · Gallery **Settings → Graphics backend**.

---

## Which backend should I ship?

| OS | Ship default | When to pick something else |
|----|--------------|-----------------------------|
| **Windows** | **`opengl`** | Driver crash / black frame → try `d3d11`, then `vulkan`. Avoid changing silently for “performance” if you use DWM materials. |
| **Linux** | **`opengl`** | Prefer `vulkan` only after validating on your target GPUs/compositors. |
| **macOS** | **`metal`** (when listed) | Fall back to `opengl` if Metal is unavailable in the build. |

**QWinUI3 Gallery** defaults to **`opengl` on every OS** and does **not** change that default in 1.31. Consumer apps that call nothing get Qt’s own defaults; if you care about Fluent frost on Windows, pin **`opengl`** yourself (see below).

---

## Per-backend notes (Windows)

| Backend | Frost / per-pixel alpha | Typical trade-off |
|---------|-------------------------|-------------------|
| `opengl` | Best path for DWM Mica / Acrylic without a thin edge ring | Gallery / kit recommendation |
| `d3d11` / `d3d12` | Materials often work | May show a **thin white edge** around frosted windows |
| `vulkan` | Alpha OK on many GPUs | Border / backdrop workarounds are limited |

`d3d12` needs Qt **6.6+** (`QWINUI3_HAVE_RHI_D3D12`). Gallery lists only backends available in the running build.

Gallery itself stays on **`BackdropSolid`** — see [window-transparency-dwm.md](window-transparency-dwm.md). RHI choice still matters for apps that enable `BackdropMica` / `Acrylic`, and for diagnosing driver quirks.

---

## Alpha / backdrop caveats

1. **Solid shells** — No system backdrop; RHI is mostly a driver/performance knob.
2. **Mica / Acrylic / transparent host** — Prefer **`opengl`** on Windows. D3D paths can leave a white fringe; Vulkan may not get the same border fixes.
3. **Do not stack** a QML 1px border on a transparent frosted window (classic “white edge” look) — [window-chrome.md](window-chrome.md).
4. Compat `Rhi::apply` sets a **non-alpha** default surface format for the Gallery path; shells that need transparency still go through Platform / `WindowHelper` backdrop install — do not assume flipping RHI alone enables frost.

---

## Gallery: Settings, restart, CLI

**Settings → Graphics backend** writes `graphics/rhiBackend` under `QSettings("QWinUI3", "Gallery")` and shows **Restart** when preferred ≠ active.

Restart relaunches with `--rhi=<preferred>`. Cold start **without** CLI/env uses the Gallery **OpenGL default**; a saved preference surfaces as “restart required” until you Restart or pass `--rhi` / env yourself.

**Priority at process start** (`GraphicsBackend::applyEarly`):

1. `--rhi` / `-rhi` / `--rhi=`
2. `QSG_RHI_BACKEND`
3. Gallery default (`opengl`)

```text
qwinui3_gallery --rhi opengl
qwinui3_gallery --rhi=d3d11
```

Startup log:

```text
QWinUI3 Gallery RHI backend: "opengl" (…; change in Settings or pass --rhi …)
```

Available ids: `opengl` | `vulkan` | `d3d11` | `d3d12` | `metal` (platform-filtered).

---

## Consumer apps

Pin the backend **before** `QGuiApplication` (same idea as Gallery):

```cpp
#include <QWinUI3/Compat/QtCompatRhi.h>

int main(int argc, char *argv[])
{
    QWinUI3::Compat::Rhi::apply(QStringLiteral("opengl")); // Windows + Mica/Acrylic
    // or: QWinUI3::configureEnvironment(argv[0]); then apply if you need an explicit RHI
    QGuiApplication app(argc, argv);
    // …
}
```

Helpers: `normalize`, `platformBackends`, `coerceAvailable`, `apply` — [qt-version-compat.md](qt-version-compat.md).

Do **not** change Windows defaults under users’ feet mid-release; document the choice and keep OpenGL as the Fluent-frost recommendation.

---

## Fixedsys / DirectWrite warnings

Messages such as:

```text
DirectWrite: CreateFontFaceFromHDC() failed … LOGFONT("Fixedsys", …)
```

come from Windows bitmap fonts that DirectWrite cannot open. They are **harmless** for QWinUI3 — Theme uses Fluent / Segoe-style families, not Fixedsys. Safe to ignore unless you request Fixedsys in app code.
