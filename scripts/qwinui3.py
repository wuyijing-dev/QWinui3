#!/usr/bin/env python3
"""QWinUI3 developer shortcuts — Gallery, doctor, consumer init (2.73+).

  python scripts/qwinui3.py gallery [--smoke]
  python scripts/qwinui3.py python [--smoke]
  python scripts/qwinui3.py doctor [--fix]
  python scripts/qwinui3.py init --cpp|--python ...
  python scripts/qwinui3.py build gallery|kit
"""

from __future__ import annotations

import argparse
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


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="QWinUI3 — Gallery, doctor, and consumer init",
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

    args = parser.parse_args(argv)
    if getattr(args, "extra", None) and args.extra and args.extra[0] == "--":
        args.extra = args.extra[1:]
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
