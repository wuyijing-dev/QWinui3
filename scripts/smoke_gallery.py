#!/usr/bin/env python3
"""Lightweight Gallery smoke: binary exists, modules load, Main instantiates (--smoke).

  python scripts/smoke_gallery.py
  python scripts/smoke_gallery.py --build-dir build

On Windows:
  - Never keep an inherited QT_QPA_PLATFORM=offscreen — desktop kits only ship
    qwindows.dll (dialog: "Available platform plugins are: windows.").
  - Prepend the CMake-configured Qt bin ahead of PATH so tools like
    ST-Link / CubeProgrammer / a second Qt kit cannot load a mismatched Qt6Core.
  Gallery itself also coerces foreign QPA values to windows on Win32.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def find_gallery(build_dir: Path) -> Path:
    names = ("qwinui3_gallery.exe", "qwinui3_gallery")
    candidates = [
        build_dir / names[0],
        build_dir / names[1],
        build_dir / "src" / "gallery" / names[0],
        build_dir / "src" / "gallery" / names[1],
    ]
    for c in candidates:
        if c.is_file():
            return c
    found = list(build_dir.rglob("qwinui3_gallery.exe")) + list(build_dir.rglob("qwinui3_gallery"))
    found = [p for p in found if p.is_file()]
    if not found:
        raise FileNotFoundError(f"qwinui3_gallery not found under {build_dir}")
    return max(found, key=lambda p: p.stat().st_mtime)


def qt_prefix_from_cache(build_dir: Path) -> Path | None:
    cache = build_dir / "CMakeCache.txt"
    if not cache.is_file():
        return None
    text = cache.read_text(encoding="utf-8", errors="replace")
    for key in ("CMAKE_PREFIX_PATH:UNINITIALIZED=", "CMAKE_PREFIX_PATH:PATH=", "Qt6_DIR:PATH="):
        m = re.search(rf"^{re.escape(key)}(.+)$", text, re.MULTILINE)
        if not m:
            continue
        raw = m.group(1).strip().split(";")[0].strip()
        if not raw:
            continue
        p = Path(raw)
        if key.startswith("Qt6_DIR") and p.name == "Qt6":
            p = p.parent.parent.parent
        if (p / "bin").is_dir() or (p / "lib").is_dir():
            return p
    return None


def resolve_platform(cli_platform: str | None) -> tuple[str, str | None]:
    """Return (platform, note_about_override)."""
    if cli_platform:
        return cli_platform, None

    inherited = os.environ.get("QT_QPA_PLATFORM", "").strip()
    if sys.platform.startswith("win"):
        if inherited in ("", "windows"):
            return "windows", None
        return "windows", f"ignored inherited QT_QPA_PLATFORM={inherited!r}"
    if inherited:
        return inherited, None
    return "offscreen", None


def pin_qt_on_path(env: dict[str, str], build_dir: Path) -> str | None:
    if not sys.platform.startswith("win"):
        return None
    prefix = qt_prefix_from_cache(build_dir)
    if prefix is None:
        return None
    qt_bin = prefix / "bin"
    qt_plugins = prefix / "plugins"
    if not qt_bin.is_dir():
        return None
    path = env.get("PATH", "")
    env["PATH"] = str(qt_bin) + os.pathsep + path
    env["QTDIR"] = str(prefix)
    if qt_plugins.is_dir():
        env["QT_PLUGIN_PATH"] = str(qt_plugins)
    return str(prefix)


def _run_preflight(script: str, label: str) -> int | None:
    path = ROOT / "scripts" / script
    if not path.is_file():
        return None
    proc = subprocess.run([sys.executable, str(path)], cwd=str(ROOT), check=False)
    if proc.returncode != 0:
        print(f"error: {script} failed", file=sys.stderr)
        return proc.returncode if proc.returncode > 0 else 1
    print(f"smoke: {label}")
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description="Run QWinUI3 Gallery --smoke")
    parser.add_argument("--build-dir", type=Path, default=ROOT / "build")
    parser.add_argument("--bin", type=Path, default=None, help="Gallery binary path")
    parser.add_argument("--timeout", type=float, default=120.0, help="Seconds before kill")
    parser.add_argument(
        "--platform",
        default=None,
        help="QT_QPA_PLATFORM (Windows default: windows; Linux default: offscreen)",
    )
    args = parser.parse_args()

    binary = args.bin if args.bin else find_gallery(args.build_dir)
    if not binary.is_file():
        print(f"error: binary not found: {binary}", file=sys.stderr)
        return 2

    platform, note = resolve_platform(args.platform)
    env = os.environ.copy()
    env["QT_QPA_PLATFORM"] = platform
    env["QWINUI3_KEEP_QPA_PLATFORM"] = "1"
    env.setdefault("QT_QUICK_CONTROLS_STYLE", "QWinUI3")
    pinned = pin_qt_on_path(env, args.build_dir.resolve())

    cmd = [str(binary), "--smoke"]
    print(f"smoke: running {' '.join(cmd)} (platform={platform})")
    if note:
        print(f"smoke: {note}")
    if pinned:
        print(f"smoke: pinned Qt prefix {pinned}")

    for script, label in (
        ("smoke_catalog.py", "catalog integrity OK"),
        ("check_gallery_translations.py", "translation seeds OK"),
        ("check_catalog_refresh.py", "catalog refresh OK"),
        ("check_docs_links.py", "docs links OK"),
        ("check_shared_package.py", "shared package contracts OK"),
    ):
        rc = _run_preflight(script, label)
        if rc is not None:
            return rc

    try:
        proc = subprocess.run(
            cmd,
            cwd=str(binary.parent),
            env=env,
            timeout=args.timeout,
            check=False,
        )
    except subprocess.TimeoutExpired:
        print(f"error: smoke timed out after {args.timeout}s", file=sys.stderr)
        return 124

    if proc.returncode != 0:
        print(f"error: smoke exited {proc.returncode}", file=sys.stderr)
        return proc.returncode if proc.returncode > 0 else 1

    print("smoke: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
