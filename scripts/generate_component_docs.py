#!/usr/bin/env python3
"""Generate QWinUI3 component docs by regex-parsing QML source comments.

Source of truth = comments in each .qml file. This script does not invent API text.

Output layout (one markdown file per component):

  docs/components.md              # index
  docs/components/AccentButton.md
  docs/components/NavigationView.md
  …

Comment convention (after imports / pragma):

  // Name — one-line summary.
  //
  //   Name {
  //       prop: value
  //   }

Optional tagged form (also recognized):

  // @brief one-line summary
  // @usage
  //   Name { … }

Also extracts top-level `property` / `signal` / `function` via regex for a short API list.

Usage:
  python scripts/generate_component_docs.py
  python scripts/generate_component_docs.py --lint
  python scripts/generate_component_docs.py -o docs/components.md --outdir docs/components
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

SCAN_DIRS = [
    ROOT / "src" / "extras" / "QWinUI3" / "Extras",
    ROOT / "src" / "style" / "QWinUI3",
    ROOT / "src" / "platform" / "QWinUI3" / "Platform",
    ROOT / "src" / "theme" / "QWinUI3" / "Theme",
]

# Listed under "Internal" in the generated doc (still parsed).
INTERNAL_NAMES = {
    "ShellWindowSupport.qml",
    "WindowChrome.qml",
    "CaptionButton.qml",
    "WindowResizeBorder.qml",
    "ElevatedChrome.qml",
    "IconSource.qml",
    "FocusStroke.qml",
    "SelectionPip.qml",
    "ChartUtils.qml",
}

# --- regexes -----------------------------------------------------------------

RE_HEADER_BLOCK = re.compile(
    r"(?m)^(?:pragma[^\n]*\n|import[^\n]*\n|\s*\n)*"  # preamble
    r"(?P<header>(?://[^\n]*\n)+)",
)

RE_BRIEF_TAG = re.compile(r"(?m)^//\s*@brief\s+(?P<brief>.+)\s*$")
RE_USAGE_TAG = re.compile(r"(?m)^//\s*@usage\s*$")
RE_SUMMARY_EM = re.compile(
    r"(?m)^//\s*(?P<name>[\w.]+)\s*[—–\-:]\s*(?P<summary>.+)\s*$"
)
RE_COMMENT_LINE = re.compile(r"(?m)^//(?P<body>.*)$")

RE_PROPERTY = re.compile(
    r"(?m)^\s*(?:readonly\s+|default\s+|required\s+)*property\s+"
    r"(?:alias\s+)?(?P<type>[\w.<>,\s]+?)\s+(?P<name>\w+)\s*(?::|$)"
)
RE_SIGNAL = re.compile(r"(?m)^\s*signal\s+(?P<name>\w+)\s*(?P<args>\([^)]*\))?")
RE_FUNCTION = re.compile(r"(?m)^\s*function\s+(?P<name>\w+)\s*(?P<args>\([^)]*\))")
RE_PROP_DOC = re.compile(
    r"(?m)^\s*//\s*(?P<doc>.+)\n\s*(?:readonly\s+|default\s+|required\s+)*property\s+"
    r"(?:alias\s+)?[\w.<>,\s]+?\s+(?P<name>\w+)"
)
RE_SIG_DOC = re.compile(
    r"(?m)^\s*//\s*(?P<doc>.+)\n\s*signal\s+(?P<name>\w+)"
)
RE_FUNC_DOC = re.compile(
    r"(?m)^\s*//\s*(?P<doc>.+)\n\s*function\s+(?P<name>\w+)"
)


@dataclass
class Component:
    name: str
    path: Path
    module: str
    summary: str = ""
    usage: str = ""
    properties: list[tuple[str, str, str]] = field(default_factory=list)  # name, type, doc
    signals: list[tuple[str, str]] = field(default_factory=list)  # sig, doc
    functions: list[tuple[str, str]] = field(default_factory=list)  # sig, doc
    internal: bool = False
    lint_errors: list[str] = field(default_factory=list)

    @property
    def doc_filename(self) -> str:
        return f"{self.name}.md"


def module_for(path: Path) -> str:
    parts = path.as_posix()
    if "/Extras/" in parts:
        return "QWinUI3.Extras"
    if "/Platform/" in parts:
        return "QWinUI3.Platform"
    if "/Theme/" in parts:
        return "QWinUI3.Theme"
    if "/style/" in parts:
        return "QtQuick.Controls.QWinUI3"
    return "QWinUI3"


def _unindent_usage(lines: list[str]) -> str:
    bodies = []
    for line in lines:
        if line.startswith("   "):
            bodies.append(line[3:])
        elif line.startswith(" "):
            bodies.append(line.lstrip())
        else:
            bodies.append(line)
    while bodies and not bodies[0].strip():
        bodies.pop(0)
    while bodies and not bodies[-1].strip():
        bodies.pop()
    return "\n".join(bodies).rstrip()


def parse_header_comments(text: str, name: str) -> tuple[str, str, list[str]]:
    """Return (summary, usage, lint_errors) from the leading // block after imports."""
    errors: list[str] = []
    m = RE_HEADER_BLOCK.match(text)
    if not m:
        return "", "", [f"{name}: missing leading // doc comment after imports"]

    header = m.group("header")
    comment_lines = RE_COMMENT_LINE.findall(header)

    brief_m = RE_BRIEF_TAG.search(header)
    if brief_m:
        summary = brief_m.group("brief").strip()
        usage_lines: list[str] = []
        seen_usage = False
        for body in comment_lines:
            if re.match(r"\s*@usage\s*$", body):
                seen_usage = True
                continue
            if re.match(r"\s*@brief\b", body):
                continue
            if seen_usage:
                usage_lines.append(body)
        usage = _unindent_usage(usage_lines)
        if not usage:
            errors.append(f"{name}: @usage block empty or missing")
        return summary, usage, errors

    summary = ""
    usage_lines = []
    phase = "summary"  # summary | blank | usage
    for body in comment_lines:
        if phase == "summary":
            em = re.match(r"\s*([\w.]+)\s*[—–\-:]\s*(.+)\s*$", body)
            if em:
                summary = em.group(2).strip()
                phase = "after_summary"
                continue
            if body.strip():
                summary = body.strip()
                phase = "after_summary"
            continue
        if phase == "after_summary":
            if not body.strip():
                phase = "usage"
                continue
            summary = (summary + " " + body.strip()).strip()
            continue
        usage_lines.append(body)

    usage = _unindent_usage(usage_lines)
    if not summary:
        errors.append(f"{name}: missing summary line (`// Name — …`)")
    if not usage:
        errors.append(f"{name}: missing indented usage example under the summary")
    elif "{" not in usage and "=" not in usage and "(" not in usage:
        errors.append(f"{name}: usage block does not look like QML/API sample")
    return summary, usage, errors


