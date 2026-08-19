#!/usr/bin/env python3
"""Stage kit + Gallery QML into python/, sync version, and build PyPI wheels.

  python scripts/build_pypi_wheel.py
  python scripts/build_pypi_wheel.py --kit-dir dist/qwinui3-2.64-windows-x64-shared
  python scripts/build_pypi_wheel.py --skip-kit-build --upload testpypi

Requires: pip install build twine (for upload). Builds a **platform** wheel with
native QWinUI3 shared libraries — run on Windows or Linux separately.
"""

from __future__ import annotations

import argparse
import os
import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PYPROJECT = ROOT / "pyproject.toml"
KIT_DEST = ROOT / "python" / "qwinui3" / "_kit"
GALLERY_DEST = ROOT / "python" / "qwinui3_gallery" / "_gallery_qml"
PACKAGE_SCRIPT = ROOT / "scripts" / "package_release_libs.py"


def _run(cmd: list[str], *, cwd: Path | None = None) -> None:
    print("+", " ".join(cmd), flush=True)
    subprocess.check_call(cmd, cwd=str(cwd or ROOT))


def _project_version() -> str:
    text = (ROOT / "CMakeLists.txt").read_text(encoding="utf-8")
    m = re.search(r'set\s*\(\s*QWINUI3_VERSION\s+"([0-9]+\.[0-9]{2})"\s*\)', text)
    if not m:
        raise RuntimeError("Could not parse QWINUI3_VERSION from CMakeLists.txt")
    return m.group(1)


def _pypi_version(cmake_version: str) -> str:
    if cmake_version.count(".") == 1:
        return f"{cmake_version}.0"
    return cmake_version


def _sync_pyproject_version(version: str) -> None:
    text = PYPROJECT.read_text(encoding="utf-8")
    updated, n = re.subn(
        r'^version = "[^"]+"',
        f'version = "{version}"',
        text,
        count=1,
        flags=re.MULTILINE,
    )
    if n != 1:
        raise RuntimeError("Could not update version in pyproject.toml")
    PYPROJECT.write_text(updated, encoding="utf-8")
    print(f"pyproject.toml version → {version}", flush=True)


def _kit_in_dist() -> Path | None:
    dist = ROOT / "dist"
    if not dist.is_dir():
        return None
    for candidate in sorted(dist.glob("qwinui3-*-shared"), reverse=True):
        qml = candidate / "qml" / "QWinUI3"
        if qml.is_dir():
            return candidate.resolve()
    return None


def _ensure_kit(*, kit_dir: Path | None, skip_build: bool) -> Path:
    if kit_dir is not None:
        kit_dir = kit_dir.resolve()
        if not (kit_dir / "qml" / "QWinUI3").is_dir():
            raise FileNotFoundError(f"Invalid kit (missing qml/QWinUI3): {kit_dir}")
        return kit_dir
    existing = _kit_in_dist()
    if existing is not None:
        return existing
    if skip_build:
        raise FileNotFoundError(
            "No kit under dist/. Pass --kit-dir or run package_release_libs.py first."
        )
    _run([sys.executable, str(PACKAGE_SCRIPT), "--shared", "--archive"])
    existing = _kit_in_dist()
    if existing is None:
        raise RuntimeError("package_release_libs.py finished but no dist/qwinui3-*-shared found.")
    return existing


def _copy_tree(src: Path, dest: Path) -> None:
    if dest.exists():
        shutil.rmtree(dest)
    shutil.copytree(src, dest)


def _stage_kit(kit_dir: Path) -> None:
    print(f"Staging kit {kit_dir} → {KIT_DEST}", flush=True)
    _copy_tree(kit_dir, KIT_DEST)
    meta = (
        f"product={_project_version()}\n"
        f"platform={platform.system()}-{platform.machine()}\n"
        f"source={kit_dir.name}\n"
    )
    (KIT_DEST / "WHEEL.txt").write_text(meta, encoding="utf-8")


def _stage_gallery_qml() -> None:
    src = ROOT / "src" / "gallery"
    if not src.is_dir():
        raise FileNotFoundError(f"Gallery source missing: {src}")
    print(f"Staging Gallery QML {src} → {GALLERY_DEST}", flush=True)
    if GALLERY_DEST.exists():
        shutil.rmtree(GALLERY_DEST)
    GALLERY_DEST.mkdir(parents=True)

    for qml in src.rglob("*.qml"):
        rel = qml.relative_to(src)
        target = GALLERY_DEST / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(qml, target)

    trans_src = src / "translations"
    trans_dest = GALLERY_DEST / "translations"
    if trans_src.is_dir():
        trans_dest.mkdir(parents=True, exist_ok=True)
        for qm in trans_src.glob("*.qm"):
            shutil.copy2(qm, trans_dest / qm.name)


def _build_wheel() -> list[Path]:
    _run([sys.executable, "-m", "pip", "install", "--upgrade", "build", "setuptools>=68", "wheel"])
    for old in (ROOT / "dist").glob("qwinui3-*.whl"):
        old.unlink()
    _run([sys.executable, "-m", "build", "--wheel"])
    wheels = sorted((ROOT / "dist").glob("qwinui3-*.whl"), key=lambda p: p.stat().st_mtime)
    wheels = [w for w in wheels if "py3-none-any" not in w.name]
    if not wheels:
        raise RuntimeError("No platform wheel produced under dist/")
    return wheels


def _upload(wheels: list[Path], target: str) -> None:
    repo = "testpypi" if target == "testpypi" else "pypi"
    _run([sys.executable, "-m", "pip", "install", "--upgrade", "twine"])
    env = os.environ.copy()
    if target == "testpypi":
        env.setdefault("TWINE_REPOSITORY", "testpypi")
    _run([sys.executable, "-m", "twine", "upload", "--non-interactive", *[str(w) for w in wheels]], cwd=ROOT)


def main() -> int:
    parser = argparse.ArgumentParser(description="Build qwinui3 PyPI wheel with bundled kit")
    parser.add_argument("--kit-dir", type=Path, default=None, help="Existing shared kit root")
    parser.add_argument(
        "--skip-kit-build",
        action="store_true",
        help="Do not invoke package_release_libs.py; require dist/ or --kit-dir",
    )
    parser.add_argument(
        "--keep-staged",
        action="store_true",
        help="Leave python/qwinui3/_kit and _gallery_qml after build",
    )
    parser.add_argument(
        "--upload",
        choices=("testpypi", "pypi"),
        default=None,
        help="Upload built wheel(s) with twine",
    )
    args = parser.parse_args()

    version = _pypi_version(_project_version())
    _sync_pyproject_version(version)

    kit_dir = _ensure_kit(kit_dir=args.kit_dir, skip_build=args.skip_kit_build)
    _stage_kit(kit_dir)
    _stage_gallery_qml()

    wheels = _build_wheel()
    for wheel in wheels:
        print(f"Wheel → {wheel}", flush=True)

    if not args.keep_staged:
        for path in (KIT_DEST, GALLERY_DEST):
            if path.exists():
                shutil.rmtree(path)
                print(f"Removed staged {path}", flush=True)

    if args.upload:
        _upload(wheels, args.upload)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
