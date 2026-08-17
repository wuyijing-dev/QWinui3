#!/usr/bin/env python3
"""Sparse-clone / refresh SIL Keyman Core into third_party/keyman.

The tree is normally vendored in git. This script is for maintainers refreshing
upstream, or for CMake fallback when the vendored tree is missing.
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / "third_party" / "keyman"
REPO = "https://github.com/keymanapp/keyman.git"


def main() -> int:
    DEST.parent.mkdir(parents=True, exist_ok=True)
    if (DEST / "core" / "src" / "km_core_keyboard_api.cpp").exists():
        print(f"Keyman Core already at {DEST}")
        return 0
    if DEST.exists():
        subprocess.check_call(["git", "-C", str(DEST), "sparse-checkout", "set", "--no-cone",
                               "core", "common/cpp", "common/include", "VERSION.md"])
        subprocess.check_call(["git", "-C", str(DEST), "checkout", "HEAD", "--",
                               "common/cpp", "common/include", "VERSION.md", "core"])
        return 0
    subprocess.check_call(["git", "clone", "--depth", "1", "--filter=blob:none", "--sparse",
                           REPO, str(DEST)])
    subprocess.check_call(["git", "-C", str(DEST), "sparse-checkout", "set", "--no-cone",
                           "core", "common/cpp", "common/include", "VERSION.md"])
    subprocess.check_call(["git", "-C", str(DEST), "checkout", "HEAD", "--",
                           "common/cpp", "common/include", "VERSION.md", "core"])
    print(f"Keyman Core ready at {DEST}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
