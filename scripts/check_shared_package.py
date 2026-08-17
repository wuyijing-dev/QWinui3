#!/usr/bin/env python3
"""Validate shared/static library packaging contracts (1.46).

  python scripts/check_shared_package.py
  python scripts/check_shared_package.py --dir dist/qwinui3-1.46-windows-x64-shared

Without --dir: checks packaging scripts, strip helper, and docs anchors (no Qt / no build).
With --dir: validates a packaged tree (bin/ · lib/ · qml/ · README).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

EXPECTED_MODULES = ("theme", "style", "platform", "extras")
EXPECTED_PRESETS = ("all", "full", "core", "shell", "extras")
DOC_MARKERS = (
    "Shared vs static",
    "windeployqt",
    "linuxdeploy",
    "strip-restricted",
    "check_shared_package",
    "gallery-shell",
    "find_package(QWinUI3",
    "Path C",
)


def _check_repo_contracts() -> list[str]:
    errors: list[str] = []

    pkg = ROOT / "scripts" / "package_release_libs.py"
    if not pkg.is_file():
        errors.append(f"missing {pkg}")
        return errors

    text = pkg.read_text(encoding="utf-8")
    for name in EXPECTED_MODULES:
        if f'"{name}"' not in text and f"'{name}'" not in text:
            errors.append(f"package_release_libs.py: module {name!r} not found")
    for preset in EXPECTED_PRESETS:
        if f'"{preset}"' not in text:
            errors.append(f"package_release_libs.py: preset {preset!r} not found")
    if "QWINUI3_BUILD_SHARED" not in text:
        errors.append("package_release_libs.py: missing QWINUI3_BUILD_SHARED")

    gallery = ROOT / "scripts" / "package_release_gallery.py"
    if not gallery.is_file():
        errors.append(f"missing {gallery}")
    else:
        gtext = gallery.read_text(encoding="utf-8")
        for needle in ("windeployqt", "linuxdeploy", "_strip_restricted"):
            if needle not in gtext:
                errors.append(f"package_release_gallery.py: missing {needle!r}")

    strip = ROOT / "cmake" / "StripRestrictedQtModules.cmake"
    if not strip.is_file():
        errors.append(f"missing {strip}")
    else:
        stext = strip.read_text(encoding="utf-8")
        if "VirtualKeyboard" not in stext:
            errors.append("StripRestrictedQtModules.cmake: missing VirtualKeyboard strip")
        if "qwinui3_strip_restricted_qt_modules" not in stext:
            errors.append("StripRestrictedQtModules.cmake: missing function name")

    pkg_cmake = ROOT / "cmake" / "package" / "QWinUI3Config.cmake.in"
    if not pkg_cmake.is_file():
        errors.append(f"missing {pkg_cmake}")
    else:
        ctext = pkg_cmake.read_text(encoding="utf-8")
        for needle in ("QWinUI3::", "qwinui3_target_setup", "official vcpkg"):
            if needle not in ctext:
                errors.append(f"QWinUI3Config.cmake.in: missing {needle!r}")

    ver_in = ROOT / "cmake" / "package" / "QWinUI3ConfigVersion.cmake.in"
    if not ver_in.is_file():
        errors.append(f"missing {ver_in}")

    consumer = ROOT / "examples" / "find-package-consumer" / "CMakeLists.txt"
    if not consumer.is_file():
        errors.append(f"missing {consumer}")
    elif "find_package(QWinUI3" not in consumer.read_text(encoding="utf-8"):
        errors.append("find-package-consumer: missing find_package(QWinUI3)")

    verify = ROOT / "scripts" / "verify_find_package.py"
    if not verify.is_file():
        errors.append(f"missing {verify}")

    doc = ROOT / "docs" / "packaging-consumer.md"
    if not doc.is_file():
        errors.append(f"missing {doc}")
    else:
        dtext = doc.read_text(encoding="utf-8")
        for marker in DOC_MARKERS:
            if marker not in dtext:
                errors.append(f"packaging-consumer.md: missing section/marker {marker!r}")

    return errors


def _detect_modules(qml_root: Path) -> list[str]:
    found: list[str] = []
    if (qml_root / "QWinUI3" / "Theme" / "qmldir").is_file():
        found.append("theme")
    # Style URI tree is qml/QWinUI3/ (controls); Theme is qml/QWinUI3/Theme/.
    if (qml_root / "QWinUI3" / "qmldir").is_file() and (
        qml_root / "QWinUI3" / "Button.qml"
    ).is_file():
        found.append("style")
    if (qml_root / "QWinUI3" / "Platform" / "qmldir").is_file():
        found.append("platform")
    if (qml_root / "QWinUI3" / "Extras" / "qmldir").is_file():
        found.append("extras")
    return found


def _check_package_dir(out_dir: Path, expect_shared: bool | None) -> list[str]:
    errors: list[str] = []
    if not out_dir.is_dir():
        return [f"not a directory: {out_dir}"]

    readme = out_dir / "README.md"
    shared = expect_shared
    if not readme.is_file():
        errors.append("missing README.md")
    else:
        rtext = readme.read_text(encoding="utf-8", errors="replace")
        if "QWinUI3" not in rtext:
            errors.append("README.md does not mention QWinUI3")
        if shared is None:
            kind_line = next(
                (ln for ln in rtext.splitlines() if ln.startswith("Library type:")),
                "",
            )
            if "SHARED" in kind_line.upper():
                shared = True
            elif "STATIC" in kind_line.upper():
                shared = False
            else:
                shared = True

    if not (out_dir / "LICENSE").is_file() and not (out_dir / "COPYING").is_file():
        errors.append("missing LICENSE and COPYING")

    lib_dir = out_dir / "lib"
    qml_dir = out_dir / "qml"
    bin_dir = out_dir / "bin"
    if not lib_dir.is_dir():
        errors.append("missing lib/")
    if not qml_dir.is_dir():
        errors.append("missing qml/")
    if not bin_dir.is_dir():
        errors.append("missing bin/")

    if errors:
        return errors

    modules = _detect_modules(qml_dir)
    if "theme" not in modules:
        errors.append("qml/: missing QWinUI3/Theme (theme module)")
    if not modules:
        errors.append("qml/: no QWinUI3 module trees detected")

    lib_files = [p for p in lib_dir.iterdir() if p.is_file() or p.is_symlink()]
    if not lib_files:
        errors.append("lib/: empty (expected qwinui3_* libraries)")

    dlls = list(bin_dir.glob("*.dll"))
    sos = list(lib_dir.glob("*.so*"))
    static_libs = list(lib_dir.glob("*.lib")) + list(lib_dir.glob("*.a"))

    if shared is True:
        if not dlls and not sos:
            errors.append("shared package: no DLL in bin/ and no .so in lib/")
        cmake_cfg = lib_dir / "cmake" / "QWinUI3" / "QWinUI3Config.cmake"
        if not cmake_cfg.is_file():
            errors.append("shared package: missing lib/cmake/QWinUI3/QWinUI3Config.cmake (1.61)")
        if "platform" in modules:
            bootstrap = out_dir / "include" / "QWinUI3" / "Bootstrap.h"
            if not bootstrap.is_file():
                errors.append("shared package with platform: missing include/QWinUI3/Bootstrap.h")
    elif shared is False:
        if not static_libs and not any("qwinui3" in p.name.lower() for p in lib_files):
            errors.append("static package: no .lib/.a (or qwinui3_* libs) in lib/")

    # Restricted Qt add-ons must not appear inside the QWinUI3 package itself.
    restricted = (
        "VirtualKeyboard",
        "QtCharts",
        "QtWebEngine",
        "QtQuick3D",
    )
    for path in out_dir.rglob("*"):
        if not path.is_file() and not path.is_dir():
            continue
        name = path.name
        for bad in restricted:
            if bad in name or bad in str(path.relative_to(out_dir)):
                # Allow mention only inside README text files
                if path.suffix.lower() in {".md", ".txt"}:
                    continue
                errors.append(f"restricted Qt path present: {path.relative_to(out_dir)}")
                break

    if not errors:
        print(
            f"ok: package {out_dir.name} modules={','.join(modules) or '(none)'} "
            f"shared={shared} lib_files={len(lib_files)} dlls={len(dlls)} sos={len(sos)}"
        )
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dir",
        type=Path,
        default=None,
        help="Validate a packaged output directory (shared or static)",
    )
    parser.add_argument(
        "--expect-shared",
        choices=("yes", "no", "auto"),
        default="auto",
        help="When using --dir, require SHARED or STATIC (default: auto from README)",
    )
    args = parser.parse_args()

    errors = _check_repo_contracts()
    if not errors:
        print("ok: packaging scripts + strip helper + docs anchors")

    if args.dir is not None:
        expect: bool | None
        if args.expect_shared == "yes":
            expect = True
        elif args.expect_shared == "no":
            expect = False
        else:
            expect = None
        errors.extend(_check_package_dir(args.dir.resolve(), expect))

    if errors:
        for err in errors:
            print(f"error: {err}", file=sys.stderr)
        return 2

    print("shared package contracts: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
