#!/usr/bin/env python3
"""Package QWinUI3 Release libraries (DLL/.so + QML modules) into dist/.

Default libraries are STATIC (linked into Gallery). Pass --shared to configure
a separate build with -DQWINUI3_BUILD_SHARED=ON and collect redistributable
shared libraries + QML import trees.

Examples (PowerShell / cmd from repo root):

  python scripts/package_release_libs.py
  python scripts/package_release_libs.py --shared
  python scripts/package_release_libs.py --shared --build-dir build-shared-release --out dist/qwinui3

Requires: cmake, a Qt 6.8+ kit on CMAKE_PREFIX_PATH / Qt6_DIR / PATH.
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "dist" / "qwinui3"


def _run(cmd: list[str], cwd: Path | None = None) -> None:
    print("+", " ".join(cmd), flush=True)
    subprocess.check_call(cmd, cwd=str(cwd or ROOT))


def _detect_qt_prefix() -> str | None:
    for key in ("CMAKE_PREFIX_PATH", "Qt6_DIR", "QTDIR"):
        val = os.environ.get(key)
        if not val:
            continue
        # Qt6_DIR is often <prefix>/lib/cmake/Qt6
        p = Path(val)
        if p.name == "Qt6" and p.parent.name == "cmake":
            return str(p.parents[2])
        return val.split(os.pathsep)[0]
    return None


def _configure(build_dir: Path, shared: bool, qt_prefix: str | None) -> None:
    build_dir.mkdir(parents=True, exist_ok=True)
    cmd = [
        "cmake",
        "-S",
        str(ROOT),
        "-B",
        str(build_dir),
        "-DCMAKE_BUILD_TYPE=Release",
        f"-DQWINUI3_BUILD_SHARED={'ON' if shared else 'OFF'}",
        "-DQWINUI3_BUILD_EXAMPLES=OFF",
    ]
    if qt_prefix:
        cmd.append(f"-DCMAKE_PREFIX_PATH={qt_prefix}")
    # Prefer Ninja when available
    if shutil.which("ninja"):
        cmd[1:1] = ["-G", "Ninja"]
    _run(cmd)


def _build(build_dir: Path, shared: bool) -> None:
    cmd = ["cmake", "--build", str(build_dir), "--config", "Release"]
    jobs = os.cpu_count() or 4
    cmd.extend(["--parallel", str(jobs)])
    # Shared packaging must not link Gallery (it still expects static QML plugins).
    if shared:
        cmd.extend(
            [
                "--target",
                "qwinui3_theme",
                "qwinui3_style",
                "qwinui3_platform",
                "qwinui3_extras",
            ]
        )
    _run(cmd)


def _is_lib(path: Path) -> bool:
    name = path.name.lower()
    return name.endswith((".dll", ".so", ".dylib", ".lib", ".a")) and "qwinui3" in name


def _collect_files(build_dir: Path, out_dir: Path) -> list[Path]:
    lib_dir = out_dir / "lib"
    qml_dir = out_dir / "qml"
    bin_dir = out_dir / "bin"
    lib_dir.mkdir(parents=True, exist_ok=True)
    qml_dir.mkdir(parents=True, exist_ok=True)
    bin_dir.mkdir(parents=True, exist_ok=True)

    copied: list[Path] = []

    # Shared / import libraries
    for pattern in ("**/*qwinui3*", "**/QWinUI3/**"):
        for path in build_dir.glob(pattern):
            if not path.is_file():
                continue
            if _is_lib(path):
                dest = lib_dir / path.name
                shutil.copy2(path, dest)
                copied.append(dest)
                # Also put runtime DLLs in bin/
                if path.suffix.lower() == ".dll":
                    bdest = bin_dir / path.name
                    shutil.copy2(path, bdest)
                    copied.append(bdest)

    # QML module trees (qmldir + qmltypes + qml)
    for module_rel in (
        "QWinUI3",
        "QWinUI3/Theme",
        "QWinUI3/Extras",
        "QWinUI3/Platform",
    ):
        candidates = list(build_dir.glob(f"**/{module_rel}/qmldir"))
        # Prefer src/... layout under build
        candidates.sort(key=lambda p: ("src" not in str(p), len(str(p))))
        if not candidates:
            continue
        src_root = candidates[0].parent
        dest_root = qml_dir / module_rel.replace("/", os.sep)
        if dest_root.exists():
            shutil.rmtree(dest_root)
        shutil.copytree(
            src_root,
            dest_root,
            ignore=shutil.ignore_patterns(
                "*.obj", "*.o", "*.pdb", "CMakeFiles", "*.cmake", "Makefile*"
            ),
        )
        copied.append(dest_root)

    return copied


def _write_readme(out_dir: Path, shared: bool) -> None:
    text = f"""# QWinUI3 Release package

