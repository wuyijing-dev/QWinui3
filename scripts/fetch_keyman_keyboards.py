#!/usr/bin/env python3
"""Download a named MIT Keyman .kmx subset into Extras/keyboards (not every keyboard).

  python scripts/fetch_keyman_keyboards.py

Uses https://downloads.keyman.com/keyboards/{id}/{version}/{id}.kmp and extracts .kmx.
Versions come from https://api.keyman.com/keyboard/{id}.
"""
from __future__ import annotations

import io
import json
import sys
import urllib.request
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / "src" / "extras" / "QWinUI3" / "Extras" / "keyboards"

# Named shipped subset (1.71 + 1.75). Do not expand to “every” community keyboard here.
PACKS = (
    "basic_kbdus",
    "basic_kbduk",
    "basic_kbdgr",
    "basic_kbdfr",
    "basic_kbdes",
    "basic_kbdit",
    "basic_kbdpo",
    "basic_kbdpl",
    "basic_kbdsw",
    "basic_kbdtuq",
    "basic_kbdru",
    "basic_kbda1",
)


def fetch_json(url: str) -> dict:
    with urllib.request.urlopen(url, timeout=60) as r:
        return json.loads(r.read().decode("utf-8"))


def fetch_bytes(url: str) -> bytes:
    with urllib.request.urlopen(url, timeout=120) as r:
        return r.read()


def main() -> int:
    DEST.mkdir(parents=True, exist_ok=True)
    for kid in PACKS:
        meta = fetch_json(f"https://api.keyman.com/keyboard/{kid}")
        ver = meta["version"]
        url = f"https://downloads.keyman.com/keyboards/{kid}/{ver}/{kid}.kmp"
        print(f"fetch {url}")
        blob = fetch_bytes(url)
        with zipfile.ZipFile(io.BytesIO(blob)) as zf:
            names = [n for n in zf.namelist() if n.lower().endswith(".kmx")]
            if not names:
                print(f"error: no .kmx in {kid}.kmp", file=sys.stderr)
                return 1
            data = zf.read(names[0])
        out = DEST / f"{kid}.kmx"
        out.write_bytes(data)
        print(f"  wrote {out.relative_to(ROOT)} ({len(data)} bytes)")
    print("done")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
