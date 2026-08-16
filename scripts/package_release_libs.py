#!/usr/bin/env python3
"""Package QWinUI3 Release libraries (DLL/.so + QML modules) into dist/.

Default libraries are STATIC (linked into Gallery). Pass --shared to configure
a separate build with -DQWINUI3_BUILD_SHARED=ON and collect redistributable
shared libraries + QML import trees.

Select modules on demand with --modules / --preset (dependencies are pulled in):

  python scripts/package_release_libs.py --shared --archive
  python scripts/package_release_libs.py --shared --modules theme,style
  python scripts/package_release_libs.py --shared --preset core --archive
  python scripts/package_release_libs.py --shared --preset shell --webview2 off

Requires: cmake, a Qt 6.8+ kit on CMAKE_PREFIX_PATH / Qt6_DIR / PATH.
"""

from __future__ import annotations

import argparse
import os
import platform
import re
import shutil
import subprocess
import sys
import tarfile
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "dist" / "qwinui3"

# Logical packaging units → cmake target, QML tree, dependency names, lib name stems
MODULES: dict[str, dict] = {
    "theme": {
        "target": "qwinui3_theme",
        "qml": ("QWinUI3/Theme",),
        "depends": (),
        "lib_stems": ("qwinui3_theme",),
    },
    "style": {
        "target": "qwinui3_style",
        "qml": ("QWinUI3",),  # URI QtQuick.Controls style plugin tree
        "depends": ("theme",),
        "lib_stems": ("qwinui3_style",),
    },
    "platform": {
        "target": "qwinui3_platform",
        "qml": ("QWinUI3/Platform",),
        "depends": ("theme",),
        "lib_stems": ("qwinui3_platform",),
    },
    "extras": {
        "target": "qwinui3_extras",
        "qml": ("QWinUI3/Extras",),
        "depends": ("theme",),
        "lib_stems": ("qwinui3_extras",),
    },
}

ALL_MODULES = tuple(MODULES.keys())

PRESETS: dict[str, tuple[str, ...]] = {
    "all": ALL_MODULES,
    "full": ALL_MODULES,
    "core": ("theme", "style"),
    "shell": ("theme", "style", "platform"),
    "extras": ("theme", "extras"),  # theme + extras only
    "theme": ("theme",),
    "style": ("theme", "style"),
    "platform": ("theme", "platform"),
}


def _project_version() -> str:
    text = (ROOT / "CMakeLists.txt").read_text(encoding="utf-8")
    m = re.search(r'set\s*\(\s*QWINUI3_VERSION\s+"([0-9]+\.[0-9]{2})"\s*\)', text)
    if m:
        return m.group(1)
    m = re.search(r"project\s*\(\s*QWinUI3\s+VERSION\s+([0-9]+\.[0-9]+\.[0-9]+)", text)
    if not m:
        raise RuntimeError("Could not parse QWINUI3_VERSION from CMakeLists.txt")
    return m.group(1)


def _run(cmd: list[str], cwd: Path | None = None) -> None:
    print("+", " ".join(cmd), flush=True)
    subprocess.check_call(cmd, cwd=str(cwd or ROOT))


def _detect_qt_prefix() -> str | None:
    for key in ("CMAKE_PREFIX_PATH", "Qt6_DIR", "QTDIR"):
        val = os.environ.get(key)
        if not val:
            continue
        p = Path(val)
        if p.name == "Qt6" and p.parent.name == "cmake":
            return str(p.parents[2])
        return val.split(os.pathsep)[0]
    return None


def _parse_modules(raw: str | None, preset: str | None) -> list[str]:
    selected: list[str] = []
    if preset:
        key = preset.strip().lower()
        if key not in PRESETS:
            raise SystemExit(
                f"Unknown preset {preset!r}. Choose from: {', '.join(sorted(PRESETS))}"
            )
        selected.extend(PRESETS[key])
    if raw:
        for part in re.split(r"[,;\s]+", raw.strip()):
            if not part:
                continue
            name = part.strip().lower()
            if name in ("all", "full"):
                selected.extend(ALL_MODULES)
                continue
            if name not in MODULES:
                raise SystemExit(
                    f"Unknown module {part!r}. Choose from: {', '.join(ALL_MODULES)}"
                )
            selected.append(name)
    if not selected:
        selected = list(ALL_MODULES)

    # Resolve dependencies (stable order following ALL_MODULES)
    resolved: set[str] = set()

    def add(name: str) -> None:
        if name in resolved:
            return
        for dep in MODULES[name]["depends"]:
            add(dep)
        resolved.add(name)

    for name in selected:
        add(name)

    ordered = [m for m in ALL_MODULES if m in resolved]
    print(f"Modules: {', '.join(ordered)}", flush=True)
    return ordered


