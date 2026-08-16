# Graphics backend (RHI) and font noise

## RHI selection

Qt Quick uses an RHI backend (`opengl`, `vulkan`, `d3d11`, `d3d12`, …).

**Gallery Settings** → “Graphics backend” sets `GraphicsBackend.preferred` and
may require **Restart**.

**CLI** (when launching the Gallery / apps):

```text
--rhi opengl|vulkan|d3d11|d3d12
```

Startup logs look like:

```text
QWinUI3 Gallery RHI backend: "opengl" (change in Settings or pass --rhi …)
```

Use Settings or `--rhi` when diagnosing rendering / driver issues. Prefer a
backend your GPU drivers support; OpenGL is a common fallback on Windows kits.

## Fixedsys / DirectWrite warnings

Messages such as:

```text
DirectWrite: CreateFontFaceFromHDC() failed … LOGFONT("Fixedsys", …)
```

come from Windows bitmap fonts (e.g. Fixedsys) that DirectWrite cannot open.
They are **harmless system noise** for QWinUI3 — Theme uses Fluent / Segoe-style
families, not Fixedsys. Safe to ignore unless you explicitly request Fixedsys
in app code.
