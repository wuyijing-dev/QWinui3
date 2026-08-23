"""Shared helpers for scripts/qwinui3.py."""

from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUILD_DIR = ROOT / "build"
SHARED_BUILD_DIR = ROOT / "build-shared-release"


def find_gallery(build_dir: Path | None = None) -> Path | None:
    build_dir = (build_dir or BUILD_DIR).resolve()
    if not build_dir.is_dir():
        return None
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
    found = list(build_dir.rglob("qwinui3_gallery.exe")) + list(
        build_dir.rglob("qwinui3_gallery")
    )
    found = [p for p in found if p.is_file()]
    return max(found, key=lambda p: p.stat().st_mtime) if found else None


def cmake_configured(build_dir: Path | None = None) -> bool:
    build_dir = build_dir or BUILD_DIR
    return (build_dir / "CMakeCache.txt").is_file()


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


def gallery_run_env(build_dir: Path | None = None) -> dict[str, str]:
    build_dir = (build_dir or BUILD_DIR).resolve()
    env = os.environ.copy()
    if sys.platform.startswith("win"):
        inherited = env.get("QT_QPA_PLATFORM", "").strip()
        if inherited and inherited not in ("windows", "direct2d"):
            env["QT_QPA_PLATFORM"] = "windows"
        elif not inherited:
            env.setdefault("QT_QPA_PLATFORM", "windows")
        prefix = qt_prefix_from_cache(build_dir)
        if prefix is not None:
            qt_bin = prefix / "bin"
            if qt_bin.is_dir():
                env["PATH"] = str(qt_bin) + os.pathsep + env.get("PATH", "")
                env["QTDIR"] = str(prefix)
            qt_plugins = prefix / "plugins"
            if qt_plugins.is_dir():
                env["QT_PLUGIN_PATH"] = str(qt_plugins)
    else:
        env.setdefault("QT_QPA_PLATFORM", "offscreen")
    env.setdefault("QT_QUICK_CONTROLS_STYLE", "QWinUI3")
    return env


def run(cmd: list[str], *, cwd: Path | None = None, env: dict[str, str] | None = None) -> int:
    print("+", " ".join(cmd), flush=True)
    return subprocess.call(cmd, cwd=str(cwd or ROOT), env=env or os.environ.copy())


def ensure_gallery_binary(*, build_dir: Path | None = None, rebuild: bool = False) -> Path:
    build_dir = (build_dir or BUILD_DIR).resolve()
    binary = find_gallery(build_dir)
    if binary is not None and not rebuild:
        return binary

    if not cmake_configured(build_dir):
        rc = run(["cmake", "--preset", "release"])
        if rc != 0:
            raise RuntimeError(
                "CMake configure failed. Set Qt in CMakeUserPresets.json "
                "(copy CMakeUserPresets.json.example) or CMAKE_PREFIX_PATH / QTDIR."
            )

    rc = run(
        [
            "cmake",
            "--build",
            str(build_dir),
            "--config",
            "Release",
            "--target",
            "qwinui3_gallery",
        ]
    )
    if rc != 0:
        raise RuntimeError("Gallery build failed.")

    binary = find_gallery(build_dir)
    if binary is None:
        raise RuntimeError(f"Gallery binary not found under {build_dir}")
    return binary


def _kit_in_dist() -> Path | None:
    dist = ROOT / "dist"
    if not dist.is_dir():
        return None
    for candidate in sorted(dist.glob("qwinui3-*-shared"), reverse=True):
        qml = candidate / "qml" / "QWinUI3"
        if qml.is_dir():
            return candidate.resolve()
    return None


def ensure_python_kit(*, rebuild: bool = False) -> Path:
    if not rebuild:
        kit = _kit_in_dist()
        if kit is not None:
            return kit

    package = ROOT / "scripts" / "package_release_libs.py"
    shared_ready = SHARED_BUILD_DIR.is_dir() and (
        any(SHARED_BUILD_DIR.glob("qwinui3_*.dll"))
        or any(SHARED_BUILD_DIR.glob("libqwinui3_*.so*"))
    )

    if not rebuild and shared_ready:
        print("Packaging shared kit from build-shared-release (no rebuild)...", flush=True)
        rc = run(
            [
                sys.executable,
                str(package),
                "--shared",
                "--archive",
                "--no-build",
                "--build-dir",
                str(SHARED_BUILD_DIR),
            ]
        )
    else:
        print("Building + packaging shared kit (one-time; needs Qt + compiler)...", flush=True)
        rc = run([sys.executable, str(package), "--shared", "--archive"])

    if rc != 0:
        raise RuntimeError(
            "Shared kit packaging failed. Ensure Qt is on CMAKE_PREFIX_PATH / QTDIR "
            "and MSVC (Windows) or Ninja+GCC (Linux) is available."
        )

    kit = _kit_in_dist()
    if kit is None:
        raise RuntimeError("Shared kit not found under dist/ after packaging.")
    return kit