def _modules_slug(modules: list[str]) -> str:
    if modules == list(ALL_MODULES):
        return "all"
    return "+".join(modules)


def _configure(
    build_dir: Path,
    shared: bool,
    qt_prefix: str | None,
    *,
    media: bool | None,
    webview2: bool | None,
) -> None:
    build_dir.mkdir(parents=True, exist_ok=True)
    cmd = [
        "cmake",
        "-S",
        str(ROOT),
        "-B",
        str(build_dir),
        "-DCMAKE_BUILD_TYPE=Release",
        f"-DQWINUI3_BUILD_SHARED={'ON' if shared else 'OFF'}",
        "-DQWINUI3_BUILD_EXAMPLES=OFF",
    ]
    if media is True:
        cmd.append("-DQWINUI3_BUILD_MEDIA=ON")
    elif media is False:
        cmd.append("-DQWINUI3_BUILD_MEDIA=OFF")
    if webview2 is True:
        cmd.append("-DQWINUI3_BUILD_WEBVIEW2=ON")
    elif webview2 is False:
        cmd.append("-DQWINUI3_BUILD_WEBVIEW2=OFF")
    if qt_prefix:
        cmd.append(f"-DCMAKE_PREFIX_PATH={qt_prefix}")
    if shutil.which("ninja"):
        cmd[1:1] = ["-G", "Ninja"]
    _run(cmd)


def _build(build_dir: Path, modules: list[str]) -> None:
    targets = [MODULES[m]["target"] for m in modules]
    cmd = ["cmake", "--build", str(build_dir), "--config", "Release"]
    jobs = os.cpu_count() or 4
    cmd.extend(["--parallel", str(jobs), "--target", *targets])
    _run(cmd)


def _is_lib_for_modules(path: Path, modules: list[str]) -> bool:
    name = path.name.lower()
    stems = []
    for m in modules:
        stems.extend(MODULES[m]["lib_stems"])
    if not any(stem in name for stem in stems):
        return False
    if name.endswith((".dll", ".dylib", ".lib", ".a")):
        return True
    if ".so" in name and (name.endswith(".so") or ".so." in name):
        return True
    return False


def _collect_files(build_dir: Path, out_dir: Path, modules: list[str]) -> list[Path]:
    lib_dir = out_dir / "lib"
    qml_dir = out_dir / "qml"
    bin_dir = out_dir / "bin"
    lib_dir.mkdir(parents=True, exist_ok=True)
    qml_dir.mkdir(parents=True, exist_ok=True)
    bin_dir.mkdir(parents=True, exist_ok=True)

    copied: list[Path] = []
    seen: set[str] = set()

    for pattern in ("**/*qwinui3*", "**/libqwinui3*", "**/QWinUI3/**"):
        for path in build_dir.glob(pattern):
            if not path.is_file() and not path.is_symlink():
                continue
            if not _is_lib_for_modules(path, modules):
                continue
            key = path.name
            if key in seen:
                continue
            seen.add(key)
            dest = lib_dir / path.name
            if path.is_symlink():
                try:
                    dest.symlink_to(os.readlink(path))
                except OSError:
                    shutil.copy2(path, dest, follow_symlinks=True)
            else:
                shutil.copy2(path, dest)
            copied.append(dest)
            if path.suffix.lower() == ".dll":
                bdest = bin_dir / path.name
                shutil.copy2(path, bdest)
                copied.append(bdest)

    qml_rels: list[str] = []
    for m in modules:
        qml_rels.extend(MODULES[m]["qml"])

    for module_rel in qml_rels:
        # Style URI tree is "QWinUI3" but must not steal QWinUI3/Theme etc.
        if module_rel == "QWinUI3":
            candidates = [
                p
                for p in build_dir.glob("**/QWinUI3/qmldir")
                if p.parent.name == "QWinUI3"
                and (p.parent / "Button.qml").exists()  # style controls
            ]
        else:
            candidates = list(build_dir.glob(f"**/{module_rel}/qmldir"))
        candidates.sort(key=lambda p: ("src" not in str(p), len(str(p))))
        if not candidates:
            print(f"WARNING: QML tree not found for {module_rel}", file=sys.stderr)
            continue
        src_root = candidates[0].parent
        dest_root = qml_dir / module_rel.replace("/", os.sep)
        if dest_root.exists():
            shutil.rmtree(dest_root)
        shutil.copytree(
            src_root,
            dest_root,
            ignore=shutil.ignore_patterns(
                "*.obj", "*.o", "*.pdb", "CMakeFiles", "*.cmake", "Makefile*"
            ),
        )
        copied.append(dest_root)

    return copied


