"""Stage Gallery QML into a filesystem QWinUI3.Gallery module for Python."""

from __future__ import annotations

import os
import shutil
import sys
from pathlib import Path

from qwinui3._paths import repo_root

_PKG = Path(__file__).resolve().parent
_BUNDLED_SRC = _PKG / "_gallery_qml"
_GALLERY_IMPORT = "import QWinUI3.Gallery 1.0"

_SINGLETONS = {"ControlCatalog", "GalleryHistory"}
_SKIP_TYPES = {"GraphicsBackend", "GalleryLanguage", "DemoTreeModel"}

_module_dir: Path | None = None


def gallery_qml_source() -> Path:
    """Bundled wheel copy, or repo `src/gallery`."""
    if _BUNDLED_SRC.is_dir():
        return _BUNDLED_SRC
    root = repo_root()
    if root is not None:
        src = root / "src" / "gallery"
        if src.is_dir():
            return src
    raise FileNotFoundError(
        "Gallery QML source not found. Install qwinui3 from PyPI or run from the repo checkout."
    )


def default_stage_root() -> Path:
    """Where to materialize the QWinUI3.Gallery import tree."""
    root = repo_root()
    if root is not None:
        return root / "examples" / "python-gallery" / ".qml-module"
    override = os.environ.get("QWINUI3_GALLERY_CACHE", "").strip()
    if override:
        return Path(override)
    if sys.platform == "win32":
        base = os.environ.get("LOCALAPPDATA") or str(Path.home() / "AppData" / "Local")
    else:
        base = os.environ.get("XDG_CACHE_HOME") or str(Path.home() / ".cache")
    return Path(base) / "qwinui3" / "gallery-qml-module"


def gallery_module_dir(stage_root: Path | None = None) -> Path:
    root = stage_root or default_stage_root()
    return root / "QWinUI3" / "Gallery"


def get_module_dir() -> Path:
    """Module directory after `stage_gallery_qml()` (or the default path)."""
    return _module_dir if _module_dir is not None else gallery_module_dir()


def stage_gallery_qml(src: Path | None = None, dest: Path | None = None) -> Path:
    """Copy Gallery QML and write qmldir. Returns import-path root."""
    global _module_dir
    source = Path(src) if src else gallery_qml_source()
    stage_root = dest.parent.parent if dest else default_stage_root()
    module_dir = Path(dest) if dest else gallery_module_dir(stage_root)
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
    _module_dir = module_dir
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
