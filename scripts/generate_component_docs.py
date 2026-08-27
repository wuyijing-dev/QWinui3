#!/usr/bin/env python3
"""Generate QWinUI3 component API docs from registered module sources.

Source of truth is each ``qt_add_qml_module()`` in module CMakeLists (URI +
``QML_FILES`` + ``SOURCES``) — not a directory glob. One CMakeLists may declare
several modules (e.g. Extras + Extras.Charts + Extras.Osk; Platform + WebView2).

  src/extras/QWinUI3/Extras     → QWinUI3.Extras / .Charts / .Osk
  src/style/QWinUI3             → QtQuick.Controls.QWinUI3  (style id; CMake URI is QWinUI3)
  src/platform/QWinUI3/Platform → QWinUI3.Platform / .WebView2
  src/theme/QWinUI3/Theme       → QWinUI3.Theme

Also:
  - Cross-links Gallery pages from ControlCatalog.qml
  - Writes docs/components.json for the docs site search index
  - Generates Python package API docs (``qwinui3``, ``qwinui3_gallery``)
  - Prunes stale pages, reports version from CMakeLists.txt
  - Optional --lint for missing public headers

Usage:
  python scripts/generate_component_docs.py
  python scripts/generate_component_docs.py --lint
  python scripts/generate_component_docs.py --json docs/components.json
  python scripts/generate_component_docs.py --skip-qml
  python scripts/generate_component_docs.py --skip-python
"""

from __future__ import annotations

import argparse
import ast
import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

PYTHON_ROOT = ROOT / "python"

# Pip packages shipped / documented for PySide6 · PyQt6 consumers.
PYTHON_PACKAGES: list[dict[str, object]] = [
    {
        "name": "qwinui3",
        "title": "qwinui3",
        "summary": (
            "PySide6 or PyQt6 bootstrap — locate a shared kit, configure environment, "
            "and wire QQmlApplicationEngine import paths (mirrors C++ Bootstrap)."
        ),
        "path": PYTHON_ROOT / "qwinui3",
        "modules": [
            "__init__",
            "bootstrap",
            "rhi",
            "fonts",
        ],
        "internal_modules": ["_qt", "_paths", "welcome"],
    },
    {
        "name": "qwinui3_gallery",
        "title": "qwinui3_gallery",
        "summary": (
            "Full Gallery from Python — stage QWinUI3.Gallery QML, register Gallery helpers "
            "via @QmlElement / @QmlSingleton, and run the same smoke path as the C++ exe."
        ),
        "path": PYTHON_ROOT / "qwinui3_gallery",
        "modules": [
            "__init__",
            "main",
            "qml_module",
            "types",
            "graphics_backend",
            "gallery_language",
            "demo_tree_model",
            "rhi",
        ],
        "internal_modules": [],
    },
]

CATALOG_PATH = ROOT / "src" / "gallery" / "ControlCatalog.qml"
CMAKE_PATH = ROOT / "CMakeLists.txt"

# CMakeLists that declare one or more qt_add_qml_module() targets.
# Documented import for URI "QWinUI3" (style plugin) is QtQuick.Controls.QWinUI3.
CMAKE_MODULE_ROOTS: list[tuple[Path, Path]] = [
    (
        ROOT / "src" / "extras" / "QWinUI3" / "Extras" / "CMakeLists.txt",
        ROOT / "src" / "extras" / "QWinUI3" / "Extras",
    ),
    (
        ROOT / "src" / "style" / "QWinUI3" / "CMakeLists.txt",
        ROOT / "src" / "style" / "QWinUI3",
    ),
    (
        ROOT / "src" / "platform" / "QWinUI3" / "Platform" / "CMakeLists.txt",
        ROOT / "src" / "platform" / "QWinUI3" / "Platform",
    ),
    (
        ROOT / "src" / "theme" / "QWinUI3" / "Theme" / "CMakeLists.txt",
        ROOT / "src" / "theme" / "QWinUI3" / "Theme",
    ),
]

# Back-compat alias used by older call sites / tests.
CMAKE_MODULES: list[tuple[Path, Path, str]] = [
    (cmake, directory, "") for cmake, directory in CMAKE_MODULE_ROOTS
]

QML_FILES_END = {
    "IMPORTS",
    "RESOURCES",
    "SOURCES",
    "DEPENDENCIES",
    "OUTPUT_DIRECTORY",
    "NO_CACHEGEN",
    "NO_LINT",
    "NO_PLUGIN",
    "NO_GENERATE_PLUGIN_SOURCE",
    "CLASSNAME",
    "PLUGIN_TARGET",
}