def _write_readme(
    out_dir: Path,
    shared: bool,
    modules: list[str],
    *,
    media: bool | None,
    webview2: bool | None,
) -> None:
    host = platform.system()
    qml_list = []
    for m in modules:
        qml_list.extend(MODULES[m]["qml"])
    feature_bits = []
    if media is True:
        feature_bits.append("media=ON")
    elif media is False:
        feature_bits.append("media=OFF")
    if webview2 is True:
        feature_bits.append("webview2=ON")
    elif webview2 is False:
        feature_bits.append("webview2=OFF")
    features = (", ".join(feature_bits) if feature_bits else "defaults")

    text = f"""# QWinUI3 Release package

Build type: Release
Host: {host}
Library type: {"SHARED (DLL/.so)" if shared else "STATIC (.lib/.a)"}
Modules: {", ".join(modules)}
Features: {features}

## Layout

- `bin/` — runtime DLLs (Windows shared builds)
- `lib/` — import / static / shared libraries and plugins
- `qml/` — QML modules ({", ".join(f"`{q}`" for q in qml_list)})

## Consumer notes

1. Add `qml/` to `QML_IMPORT_PATH` (or copy beside your app and set `QML2_IMPORT_PATH`).
2. Link against the selected `qwinui3_*` libraries (and `*plugin` when STATIC).
3. On Linux shared builds, add `lib/` to `LD_LIBRARY_PATH` (or set `rpath`).
4. Qt 6.8+ required: Quick, QuickControls2, LabsQmlModels.
5. License: **LGPL-3.0** (see `LICENSE` and `COPYING` in this package).

### On-demand packaging

```bash
# Full kit (default)
python scripts/package_release_libs.py --shared --archive

# Theme + Quick Controls style only
python scripts/package_release_libs.py --shared --preset core --archive

# Theme + style + platform shells
python scripts/package_release_libs.py --shared --preset shell --archive

# Explicit list (deps auto-included)
python scripts/package_release_libs.py --shared --modules platform,extras --archive

# Feature toggles
python scripts/package_release_libs.py --shared --modules platform --webview2 off --archive
```

Presets: {", ".join(sorted(PRESETS))}
Modules: {", ".join(ALL_MODULES)}
"""
    (out_dir / "README.md").write_text(text, encoding="utf-8")
    for name in ("LICENSE", "COPYING"):
        src = ROOT / name
        if src.is_file():
            shutil.copy2(src, out_dir / name)