Build type: Release
Library type: {"SHARED (DLL/.so)" if shared else "STATIC (.lib/.a)"}

## Layout

- `bin/` — runtime DLLs (Windows shared builds)
- `lib/` — import / static libraries and plugins
- `qml/` — QML modules (`QWinUI3`, `QWinUI3.Theme`, `QWinUI3.Extras`, `QWinUI3.Platform`)

## Consumer notes

1. Add `qml/` to `QML_IMPORT_PATH` (or copy beside your app and set `QML2_IMPORT_PATH`).
2. Link against the `qwinui3_*` libraries (and `*plugin` when STATIC).
3. Qt 6.8+ required: Quick, QuickControls2, LabsQmlModels.
4. License: **LGPL-3.0** (see `LICENSE` and `COPYING` in this package).
5. Prefer SHARED packaging for redistributable SDKs:

```bash
python scripts/package_release_libs.py --shared
```

Default in-tree builds stay STATIC for simpler Gallery linking.
"""
    (out_dir / "README.md").write_text(text, encoding="utf-8")
    for name in ("LICENSE", "COPYING"):
        src = ROOT / name
        if src.is_file():
            shutil.copy2(src, out_dir / name)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--shared",
        action="store_true",
        help="Configure -DQWINUI3_BUILD_SHARED=ON (emit DLL/.so)",
    )
    parser.add_argument(
        "--build-dir",
        type=Path,
        default=None,
        help="CMake build directory (default: build or build-shared-release)",
    )
    parser.add_argument(
        "--out",
        type=Path,
        default=DEFAULT_OUT,
        help=f"Output directory (default: {DEFAULT_OUT})",
    )
    parser.add_argument(
        "--no-build",
        action="store_true",
        help="Skip configure/build; only collect from --build-dir",
    )
    parser.add_argument(
        "--qt-prefix",
        default=None,
        help="CMAKE_PREFIX_PATH for Qt (default: env CMAKE_PREFIX_PATH/Qt6_DIR/QTDIR)",
    )
    args = parser.parse_args()

    build_dir = args.build_dir
    if build_dir is None:
        build_dir = ROOT / ("build-shared-release" if args.shared else "build")
    build_dir = build_dir.resolve()
    out_dir = args.out.resolve()

    qt_prefix = args.qt_prefix or _detect_qt_prefix()

    if not args.no_build:
        _configure(build_dir, args.shared, qt_prefix)
        _build(build_dir, args.shared)

    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    copied = _collect_files(build_dir, out_dir)
    _write_readme(out_dir, args.shared)

    print(f"\nPackaged {len(copied)} items → {out_dir}")
    if args.shared and not any(p.suffix.lower() == ".dll" for p in out_dir.joinpath("bin").glob("*") if p.is_file()):
        # Non-Windows or empty — still OK if .so present
        sos = list(out_dir.joinpath("lib").glob("*.so*"))
        if not sos:
            print(
                "WARNING: no DLL/.so found. Shared plugins may live under build/; "
                "inspect lib/ and qml/.",
                file=sys.stderr,
            )
    return 0


if __name__ == "__main__":
    sys.exit(main())