def extract_api(
    text: str,
) -> tuple[list[tuple[str, str, str]], list[tuple[str, str]], list[tuple[str, str]]]:
    head = "\n".join(text.splitlines()[:240])
    prop_docs = {m.group("name"): m.group("doc").strip() for m in RE_PROP_DOC.finditer(head)}
    sig_docs = {m.group("name"): m.group("doc").strip() for m in RE_SIG_DOC.finditer(head)}
    func_docs = {m.group("name"): m.group("doc").strip() for m in RE_FUNC_DOC.finditer(head)}

    props: list[tuple[str, str, str]] = []
    seen = set()
    for m in RE_PROPERTY.finditer(head):
        n = m.group("name")
        if n.startswith("_") or n in seen:
            continue
        seen.add(n)
        props.append((n, m.group("type").strip(), prop_docs.get(n, "")))

    signals: list[tuple[str, str]] = []
    seen_s: set[str] = set()
    for m in RE_SIGNAL.finditer(head):
        n = m.group("name")
        if n.startswith("_") or n in seen_s:
            continue
        seen_s.add(n)
        sig = n + (m.group("args") or "()")
        signals.append((sig, sig_docs.get(n, "")))

    funcs: list[tuple[str, str]] = []
    seen_f: set[str] = set()
    for m in RE_FUNCTION.finditer(head):
        n = m.group("name")
        if n.startswith("_") or n in seen_f:
            continue
        seen_f.add(n)
        sig = n + (m.group("args") or "()")
        funcs.append((sig, func_docs.get(n, "")))

    return props[:40], signals[:24], funcs[:24]


def parse_component(path: Path) -> Component:
    text = path.read_text(encoding="utf-8")
    name = path.stem
    summary, usage, lint = parse_header_comments(text, name)
    props, signals, funcs = extract_api(text)
    return Component(
        name=name,
        path=path,
        module=module_for(path),
        summary=summary or f"{name} (undocumented)",
        usage=usage,
        properties=props,
        signals=signals,
        functions=funcs,
        internal=path.name in INTERNAL_NAMES or path.name.startswith("_"),
        lint_errors=lint,
    )


def collect() -> list[Component]:
    comps: list[Component] = []
    for d in SCAN_DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            comps.append(parse_component(path))
    return comps


