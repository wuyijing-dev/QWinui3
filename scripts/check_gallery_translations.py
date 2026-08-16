#!/usr/bin/env python3
"""Validate Gallery translation seed catalogs (1.45).

  python scripts/check_gallery_translations.py

Checks that seed .ts files exist and parse as XML with <TS> root.
Does not require Qt / lupdate. Pair with manual lrelease for .qm demos.
"""

from __future__ import annotations

import sys
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TRANS = ROOT / "src" / "gallery" / "translations"

# Seed catalogs shipped in-tree (keep small — not full Gallery lupdate).
REQUIRED = [
    "qwinui3_gallery_en.ts",
    "qwinui3_gallery_zh_CN.ts",
]


def main() -> int:
    if not TRANS.is_dir():
        print(f"error: missing {TRANS}", file=sys.stderr)
        return 2

    ok = 0
    for name in REQUIRED:
        path = TRANS / name
        if not path.is_file():
            print(f"error: missing seed catalog {path}", file=sys.stderr)
            return 2
        try:
            tree = ET.parse(path)
        except ET.ParseError as exc:
            print(f"error: {path}: {exc}", file=sys.stderr)
            return 2
        root = tree.getroot()
        if root.tag != "TS":
            print(f"error: {path}: root is <{root.tag}>, expected <TS>", file=sys.stderr)
            return 2
        lang = root.attrib.get("language", "")
        contexts = list(root.findall("context"))
        messages = sum(len(c.findall("message")) for c in contexts)
        if messages < 1:
            print(f"error: {path}: no <message> entries", file=sys.stderr)
            return 2
        print(f"ok: {name} language={lang or '(none)'} contexts={len(contexts)} messages={messages}")
        ok += 1

    readme = TRANS / "README.md"
    if not readme.is_file():
        print(f"error: missing {readme}", file=sys.stderr)
        return 2

    print(f"translations: {ok} seed catalogs OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