# Public type names that are implementation helpers (not app-facing).
INTERNAL_TYPES = {
    "ShellWindowSupport",
    "WindowChrome",
    "CaptionButton",
    "WindowResizeBorder",
    "ElevatedChrome",
    "IconSource",
    "FocusStroke",
    "SelectionPip",
    "ChartUtils",
    "GaugeUtils",
    "GaugeDragLayer",
    "KeyboardEngine",
    "OskSpeechService",
    "OskHandwritingService",
    "HangulComposer",
    "RomajiKana",
    "PinyinLexicon",
    "OskUserLexicon",
}

# ControlCatalog page stem → extra control names that share that demo.
GALLERY_ALIASES = {
    "WebView2Host": "WebView2",
    "FilePicker": "SystemIntegration",
    "TrayIcon": "SystemIntegration",
    "FluentIcons": "FontIcon",
    "FluentIconsCatalog": "FontIcon",
    "ThemeFonts": "FontIcon",
    "WindowHelper": "WindowParadigm",
    "FrameStatsMonitor": "GraphicsBackend",
    "ChartSeries": "LineChart",
    "MatchHighlightText": "NavigationView",
    "TitleBarCommandBar": "TitleBar",
    "TitleBarToolbar": "TitleBar",
    "CommandPaletteHost": "CommandPalette",
    "LayoutPreset": "SplitWorkspace",
    "LiveMetricStrip": "FrameStatsOverlay",
}

