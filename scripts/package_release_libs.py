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
import platform
import re
import shutil
import subprocess
import sys
import tarfile
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "dist" / "qwinui3"


def _project_version() -> str:
    text = (ROOT / "CMakeLists.txt").read_text(encoding="utf-8")
    m = re.search(r"project\s*\(\s*QWinUI3\s+VERSION\s+([0-9]+\.[0-9]+\.[0-9]+)", text)
    if not m:
        raise RuntimeError("Could not parse VERSION from CMakeLists.txt")
    return m.group(1)


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
    if "qwinui3" not in name:
        return False
    if name.endswith((".dll", ".dylib", ".lib", ".a")):
        return True
    # Linux: libqwinui3_theme.so, .so.1, .so.1.0.0
    if ".so" in name and (name.endswith(".so") or ".so." in name):
        return True
    return False


def _collect_files(build_dir: Path, out_dir: Path) -> list[Path]:
    lib_dir = out_dir / "lib"
    qml_dir = out_dir / "qml"
    bin_dir = out_dir / "bin"
    lib_dir.mkdir(parents=True, exist_ok=True)
    qml_dir.mkdir(parents=True, exist_ok=True)
    bin_dir.mkdir(parents=True, exist_ok=True)

    copied: list[Path] = []
    seen: set[str] = set()

    # Shared / import libraries (include versioned .so* and symlinks)
    for pattern in ("**/*qwinui3*", "**/libqwinui3*", "**/QWinUI3/**"):
        for path in build_dir.glob(pattern):
            if not path.is_file() and not path.is_symlink():
                continue
            if not _is_lib(path):
                continue
            key = path.name
            if key in seen:
                continue
            seen.add(key)
            dest = lib_dir / path.name
            if path.is_symlink():
                # Preserve relative symlink when possible
                try:
                    dest.symlink_to(os.readlink(path))
                except OSError:
                    shutil.copy2(path, dest, follow_symlinks=True)
            else:
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
    host = platform.system()
    text = f"""# QWinUI3 Release package

Build type: Release
Host: {host}
Library type: {"SHARED (DLL/.so)" if shared else "STATIC (.lib/.a)"}

## Layout

- `bin/` — runtime DLLs (Windows shared builds)
- `lib/` — import / static / shared libraries and plugins
- `qml/` — QML modules (`QWinUI3`, `QWinUI3.Theme`, `QWinUI3.Extras`, `QWinUI3.Platform`)

## Consumer notes

1. Add `qml/` to `QML_IMPORT_PATH` (or copy beside your app and set `QML2_IMPORT_PATH`).
2. Link against the `qwinui3_*` libraries (and `*plugin` when STATIC).
3. On Linux shared builds, add `lib/` to `LD_LIBRARY_PATH` (or set `rpath`).
4. Qt 6.8+ required: Quick, QuickControls2, LabsQmlModels.
5. License: **LGPL-3.0** (see `LICENSE` and `COPYING` in this package).
6. Prefer SHARED packaging for redistributable SDKs:

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


def _archive(out_dir: Path, archive: Path) -> None:
    if archive.exists():
        archive.unlink()
    archive.parent.mkdir(parents=True, exist_ok=True)
    if archive.name.endswith(".tar.gz"):
        with tarfile.open(archive, "w:gz") as tf:
            tf.add(out_dir, arcname=out_dir.name)
    else:
        with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for path in out_dir.rglob("*"):
                if path.is_file():
                    zf.write(path, arcname=str(Path(out_dir.name) / path.relative_to(out_dir)))


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
    parser.add_argument(
        "--version",
        default=None,
        help="Version string for archive name (default: CMake project VERSION)",
    )
    parser.add_argument(
        "--archive",
        action="store_true",
        help="Also create a zip (Windows) or tar.gz (elsewhere) under dist/",
    )
    args = parser.parse_args()

    version = args.version or _project_version()
    build_dir = args.build_dir
    if build_dir is None:
        build_dir = ROOT / ("build-shared-release" if args.shared else "build")
    build_dir = build_dir.resolve()

    host = platform.system().lower()
    plat = "windows" if host.startswith("win") else "linux"
    arch = "x64"
    kind = "shared" if args.shared else "static"
    default_name = f"qwinui3-{version}-{plat}-{arch}-{kind}"

    out_dir = args.out.resolve()
    # If caller left the generic default, use platform-versioned folder name.
    if args.out == DEFAULT_OUT:
        out_dir = (ROOT / "dist" / default_name).resolve()

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
    if args.shared and not any(
        p.suffix.lower() == ".dll" for p in out_dir.joinpath("bin").glob("*") if p.is_file()
    ):
        sos = list(out_dir.joinpath("lib").glob("*.so*"))
        if not sos:
            print(
                "WARNING: no DLL/.so found. Shared plugins may live under build/; "
                "inspect lib/ and qml/.",
                file=sys.stderr,
            )

    if args.archive:
        if plat == "windows":
            archive = ROOT / "dist" / f"{default_name}.zip"
        else:
            archive = ROOT / "dist" / f"{default_name}.tar.gz"
        _archive(out_dir, archive)
        print(f"Archive → {archive}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
