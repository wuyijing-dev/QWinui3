#!/usr/bin/env python3
"""QWinUI3 developer shortcuts — one entry for C++ and Python Gallery.

  python scripts/qwinui3.py gallery           # build C++ Gallery if needed, then run
  python scripts/qwinui3.py gallery --smoke   # CI-style smoke
  python scripts/qwinui3.py python            # package Python kit if needed, then run
  python scripts/qwinui3.py python --smoke
  python scripts/qwinui3.py doctor            # check Qt / kit / bindings

Root launchers (Windows): gallery.cmd · python-gallery.cmd
"""

from __future__ import annotations

import argparse
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


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="QWinUI3 — build and run Gallery (C++ or Python)",
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
    p_doc.set_defaults(
        func=lambda a: doctor_report(
            prefer_binding=a.binding,
            explicit_kit=a.kit,
            report_runtime=a.report,
        )
    )

    args = parser.parse_args(argv)
    if getattr(args, "extra", None) and args.extra and args.extra[0] == "--":
        args.extra = args.extra[1:]
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
