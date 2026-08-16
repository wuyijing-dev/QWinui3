#!/usr/bin/env python3
"""Generate FluentIconsFontMap.inc from WinSymbols3.ttf PUA codepoints."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TTF = ROOT / "src/theme/QWinUI3/Theme/fonts/WinSymbols3.ttf"
OUT = ROOT / "src/theme/QWinUI3/Theme/FluentIconsFontMap.inc"


def main() -> int:
    from fontTools.ttLib import TTFont

    font = TTFont(str(TTF))
    cmap = font.getBestCmap() or {}
    pua = sorted(cp for cp in cmap if 0xE000 <= cp <= 0xF8FF)
    lines = [
        "// Auto-generated from WinSymbols3.ttf — do not edit by hand.",
        "// Regenerate: python scripts/generate_fluent_icons_font_map.py",
        f"static constexpr int kFluentIconCodepointCount = {len(pua)};",
        "static constexpr quint16 kFluentIconCodepoints[] = {",
    ]
    row: list[str] = []
    for cp in pua:
        row.append(f"0x{cp:04X}")
        if len(row) == 12:
            lines.append("    " + ", ".join(row) + ",")
            row = []
    if row:
        lines.append("    " + ", ".join(row))
    lines.append("};")
    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {OUT.relative_to(ROOT)} ({len(pua)} codepoints)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