def _archive(out_dir: Path, archive: Path) -> None:
    if archive.exists():
        archive.unlink()
    archive.parent.mkdir(parents=True, exist_ok=True)
    if archive.name.endswith(".tar.gz"):
        with tarfile.open(archive, "w:gz") as tf:
            tf.add(out_dir, arcname=out_dir.name)
    else:
        with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for path in out_dir.rglob("*"):
                if path.is_file():
                    zf.write(path, arcname=str(Path(out_dir.name) / path.relative_to(out_dir)))


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--shared",
        action="store_true",
        help="Configure -DQWINUI3_BUILD_SHARED=ON (emit DLL/.so)",
    )
    parser.add_argument(
        "--modules",
        default=None,
        help=f"Comma-separated modules to package: {', '.join(ALL_MODULES)} (default: all)",
    )
    parser.add_argument(
        "--preset",
        default=None,
        help=f"Module preset: {', '.join(sorted(PRESETS))} (merged with --modules)",
    )
    parser.add_argument(
        "--list-modules",
        action="store_true",
        help="Print available modules/presets and exit",
    )
    parser.add_argument(
        "--media",
        choices=("on", "off"),
        default=None,
        help="Force QWINUI3_BUILD_MEDIA on/off (default: CMake auto)",
    )
    parser.add_argument(
        "--webview2",
        choices=("on", "off"),
        default=None,
        help="Force QWINUI3_BUILD_WEBVIEW2 on/off (default: CMake auto)",
    )
    parser.add_argument(
        "--build-dir",
        type=Path,
        default=None,
        help="CMake build directory (default: build or build-shared-release)",
    )
    parser.add_argument(
        "--out",
        type=Path,
        default=DEFAULT_OUT,
        help=f"Output directory (default: versioned under dist/)",
    )
    parser.add_argument(
        "--no-build",
        action="store_true",
        help="Skip configure/build; only collect from --build-dir",
    )
    parser.add_argument(
        "--qt-prefix",
        default=None,
        help="CMAKE_PREFIX_PATH for Qt (default: env CMAKE_PREFIX_PATH/Qt6_DIR/QTDIR)",
    )
    parser.add_argument(
        "--version",
        default=None,
        help="Version string for archive name (default: CMake project VERSION)",
    )
    parser.add_argument(
        "--archive",
        action="store_true",
        help="Also create a zip (Windows) or tar.gz (elsewhere) under dist/",
    )
    args = parser.parse_args()

    if args.list_modules:
        print("Modules:")
        for name, info in MODULES.items():
            deps = ", ".join(info["depends"]) or "(none)"
            print(f"  {name:10} target={info['target']}  depends={deps}")
        print("\nPresets:")
        for name, mods in sorted(PRESETS.items()):
            print(f"  {name:10} → {', '.join(mods)}")

        return 0

    modules = _parse_modules(args.modules, args.preset)
    version = args.version or _project_version()
    build_dir = args.build_dir
    if build_dir is None:
        build_dir = ROOT / ("build-shared-release" if args.shared else "build")
    build_dir = build_dir.resolve()

    host = platform.system().lower()
    plat = "windows" if host.startswith("win") else "linux"
    arch = "x64"
    kind = "shared" if args.shared else "static"
    slug = _modules_slug(modules)
    # Keep full-kit names stable for CI/releases; suffix only for subsets.
    if slug == "all":
        default_name = f"qwinui3-{version}-{plat}-{arch}-{kind}"
    else:
        default_name = f"qwinui3-{version}-{plat}-{arch}-{kind}-{slug}"

    out_dir = args.out.resolve()
    if args.out == DEFAULT_OUT:
        out_dir = (ROOT / "dist" / default_name).resolve()

    qt_prefix = args.qt_prefix or _detect_qt_prefix()

    media_flag = None if args.media is None else (args.media == "on")
    webview2_flag = None if args.webview2 is None else (args.webview2 == "on")

    if not args.no_build:
        _configure(
            build_dir,
            args.shared,
            qt_prefix,
            media=media_flag,
            webview2=webview2_flag,
        )
        _build(build_dir, modules)

    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    copied = _collect_files(build_dir, out_dir, modules)
    _write_readme(
        out_dir,
        args.shared,
        modules,
        media=media_flag,
        webview2=webview2_flag,
    )

    print(f"\nPackaged {len(copied)} items → {out_dir}")
    if args.shared:
        has_dll = any(p.suffix.lower() == ".dll" for p in out_dir.joinpath("bin").glob("*") if p.is_file())
        has_so = list(out_dir.joinpath("lib").glob("*.so*"))
        if not has_dll and not has_so:
            print(
                "WARNING: no DLL/.so found. Shared plugins may live under build/; "
                "inspect lib/ and qml/.",
                file=sys.stderr,
            )

    if args.archive:
        if plat == "windows":
            archive = ROOT / "dist" / f"{default_name}.zip"
        else:
            archive = ROOT / "dist" / f"{default_name}.tar.gz"
        _archive(out_dir, archive)
        print(f"Archive → {archive}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
