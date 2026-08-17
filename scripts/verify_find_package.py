#!/usr/bin/env python3
"""Verify the 1.61 find_package sketch against a shared package (Release).

  python scripts/verify_find_package.py
  python scripts/verify_find_package.py --package-dir dist/qwinui3-1.61-windows-x64-shared-…

Without --package-dir: builds a shell shared kit (webview2 off), then configures
and builds examples/find-package-consumer in Release.

Requires: cmake, Ninja (preferred), Qt on CMAKE_PREFIX_PATH / PATH.
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONSUMER = ROOT / "examples" / "find-package-consumer"


def _run(cmd: list[str], cwd: Path | None = None) -> None:
    print("+", " ".join(cmd), flush=True)
    subprocess.check_call(cmd, cwd=str(cwd or ROOT))


def _detect_qt_prefix() -> str | None:
    for key in ("CMAKE_PREFIX_PATH", "Qt6_DIR", "QTDIR"):
        val = os.environ.get(key)
        if not val:
            continue
        p = Path(val)
        if p.name == "Qt6" and p.parent.name == "cmake":
            return str(p.parents[2])
        return val.split(os.pathsep)[0]
    # Common local kit
    candidate = Path(r"D:\Qt\6.8.0\msvc2022_64")
    if candidate.is_dir():
        return str(candidate)
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--package-dir",
        type=Path,
        default=None,
        help="Existing shared package root (bin/ lib/ qml/). If omitted, package shell kit.",
    )
    parser.add_argument(
        "--build-dir",
        type=Path,
        default=ROOT / "build-fpc",
        help="Consumer build directory (default: build-fpc)",
    )
    parser.add_argument(
        "--skip-package",
        action="store_true",
        help="Require --package-dir; do not invoke package_release_libs.py",
    )
    args = parser.parse_args()

    if not CONSUMER.is_dir():
        print(f"error: missing {CONSUMER}", file=sys.stderr)
        return 2

    qt_prefix = _detect_qt_prefix()
    if not qt_prefix:
        print("error: set CMAKE_PREFIX_PATH / Qt6_DIR to a Qt 6.5+ kit", file=sys.stderr)
        return 2
    qt_prefix = str(Path(qt_prefix.strip()).resolve())

    package_dir = args.package_dir
    if package_dir is None:
        if args.skip_package:
            print("error: --skip-package requires --package-dir", file=sys.stderr)
            return 2
        # Build a minimal shell shared kit for the sketch.
        _run(
            [
                sys.executable,
                str(ROOT / "scripts" / "package_release_libs.py"),
                "--shared",
                "--preset",
                "shell",
                "--webview2",
                "off",
            ]
        )
        # Discover newest matching dist folder.
        dist = ROOT / "dist"
        candidates = sorted(
            dist.glob("qwinui3-*-windows-x64-shared*"),
            key=lambda p: p.stat().st_mtime,
            reverse=True,
        )
        # Prefer theme+style+platform slug over full "all" if both exist from this run.
        shellish = [p for p in candidates if p.is_dir() and "theme+style+platform" in p.name]
        package_dir = shellish[0] if shellish else (candidates[0] if candidates else None)
        if package_dir is None or not package_dir.is_dir():
            print("error: package_release_libs.py did not produce a dist folder", file=sys.stderr)
            return 2
    else:
        package_dir = package_dir.resolve()
        if not package_dir.is_dir():
            print(f"error: not a directory: {package_dir}", file=sys.stderr)
            return 2

    cfg = package_dir / "lib" / "cmake" / "QWinUI3" / "QWinUI3Config.cmake"
    if not cfg.is_file():
        print(f"error: missing {cfg} — re-run package_release_libs.py (1.61+)", file=sys.stderr)
        return 2

    # Prefer a developer shell on Windows so CMake can find MSVC.
    if os.name == "nt" and not (shutil.which("cl") or shutil.which("cl.exe")):
        print(
            "warning: cl.exe not on PATH — if configure fails, run from VsDevCmd / vcvars64",
            file=sys.stderr,
        )

    build_dir = args.build_dir.resolve()
    if build_dir.exists():
        shutil.rmtree(build_dir)
    build_dir.mkdir(parents=True, exist_ok=True)

    prefix = os.pathsep.join([qt_prefix, str(package_dir)])
    configure = [
        "cmake",
        "-S",
        str(CONSUMER),
        "-B",
        str(build_dir),
        f"-DCMAKE_PREFIX_PATH={prefix}",
        "-DCMAKE_BUILD_TYPE=Release",
    ]
    if shutil.which("ninja"):
        configure[1:1] = ["-G", "Ninja"]
    _run(configure)

    build = ["cmake", "--build", str(build_dir), "--config", "Release"]
    jobs = os.cpu_count() or 4
    build.extend(["--parallel", str(jobs)])
    _run(build)

    exe = build_dir / "qwinui3_find_package_consumer.exe"
    if not exe.is_file():
        # Ninja may place beside build dir root already
        matches = list(build_dir.rglob("qwinui3_find_package_consumer.exe"))
        exe = matches[0] if matches else exe
    if not exe.is_file():
        # Linux
        matches = list(build_dir.rglob("qwinui3_find_package_consumer"))
        exe = matches[0] if matches else exe
    if not exe.is_file():
        print("error: consumer executable not found after build", file=sys.stderr)
        return 2

    print(f"verify_find_package: OK ({exe})")
    print(f"  package: {package_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
