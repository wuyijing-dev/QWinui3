# CI smoke (1.06)

Lightweight regression gate — **not** a full test suite.

| Workflow | When | What |
|----------|------|------|
| [`.github/workflows/smoke.yml`](../.github/workflows/smoke.yml) | `push` / `pull_request` to `master`, manual | Release configure → build `qwinui3_gallery` → `--smoke` |
| [`.github/workflows/release.yml`](../.github/workflows/release.yml) | `v*` tags / dispatch | Shared libs + Gallery packages |
| [`.github/workflows/docs.yml`](../.github/workflows/docs.yml) | docs changes | MkDocs / Pages |

## Local

```bat
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=OFF
cmake --build build --config Release --target qwinui3_gallery
python scripts/smoke_gallery.py --build-dir build
```

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=OFF
cmake --build build --config Release --target qwinui3_gallery
python scripts/smoke_gallery.py --build-dir build
```

### Windows QPA pitfall

Desktop Qt kits / `windeployqt` trees often **only** ship `platforms/qwindows.dll`.
If the shell has `QT_QPA_PLATFORM=offscreen` (Cursor and some CI images do), Gallery
shows:

> Available platform plugins are: windows.

**Fixes (1.06):**

- Gallery **always** coerces foreign `QT_QPA_PLATFORM` values to `windows` on Win32
  (not only `--smoke`). Opt out with `QWINUI3_ALLOW_FOREIGN_QPA=1`.
- `scripts/smoke_gallery.py` ignores inherited `offscreen`/`minimal` and prepends the
  CMake `CMAKE_PREFIX_PATH` Qt `bin` so a second kit on `PATH` (CubeProgrammer, etc.)
  cannot load a mismatched `Qt6Core.dll`.

| Host | Default platform |
|------|------------------|
| Windows | `windows` |
| Linux CI | `offscreen` |

```bat
REM After build.bat (windeploy) or with the build Qt bin first on PATH:
qwinui3_gallery.exe
qwinui3_gallery.exe --smoke
python scripts/smoke_gallery.py --build-dir build --platform windows
```

`--smoke` loads `QWinUI3.Gallery/Main`, processes events once, prints `QWinUI3 Gallery smoke OK`, exits `0`.

## Scope

**In 1.06:** Windows + Linux, Qt **6.8**, Gallery only, examples/WebView2 off for speed.

**Not in 1.06:** Screenshot diffs, multi-Qt matrix, packaging inside smoke.
