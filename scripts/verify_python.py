#!/usr/bin/env python3
"""Verify QWinUI3 Python path — delegates to scripts/qwinui3.py.

  python scripts/verify_python.py          # same as qwinui3.py doctor
  python scripts/verify_python.py --smoke  # same as qwinui3.py python --smoke
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify QWinUI3 Python consumer path")
    parser.add_argument("--kit", default=None)
    parser.add_argument("--binding", choices=("pyside6", "pyqt6"), default=None)
    parser.add_argument("--smoke", action="store_true")
    parser.add_argument("--run-qml", action="store_true", help="Alias for --smoke")
    args = parser.parse_args()

    cmd = [sys.executable, str(ROOT / "scripts" / "qwinui3.py")]
    if args.smoke or args.run_qml:
        cmd.append("python")
        cmd.append("--smoke")
        if args.binding:
            cmd.extend(["--binding", args.binding])
        if args.kit:
            cmd.extend(["--kit", args.kit])
    else:
        cmd.append("doctor")
    return subprocess.call(cmd, cwd=str(ROOT))


if __name__ == "__main__":
    raise SystemExit(main())
