"""Stage src/gallery QML into a filesystem QWinUI3.Gallery module for Python."""

from __future__ import annotations

import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "src" / "gallery"
STAGE_ROOT = ROOT / "examples" / "python-gallery" / ".qml-module"
MODULE_DIR = STAGE_ROOT / "QWinUI3" / "Gallery"

_SINGLETONS = {"ControlCatalog", "GalleryHistory"}
_SKIP_TYPES = {"GraphicsBackend", "GalleryLanguage", "DemoTreeModel"}
_GALLERY_IMPORT = "import QWinUI3.Gallery 1.0"


def stage_gallery_qml(src: Path | None = None, dest: Path | None = None) -> Path:
    """Copy Gallery QML from src/gallery and write qmldir. Returns import-path root."""
    source = Path(src) if src else SRC
    module_dir = Path(dest) if dest else MODULE_DIR
    if not source.is_dir():
        raise FileNotFoundError(f"Gallery QML source not found: {source}")

    module_dir.mkdir(parents=True, exist_ok=True)
    copied: list[Path] = []
    for qml in sorted(source.rglob("*.qml")):
        rel = qml.relative_to(source)
        target = module_dir / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        inject = rel.parts and rel.parts[0] == "pages"
        stale = (
            not target.is_file()
            or qml.stat().st_mtime > target.stat().st_mtime
            or qml.stat().st_size != target.stat().st_size
            or (inject and _GALLERY_IMPORT not in target.read_text(encoding="utf-8"))
        )
        if stale:
            _write_qml(qml, target, inject_import=inject)
        copied.append(rel)

    trans_src = source / "translations"
    trans_dest = module_dir / "translations"
    if trans_src.is_dir():
        trans_dest.mkdir(parents=True, exist_ok=True)
        for qm in trans_src.glob("*.qm"):
            shutil.copy2(qm, trans_dest / qm.name)

    _write_qmldir(module_dir, copied)
    return module_dir.parent.parent  # …/.qml-module


def _write_qml(src: Path, dest: Path, *, inject_import: bool) -> None:
    text = src.read_text(encoding="utf-8")
    if inject_import and _GALLERY_IMPORT not in text:
        lines = text.splitlines()
        insert_at = 0
        for i, line in enumerate(lines):
            if line.startswith("import "):
                insert_at = i + 1
            elif line.strip() and not line.strip().startswith("//"):
                break
        lines.insert(insert_at, _GALLERY_IMPORT)
        text = "\n".join(lines)
        if src.read_text(encoding="utf-8").endswith("\n"):
            text += "\n"
    dest.write_text(text, encoding="utf-8")


def _write_qmldir(module_dir: Path, qml_files: list[Path]) -> None:
    lines = [
        "module QWinUI3.Gallery",
        "depends QtQuick",
        "depends QtQuick.Controls",
        "depends QWinUI3.Theme",
        "depends QWinUI3.Platform",
        "depends QWinUI3.Extras",
        "# Python registers GraphicsBackend, GalleryLanguage, DemoTreeModel via @QmlElement.",
        "",
    ]
    for rel in qml_files:
        name = rel.stem
        if name in _SKIP_TYPES:
            continue
        rel_posix = rel.as_posix()
        if name in _SINGLETONS:
            lines.append(f"singleton {name} 1.0 {rel_posix}")
        else:
            lines.append(f"{name} 1.0 {rel_posix}")
    (module_dir / "qmldir").write_text("\n".join(lines) + "\n", encoding="utf-8")
