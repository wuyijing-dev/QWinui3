# Open in Qt Creator

QWinUI3 is a **CMake** project. Open the **repository root** `CMakeLists.txt` (not an example subfolder).

## Quick start

1. **File → Open File or Project…** → select `CMakeLists.txt` at the repo root.
2. Pick a kit with **Qt 6.8+** (MSVC 2022 64-bit recommended on Windows).
3. Choose configure preset **Default (Release)** / **Release (Ninja)** (or open without a preset — CMake still defaults to Release).
4. Build target `qwinui3_gallery`.

Qt Creator injects `CMAKE_PREFIX_PATH` from the kit. Shared `CMakePresets.json` intentionally does **not** hardcode a Qt install path.

## Presets

| Preset | Build dir | Notes |
|--------|-----------|--------|
| `default` / `release` / `qt68-msvc` | `build/` | **Release** (project default) |
| `debug` | `build-debug/` | Only if you need Debug |
| `relwithdebinfo` | `build-relwithdebinfo/` | Optional |

Plain `cmake -S . -B build` (no `-DCMAKE_BUILD_TYPE`) also configures **Release**. Multi-config generators (Visual Studio) use `CMAKE_DEFAULT_BUILD_TYPE=Release`.

Local Qt / Ninja paths: copy [`CMakeUserPresets.json.example`](https://github.com/wuyijing-dev/QWinui3/blob/master/CMakeUserPresets.json.example) to `CMakeUserPresets.json` and edit (file is gitignored).

```bat
copy CMakeUserPresets.json.example CMakeUserPresets.json
cmake --preset local-qt68-msvc
cmake --build --preset local-qt68-msvc
```

## Kit checklist (Windows)

- Qt 6.8.x `msvc2022_64` (or newer 6.x with the same ABI)
- Compiler: **Microsoft Visual C++ Compiler 17.x (amd64)**
- CMake: Qt Maintenance Tool’s CMake, or system CMake ≥ 3.21
- Generator: **Ninja** (Qt → Tools → Ninja on `PATH`, or set `CMAKE_MAKE_PROGRAM` in user presets)
- Optional: run `scripts/fetch_webview2.ps1` if you want WebView2Host

## Common issues

| Symptom | Fix |
|---------|-----|
| `Could not find Qt6` | Select a Qt 6.8+ kit, or set `CMAKE_PREFIX_PATH` in `CMakeUserPresets.json` |
| `Ninja not found` | Install Ninja via Qt Maintenance Tool; add `…/Qt/Tools/Ninja` to kit PATH |
| Configure fights an old `build/` cache | Delete `build/CMakeCache.txt` or use a fresh preset build dir |
| Opened wrong folder | Always open the **repo root** CMakeLists, not `examples/…` |

## CLI (same tree as Creator Release)

```bat
cmake --preset release
cmake --build --preset release
```

Executable: `build/qwinui3_gallery.exe` (Release).
