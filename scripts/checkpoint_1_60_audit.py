#!/usr/bin/env python3
"""Compatibility entry for 1.60 mid-horizon checkpoint audit — delegates to check_docs_links.py."""

from __future__ import annotations

import runpy
import sys
from pathlib import Path

if __name__ == "__main__":
    target = Path(__file__).resolve().parent / "check_docs_links.py"
    sys.argv[0] = str(target)
    runpy.run_path(str(target), run_name="__main__")
