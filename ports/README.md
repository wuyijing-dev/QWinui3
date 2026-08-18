# vcpkg overlay ports

Official **QWinUI3** port for [vcpkg](https://vcpkg.io/) — ships a **shared Release** kit (`bin/` · `lib/` · `qml/` · `lib/cmake/QWinUI3/`).

Consumer guide: [docs/packaging-vcpkg-conan.md](../docs/packaging-vcpkg-conan.md).

## Quick install (overlay)

From a clone of this repository:

```bat
vcpkg install qwinui3 --overlay-ports=./ports --triplet x64-windows
```

```bash
vcpkg install qwinui3 --overlay-ports=./ports --triplet x64-linux
```

When the overlay detects the enclosing tree (`ports/qwinui3/../../CMakeLists.txt`), it **builds local source** instead of downloading GitHub.

## Features

| Feature | Default | Effect |
|---------|---------|--------|
| `extras` | on | Full kit (theme + style + platform + extras) |
| `media` | off | `MediaPlayerElement` (experimental) + `qtmultimedia` |
| `webview2` | off | `WebView2Host` (Windows only) |

Without `extras`: `--preset shell` (theme + style + platform only).

## Triplets

| Triplet | Status |
|---------|--------|
| `x64-windows` | Supported (MSVC + Qt from vcpkg) |
| `x64-linux` | Supported (gcc + Qt from vcpkg) |

## Registry submission

Before opening a PR to [microsoft/vcpkg](https://github.com/microsoft/vcpkg):

1. Tag `vX.YY` on this repo.
2. Run `vcpkg hash git https://github.com/wuyijing-dev/QWinui3 vX.YY` and paste SHA512 into `portfile.cmake`.
3. Remove or keep the overlay local-source fallback (registry ports typically use GitHub fetch only).
