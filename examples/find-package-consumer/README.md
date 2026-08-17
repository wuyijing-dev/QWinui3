# find_package consumer (1.61)

Tiny **standalone** app that consumes a **shared Release package** via `find_package(QWinUI3 CONFIG)`.

**Not** wired into the monorepo `examples/` CMake tree (avoids requiring a packaged kit for normal Gallery builds).

## Prerequisites

1. Qt **6.5+** (recommended **6.8**) on `CMAKE_PREFIX_PATH`
2. A shared kit, e.g.:

```bat
python scripts/package_release_libs.py --shared --preset shell --webview2 off
```

Output under `dist/qwinui3-<ver>-windows-x64-shared-theme+style+platform/` (or full `…-shared`).

## Configure & build (Release)

```bat
cmake -S examples/find-package-consumer -B build-fpc -G Ninja -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_PREFIX_PATH=D:/Qt/6.8.0/msvc2022_64;D:/path/to/qwinui3-…-shared
cmake --build build-fpc
```

Or set `QWinUI3_DIR` to `<package>/lib/cmake/QWinUI3`.

## Verify helper

```bat
python scripts/verify_find_package.py --package-dir dist/qwinui3-…-shared
```

## Notes

- Sketch only — **not** an official vcpkg/Conan port ([parking lot](../../ROADMAP.md#parking-lot)).
- Full recipe: [docs/packaging-consumer.md](../../docs/packaging-consumer.md) **Path C**.
- Shared builds: do **not** use `QWINUI3_IMPORT_QML_PLUGINS` (plugins load from `qml/`).
