#!/usr/bin/env python3
"""One-shot: compact MIT pinyin tables for the in-app IME (not a build step).

  python scripts/gen_pinyin_lexicon.py <pinyin.txt> [phrase-pinyin.txt]

Sources (MIT):
  https://github.com/mozillazg/pinyin-data
  https://github.com/mozillazg/phrase-pinyin-data
"""
from __future__ import annotations

import re
import sys
import unicodedata
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_CHARS = ROOT / "src" / "extras" / "QWinUI3" / "Extras" / "keyboards" / "pinyin_lexicon.tsv"
OUT_WORDS = ROOT / "src" / "extras" / "QWinUI3" / "Extras" / "keyboards" / "pinyin_words.tsv"

COMMON = (
    "的一是不了在人有我他这个们中来上大为和国地到以说时要就出会可也你对生"
    "能而子那得于着下自之年过发后作里用道行所然家种事成方多经么去法学如"
    "都同现当没动面起看定天分还进好小部其些主样理心她本前开但因只从想实"
    "日军民很站正把化老已机位分明工物什无级头知世名同己正长太桥车"
)

TONE = str.maketrans(
    "āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜüńňǹ",
    "aaaaeeeeiiiioooouuuuvvvvvnnn",
)


def strip_tone(s: str) -> str:
    s = unicodedata.normalize("NFD", s.translate(TONE))
    s = "".join(ch for ch in s if unicodedata.category(ch) != "Mn")
    return s.replace("ü", "v").replace("u:", "v").lower()


def romanize(reading: str) -> str:
    parts = []
    for token in reading.replace("'", " ").split():
        py = re.sub(r"[^a-z]", "", strip_tone(token.strip()))
        if py:
            parts.append(py)
    return "".join(parts)


def write_chars(src: Path) -> int:
    rank: dict[str, int] = {}
    for i, ch in enumerate(COMMON):
        rank.setdefault(ch, i)
    buckets: dict[str, list[str]] = defaultdict(list)
    line_re = re.compile(r"^U\+([0-9A-Fa-f]+):\s*([^#]+)")
    for raw in src.read_text(encoding="utf-8").splitlines():
        m = line_re.match(raw)
        if not m:
            continue
        cp = int(m.group(1), 16)
        if not (0x4E00 <= cp <= 0x9FFF):
            continue
        ch = chr(cp)
        for reading in m.group(2).split(","):
            py = romanize(reading)
            if not py:
                continue
            buckets[py].append(ch)

    lines = ["# Compact pinyin → hanzi. Generated from mozillazg/pinyin-data (MIT)."]
    for py in sorted(buckets):
        seen: set[str] = set()
        uniq: list[str] = []
        for ch in buckets[py]:
            if ch in seen:
                continue
            seen.add(ch)
            uniq.append(ch)
        uniq.sort(key=lambda c: (rank.get(c, 10_000), ord(c)))
        lines.append(f"{py}\t{''.join(uniq[:12])}")
    OUT_CHARS.parent.mkdir(parents=True, exist_ok=True)
    OUT_CHARS.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return len(lines) - 1


def write_words(src: Path) -> int:
    buckets: dict[str, list[str]] = defaultdict(list)
    for raw in src.read_text(encoding="utf-8").splitlines():
        if not raw or raw.startswith("#") or ":" not in raw:
            continue
        phrase, reading = raw.split(":", 1)
        phrase = phrase.strip()
        if not (2 <= len(phrase) <= 4):
            continue
        if any(ord(c) < 0x4E00 or ord(c) > 0x9FFF for c in phrase):
            continue
        py = romanize(reading.split("#", 1)[0])
        if len(py) < 2:
            continue
        if phrase not in buckets[py]:
            buckets[py].append(phrase)

    lines = ["# Compact pinyin → words. Generated from mozillazg/phrase-pinyin-data (MIT)."]
    for py in sorted(buckets):
        lines.append(f"{py}\t{','.join(buckets[py][:6])}")
    OUT_WORDS.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return len(lines) - 1


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: gen_pinyin_lexicon.py <pinyin.txt> [phrase-pinyin.txt]", file=sys.stderr)
        return 2
    n = write_chars(Path(sys.argv[1]))
    print(f"wrote {OUT_CHARS} ({n} syllables)")
    if len(sys.argv) >= 3:
        w = write_words(Path(sys.argv[2]))
        print(f"wrote {OUT_WORDS} ({w} romanizations)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
