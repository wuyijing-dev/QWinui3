#!/usr/bin/env python3
"""Package the QWinUI3 Gallery with a redistributable Qt runtime.

Linux: linuxdeploy + linuxdeploy-plugin-qt → AppDir → .tar.gz
Windows: windeployqt → folder → .zip

Examples:

  python scripts/package_release_gallery.py
  python scripts/package_release_gallery.py --version 1.0.0 --out dist
  python scripts/package_release_gallery.py --no-build --build-dir build

Requires: cmake, Ninja (preferred), Qt 6.8+ on PATH / CMAKE_PREFIX_PATH.
Linux also downloads linuxdeploy tools into the build cache when missing.
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
import urllib.request
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "dist"
LINUXDEPLOY = "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
LINUXDEPLOY_QT = (
    "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/"
    "continuous/linuxdeploy-plugin-qt-x86_64.AppImage"
)


def _run(cmd: list[str], cwd: Path | None = None, env: dict | None = None) -> None:
    print("+", " ".join(cmd), flush=True)
    merged = os.environ.copy()
    if env:
        merged.update(env)
    subprocess.check_call(cmd, cwd=str(cwd or ROOT), env=merged)


def _detect_qt_prefix() -> str | None:
    for key in ("CMAKE_PREFIX_PATH", "Qt6_DIR", "QTDIR"):
        val = os.environ.get(key)
        if not val:
            continue
        p = Path(val.split(os.pathsep)[0])
        if p.name == "Qt6" and p.parent.name == "cmake":
            return str(p.parents[2])
        return str(p)
    for tool in ("qtpaths6", "qtpaths", "qmake6", "qmake"):
        exe = shutil.which(tool)
        if not exe:
            continue
        try:
            if "qmake" in tool:
                out = subprocess.check_output([exe, "-query", "QT_INSTALL_PREFIX"], text=True)
            else:
                out = subprocess.check_output([exe, "--install-prefix"], text=True)
            prefix = out.strip()
            if prefix:
                return prefix
        except subprocess.CalledProcessError:
            continue
    return None


def _project_version() -> str:
    text = (ROOT / "CMakeLists.txt").read_text(encoding="utf-8")
    m = re.search(r'set\s*\(\s*QWINUI3_VERSION\s+"([0-9]+\.[0-9]{2})"\s*\)', text)
    if m:
        return m.group(1)
    m = re.search(r"project\s*\(\s*QWinUI3\s+VERSION\s+([0-9]+\.[0-9]+\.[0-9]+)", text)
    if not m:
        raise RuntimeError("Could not parse QWINUI3_VERSION from CMakeLists.txt")
    return m.group(1)


def _configure_and_build(build_dir: Path, qt_prefix: str | None) -> None:
    build_dir.mkdir(parents=True, exist_ok=True)
    cmd = [
        "cmake",
        "-S",
        str(ROOT),
        "-B",
        str(build_dir),
        "-DCMAKE_BUILD_TYPE=Release",
        "-DQWINUI3_BUILD_SHARED=OFF",
        "-DQWINUI3_BUILD_EXAMPLES=OFF",
        "-DQWINUI3_BUILD_WEBVIEW2=OFF",
    ]
    if qt_prefix:
        cmd.append(f"-DCMAKE_PREFIX_PATH={qt_prefix}")
    if shutil.which("ninja"):
        cmd[1:1] = ["-G", "Ninja"]
    _run(cmd)
    jobs = str(os.cpu_count() or 4)
    _run(
        [
            "cmake",
            "--build",
            str(build_dir),
            "--config",
            "Release",
            "--parallel",
            jobs,
            "--target",
            "qwinui3_gallery",
            "publish_qwinui3_gallery",
        ]
    )


def _find_gallery_binary(build_dir: Path) -> Path:
    names = ("qwinui3_gallery.exe", "qwinui3_gallery")
    candidates = [
        build_dir / names[0],
        build_dir / names[1],
        build_dir / "src" / "gallery" / names[0],
        build_dir / "src" / "gallery" / names[1],
        build_dir / "bin" / names[0],
        build_dir / "bin" / names[1],
    ]
    for c in candidates:
        if c.is_file():
            return c
    found = list(build_dir.rglob("qwinui3_gallery.exe")) + list(build_dir.rglob("qwinui3_gallery"))
    found = [p for p in found if p.is_file()]
    if not found:
        raise FileNotFoundError(f"qwinui3_gallery not found under {build_dir}")
    return found[0]


def _strip_restricted(stage: Path) -> None:
    dirs = [
        "qml/QtQuick/VirtualKeyboard",
        "qml/QtQuick/Scene2D",
        "qml/QtQuick/Scene3D",
        "qml/QtCharts",
        "qml/QtDataVisualization",
        "qml/QtWebEngine",
        "qml/QtWebView",
        "qml/QtQuick3D",
        "qml/QtGraphs",
        "usr/qml/QtQuick/VirtualKeyboard",
        "usr/qml/QtQuick/Scene2D",
        "usr/qml/QtQuick/Scene3D",
        "usr/qml/QtCharts",
        "usr/qml/QtDataVisualization",
        "usr/qml/QtWebEngine",
        "usr/qml/QtWebView",
        "usr/qml/QtQuick3D",
        "usr/qml/QtGraphs",
    ]
    files = [
        "Qt6VirtualKeyboard.dll",
        "Qt6VirtualKeyboardQml.dll",
        "Qt6Charts.dll",
        "Qt6Quick3D.dll",
        "Qt6Quick3DUtils.dll",
        "platforminputcontexts/qtvirtualkeyboardplugin.dll",
        "libQt6VirtualKeyboard.so",
        "libQt6VirtualKeyboardQml.so",
        "libQt6Charts.so",
        "libQt6Quick3D.so",
        "libQt6Quick3DUtils.so",
        "plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so",
        "usr/lib/libQt6VirtualKeyboard.so*",
        "usr/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so",
    ]
    for rel in dirs:
        p = stage / rel
        if p.exists():
            shutil.rmtree(p)
    for pattern in files:
        if "*" in pattern:
            for p in stage.glob(pattern):
                if p.is_file() or p.is_symlink():
                    p.unlink()
            # also under usr/
            for p in stage.glob(f"usr/{pattern}" if not pattern.startswith("usr/") else pattern):
                if p.is_file() or p.is_symlink():
                    p.unlink()
        else:
            p = stage / pattern
            if p.is_file():
                p.unlink()


def _download(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.is_file() and dest.stat().st_size > 0:
        return
    print(f"Downloading {url} → {dest}", flush=True)
    urllib.request.urlretrieve(url, dest)
    dest.chmod(dest.stat().st_mode | 0o111)


def _write_desktop(appdir: Path) -> Path:
    apps = appdir / "usr" / "share" / "applications"
    apps.mkdir(parents=True, exist_ok=True)
    desktop = apps / "qwinui3_gallery.desktop"
    desktop.write_text(
        "\n".join(
            [
                "[Desktop Entry]",
                "Type=Application",
                "Name=QWinUI3 Gallery",
                "Comment=Fluent / WinUI 3 control catalog for Qt Quick",
                "Exec=qwinui3_gallery",
                "Icon=qwinui3_gallery",
                "Categories=Development;Qt;",
                "Terminal=false",
                "",
            ]
        ),
        encoding="utf-8",
    )
    return desktop


def _write_icon(appdir: Path) -> Path:
    # Minimal placeholder PNG is optional; linuxdeploy accepts missing icon with --icon-file skip.
    icons = appdir / "usr" / "share" / "icons" / "hicolor" / "256x256" / "apps"
    icons.mkdir(parents=True, exist_ok=True)
    icon = icons / "qwinui3_gallery.png"
    if not icon.is_file():
        # 1x1 transparent PNG
        icon.write_bytes(
            bytes.fromhex(
                "89504e470d0a1a0a0000000d49484452000000010000000108060000001f15c489"
                "0000000a49444154789c63000100000500010d0a2db40000000049454e44ae426082"
            )
        )
    return icon


def _package_linux(build_dir: Path, stage: Path, qt_prefix: str | None) -> None:
    if stage.exists():
        shutil.rmtree(stage)
    appdir = stage / "AppDir"
    appdir.mkdir(parents=True)

    binary = _find_gallery_binary(build_dir)
    cache = ROOT / ".cache" / "linuxdeploy"
    ld = cache / "linuxdeploy-x86_64.AppImage"
    ldqt = cache / "linuxdeploy-plugin-qt-x86_64.AppImage"
    _download(LINUXDEPLOY, ld)
    _download(LINUXDEPLOY_QT, ldqt)

    desktop = _write_desktop(appdir)
    icon = _write_icon(appdir)

    env = {
        "APPIMAGE_EXTRACT_AND_RUN": "1",
        "QML_SOURCES_PATHS": str(ROOT / "src"),
        "EXTRA_QT_PLUGINS": "platforms;xcbglintegrations;imageformats;iconengines;tls;networkinformation;generic",
    }
    if qt_prefix:
        env["QMAKE"] = str(Path(qt_prefix) / "bin" / "qmake")
        if not Path(env["QMAKE"]).is_file():
            env["QMAKE"] = str(Path(qt_prefix) / "bin" / "qmake6")
        lib_dir = Path(qt_prefix) / "lib"
        if lib_dir.is_dir():
            env["LD_LIBRARY_PATH"] = f"{lib_dir}{os.pathsep}{os.environ.get('LD_LIBRARY_PATH', '')}"

    # Seed binary into AppDir usr/bin
    usr_bin = appdir / "usr" / "bin"
    usr_bin.mkdir(parents=True, exist_ok=True)
    staged_bin = usr_bin / "qwinui3_gallery"
    shutil.copy2(binary, staged_bin)
    staged_bin.chmod(staged_bin.stat().st_mode | 0o111)

    _run(
        [
            str(ld),
            "--appimage-extract-and-run",
            f"--appdir={appdir}",
            f"--executable={staged_bin}",
            f"--desktop-file={desktop}",
            f"--icon-file={icon}",
            "--plugin=qt",
        ],
        env=env,
    )

    _strip_restricted(appdir)

    # Portable launcher
    run_sh = stage / "run-gallery.sh"
    run_sh.write_text(
        "\n".join(
            [
                "#!/usr/bin/env bash",
                "set -euo pipefail",
                'HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                'APPDIR="${HERE}/AppDir"',
                'export QT_PLUGIN_PATH="${APPDIR}/usr/plugins${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"',
                'export QML2_IMPORT_PATH="${APPDIR}/usr/qml${QML2_IMPORT_PATH:+:$QML2_IMPORT_PATH}"',
                'export QML_IMPORT_PATH="${QML2_IMPORT_PATH}"',
                'export LD_LIBRARY_PATH="${APPDIR}/usr/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"',
                'export QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-xcb}"',
                'exec "${APPDIR}/usr/bin/qwinui3_gallery" "$@"',
                "",
            ]
        ),
        encoding="utf-8",
    )
    run_sh.chmod(run_sh.stat().st_mode | 0o111)

    readme = stage / "README.md"
    readme.write_text(
        "\n".join(
            [
                "# QWinUI3 Gallery (Linux x64)",
                "",
                "Self-contained AppDir with Qt runtime (linuxdeploy-plugin-qt).",
                "",
                "## Run",
                "",
                "```bash",
                "./run-gallery.sh",
                "```",
                "",
                "Requires a working X11/Wayland session. Default QPA is `xcb`",
                "(set `QT_QPA_PLATFORM=wayland` if your host has Wayland Qt plugins).",
                "",
                "License: LGPL-3.0 — see `LICENSE` / `COPYING`.",
                "",
            ]
        ),
        encoding="utf-8",
    )
    for name in ("LICENSE", "COPYING"):
        src = ROOT / name
        if src.is_file():
            shutil.copy2(src, stage / name)


def _package_windows(build_dir: Path, stage: Path, qt_prefix: str | None) -> None:
    if stage.exists():
        shutil.rmtree(stage)
    stage.mkdir(parents=True)

    binary = _find_gallery_binary(build_dir)
    dest_bin = stage / binary.name
    shutil.copy2(binary, dest_bin)

    windeployqt = shutil.which("windeployqt") or shutil.which("windeployqt6")
    if not windeployqt and qt_prefix:
        cand = Path(qt_prefix) / "bin" / "windeployqt.exe"
        if cand.is_file():
            windeployqt = str(cand)
    if not windeployqt:
        raise RuntimeError("windeployqt not found on PATH / Qt prefix")

    _run(
        [
            windeployqt,
            "--release",
            "--qmldir",
            str(ROOT / "src"),
            "--no-translations",
            str(dest_bin),
        ]
    )
    _strip_restricted(stage)

    for name in ("LICENSE", "COPYING"):
        src = ROOT / name
        if src.is_file():
            shutil.copy2(src, stage / name)
    (stage / "README.md").write_text(
        "# QWinUI3 Gallery (Windows x64)\n\n"
        "Run `qwinui3_gallery.exe`. Qt runtime is bundled via windeployqt.\n\n"
        "License: LGPL-3.0 — see `LICENSE` / `COPYING`.\n",
        encoding="utf-8",
    )


def _archive(stage: Path, archive: Path) -> None:
    if archive.exists():
        archive.unlink()
    archive.parent.mkdir(parents=True, exist_ok=True)
    if archive.suffixes[-2:] == [".tar", ".gz"] or archive.name.endswith(".tar.gz"):
        with tarfile.open(archive, "w:gz") as tf:
            tf.add(stage, arcname=stage.name)
    else:
        with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for path in stage.rglob("*"):
                if path.is_file():
                    zf.write(path, arcname=str(Path(stage.name) / path.relative_to(stage)))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", default=None, help="Package version (default: CMake project VERSION)")
    parser.add_argument("--build-dir", type=Path, default=ROOT / "build-gallery-release")
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT, help="Directory for the archive")
    parser.add_argument("--stage", type=Path, default=None, help="Staging folder (default under --out)")
    parser.add_argument("--no-build", action="store_true")
    parser.add_argument("--qt-prefix", default=None)
    parser.add_argument(
        "--platform",
        choices=("auto", "linux", "windows"),
        default="auto",
        help="Packaging backend (default: host OS)",
    )
    args = parser.parse_args()

    version = args.version or _project_version()
    qt_prefix = args.qt_prefix or _detect_qt_prefix()
    build_dir = args.build_dir.resolve()
    out_dir = args.out.resolve()

    host = platform.system().lower()
    plat = args.platform
    if plat == "auto":
        plat = "windows" if host.startswith("win") else "linux"

    if not args.no_build:
        _configure_and_build(build_dir, qt_prefix)

    if plat == "linux":
        stage_name = f"qwinui3-gallery-{version}-linux-x64"
        stage = (args.stage or (out_dir / stage_name)).resolve()
        _package_linux(build_dir, stage, qt_prefix)
        archive = out_dir / f"{stage_name}.tar.gz"
        _archive(stage, archive)
    else:
        stage_name = f"qwinui3-gallery-{version}-windows-x64"
        stage = (args.stage or (out_dir / stage_name)).resolve()
        _package_windows(build_dir, stage, qt_prefix)
        archive = out_dir / f"{stage_name}.zip"
        _archive(stage, archive)

    print(f"\nGallery package → {archive}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
