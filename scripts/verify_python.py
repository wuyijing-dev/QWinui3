#!/usr/bin/env python3
"""Verify QWinUI3 Python bindings (import, optional Gallery smoke).

  python scripts/verify_python.py
  python scripts/verify_python.py --smoke
  python scripts/verify_python.py --binding pyside6
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify QWinUI3 Python consumer path")
    parser.add_argument("--kit", default=None)
    parser.add_argument("--binding", choices=("pyside6", "pyqt6"), default=None)
    parser.add_argument("--smoke", action="store_true", help="Load Gallery Main + critical pages")
    parser.add_argument("--run-qml", action="store_true", help="Alias for --smoke")
    args = parser.parse_args()

    from qwinui3 import binding_name, configure_environment, qt_version

    try:
        kit = configure_environment(kit=args.kit, binding=args.binding)
    except FileNotFoundError as exc:
        print(exc, file=sys.stderr)
        return 1
    print(f"qwinui3 python: binding={binding_name()} Qt={qt_version()} kit={kit}", flush=True)

    if args.smoke or args.run_qml:
        from qwinui3_gallery.main import main as gallery_main

        extra = ["--smoke"]
        if args.kit:
            extra.extend(["--kit", args.kit])
        if args.binding:
            extra.extend(["--binding", args.binding])
        return gallery_main(extra)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
