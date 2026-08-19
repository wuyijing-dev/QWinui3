"""Filesystem layout helpers for repo checkout vs pip-installed wheel."""

from __future__ import annotations

import os
from pathlib import Path

_PKG = Path(__file__).resolve().parent


def package_dir() -> Path:
    """Directory containing the installed `qwinui3` package."""
    return _PKG


def repo_root() -> Path | None:
    """Monorepo root when running from a git checkout."""
    for parent in (_PKG, *_PKG.parents):
        if (parent / "CMakeLists.txt").is_file() and (parent / "src" / "gallery").is_dir():
            return parent
    return None


def bundled_kit_dir() -> Path | None:
    """Shared kit copied into the wheel at build time (`qwinui3/_kit/`)."""
    kit = _PKG / "_kit"
    if _kit_looks_valid(kit):
        return kit.resolve()
    return None


def dist_kit_dirs() -> list[Path]:
    """Versioned shared kits under `dist/` (repo development only)."""
    root = repo_root()
    if root is None:
        return []
    dist = root / "dist"
    if not dist.is_dir():
        return []
    return [
        p.resolve()
        for p in sorted(dist.glob("qwinui3-*-shared"), reverse=True)
        if _kit_looks_valid(p)
    ]


def _kit_looks_valid(kit: Path) -> bool:
    qml = kit / "qml"
    if (qml / "QWinUI3").is_dir() and (
        (qml / "QWinUI3" / "Theme").is_dir() or (qml / "QWinUI3" / "qmldir").is_file()
    ):
        return True
    if (kit / "src" / "theme").is_dir() or any(kit.glob("qwinui3_theme.dll")) or any(
        kit.glob("libqwinui3_theme.so*")
    ):
        return True
    return False
