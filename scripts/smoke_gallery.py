#!/usr/bin/env python3
"""Lightweight Gallery smoke: binary exists, modules load, Main instantiates (--smoke).

  python scripts/smoke_gallery.py
  python scripts/smoke_gallery.py --build-dir build
  python scripts/smoke_gallery.py --check-startup-budget   # 3.39 S16 absolute main= gate

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

# Absolute CI budgets (3.39 S16) — interactive shell = main=…ms through Main.qml.
# Documented in docs/performance.md. Soft local warn unless --check-startup-budget.
STARTUP_BUDGET_MAIN_MS = {
    "windows": 1500,
    "linux": 2000,
}
STARTUP_BUDGET_APP_MS = {
    "windows": 800,
    "linux": 1000,
}


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


def _budget_family(platform: str) -> str:
    if platform.startswith("wayland") or platform in ("xcb", "offscreen"):
        return "linux"
    if platform == "windows" or sys.platform.startswith("win"):
        return "windows"
    return "linux"


def _ci_default_budget_check() -> bool:
    for key in ("CI", "GITHUB_ACTIONS", "QWINUI3_CHECK_STARTUP_BUDGET"):
        val = os.environ.get(key, "").strip().lower()
        if val in ("1", "true", "yes"):
            return True
    return False


def _parse_startup_ms(log: str) -> tuple[int | None, int | None]:
    """Return (app_ms, main_ms) from Gallery --smoke / --startup-log lines."""
    app_ms = None
    main_ms = None
    for m in re.finditer(r"\bapp=(\d+)ms\b", log):
        app_ms = int(m.group(1))
    for m in re.finditer(r"\bmain=(\d+)ms\b", log):
        main_ms = int(m.group(1))
    return app_ms, main_ms


def check_startup_budget(log: str, platform: str, *, enforce: bool) -> int:
    """Return 0 if OK / soft; non-zero if enforce and over budget."""
    family = _budget_family(platform)
    main_limit = STARTUP_BUDGET_MAIN_MS[family]
    app_limit = STARTUP_BUDGET_APP_MS[family]
    app_ms, main_ms = _parse_startup_ms(log)

    if main_ms is None:
        msg = "startup budget: could not parse main=…ms from Gallery output"
        if enforce:
            print(f"error: {msg}", file=sys.stderr)
            return 3
        print(f"smoke: warn: {msg}")
        return 0

    print(
        f"smoke: startup budget ({family}): app={app_ms}ms/{app_limit}ms "
        f"main={main_ms}ms/{main_limit}ms (interactive shell)"
    )

    over = []
    if main_ms > main_limit:
        over.append(f"main={main_ms}ms > {main_limit}ms")
    if app_ms is not None and app_ms > app_limit:
        over.append(f"app={app_ms}ms > {app_limit}ms")

    if not over:
        print("smoke: startup budget OK")
        return 0

    detail = "; ".join(over)
    if enforce:
        print(
            f"error: startup budget exceeded ({detail}) — see docs/performance.md (3.39 S16)",
            file=sys.stderr,
        )
        return 3
    print(f"smoke: warn: startup over soft budget ({detail})")
    return 0


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
    parser.add_argument(
        "--check-startup-budget",
        action=argparse.BooleanOptionalAction,
        default=None,
        help="Fail if main=/app= exceed absolute CI budgets (default: on under CI)",
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
    # Windows: qInfo goes nowhere when stderr is a pipe unless forced (3.39 S16 parse).
    env.setdefault("QT_FORCE_STDERR_LOGGING", "1")
    pinned = pin_qt_on_path(env, args.build_dir.resolve())

    enforce_budget = (
        _ci_default_budget_check() if args.check_startup_budget is None else args.check_startup_budget
    )

    cmd = [str(binary), "--smoke"]
    print(f"smoke: running {' '.join(cmd)} (platform={platform})", flush=True)
    if note:
        print(f"smoke: {note}", flush=True)
    if pinned:
        print(f"smoke: pinned Qt prefix {pinned}", flush=True)
    if enforce_budget:
        print("smoke: startup budget check enabled (3.39 S16)", flush=True)

    for script, label in (
        ("smoke_catalog.py", "catalog integrity OK"),
        ("lint_qml_imports.py", "example QML import lint OK"),
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
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
    except subprocess.TimeoutExpired:
        print(f"error: smoke timed out after {args.timeout}s", file=sys.stderr)
        return 124

    combined = (proc.stdout or "") + (proc.stderr or "")
    if combined:
        try:
            sys.stdout.write(combined)
            if not combined.endswith("\n"):
                sys.stdout.write("\n")
        except UnicodeEncodeError:
            # Windows consoles may be GBK — don't fail smoke on log glyphs.
            sys.stdout.buffer.write(combined.encode(sys.stdout.encoding or "utf-8", errors="replace"))
            if not combined.endswith("\n"):
                sys.stdout.buffer.write(b"\n")
            sys.stdout.flush()

    if proc.returncode != 0:
        print(f"error: smoke exited {proc.returncode}", file=sys.stderr)
        return proc.returncode if proc.returncode > 0 else 1

    budget_rc = check_startup_budget(combined, platform, enforce=enforce_budget)
    if budget_rc != 0:
        return budget_rc

    print("smoke: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
