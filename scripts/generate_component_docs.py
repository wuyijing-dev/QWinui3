#!/usr/bin/env python3
"""Generate QWinUI3 component API docs from QML source comments.

Adapted to the current library layout:

  src/extras/QWinUI3/Extras     → QWinUI3.Extras
  src/style/QWinUI3             → QtQuick.Controls.QWinUI3
  src/platform/QWinUI3/Platform → QWinUI3.Platform
  src/theme/QWinUI3/Theme       → QWinUI3.Theme

Also:
  - Cross-links Gallery pages from ControlCatalog.qml
  - Writes docs/components.json for the docs site search index
  - Prunes stale pages, reports version from CMakeLists.txt
  - Optional --lint for missing public headers

Usage:
  python scripts/generate_component_docs.py
  python scripts/generate_component_docs.py --lint
  python scripts/generate_component_docs.py --json docs/components.json
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

SCAN_DIRS = [
    ROOT / "src" / "extras" / "QWinUI3" / "Extras",
    ROOT / "src" / "style" / "QWinUI3",
    ROOT / "src" / "platform" / "QWinUI3" / "Platform",
    ROOT / "src" / "theme" / "QWinUI3" / "Theme",
]

CATALOG_PATH = ROOT / "src" / "gallery" / "ControlCatalog.qml"
CMAKE_PATH = ROOT / "CMakeLists.txt"

INTERNAL_NAMES = {
    "ShellWindowSupport.qml",
    "WindowChrome.qml",
    "CaptionButton.qml",
    "WindowResizeBorder.qml",
    "ElevatedChrome.qml",
    "ElevatedChrome_Simple.qml",
    "IconSource.qml",
    "FocusStroke.qml",
    "SelectionPip.qml",
    "ChartUtils.qml",
    "MediaPlayerElementStub.qml",  # CMake typename → MediaPlayerElement when no Multimedia
}

# Heuristic Gallery / docs categories (Extras-heavy types).
CATEGORY_RULES: list[tuple[str, tuple[str, ...]]] = [
    ("Shells & windows", (
        "Window", "Shell", "TitleBar", "BlankWindow", "NavigationWindow",
        "DialogShell", "ToolShell", "CompactOverlay", "MenuStatus",
    )),
    ("Navigation", (
        "Navigation", "TabView", "Pivot", "Breadcrumb", "SelectorBar",
        "Pager", "PipsPager", "Frame",
    )),
    ("Buttons & commands", (
        "Button", "AppBar", "CommandBar", "CommandPalette", "Hyperlink",
        "SplitButton", "DropDown", "CopyButton", "IconButton", "Iconic",
        "ProgressButton", "ToggleSplit",
    )),
    ("Input & forms", (
        "Text", "NumberBox", "Password", "Combo", "Spin", "Slider", "Dial",
        "Check", "Radio", "Switch", "Rating", "Tokeniz", "AutoSuggest",
        "Search", "Headered", "Form", "Validation", "ColorPicker",
        "Keyboard", "OnScreen",
    )),
    ("Collections & data", (
        "List", "Tree", "Table", "DataTable", "Items", "GridTile", "ListTile",
        "Chip", "Avatar", "PersonPicture", "Timeline", "DetailRow",
    )),
    ("Dialogs & flyouts", (
        "Dialog", "Flyout", "TeachingTip", "Toast", "InfoBar", "Popup",
        "Drawer", "ContentDialog",
    )),
    ("Status & feedback", (
        "InfoBadge", "InfoButton", "Busy", "Progress", "Shimmer", "EmptyState",
        "Status", "Notification", "MeterBar", "StepBar",
    )),
    ("Charts & gauges", (
        "Chart", "Gauge", "Sparkline", "Heatmap", "Kpi",
    )),
    ("Date & time", ("Date", "Time", "Calendar", "Month", "DayOfWeek")),
    ("Layout", (
        "Panel", "Stack", "Uniform", "TwoPane", "Relative", "Dock", "Wrap",
        "Settings", "ContentCard", "ActionCard", "ChartCard", "Acrylic",
    )),
    ("Media & platform", (
        "Media", "WebView", "FileDrop", "FilePicker", "Tray", "ConnectedAnimation",
        "Theme", "FluentIcons", "FontIcon",
    )),
]

INHERITED_API: dict[str, list[str]] = {
    "AbstractButton": ["`text`", "`enabled`", "`down` / `pressed` / `hovered`", "`clicked()`"],
    "Button": ["`text`", "`enabled`", "`flat` / `highlighted`", "`clicked()`"],
    "CheckBox": ["`text`", "`checked` / `checkState`", "`toggled()`"],
    "RadioButton": ["`text`", "`checked`", "`toggled()`"],
    "Switch": ["`text`", "`checked`", "`toggled()`"],
    "Dialog": ["`title`", "`open()` / `close()`", "`accepted()` / `rejected()`"],
    "Popup": ["`open()` / `close()`", "`opened()` / `closed()`", "`modal` / `focus`"],
    "ComboBox": ["`model`", "`currentIndex` / `currentText`", "`activated()`"],
    "TextField": ["`text`", "`placeholderText`", "`accepted()`"],
    "Control": ["`padding`", "`font`", "`background` / `contentItem`"],
    "Page": ["`header` / `footer`", "`title`"],
    "Pane": ["`padding`", "`background`"],
    "Item": ["`width` / `height`", "`visible`", "`anchors`"],
    "Window": ["`title`", "`visible`", "`width` / `height`"],
    "ApplicationWindow": ["`title`", "`menuBar` / `header` / `footer`"],
    "BusyIndicator": ["`running`"],
    "PageIndicator": ["`count`", "`currentIndex`"],
    "Tumbler": ["`model`", "`currentIndex`"],
    "RoundButton": ["`text`", "`clicked()`"],
    "ToolButton": ["`text`", "`checkable` / `checked`", "`clicked()`"],
    "ScrollBar": ["`policy`", "`size` / `position`"],
    "ScrollIndicator": ["`active`", "`size` / `position`"],
    "MenuItem": ["`text`", "`triggered()`"],
    "Frame": ["`padding`", "`contentItem`"],
    "DayOfWeekRow": ["`locale`", "`delegate`"],
    "HorizontalHeaderView": ["`syncView`", "`model`"],
    "VerticalHeaderView": ["`syncView`", "`model`"],
    "TreeViewDelegate": ["`treeView`", "`expanded`", "`depth`"],
    "RangeSlider": ["`from` / `to`", "`first` / `second`"],
    "Slider": ["`from` / `to`", "`value`", "`moved()`"],
    "SpinBox": ["`from` / `to`", "`value`", "`valueModified()`"],
    "Dial": ["`from` / `to`", "`value`"],
}

RE_HEADER_BLOCK = re.compile(
    r"(?m)^(?:pragma[^\n]*\n|import[^\n]*\n|\s*\n)*"
    r"(?P<header>(?://[^\n]*\n)+)",
)
RE_BRIEF_TAG = re.compile(r"(?m)^//\s*@brief\s+(?P<brief>.+)\s*$")
RE_COMMENT_LINE = re.compile(r"(?m)^//(?P<body>.*)$")
RE_CATALOG_ENTRY = re.compile(
    r"title:\s*qsTr\(\s*\"(?P<title>[^\"]+)\"\s*\)\s*,"
    r".*?component:\s*\"(?P<component>\w+)\"\s*,"
    r".*?source:\s*\"(?P<source>[^\"]+)\"",
    re.DOTALL,
)


@dataclass
class Component:
    name: str
    path: Path
    module: str
    summary: str = ""
    usage: str = ""
    notes: str = ""
    properties: list[tuple[str, str, str]] = field(default_factory=list)
    signals: list[tuple[str, str]] = field(default_factory=list)
    functions: list[tuple[str, str]] = field(default_factory=list)
    base_type: str = ""
    internal: bool = False
    lint_errors: list[str] = field(default_factory=list)
    gallery_page: str = ""
    gallery_title: str = ""
    category: str = "Other"

    @property
    def doc_filename(self) -> str:
        return f"{self.name}.md"

    def to_json(self) -> dict:
        return {
            "name": self.name,
            "module": self.module,
            "summary": self.summary,
            "path": self.path.relative_to(ROOT).as_posix(),
            "baseType": self.base_type,
            "internal": self.internal,
            "category": self.category,
            "galleryPage": self.gallery_page,
            "galleryTitle": self.gallery_title,
            "doc": f"components/{self.doc_filename}",
            "propertyCount": len(self.properties),
            "signalCount": len(self.signals),
            "methodCount": len(self.functions),
        }


def project_version() -> str:
    text = CMAKE_PATH.read_text(encoding="utf-8") if CMAKE_PATH.is_file() else ""
    m = re.search(r'set\s*\(\s*QWINUI3_VERSION\s+"([0-9]+\.[0-9]{2})"\s*\)', text)
    if m:
        return m.group(1)
    m = re.search(r"project\s*\(\s*QWinUI3\s+VERSION\s+([\d.]+)", text)
    return m.group(1) if m else "0.00"


def load_gallery_map() -> dict[str, tuple[str, str]]:
    """Map control name → (gallery title, pages/….qml)."""
    if not CATALOG_PATH.is_file():
        return {}
    text = CATALOG_PATH.read_text(encoding="utf-8")
    out: dict[str, tuple[str, str]] = {}
    # Simpler line-oriented parse: look for component: "FooPage"
    blocks = re.split(r"\n\s*\{\s*\n", text)
    for block in blocks:
        title_m = re.search(r'title:\s*qsTr\(\s*"([^"]+)"\s*\)', block)
        comp_m = re.search(r'component:\s*"(\w+)"', block)
        src_m = re.search(r'source:\s*"([^"]+)"', block)
        if not (title_m and comp_m and src_m):
            continue
        page = comp_m.group(1)
        if not page.endswith("Page"):
            continue
        control = page[: -len("Page")]
        out[control] = (title_m.group(1), src_m.group(1))
    return out


def categorize(name: str, module: str) -> str:
    if module == "QtQuick.Controls.QWinUI3":
        return "Styled controls"
    if module == "QWinUI3.Platform":
        return "Platform"
    if module == "QWinUI3.Theme":
        return "Theme"
    for label, keys in CATEGORY_RULES:
        for key in keys:
            if key.lower() in name.lower():
                return label
    return "Other"


def detect_base_type(text: str) -> str:
    m = re.search(
        r"(?m)^(?:pragma[^\n]*\n|import[^\n]*\n|\s*\n|//[^\n]*\n)*"
        r"(?:T\.)?(\w+)\s*\{",
        text,
    )
    return m.group(1) if m else ""


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


def parse_header_comments(text: str, name: str) -> tuple[str, str, str, list[str]]:
    errors: list[str] = []
    m = RE_HEADER_BLOCK.match(text)
    if not m:
        return "", "", "", [f"{name}: missing leading // doc comment after imports"]

    header = m.group("header")
    comment_lines = RE_COMMENT_LINE.findall(header)

    if RE_BRIEF_TAG.search(header):
        summary = RE_BRIEF_TAG.search(header).group("brief").strip()  # type: ignore[union-attr]
        usage_lines: list[str] = []
        notes_lines: list[str] = []
        phase = "pre"
        for body in comment_lines:
            if re.match(r"\s*@brief\b", body):
                continue
            if re.match(r"\s*@usage\s*$", body):
                phase = "usage"
                continue
            if re.match(r"\s*@notes\s*$", body):
                phase = "notes"
                continue
            if phase == "usage":
                usage_lines.append(body)
            elif phase == "notes":
                notes_lines.append(body)
        usage = _unindent_usage(usage_lines)
        notes = _unindent_usage(notes_lines)
        if not usage:
            errors.append(f"{name}: @usage block empty or missing")
        return summary, usage, notes, errors

    summary = ""
    usage_lines = []
    notes_lines = []
    phase = "summary"
    for body in comment_lines:
        if re.match(r"\s*@notes\s*$", body):
            phase = "notes"
            continue
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
        if phase == "notes":
            notes_lines.append(body)
            continue
        usage_lines.append(body)

    usage = _unindent_usage(usage_lines)
    notes = _unindent_usage(notes_lines)
    if not summary:
        errors.append(f"{name}: missing summary line (`// Name — …`)")
    if not usage:
        errors.append(f"{name}: missing indented usage example under the summary")
    elif "{" not in usage and "=" not in usage and "(" not in usage:
        errors.append(f"{name}: usage block does not look like QML/API sample")
    return summary, usage, notes, errors


def _root_member_indent(lines: list[str]) -> int | None:
    for line in lines:
        if re.match(r"^(?:T\.)?[A-Za-z_]\w*\s*\{", line):
            return 4
    for line in lines:
        m = re.match(
            r"^(\s+)(?:(?:readonly|default|required)\s+)*property\s+",
            line,
        ) or re.match(r"^(\s+)signal\s+", line) or re.match(
            r"^(\s+)function\s+", line
        )
        if m:
            return len(m.group(1))
    return None


def extract_api(
    text: str,
) -> tuple[list[tuple[str, str, str]], list[tuple[str, str]], list[tuple[str, str]]]:
    lines = text.splitlines()
    indent = _root_member_indent(lines)
    if indent is None:
        return [], [], []

    prefix = "^" + (" " * indent)
    prop_re = re.compile(
        prefix
        + r"(?:(?:readonly|default|required)\s+)*property\s+"
        + r"(?:alias\s+)?(?P<type>[\w.<>,\s]+?)\s+(?P<name>\w+)\b"
    )
    sig_re = re.compile(prefix + r"signal\s+(?P<name>\w+)\s*(?P<args>\([^)]*\))?")
    func_re = re.compile(prefix + r"function\s+(?P<name>\w+)\s*(?P<args>\([^)]*\))")
    doc_re = re.compile(prefix + r"//\s*(?P<doc>.+)\s*$")

    props: list[tuple[str, str, str]] = []
    signals: list[tuple[str, str]] = []
    funcs: list[tuple[str, str]] = []
    seen_p: set[str] = set()
    seen_s: set[str] = set()
    seen_f: set[str] = set()

    for i, line in enumerate(lines):
        prev = lines[i - 1] if i else ""
        doc = ""
        dm = doc_re.match(prev)
        if dm:
            doc = dm.group("doc").strip()

        pm = prop_re.match(line)
        if pm:
            n = pm.group("name")
            if not n.startswith("_") and n not in seen_p:
                seen_p.add(n)
                props.append((n, pm.group("type").strip(), doc))
            continue

        sm = sig_re.match(line)
        if sm:
            n = sm.group("name")
            if not n.startswith("_") and n not in seen_s:
                seen_s.add(n)
                signals.append((n + (sm.group("args") or "()"), doc))
            continue

        fm = func_re.match(line)
        if fm:
            n = fm.group("name")
            if not n.startswith("_") and n not in seen_f:
                seen_f.add(n)
                funcs.append((n + (fm.group("args") or "()"), doc))

    return props, signals, funcs


def parse_component(path: Path, gallery: dict[str, tuple[str, str]]) -> Component:
    text = path.read_text(encoding="utf-8")
    name = path.stem
    summary, usage, notes, lint = parse_header_comments(text, name)
    props, signals, funcs = extract_api(text)
    module = module_for(path)
    gtitle, gsrc = gallery.get(name, ("", ""))
    return Component(
        name=name,
        path=path,
        module=module,
        summary=summary or f"{name} (undocumented)",
        usage=usage,
        notes=notes,
        properties=props,
        signals=signals,
        functions=funcs,
        base_type=detect_base_type(text),
        internal=path.name in INTERNAL_NAMES or path.name.startswith("_"),
        lint_errors=lint,
        gallery_page=gsrc,
        gallery_title=gtitle,
        category=categorize(name, module),
    )


def collect() -> list[Component]:
    gallery = load_gallery_map()
    comps: list[Component] = []
    for d in SCAN_DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            comps.append(parse_component(path, gallery))
    return comps


def _md_table(headers: list[str], rows: list[list[str]]) -> list[str]:
    out = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]
    for row in rows:
        out.append("| " + " | ".join(row) + " |")
    return out


def render_component_page(c: Component, version: str) -> str:
    rel = c.path.relative_to(ROOT).as_posix()
    src_url = f"https://github.com/wuyijing-dev/QWinui3/blob/master/{rel}"
    out: list[str] = [
        f"# {c.name}",
        "",
        c.summary,
        "",
        f"`import {c.module}` · [`{rel}`]({src_url})",
        "",
        f"**Category:** {c.category} · **Library:** v{version}",
        "",
        "[← Component index](../components.md)",
        "",
    ]
    if c.gallery_page:
        g_url = (
            f"https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/{c.gallery_page}"
        )
        out.append(
            f"**Gallery:** `{c.gallery_title or c.name}` — "
            f"[`src/gallery/{c.gallery_page}`]({g_url})"
        )
        out.append("")
    if c.internal:
        out.append("> Internal / support type — not part of the public Gallery surface.")
        out.append("")

    if c.base_type and c.base_type != c.name:
        out.append(f"**Extends** `{c.base_type}`.")
        out.append("")

    if c.usage:
        out += ["## Example", "", "```qml", c.usage, "```", ""]

    if c.notes:
        out += ["## Notes", "", c.notes, ""]

    style_only = (
        "/style/" in c.path.as_posix()
        and not c.properties
        and not c.signals
        and not c.functions
    )

    out += ["## API", ""]

    if style_only:
        out.append(
            "Style-only control: no extra QWinUI3 properties. "
            f"Use the Qt Quick Controls `{c.base_type or c.name}` API "
            "(this file only supplies Fluent visuals / metrics)."
        )
        out.append("")
        inherited = INHERITED_API.get(c.base_type or c.name, [])
        if inherited:
            out.append(f"### Inherited from `{c.base_type or c.name}`")
            out.append("")
            for item in inherited:
                out.append(f"- {item}")
            out.append("")
    else:
        out.append("### Properties")
        out.append("")
        if c.properties:
            rows = [
                [f"`{n}`", f"`{t}`", doc.replace("|", "\\|") if doc else "—"]
                for n, t, doc in c.properties
            ]
            out.extend(_md_table(["Name", "Type", "Description"], rows))
            out.append("")
        else:
            out.append("_No additional properties beyond the base type._")
            out.append("")

        out.append("### Signals")
        out.append("")
        if c.signals:
            rows = [
                [f"`{s}`", doc.replace("|", "\\|") if doc else "—"]
                for s, doc in c.signals
            ]
            out.extend(_md_table(["Signature", "Description"], rows))
            out.append("")
        else:
            out.append("_No custom signals_ (use inherited signals from the base type).")
            out.append("")

        out.append("### Methods")
        out.append("")
        if c.functions:
            rows = [
                [f"`{f}`", doc.replace("|", "\\|") if doc else "—"]
                for f, doc in c.functions
            ]
            out.extend(_md_table(["Signature", "Description"], rows))
            out.append("")
        else:
            out.append("_No custom methods_ (use inherited methods from the base type).")
            out.append("")

        inherited = INHERITED_API.get(c.base_type, [])
        if inherited and c.base_type and c.base_type != c.name:
            out.append(f"### Inherited from `{c.base_type}`")
            out.append("")
            out.append("Also available (base type / Qt Quick Controls):")
            out.append("")
            for item in inherited:
                out.append(f"- {item}")
            out.append("")

    out += [
        "---",
        "*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*",
        "",
    ]
    return "\n".join(out)


def render_index(comps: list[Component], outdir: Path, version: str) -> str:
    public = [c for c in comps if not c.internal]
    internal = [c for c in comps if c.internal]
    by_mod: dict[str, list[Component]] = {}
    by_cat: dict[str, list[Component]] = {}
    for c in public:
        by_mod.setdefault(c.module, []).append(c)
        by_cat.setdefault(c.category, []).append(c)

    gallery_n = sum(1 for c in public if c.gallery_page)
    rel_dir = outdir.relative_to(ROOT).as_posix()

    out: list[str] = [
        "# QWinUI3 component API",
        "",
        f"Library **v{version}**. Generated from QML source comments "
        f"(`scripts/generate_component_docs.py`).",
        f"Each control has its own page under `{rel_dir}/`.",
        "",
        "```bash",
        "python scripts/generate_component_docs.py",
        "python scripts/generate_component_docs.py --lint",
        "```",
        "",
        f"**{len(public)}** public · **{len(internal)}** internal · "
        f"**{gallery_n}** with Gallery demos · "
        f"Hub: [docs home](index.md).",
        "",
        "## By module",
        "",
    ]
    for mod in sorted(by_mod):
        out.append(f"### `{mod}`")
        out.append("")
        for c in by_mod[mod]:
            badge = " · Gallery" if c.gallery_page else ""
            out.append(
                f"- [{c.name}]({outdir.name}/{c.doc_filename}) — {c.summary}{badge}"
            )
        out.append("")

    out.append("## By category")
    out.append("")
    for cat in sorted(by_cat):
        out.append(f"### {cat}")
        out.append("")
        for c in sorted(by_cat[cat], key=lambda x: x.name):
            out.append(f"- [{c.name}]({outdir.name}/{c.doc_filename}) — `{c.module}`")
        out.append("")

    if internal:
        out.append("## Internal / support")
        out.append("")
        for c in internal:
            out.append(
                f"- [{c.name}]({outdir.name}/{c.doc_filename}) "
                f"(`{c.module}`) — {c.summary}"
            )
        out.append("")

    out += [
        "---",
        "*Generated by `scripts/generate_component_docs.py` — do not edit by hand.*",
        "",
    ]
    return "\n".join(out)


def write_json_catalog(comps: list[Component], path: Path, version: str) -> None:
    payload = {
        "name": "QWinUI3",
        "version": version,
        "generatedBy": "scripts/generate_component_docs.py",
        "publicCount": sum(1 for c in comps if not c.internal),
        "components": [c.to_json() for c in comps],
    }
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
        newline="\n",
    )


def write_docs(
    comps: list[Component],
    index_path: Path,
    outdir: Path,
    json_path: Path | None,
    version: str,
) -> None:
    outdir.mkdir(parents=True, exist_ok=True)
    wanted = {c.doc_filename for c in comps}

    for c in comps:
        (outdir / c.doc_filename).write_text(
            render_component_page(c, version), encoding="utf-8", newline="\n"
        )

    for old in outdir.glob("*.md"):
        if old.name not in wanted:
            old.unlink()

    index_path.parent.mkdir(parents=True, exist_ok=True)
    index_path.write_text(
        render_index(comps, outdir, version), encoding="utf-8", newline="\n"
    )
    if json_path:
        write_json_catalog(comps, json_path, version)


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
        "--json",
        type=Path,
        default=ROOT / "docs" / "components.json",
        help="JSON catalog path (empty string to skip)",
    )
    ap.add_argument(
        "--lint",
        action="store_true",
        help="Exit non-zero if any public component lacks a proper comment header",
    )
    args = ap.parse_args()

    version = project_version()
    comps = collect()
    json_path = None if str(args.json) in ("", "-", "none") else args.json
    write_docs(comps, args.output, args.outdir, json_path, version)

    public = sum(1 for c in comps if not c.internal)
    print(
        f"QWinUI3 v{version}: wrote {args.output.relative_to(ROOT)} + "
        f"{len(comps)} pages ({public} public) under {args.outdir.relative_to(ROOT)}"
        + (f" + {json_path.relative_to(ROOT)}" if json_path else "")
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
