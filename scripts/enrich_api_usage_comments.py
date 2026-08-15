#!/usr/bin/env python3
"""Append signal/method API usage lines to QML file headers.

Keeps existing property examples; adds an explicit API block so docs are not
property-only.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from generate_component_docs import (  # noqa: E402
    SCAN_DIRS,
    extract_api,
    parse_header_comments,
    RE_HEADER_BLOCK,
)


def detect_base(text: str) -> str:
    m = re.search(
        r"(?m)^(?:pragma[^\n]*\n|import[^\n]*\n|\s*\n|//[^\n]*\n)*"
        r"(?:T\.)?(\w+)\s*\{",
        text,
    )
    return m.group(1) if m else ""


def oid_for(name: str) -> str:
    return name[0].lower() + name[1:] if name else "control"


def main() -> None:
    changed = 0
    for d in SCAN_DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            text = path.read_text(encoding="utf-8")
            name = path.stem
            summary, usage, _ = parse_header_comments(text, name)
            if not summary:
                continue
            _props, signals, funcs = extract_api(text)
            base = detect_base(text)
            # Also annotate inherits-only controls (e.g. AccentButton → Button)
            if not signals and not funcs and base in (
                "Button",
                "AbstractButton",
                "Dialog",
                "Popup",
                "CheckBox",
                "ComboBox",
                "TextField",
                "Switch",
                "RadioButton",
            ):
                pass  # still append inherits API note
            elif not signals and not funcs:
                continue
            if "--- API ---" in usage:
                continue

            oid = oid_for(name)
            base = detect_base(text)
            api_lines = ["//", "//   // --- API ---"]
            if signals:
                handlers = []
                for sig, _ in signals[:8]:
                    n = sig.split("(", 1)[0]
                    handlers.append(f"on{n[0].upper()}{n[1:]}")
                api_lines.append("//   // signals: " + ", ".join(handlers))
            if funcs:
                api_lines.append(
                    "//   // methods: " + ", ".join(s for s, _ in funcs[:10])
                )
                shown = 0
                for sig, _ in funcs:
                    n = sig.split("(", 1)[0]
                    if n.startswith("_"):
                        continue
                    api_lines.append(f"//   // {oid}.{sig}")
                    shown += 1
                    if shown >= 4:
                        break
            if base and base not in (name, "Item", "Control", "QtObject", "Rectangle"):
                api_lines.append(
                    f"//   // inherits {base} (+ Qt Quick Controls base API)"
                )

            m = RE_HEADER_BLOCK.match(text)
            if not m:
                continue
            header = m.group("header").rstrip("\n")
            # Ensure usage object has id if we show method calls
            if funcs and f"id: {oid}" not in usage and f"id:" not in usage:
                # try inject into header's first "Name {" block
                def inject_id(h: str) -> str:
                    pat = re.compile(
                        rf"(//\s+{re.escape(name)}\s*\{{)\n",
                    )
                    if pat.search(h):
                        return pat.sub(rf"\1\n//       id: {oid}\n", h, count=1)
                    # single-line: Name { ... }
                    pat2 = re.compile(
                        rf"(//\s+{re.escape(name)}\s*\{{)(\s*)([^}}]*)(\}})"
                    )

                    def repl(mm: re.Match) -> str:
                        inner = mm.group(3).strip()
                        if "id:" in inner:
                            return mm.group(0)
                        # expand single-line into multi-line with id
                        props = [p.strip() for p in inner.split(";") if p.strip()]
                        lines = [f"{mm.group(1)}", f"//       id: {oid}"]
                        for p in props:
                            lines.append(f"//       {p}")
                        lines.append("//   }")
                        return "\n".join(lines)

                    return pat2.sub(repl, h, count=1)

                header = inject_id(header)

            new_header = header + "\n" + "\n".join(api_lines) + "\n"
            new_text = text[: m.start("header")] + new_header + text[m.end("header") :]
            if new_text == text:
                continue
            path.write_text(new_text, encoding="utf-8", newline="\n")
            changed += 1
            print(f"API {path.relative_to(ROOT)}")
    print(f"Appended API usage to {changed} QML headers")


if __name__ == "__main__":
    main()
