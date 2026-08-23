#!/usr/bin/env python3
"""QWinUI3 developer shortcuts — Gallery, doctor, consumer init, run, upgrade (2.74+).

  python scripts/qwinui3.py gallery [--smoke]
  python scripts/qwinui3.py python [--smoke]
  python scripts/qwinui3.py doctor [--fix]
  python scripts/qwinui3.py init --cpp|--python ...
  python scripts/qwinui3.py build gallery|kit
  python scripts/qwinui3.py run [--build-dir DIR]
  python scripts/qwinui3.py upgrade --from X.YY
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from _dev_util import (  # noqa: E402
    BUILD_DIR,
    doctor_report,
    ensure_gallery_binary,
    ensure_python_binding,
    ensure_python_kit,
    gallery_run_env,
    run,
)

SHELLS = {
    "first-app": "templates/consumer/cpp/first-app",
    "blank": "templates/consumer/python/blank",
    "gallery-shell": "examples/gallery-shell",
    "dashboard": "examples/dashboard",
}

PACKAGING = ("subtree", "zip", "cmake-config", "vcpkg", "conan", "pip")


def _cmd_gallery(args: argparse.Namespace) -> int:
    try:
        binary = ensure_gallery_binary(build_dir=args.build_dir, rebuild=args.rebuild)
    except RuntimeError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    env = gallery_run_env(args.build_dir)
    if args.smoke:
        env["QT_QPA_PLATFORM"] = "windows" if sys.platform.startswith("win") else "offscreen"
        env["QWINUI3_KEEP_QPA_PLATFORM"] = "1"
        env["QWINUI3_NO_BANNER"] = "1"
        env["QT_FORCE_STDERR_LOGGING"] = "1"

    cmd = [str(binary), *args.extra]
    if args.smoke and "--smoke" not in args.extra:
        cmd.append("--smoke")
    print(f"Running {binary.name} …", flush=True)
    return run(cmd, cwd=binary.parent, env=env)


def _cmd_python(args: argparse.Namespace) -> int:
    try:
        ensure_python_binding(args.binding)
        if args.kit:
            kit = args.kit.resolve()
            print(f"Using kit: {kit}", flush=True)
        else:
            kit = ensure_python_kit(rebuild=args.rebuild_kit)
            print(f"Using kit: {kit}", flush=True)
    except RuntimeError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    sys.path.insert(0, str(ROOT / "python"))
    from qwinui3_gallery.main import main as gallery_main

    extra = list(args.extra)
    if args.smoke and "--smoke" not in extra:
        extra.append("--smoke")
    if args.binding and not any(a == "--binding" for a in extra):
        extra.extend(["--binding", args.binding])
    if args.kit:
        extra.extend(["--kit", str(args.kit)])
    return gallery_main(extra)


def _cmd_build(args: argparse.Namespace) -> int:
    if args.target == "gallery":
        try:
            binary = ensure_gallery_binary(build_dir=args.build_dir, rebuild=True)
            print(f"Built {binary}")
            return 0
        except RuntimeError as exc:
            print(f"error: {exc}", file=sys.stderr)
            return 1
    if args.target == "kit":
        try:
            kit = ensure_python_kit(rebuild=True)
            print(f"Packaged {kit}")
            return 0
        except RuntimeError as exc:
            print(f"error: {exc}", file=sys.stderr)
            return 1
    print(f"Unknown build target: {args.target}", file=sys.stderr)
    return 2


def _cmd_doctor(args: argparse.Namespace) -> int:
    return doctor_report(
        prefer_binding=args.binding,
        explicit_kit=args.kit,
        report_runtime=args.report,
        fix=args.fix,
    )


def _cmd_init(args: argparse.Namespace) -> int:
    if args.list_shells:
        for name, rel in SHELLS.items():
            print(f"{name:16} {rel}")
        return 0
    if args.list_packaging:
        for p in PACKAGING:
            print(p)
        return 0

    lang = "python" if args.python else "cpp"
    if args.cpp:
        lang = "cpp"
    packaging = args.packaging or ("pip" if lang == "python" else "subtree")
    shell = args.shell or ("blank" if lang == "python" else "first-app")

    if packaging not in PACKAGING:
        print(f"error: unknown packaging {packaging!r}", file=sys.stderr)
        return 2
    if shell not in SHELLS:
        print(f"error: unknown shell {shell!r}", file=sys.stderr)
        return 2

    src = ROOT / SHELLS[shell]
    if lang == "python" and shell != "blank":
        src = ROOT / SHELLS["blank"]
        print(f"note: Python init uses blank template (requested shell={shell})", flush=True)
    if lang == "cpp" and shell == "blank":
        src = ROOT / SHELLS["first-app"]
        print("note: C++ init uses first-app template", flush=True)

    if not src.is_dir():
        print(f"error: template missing: {src}", file=sys.stderr)
        return 1

    out = Path(args.out).resolve()
    if out.exists() and any(out.iterdir()):
        print(f"error: output not empty: {out}", file=sys.stderr)
        return 1
    out.mkdir(parents=True, exist_ok=True)
    for item in src.iterdir():
        dest = out / item.name
        if item.is_dir():
            shutil.copytree(item, dest)
        else:
            shutil.copy2(item, dest)

    readme = out / "README.md"
    extra = (
        f"\n\n## Init metadata\n\n"
        f"- language: `{lang}`\n"
        f"- packaging: `{packaging}`\n"
        f"- shell: `{shell}`\n"
        f"- docs: `docs/getting-started.md`\n"
    )
    if readme.is_file():
        readme.write_text(readme.read_text(encoding="utf-8") + extra, encoding="utf-8")
    else:
        readme.write_text("# Generated app\n" + extra, encoding="utf-8")

    print(f"Created {out}", flush=True)
    print("Next: read README.md · python scripts/qwinui3.py doctor --fix", flush=True)
    return 0



_RUN_EXE_SKIP = (
    "cmake",
    "cpack",
    "ctest",
    "moc",
    "rcc",
    "uic",
    "qmlcachegen",
    "qwinui3_gallery",
    "qwinui3_styleplugin",
    "qwinui3_themeplugin",
    "qwinui3_extrasplugin",
    "qwinui3_platformplugin",
)


def _cmake_app_exe_stems(cmake_lists: Path) -> list[str]:
    """Prefer qt_add_executable / add_executable names from the consumer CMakeLists."""
    if not cmake_lists.is_file():
        return []
    text = cmake_lists.read_text(encoding="utf-8", errors="replace")
    stems: list[str] = []
    for m in re.finditer(
        r"(?:qt_add_executable|add_executable)\s*\(\s*([A-Za-z0-9_.-]+)",
        text,
    ):
        stem = m.group(1)
        if stem.lower() not in {s.lower() for s in stems}:
            stems.append(stem)
    return stems


def _score_run_exe(path: Path, preferred: list[str]) -> tuple[int, float]:
    """Higher score wins; break ties with newer mtime."""
    stem = path.stem.lower()
    name = path.name.lower()
    score = 0
    for i, pref in enumerate(preferred):
        if stem == pref.lower():
            score = 1000 - i
            break
        if pref.lower() in stem:
            score = max(score, 500 - i)
    if "gallery" in stem or "plugin" in stem:
        score -= 200
    if "test" in stem or "smoke" in stem:
        score -= 100
    # Prefer top-level / Release over nested qwinui3 build trees.
    depth = len(path.parts)
    score -= min(depth, 40)
    return score, path.stat().st_mtime


def _find_cwd_exe(build_dir: Path, *, preferred: list[str] | None = None) -> Path | None:
    preferred = preferred or []
    names: list[Path] = []
    if sys.platform.startswith("win"):
        names = list(build_dir.glob("*.exe"))
        release = build_dir / "Release"
        if release.is_dir():
            names += list(release.glob("*.exe"))
        # Multi-config / nested outputs without walking all of CMakeFiles.
        for cand in build_dir.rglob("*.exe"):
            if "CMakeFiles" in cand.parts:
                continue
            names.append(cand)
    elif build_dir.is_dir():
        for cand in build_dir.rglob("*"):
            if (
                cand.is_file()
                and os.access(cand, os.X_OK)
                and not cand.suffix
                and "CMakeFiles" not in cand.parts
            ):
                names.append(cand)
    candidates = [
        p
        for p in names
        if p.is_file() and not any(s in p.name.lower() for s in _RUN_EXE_SKIP)
    ]
    if not candidates:
        return None
    # De-dupe by resolve path
    uniq: dict[Path, Path] = {}
    for p in candidates:
        uniq[p.resolve()] = p
    return max(uniq.values(), key=lambda p: _score_run_exe(p, preferred))


def _cmd_run(args: argparse.Namespace) -> int:
    """Build+run CMake cwd, or run main.py — 2.74 DX5."""
    cwd = Path(args.cwd or Path.cwd()).resolve()
    main_py = cwd / "main.py"
    cmake = cwd / "CMakeLists.txt"

    if main_py.is_file() and (args.prefer_python or not cmake.is_file()):
        print(f"Running Python {main_py.name} …", flush=True)
        return run([sys.executable, str(main_py), *args.extra], cwd=cwd)

    if not cmake.is_file():
        if main_py.is_file():
            return run([sys.executable, str(main_py), *args.extra], cwd=cwd)
        print(
            "error: no CMakeLists.txt or main.py in cwd — cd to a consumer app or pass --cwd",
            file=sys.stderr,
        )
        return 1

    build_dir = (args.build_dir or (cwd / "build")).resolve()
    preferred = _cmake_app_exe_stems(cmake)
    if not (build_dir / "CMakeCache.txt").is_file():
        cfg = [
            "cmake",
            "-S",
            str(cwd),
            "-B",
            str(build_dir),
            "-DCMAKE_BUILD_TYPE=Release",
        ]
        if os.environ.get("CMAKE_PREFIX_PATH"):
            cfg.append(f"-DCMAKE_PREFIX_PATH={os.environ['CMAKE_PREFIX_PATH']}")
        elif os.environ.get("QTDIR"):
            cfg.append(f"-DCMAKE_PREFIX_PATH={os.environ['QTDIR']}")
        rc = run(cfg, cwd=cwd)
        if rc != 0:
            print("error: cmake configure failed", file=sys.stderr)
            return rc

    rc = run(["cmake", "--build", str(build_dir), "--config", "Release"], cwd=cwd)
    if rc != 0:
        print("error: build failed", file=sys.stderr)
        return rc

    exe = _find_cwd_exe(build_dir, preferred=preferred)
    if exe is None:
        print("error: no executable found after Release build", file=sys.stderr)
        if preferred:
            print(f"hint: looked for CMake targets {preferred}", file=sys.stderr)
        return 1

    env = os.environ.copy()
    env.setdefault("QT_QUICK_CONTROLS_STYLE", "QWinUI3")
    print(f"Running {exe} …", flush=True)
    return run([str(exe), *args.extra], cwd=exe.parent, env=env)


def _parse_version(token: str) -> tuple[int, int] | None:
    m = re.fullmatch(r"(\d+)\.(\d{2})", token.strip())
    if not m:
        return None
    return int(m.group(1)), int(m.group(2))


def _cmd_upgrade(args: argparse.Namespace) -> int:
    """Print upgrade checklist headings from docs/upgrade-notes.md (2.76)."""
    notes = ROOT / "docs" / "upgrade-notes.md"
    if not notes.is_file():
        print(f"error: missing {notes}", file=sys.stderr)
        return 1
    from_ver = _parse_version(args.from_ver)
    if from_ver is None:
        print("error: --from must be X.YY (e.g. 2.73)", file=sys.stderr)
        return 2

    text = notes.read_text(encoding="utf-8")
    heading_re = re.compile(
        r"^(#{2,3})\s+Upgrade\s+(\d+\.\d{2})\s*(?:→|->)\s*(\d+\.\d{2})\s*$",
        re.MULTILINE,
    )
    matches = list(heading_re.finditer(text))
    if not matches:
        loose = re.compile(r"^(#{2,3})\s+.*Upgrade.*(\d+\.\d{2}).*$", re.MULTILINE)
        print(f"Upgrade checklist from {args.from_ver} (headings mentioning Upgrade):\n", flush=True)
        printed = 0
        for m in loose.finditer(text):
            line = m.group(0).lstrip("#").strip()
            vers = re.findall(r"\d+\.\d{2}", line)
            if not vers:
                continue
            last = _parse_version(vers[-1])
            if last and last > from_ver:
                print(f"- {line}")
                printed += 1
        if printed == 0:
            print("(no matching headings — see docs/upgrade-notes.md)")
        return 0

    print(f"Upgrade checklist from {args.from_ver}:\n", flush=True)
    printed = 0
    for m in matches:
        dst = _parse_version(m.group(3))
        if dst is None:
            continue
        if dst > from_ver:
            print(f"- Upgrade {m.group(2)} → {m.group(3)}")
            printed += 1
    if printed == 0:
        print("(no upgrade rows after that version — already current or see docs/upgrade-notes.md)")
    else:
        print(f"\nFull notes: {notes}")
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="QWinUI3 — Gallery, doctor, consumer init, run, upgrade",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    sub = parser.add_subparsers(dest="command", required=True)

    p_gallery = sub.add_parser("gallery", help="Run C++ Gallery (auto-build Release)")
    p_gallery.add_argument("--smoke", action="store_true", help="Run --smoke and exit")
    p_gallery.add_argument("--rebuild", action="store_true", help="Force rebuild before run")
    p_gallery.add_argument("--build-dir", type=Path, default=BUILD_DIR)
    p_gallery.add_argument("extra", nargs=argparse.REMAINDER, help="Args passed to qwinui3_gallery")
    p_gallery.set_defaults(func=_cmd_gallery)

    p_py = sub.add_parser("python", help="Run Python Gallery (auto kit from dist/)")
    p_py.add_argument("--smoke", action="store_true")
    p_py.add_argument("--rebuild-kit", action="store_true", help="Repackage shared kit")
    p_py.add_argument("--binding", choices=("pyside6", "pyqt6"), default=None)
    p_py.add_argument("--kit", type=Path, default=None, help="Shared kit root (skip auto-packaging)")
    p_py.add_argument("extra", nargs=argparse.REMAINDER)
    p_py.set_defaults(func=_cmd_python)

    p_build = sub.add_parser("build", help="Build Gallery binary or Python shared kit")
    p_build.add_argument("target", choices=("gallery", "kit"))
    p_build.add_argument("--build-dir", type=Path, default=BUILD_DIR)
    p_build.set_defaults(func=_cmd_build)

    p_doc = sub.add_parser("doctor", help="Check Qt, kit, and Python bindings")
    p_doc.add_argument("--binding", choices=("pyside6", "pyqt6"), default=None)
    p_doc.add_argument("--kit", type=Path, default=None, help="Shared kit root for runtime report")
    p_doc.add_argument("--report", action="store_true", help="Also print Python runtime_report() details")
    p_doc.add_argument("--fix", action="store_true", help="Print actionable fix lines (2.73)")
    p_doc.set_defaults(func=_cmd_doctor)

    p_init = sub.add_parser("init", help="Scaffold a consumer app (2.73)")
    p_init.add_argument("--cpp", action="store_true", help="C++ project")
    p_init.add_argument("--python", action="store_true", help="Python project")
    p_init.add_argument("--packaging", choices=PACKAGING, default=None)
    p_init.add_argument("--shell", choices=sorted(SHELLS.keys()), default=None)
    p_init.add_argument("--out", type=Path, default=Path("my-qwinui3-app"))
    p_init.add_argument("--list-shells", action="store_true")
    p_init.add_argument("--list-packaging", action="store_true")
    p_init.set_defaults(func=_cmd_init)

    p_run = sub.add_parser("run", help="Build Release + run cwd CMake app, or run main.py (2.74)")
    p_run.add_argument("--cwd", type=Path, default=None, help="App directory (default: cwd)")
    p_run.add_argument("--build-dir", type=Path, default=None, help="CMake build dir (default: cwd/build)")
    p_run.add_argument("--prefer-python", action="store_true", help="Prefer main.py when both exist")
    p_run.add_argument("extra", nargs=argparse.REMAINDER, help="Args passed to the app")
    p_run.set_defaults(func=_cmd_run)

    p_up = sub.add_parser("upgrade", help="Print upgrade checklist from docs/upgrade-notes.md (2.76)")
    p_up.add_argument("--from", dest="from_ver", required=True, help="Starting version X.YY")
    p_up.set_defaults(func=_cmd_upgrade)

    args = parser.parse_args(argv)
    if getattr(args, "extra", None) and args.extra and args.extra[0] == "--":
        args.extra = args.extra[1:]
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