def render_component_page(c: Component) -> str:
    """One standalone markdown page for a single component."""
    out: list[str] = [
        f"# {c.name}",
        "",
        c.summary,
        "",
        f"`import {c.module}` · [`{c.path.relative_to(ROOT).as_posix()}`](../../{c.path.relative_to(ROOT).as_posix()})",
        "",
        "[← Component index](../components.md)",
        "",
    ]
    if c.internal:
        out.append("> Internal / support type — not part of the public Gallery surface.")
        out.append("")
    if c.usage:
        out.append("## Usage")
        out.append("")
        out.append("```qml")
        out.append(c.usage)
        out.append("```")
        out.append("")
    if c.properties:
        out.append("## Properties")
        out.append("")
        for n, t, doc in c.properties:
            extra = f" — {doc}" if doc else ""
            out.append(f"- `{n}: {t}`{extra}")
        out.append("")
    if c.signals:
        out.append("## Signals")
        out.append("")
        for s, doc in c.signals:
            extra = f" — {doc}" if doc else ""
            out.append(f"- `{s}`{extra}")
        out.append("")
    if c.functions:
        out.append("## Methods")
        out.append("")
        for f, doc in c.functions:
            extra = f" — {doc}" if doc else ""
            out.append(f"- `{f}`{extra}")
        out.append("")
    out.append("---")
    out.append(
        "*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*"
    )
    out.append("")
    return "\n".join(out)


def render_index(comps: list[Component], outdir: Path) -> str:
    public = [c for c in comps if not c.internal]
    internal = [c for c in comps if c.internal]
    by_mod: dict[str, list[Component]] = {}
    for c in public:
        by_mod.setdefault(c.module, []).append(c)

    rel_dir = outdir.relative_to(ROOT).as_posix()

    out: list[str] = [
        "# QWinUI3 component API",
        "",
        "Generated from **QML source comments** by regex (`scripts/generate_component_docs.py`).",
        "Each control has its **own** markdown under "
        f"[`{rel_dir}/`]({outdir.name}/).",
        "Edit the `// Name — …` + indented usage block in each `.qml` file, then re-run the script.",
        "",
        "```bash",
        "python scripts/generate_component_docs.py",
        "python scripts/generate_component_docs.py --lint",
        "```",
        "",
        f"Public components: **{len(public)}**. Shell overview: [`docs/window-shells.md`](window-shells.md).",
        "",
        "## Index",
        "",
    ]
    for mod in sorted(by_mod):
        out.append(f"### `{mod}`")
        out.append("")
        for c in by_mod[mod]:
            link = f"{outdir.name}/{c.doc_filename}"
            out.append(f"- [{c.name}]({link}) — {c.summary}")
        out.append("")

    if internal:
        out.append("## Internal / support")
        out.append("")
        for c in internal:
            link = f"{outdir.name}/{c.doc_filename}"
            out.append(f"- [{c.name}]({link}) (`{c.module}`) — {c.summary}")
        out.append("")

    out.append("---")
    out.append(
        "*Generated by `scripts/generate_component_docs.py` — do not edit by hand.*"
    )
    out.append("")
    return "\n".join(out)


def write_docs(comps: list[Component], index_path: Path, outdir: Path) -> None:
    outdir.mkdir(parents=True, exist_ok=True)
    wanted = {c.doc_filename for c in comps}

    for c in comps:
        page = render_component_page(c)
        (outdir / c.doc_filename).write_text(page, encoding="utf-8", newline="\n")

    # Drop stale pages from previous runs
    for old in outdir.glob("*.md"):
        if old.name not in wanted:
            old.unlink()

    index_path.parent.mkdir(parents=True, exist_ok=True)
    index_path.write_text(render_index(comps, outdir), encoding="utf-8", newline="\n")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "-o",
        "--output",
        type=Path,
        default=ROOT / "docs" / "components.md",
        help="Index markdown path",
    )
    ap.add_argument(
        "--outdir",
        type=Path,
        default=ROOT / "docs" / "components",
        help="Directory for per-component markdown files",
    )
    ap.add_argument(
        "--lint",
        action="store_true",
        help="Exit non-zero if any public component lacks a proper comment header",
    )
    args = ap.parse_args()

    comps = collect()
    write_docs(comps, args.output, args.outdir)
    print(
        f"Wrote {args.output.relative_to(ROOT)} + "
        f"{len(comps)} pages under {args.outdir.relative_to(ROOT)}"
    )

    if args.lint:
        bad = [c for c in comps if not c.internal and c.lint_errors]
        for c in bad:
            for e in c.lint_errors:
                print(f"LINT {c.path.relative_to(ROOT)}: {e}", file=sys.stderr)
        if bad:
            print(f"{len(bad)} component(s) need comment fixes", file=sys.stderr)
            return 1
        print("Lint OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