# Heuristic Gallery / docs categories (Extras-heavy types).
CATEGORY_RULES: list[tuple[str, tuple[str, ...]]] = [
    ("Shells & windows", (
        "Window", "Shell", "TitleBar", "BlankWindow", "NavigationWindow",
        "DialogShell", "ToolShell", "CompactOverlay", "MenuStatus",
    )),
    ("Navigation", (
        "Navigation", "TabView", "Pivot", "Breadcrumb", "SelectorBar",
        "Pager", "PipsPager", "Frame", "MatchHighlight",
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
        "Keyboard", "OnScreen", "Osk", "Ime", "Masked",
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
        "Status", "Notification", "MeterBar", "StepBar", "LiveMetric",
    )),
    ("Charts & gauges", (
        "Chart", "Gauge", "Sparkline", "Heatmap", "Kpi",
        "Cluster", "Telltale", "GearIndicator", "Histogram", "Pareto",
        "Sunburst", "Violin", "Waterfall", "Polar", "Candlestick",
        "Treemap", "Funnel", "Bullet", "Radar", "Scatter", "Donut",
        "Waffle", "Lollipop", "Dumbbell", "Band", "Combo",
        "Tachometer", "Speedometer", "Voltage", "Fuel", "Quarter",
        "Odometer", "Boost", "Coolant", "Pressure", "Cylinder",
        "Digit", "Compass", "VuMeter", "Battery", "Tpms", "Automotive",
        "ChartSeries",
    )),
    ("Date & time", ("Date", "Time", "Calendar", "Month", "DayOfWeek")),
    ("Layout", (
        "Panel", "Stack", "Uniform", "TwoPane", "Relative", "Dock", "Wrap",
        "Settings", "ContentCard", "ActionCard", "ChartCard", "Acrylic",
        "SplitWorkspace", "LayoutPreset",
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
    kind: str = "qml"
    singleton: bool = False

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
            "kind": self.kind,
            "singleton": self.singleton,
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
        entry = (title_m.group(1), src_m.group(1))
        out[control] = entry
        title = title_m.group(1).replace(" ", "")
        out.setdefault(title, entry)
    return out


def gallery_for(name: str, gallery: dict[str, tuple[str, str]]) -> tuple[str, str]:
    if name in gallery:
        return gallery[name]
    alias = GALLERY_ALIASES.get(name)
    if alias and alias in gallery:
        return gallery[alias]
    return ("", "")


def document_import_for_uri(uri: str) -> str:
    """Map CMake URI to the import string shown in docs."""
    if uri == "QWinUI3":
        return "QtQuick.Controls.QWinUI3"
    return uri


def _extract_cmake_block_args(text: str, start: int) -> tuple[str, int] | None:
    """Return (inner args text, end index) for a `(...)` block starting at ``start``."""
    if start >= len(text) or text[start] != "(":
        return None
    depth = 0
    i = start
    while i < len(text):
        ch = text[i]
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
            if depth == 0:
                return text[start + 1 : i], i + 1
        i += 1
    return None


def _section_tokens(args: str, section: str) -> list[str]:
    """Collect whitespace-separated tokens under a CMake keyword until the next keyword/`(`."""
    lines = args.splitlines()
    tokens: list[str] = []
    in_section = False
    for raw in lines:
        line = raw.strip()
        if not in_section:
            if line == section or line.startswith(section + " "):
                in_section = True
                rest = line[len(section) :].strip()
                if rest:
                    tokens.extend(rest.split())
            continue
        if not line or line.startswith("#"):
            continue
        key = line.split()[0].rstrip(")")
        # Next top-level keyword ends this section (SOURCES / QML_FILES / URI / …).
        if key.isupper() and key.replace("_", "").isalnum() and not line.endswith(".qml") and not line.endswith(".h") and not line.endswith(".cpp") and not line.endswith(".hpp"):
            # Allow continuation of multi-token lines; stop on new SECTION keywords.
            if key in {
                "URI", "VERSION", "OUTPUT_DIRECTORY", "SOURCES", "QML_FILES", "IMPORTS",
                "RESOURCES", "DEPENDENCIES", "NO_CACHEGEN", "NO_LINT", "NO_PLUGIN",
                "NO_GENERATE_PLUGIN_SOURCE", "CLASSNAME", "PLUGIN_TARGET", "OPTIONAL",
            } and not line.startswith(section):
                break
        cleaned = line.replace(")", " ")
        for tok in cleaned.split():
            tokens.append(tok)
    return tokens


@dataclass
class CMakeQmlModuleDecl:
    uri: str
    qml_tokens: list[str] = field(default_factory=list)
    source_headers: list[str] = field(default_factory=list)


def parse_qt_add_qml_modules(cmake_path: Path) -> list[CMakeQmlModuleDecl]:
    """Parse every ``qt_add_qml_module(...)`` in a CMakeLists (Charts / Osk / WebView2, …)."""
    if not cmake_path.is_file():
        return []
    text = cmake_path.read_text(encoding="utf-8")
    out: list[CMakeQmlModuleDecl] = []
    needle = "qt_add_qml_module"
    pos = 0
    while True:
        idx = text.find(needle, pos)
        if idx < 0:
            break
        paren = text.find("(", idx + len(needle))
        if paren < 0:
            break
        extracted = _extract_cmake_block_args(text, paren)
        if not extracted:
            break
        args, end = extracted
        pos = end
        uri_m = re.search(r"\bURI\s+(\S+)", args)
        if not uri_m:
            continue
        uri = uri_m.group(1).strip().strip('"')
        qml_tokens = [
            t for t in _section_tokens(args, "QML_FILES")
            if t.endswith(".qml") or t.startswith("${")
        ]
        headers = [
            Path(t).name
            for t in _section_tokens(args, "SOURCES")
            if t.endswith((".h", ".hpp"))
        ]
        out.append(CMakeQmlModuleDecl(uri=uri, qml_tokens=qml_tokens, source_headers=headers))
    return out


def cmake_qml_tokens(cmake_path: Path) -> list[str]:
    """Collect QML_FILES entries from all qt_add_qml_module() blocks (compat helper)."""
    tokens: list[str] = []
    for decl in parse_qt_add_qml_modules(cmake_path):
        tokens.extend(decl.qml_tokens)
    return tokens


def resolve_qml_token(token: str, directory: Path) -> tuple[Path, str] | None:
    """Map a CMake QML_FILES token to (source path, public type name)."""
    if token == "${QWINUI3_EXTRAS_MEDIA_QML}":
        full = directory / "MediaPlayerElement.qml"
        stub = directory / "MediaPlayerElementStub.qml"
        if full.is_file():
            return full, "MediaPlayerElement"
        if stub.is_file():
            return stub, "MediaPlayerElement"
        return None
    if token == "${QWINUI3_SHELL_DECORATION_QML}":
        full = directory / "WindowShellDecoration.qml"
        simple = directory / "WindowShellDecoration_Simple.qml"
        if full.is_file():
            return full, "WindowShellDecoration"
        if simple.is_file():
            return simple, "WindowShellDecoration"
        return None
    if token == "${QWINUI3_ELEVATED_CHROME_QML}":
        full = directory / "ElevatedChrome.qml"
        simple = directory / "ElevatedChrome_Simple.qml"
        if full.is_file():
            return full, "ElevatedChrome"
        if simple.is_file():
            return simple, "ElevatedChrome"
        return None
    if token.startswith("${"):
        return None
    name = Path(token).name
    path = directory / name
    if not path.is_file():
        return None
    stem = path.stem
    if stem.endswith("_Simple"):
        stem = stem[: -len("_Simple")]
    if stem.endswith("Stub"):
        stem = stem[: -len("Stub")]
    return path, stem


def cpp_qml_names(text: str) -> tuple[str, str] | None:
    """Return (public type name, C++ class name) for a QML-registered header.

    Supports ``QML_ELEMENT`` / ``QML_NAMED_ELEMENT`` on ``class`` or ``struct``,
    and ``QML_FOREIGN(Impl)`` registration wrappers (e.g. WebView2Host_qml.h).
    """
    named = re.search(r"QML_NAMED_ELEMENT\s*\(\s*(\w+)\s*\)", text)
    elem = re.search(r"\bQML_ELEMENT\b", text)
    foreign = re.search(r"QML_FOREIGN\s*\(\s*(\w+)\s*\)", text)
    if not named and not elem and not foreign:
        return None
    if foreign and named:
        return named.group(1), foreign.group(1)
    if foreign and not named and not elem:
        return foreign.group(1), foreign.group(1)
    pos = named.start() if named else elem.start()
    types = list(
        re.finditer(r"^(?:class|struct)\s+(\w+)\b(?!\s*;)", text[:pos], re.M)
    )
    if not types:
        # Foreign-only fallback already handled; named without enclosing type.
        if named:
            return named.group(1), named.group(1)
        return None
    class_name = types[-1].group(1)
    public = named.group(1) if named else class_name
    if foreign:
        class_name = foreign.group(1)
    return public, class_name


def parse_cpp_comments_before_class(text: str, class_name: str) -> str:
    lines = text.splitlines()
    idx = None
    for i, line in enumerate(lines):
        if re.match(rf"^(?:class|struct)\s+{re.escape(class_name)}\b", line):
            idx = i
            break
    if idx is None:
        # Registration wrapper: prefer comments above the first class/struct.
        for i, line in enumerate(lines):
            if re.match(r"^(?:class|struct)\s+\w+\b", line):
                idx = i
                break
    if idx is None:
        return ""
    block: list[str] = []
    j = idx - 1
    while j >= 0:
        s = lines[j].strip()
        if s.startswith("//"):
            block.append(lines[j])
            j -= 1
            continue
        if not s or s.startswith("#"):
            j -= 1
            continue
        break
    block.reverse()
    return "\n".join(block) + ("\n" if block else "")


def extract_cpp_api(
    text: str,
) -> tuple[list[tuple[str, str, str]], list[tuple[str, str]], list[tuple[str, str]]]:
    props: list[tuple[str, str, str]] = []
    seen_p: set[str] = set()
    for m in re.finditer(
        r"Q_PROPERTY\s*\(\s*(?P<type>[\w:<>,\s\*&]+?)\s+(?P<name>\w+)\s+",
        text,
    ):
        n = m.group("name")
        if n.startswith("_") or n in seen_p:
            continue
        seen_p.add(n)
        props.append((n, re.sub(r"\s+", " ", m.group("type")).strip(), ""))

    funcs: list[tuple[str, str]] = []
    seen_f: set[str] = set()
    for m in re.finditer(
        r"Q_INVOKABLE\s+(?:static\s+)?(?:[\w:<>,\s\*&]+)\s+(?P<name>\w+)\s*(?P<args>\([^;{]*)",
        text,
    ):
        n = m.group("name")
        if n.startswith("_") or n in seen_f:
            continue
        seen_f.add(n)
        args = (m.group("args") or "()").split("{")[0].strip()
        if not args.endswith(")"):
            args = args + ")"
        funcs.append((n + args, ""))

    signals: list[tuple[str, str]] = []
    seen_s: set[str] = set()
    sig_sec = re.search(
        r"\nsignals:\s*\n(.*?)(?:\n(?:public|private|protected|public slots|private slots):|\Z)",
        text,
        re.DOTALL,
    )
    if sig_sec:
        for m in re.finditer(
            r"void\s+(?P<name>\w+)\s*(?P<args>\([^;]*\))",
            sig_sec.group(1),
        ):
            n = m.group("name")
            if n.startswith("_") or n in seen_s:
                continue
            seen_s.add(n)
            signals.append((n + m.group("args"), ""))
    return props, signals, funcs


def parse_cpp_component(path: Path, module: str, gallery: dict[str, tuple[str, str]]) -> Component | None:
    text = path.read_text(encoding="utf-8")
    names = cpp_qml_names(text)
    if names is None:
        return None
    name, class_name = names
    comment = parse_cpp_comments_before_class(text, class_name)
    if not comment:
        comment = parse_cpp_comments_before_class(text, name)
    lint: list[str] = []
    summary, usage, notes = "", "", ""
    if comment:
        fake = "import QtQuick\n" + comment
        if not comment.endswith("\n"):
            fake += "\n"
        summary, usage, notes, lint = parse_header_comments(fake, name)
        lint = [
            e
            for e in lint
            if "usage block does not look like" not in e
            and "missing indented usage" not in e
        ]
    if not summary:
        summary = f"C++ QML type in `{module}`."
        if not comment:
            lint = []

    # QML_FOREIGN wrappers: pull Q_PROPERTY / signals from the implementation header.
    api_text = text
    foreign_impl = re.search(r"QML_FOREIGN\s*\(\s*(\w+)\s*\)", text)
    if foreign_impl:
        impl = path.parent / f"{foreign_impl.group(1)}.h"
        if impl.is_file():
            api_text = impl.read_text(encoding="utf-8")
            class_name = foreign_impl.group(1)
    elif class_name != path.stem and (path.parent / f"{class_name}.h").is_file():
        api_text = (path.parent / f"{class_name}.h").read_text(encoding="utf-8")

    props, signals, funcs = extract_cpp_api(api_text)
    gtitle, gsrc = gallery_for(name, gallery)
    base = "QObject"
    if "QQuickItem" in api_text:
        base = "QQuickItem"
    elif "QQmlPropertyMap" in api_text:
        base = "QQmlPropertyMap"
    return Component(
        name=name,
        path=path,
        module=module,
        summary=summary,
        usage=usage,
        notes=notes,
        properties=props,
        signals=signals,
        functions=funcs,
        base_type=base,
        internal=name in INTERNAL_TYPES or name.startswith("_"),
        lint_errors=lint,
        gallery_page=gsrc,
        gallery_title=gtitle,
        category=categorize(name, module),
        kind="cpp",
        singleton="QML_SINGLETON" in text or "QML_SINGLETON" in api_text,
    )


def categorize(name: str, module: str) -> str:
    if module == "QtQuick.Controls.QWinUI3":
        return "Styled controls"
    if module.startswith("QWinUI3.Platform"):
        return "Platform"
    if module == "QWinUI3.Theme":
        return "Theme"
    if module.endswith(".Charts"):
        return "Charts & gauges"
    if ".Osk" in module:
        return "Input & forms"
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


def parse_component(
    path: Path,
    gallery: dict[str, tuple[str, str]],
    *,
    name: str | None = None,
    module: str | None = None,
) -> Component:
    text = path.read_text(encoding="utf-8")
    name = name or path.stem
    summary, usage, notes, lint = parse_header_comments(text, name)
    props, signals, funcs = extract_api(text)
    module = module or module_for(path)
    gtitle, gsrc = gallery_for(name, gallery)
    singleton = bool(re.search(r"(?m)^pragma\s+Singleton\b", text))
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
        internal=name in INTERNAL_TYPES or path.name.startswith("_"),
        lint_errors=lint,
        gallery_page=gsrc,
        gallery_title=gtitle,
        category=categorize(name, module),
        kind="qml",
        singleton=singleton,
    )


def collect() -> list[Component]:
    gallery = load_gallery_map()
    comps: list[Component] = []
    seen: set[str] = set()

    for cmake_path, directory in CMAKE_MODULE_ROOTS:
        decls = parse_qt_add_qml_modules(cmake_path)
        if not decls:
            # Fallback: treat as a single undocumented module using directory name.
            continue
        for decl in decls:
            module = document_import_for_uri(decl.uri)
            for token in decl.qml_tokens:
                resolved = resolve_qml_token(token, directory)
                if not resolved:
                    continue
                path, name = resolved
                key = f"{module}:{name}"
                if key in seen:
                    continue
                seen.add(key)
                comps.append(parse_component(path, gallery, name=name, module=module))
            for header_name in decl.source_headers:
                header = directory / header_name
                if not header.is_file():
                    continue
                cpp = parse_cpp_component(header, module, gallery)
                if cpp is None:
                    continue
                key = f"{module}:{cpp.name}"
                if key in seen:
                    continue
                seen.add(key)
                comps.append(cpp)

    comps.sort(key=lambda c: (c.module, c.name.lower()))
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
        f"**Category:** {c.category} · **Library:** v{version}"
        + (" · **C++ type**" if c.kind == "cpp" else "")
        + (" · **singleton**" if c.singleton else ""),
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
    if not c.internal and c.kind == "qml":
        out.append(
            "**Python:** same QML type after `qwinui3.setup_engine()` — "
            "[Python API](../python-api.md)."
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
        "*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*",
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
        f"Library **v{version}**. Generated from CMake ``QML_FILES`` + C++ "
        f"``QML_ELEMENT`` types (`scripts/generate_component_docs.py`).",
        f"Each control has its own page under `{rel_dir}/`.",
        "",
        "```bash",
        "python scripts/generate_component_docs.py",
        "python scripts/generate_component_docs.py --lint",
        "python scripts/generate_component_docs.py --skip-python",
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
            badge = ""
            if c.gallery_page:
                badge += " · Gallery"
            if c.kind == "cpp":
                badge += " · C++"
            if c.singleton:
                badge += " · singleton"
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


# --- Python package API (PySide6 / PyQt6) ------------------------------------


@dataclass
class PyFunction:
    name: str
    signature: str
    summary: str
    module: str
    package: str


@dataclass
class PyClass:
    name: str
    summary: str
    module: str
    package: str
    methods: list[tuple[str, str, str]] = field(default_factory=list)
    qml_import: str = ""
    qml_singleton: bool = False
    qml_element: bool = False

    @property
    def is_qml_type(self) -> bool:
        return self.qml_element or self.qml_singleton


@dataclass
class PyModule:
    name: str
    package: str
    path: Path
    summary: str
    functions: list[PyFunction] = field(default_factory=list)
    classes: list[PyClass] = field(default_factory=list)
    constants: list[tuple[str, str]] = field(default_factory=list)

    @property
    def rel_path(self) -> str:
        return self.path.relative_to(ROOT).as_posix()


@dataclass
class PyPackage:
    name: str
    title: str
    summary: str
    path: Path
    modules: list[PyModule] = field(default_factory=list)
    internal_modules: list[str] = field(default_factory=list)


def _decorator_name(node: ast.expr) -> str:
    if isinstance(node, ast.Name):
        return node.id
    if isinstance(node, ast.Attribute):
        return node.attr
    if isinstance(node, ast.Call):
        return _decorator_name(node.func)
    return ""


def _func_signature(node: ast.FunctionDef | ast.AsyncFunctionDef) -> str:
    args = node.args
    parts: list[str] = []
    pos_only = args.posonlyargs
    defaults = [None] * (len(args.args) - len(args.defaults)) + list(args.defaults)
    for i, arg in enumerate(args.args):
        if arg.arg in ("self", "cls"):
            continue
        part = arg.arg
        if defaults[i] is not None:
            part += "=…"
        parts.append(part)
    if args.vararg:
        parts.append(f"*{args.vararg.arg}")
    for arg in args.kwonlyargs:
        parts.append(arg.arg)
    if args.kwarg:
        parts.append(f"**{args.kwarg.arg}")
    return f"{node.name}({', '.join(parts)})"


def _first_line(doc: str | None) -> str:
    if not doc:
        return ""
    for line in doc.strip().splitlines():
        s = line.strip()
        if s:
            return s
    return ""


def _qml_import_from_source(text: str) -> str:
    m = re.search(r'QML_IMPORT_NAME\s*=\s*"([^"]+)"', text)
    if not m:
        return ""
    major = re.search(r"QML_IMPORT_MAJOR_VERSION\s*=\s*(\d+)", text)
    minor = re.search(r"QML_IMPORT_MINOR_VERSION\s*=\s*(\d+)", text)
    ver = ""
    if major:
        ver = major.group(1)
        if minor:
            ver += f".{minor.group(1)}"
    return f"{m.group(1)} {ver}".strip()


def parse_python_file(path: Path, package: str) -> PyModule:
    text = path.read_text(encoding="utf-8")
    tree = ast.parse(text)
    mod_name = path.stem
    summary = _first_line(ast.get_docstring(tree))
    qml_import = _qml_import_from_source(text)
    mod = PyModule(name=mod_name, package=package, path=path, summary=summary)

    for node in tree.body:
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id.isupper():
                    mod.constants.append((target.id, "constant"))
            continue
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            if node.name.startswith("_"):
                continue
            mod.functions.append(
                PyFunction(
                    name=node.name,
                    signature=_func_signature(node),
                    summary=_first_line(ast.get_docstring(node)),
                    module=mod_name,
                    package=package,
                )
            )
            continue
        if isinstance(node, ast.ClassDef):
            decos = {_decorator_name(d) for d in node.decorator_list}
            qml_element = "QmlElement" in decos
            qml_singleton = "QmlSingleton" in decos
            methods: list[tuple[str, str, str]] = []
            for item in node.body:
                if isinstance(item, (ast.FunctionDef, ast.AsyncFunctionDef)):
                    if item.name.startswith("_") and item.name not in ("create",):
                        continue
                    methods.append(
                        (
                            _func_signature(item),
                            _first_line(ast.get_docstring(item)),
                            "slot" if "Slot" in {_decorator_name(d) for d in item.decorator_list} else "method",
                        )
                    )
                elif isinstance(item, ast.Assign):
                    for target in item.targets:
                        if isinstance(target, ast.Name) and isinstance(item.value, ast.Call):
                            fn = _decorator_name(item.value.func)
                            if fn == "Property":
                                prop_name = target.id
                                methods.append((f"property {prop_name}", "", "property"))
            mod.classes.append(
                PyClass(
                    name=node.name,
                    summary=_first_line(ast.get_docstring(node)),
                    module=mod_name,
                    package=package,
                    methods=methods,
                    qml_import=qml_import,
                    qml_singleton=qml_singleton,
                    qml_element=qml_element,
                )
            )
    return mod


def collect_python_packages() -> list[PyPackage]:
    out: list[PyPackage] = []
    for spec in PYTHON_PACKAGES:
        pkg_dir = Path(str(spec["path"]))
        pkg_name = str(spec["name"])
        pkg = PyPackage(
            name=pkg_name,
            title=str(spec["title"]),
            summary=str(spec["summary"]),
            path=pkg_dir,
            internal_modules=[str(x) for x in spec.get("internal_modules", [])],
        )
        for mod_stem in spec["modules"]:  # type: ignore[index]
            mod_path = pkg_dir / ("__init__.py" if mod_stem == "__init__" else f"{mod_stem}.py")
            if mod_path.is_file():
                pkg.modules.append(parse_python_file(mod_path, pkg_name))
        out.append(pkg)
    return out


def render_python_package_page(pkg: PyPackage, version: str) -> str:
    rel = pkg.path.relative_to(ROOT).as_posix()
    lines = [
        f"# `{pkg.title}`",
        "",
        pkg.summary,
        "",
        f"Source: [`{rel}/`](https://github.com/wuyijing-dev/QWinui3/tree/master/{rel}) · "
        f"Library **v{version}** · "
        "[← Python API index](../python-api.md)",
        "",
        "Install:",
        "",
        "```bash",
        "pip install qwinui3[pyside6]   # or PyQt6 + QWINUI3_QT_BINDING=pyqt6",
        "```",
        "",
    ]
    if pkg.name == "qwinui3":
        lines += [
            "## Quick start",
            "",
            "```python",
            "from qwinui3 import (",
            "    configure_environment, configure_application, setup_engine,",
            "    QtGui, QtQml,",
            ")",
            "",
            "configure_environment()  # before QGuiApplication",
            "app = QtGui.QGuiApplication([])",
            "configure_application(\"org.example.app\")",
            "engine = QtQml.QQmlApplicationEngine()",
            "setup_engine(engine)",
            "engine.load(\"Main.qml\")",
            "app.exec()",
            "```",
            "",
            "QML controls (`QWinUI3.Theme`, `QWinUI3.Extras`, …) load from the shared kit "
            "after `setup_engine()`. See [Component API](../components.md) for every control.",
            "",
        ]
    elif pkg.name == "qwinui3_gallery":
        lines += [
            "## Gallery entry",
            "",
            "```bash",
            "qwinui3-gallery",
            "python -m qwinui3_gallery --smoke",
            "```",
            "",
            "Stages `src/gallery` into a filesystem `QWinUI3.Gallery` module and registers "
            "Python `@QmlElement` types (`GraphicsBackend`, `GalleryLanguage`, `DemoTreeModel`).",
            "",
        ]

    for mod in pkg.modules:
        src_url = f"https://github.com/wuyijing-dev/QWinui3/blob/master/{mod.rel_path}"
        lines += [f"## `{mod.name}`", "", f"[`{mod.rel_path}`]({src_url})", ""]
        if mod.summary:
            lines += [mod.summary, ""]
        if mod.functions:
            lines += ["### Functions", ""]
            rows = [[f"`{f.signature}`", f.summary.replace("|", "\\|") or "—"] for f in mod.functions]
            lines.extend(_md_table(["Signature", "Description"], rows))
            lines.append("")
        if mod.classes:
            lines += ["### Types", ""]
            for cls in mod.classes:
                badge = ""
                if cls.is_qml_type:
                    kind = "singleton" if cls.qml_singleton else "type"
                    badge = f" · QML {kind} · `{cls.qml_import}`" if cls.qml_import else f" · QML {kind}"
                lines += [f"#### `{cls.name}`{badge}", ""]
                if cls.summary:
                    lines += [cls.summary, ""]
                if cls.methods:
                    rows = [
                        [f"`{sig}`", kind, doc.replace("|", "\\|") if doc else "—"]
                        for sig, doc, kind in cls.methods
                    ]
                    lines.extend(_md_table(["Member", "Kind", "Description"], rows))
                    lines.append("")

    if pkg.internal_modules:
        lines += ["## Internal modules", ""]
        lines.append(
            "Not part of the stable consumer surface: "
            + ", ".join(f"`{m}`" for m in pkg.internal_modules)
            + "."
        )
        lines.append("")

    lines += [
        "---",
        "*Generated from `python/` sources by `scripts/generate_component_docs.py` — do not edit by hand.*",
        "",
    ]
    return "\n".join(lines)


def render_python_index(packages: list[PyPackage], version: str) -> str:
    fn_count = sum(len(m.functions) for p in packages for m in p.modules)
    cls_count = sum(len(m.classes) for p in packages for m in p.modules)
    qml_types = [
        c.name
        for p in packages
        for m in p.modules
        for c in m.classes
        if c.is_qml_type
    ]

    lines = [
        "# Python API (PySide6 / PyQt6)",
        "",
        f"Library **v{version}**. Python packages that load the **same QML controls** as C++ "
        "apps — shared kit (`qml/` + native plugins) + bootstrap helpers.",
        "",
        "Related: [packaging-python.md](packaging-python.md) · "
        "[Component API](components.md) · "
        "[Getting started](getting-started.md).",
        "",
        "```bash",
        "python scripts/generate_component_docs.py",
        "```",
        "",
        f"**{len(packages)}** packages · **{fn_count}** functions · "
        f"**{cls_count}** classes · **{len(qml_types)}** QML-registered types.",
        "",
        "## Packages",
        "",
    ]
    for pkg in packages:
        slug = pkg.name.replace("_", "-")
        lines += [
            f"### [`{pkg.title}`](python/{slug}.md)",
            "",
            pkg.summary,
            "",
            f"Modules: {', '.join(f'`{m.name}`' for m in pkg.modules)}.",
            "",
        ]

    if qml_types:
        lines += ["## QML types registered from Python", ""]
        lines.append(
            "Gallery helpers — import in QML as `QWinUI3.Gallery 1.0` after "
            "`qwinui3_gallery.types.register_types(engine)`:"
        )
        lines.append("")
        for name in qml_types:
            lines.append(f"- `{name}`")
        lines.append("")

    lines += [
        "## QML controls from Python",
        "",
        "All public controls documented under [components.md](components.md) work unchanged "
        "from Python: call `setup_engine(engine)` then `import QWinUI3.Extras` (etc.) in your `.qml`.",
        "",
        "---",
        "*Generated by `scripts/generate_component_docs.py` — do not edit by hand.*",
        "",
    ]
    return "\n".join(lines)


def write_python_docs(
    packages: list[PyPackage],
    index_path: Path,
    outdir: Path,
    json_path: Path | None,
    version: str,
) -> None:
    outdir.mkdir(parents=True, exist_ok=True)
    wanted: set[str] = set()
    for pkg in packages:
        slug = f"{pkg.name.replace('_', '-')}.md"
        wanted.add(slug)
        (outdir / slug).write_text(
            render_python_package_page(pkg, version),
            encoding="utf-8",
            newline="\n",
        )
    for old in outdir.glob("*.md"):
        if old.name not in wanted:
            old.unlink()
    index_path.parent.mkdir(parents=True, exist_ok=True)
    index_path.write_text(
        render_python_index(packages, version), encoding="utf-8", newline="\n"
    )
    if json_path:
        payload = {
            "name": "QWinUI3 Python",
            "version": version,
            "generatedBy": "scripts/generate_component_docs.py",
            "packages": [
                {
                    "name": p.name,
                    "summary": p.summary,
                    "doc": f"python/{p.name.replace('_', '-')}.md",
                    "modules": [m.name for m in p.modules],
                    "qmlTypes": [
                        c.name
                        for m in p.modules
                        for c in m.classes
                        if c.is_qml_type
                    ],
                }
                for p in packages
            ],
        }
        json_path.parent.mkdir(parents=True, exist_ok=True)
        json_path.write_text(
            json.dumps(payload, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
            newline="\n",
        )


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
    ap.add_argument(
        "--skip-qml",
        action="store_true",
        help="Skip QML/C++ component pages (Python docs only)",
    )
    ap.add_argument(
        "--skip-python",
        action="store_true",
        help="Skip Python package API pages",
    )
    ap.add_argument(
        "--python-index",
        type=Path,
        default=ROOT / "docs" / "python-api.md",
        help="Python API index markdown path",
    )
    ap.add_argument(
        "--python-outdir",
        type=Path,
        default=ROOT / "docs" / "python",
        help="Directory for per-package Python markdown files",
    )
    ap.add_argument(
        "--python-json",
        type=Path,
        default=ROOT / "docs" / "python.json",
        help="Python API JSON catalog (empty string to skip)",
    )
    args = ap.parse_args()

    version = project_version()
    exit_code = 0

    if not args.skip_qml:
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
                exit_code = 1
            else:
                print("Lint OK")

    if not args.skip_python:
        py_pkgs = collect_python_packages()
        py_json = None if str(args.python_json) in ("", "-", "none") else args.python_json
        write_python_docs(py_pkgs, args.python_index, args.python_outdir, py_json, version)
        mod_n = sum(len(p.modules) for p in py_pkgs)
        print(
            f"Python API v{version}: wrote {args.python_index.relative_to(ROOT)} + "
            f"{mod_n} modules under {args.python_outdir.relative_to(ROOT)}"
            + (f" + {py_json.relative_to(ROOT)}" if py_json else "")
        )

    return exit_code


if __name__ == "__main__":
    sys.exit(main())