def ensure_python_binding(prefer: str | None = None) -> str:
    sys.path.insert(0, str(ROOT / "python"))
    try:
        from qwinui3 import _qt

        return _qt.init(prefer)
    except ImportError as exc:
        raise RuntimeError(
            "PySide6 or PyQt6 required.\n"
            "  pip install PySide6\n"
            "  # or: pip install PyQt6"
        ) from exc


def doctor_report(
    *,
    prefer_binding: str | None = None,
    explicit_kit: str | Path | None = None,
    report_runtime: bool = False,
    fix: bool = False,
) -> int:
    print("QWinUI3 environment check\n")
    issues = 0
    fixes: list[str] = []

    # Qt for C++
    build_dir = BUILD_DIR
    if cmake_configured(build_dir):
        prefix = qt_prefix_from_cache(build_dir)
        print(f"  CMake build:     {build_dir} (configured)")
        print(f"  Qt prefix:       {prefix or '(not in cache — set CMAKE_PREFIX_PATH)'}")
        if prefix is None:
            issues += 1
            fixes.append(
                "Set CMAKE_PREFIX_PATH to your Qt kit (copy CMakeUserPresets.json.example → CMakeUserPresets.json)."
            )
    else:
        print(f"  CMake build:     {build_dir} (not configured — run: python scripts/qwinui3.py gallery)")
        issues += 1
        fixes.append("Configure Release: cmake --preset release  (or python scripts/qwinui3.py gallery)")

    binary = find_gallery(build_dir)
    print(f"  C++ Gallery:     {binary or 'not built'}")
    if binary is None:
        issues += 1
        fixes.append("Build Gallery: python scripts/qwinui3.py build gallery")

    discovered_kit = Path(explicit_kit).resolve() if explicit_kit is not None else _kit_in_dist()
    if discovered_kit is None:
        try:
            from qwinui3._paths import bundled_kit_dir

            discovered_kit = bundled_kit_dir()
        except ImportError:
            discovered_kit = None
    print(f"  Python kit:      {discovered_kit or 'not packaged (run: python scripts/qwinui3.py python)'}")

    sys.path.insert(0, str(ROOT / "python"))
    try:
        from qwinui3 import _qt, configure_environment, qt_version, runtime_report, validate_runtime

        binding = _qt.init(prefer_binding)
        print(f"  Python binding:  {binding} (Qt {qt_version()})")
        if discovered_kit is not None:
            print("  Tip: kit Qt major.minor should match binding Qt (see qVersion above).")
        if report_runtime:
            resolved_kit = configure_environment(kit=explicit_kit or discovered_kit, binding=prefer_binding)
            validate_runtime(resolved_kit)
            report = runtime_report(resolved_kit)
            print("\n  Python runtime report:")
            for key in ("binding", "qt_version", "kit", "qml_root", "has_qml_root", "style", "qpa_platform"):
                print(f"    {key}: {report.get(key, '')}")
    except ImportError:
        print("  Python binding:  not installed (pip install PySide6)")
        issues += 1
        fixes.append("pip install PySide6   # or: pip install PyQt6")
    except FileNotFoundError as exc:
        print(f"  Python runtime:  invalid ({exc})")
        issues += 1
        fixes.append("python scripts/qwinui3.py python   # package shared kit under dist/")

    print("\nQuick run:")
    print("  python scripts/qwinui3.py gallery    # C++ Gallery")
    print("  python scripts/qwinui3.py python     # Python Gallery")
    print("  python scripts/qwinui3.py init --help")
    if fix:
        print("\nFix (actionable):")
        if not fixes:
            print("  (no issues detected)")
        for line in fixes:
            print(f"  → {line}")
    return 1 if issues else 0
