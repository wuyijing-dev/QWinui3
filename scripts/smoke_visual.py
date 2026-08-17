#!/usr/bin/env python3
"""Opt-in Gallery visual smoke subset (1.62) — grab Home + chrome pages to PNG/hash.

Not part of default smoke_gallery.py (keeps CI/local --smoke fast).

  python scripts/smoke_visual.py --build-dir build
  python scripts/smoke_visual.py --build-dir build --compare
  python scripts/smoke_visual.py --build-dir build --update-goldens

Goldens are platform-sensitive (fonts/DPI/Qt). Force QT_SCALE_FACTOR=1 for
reproducible local compares. See docs/ci-smoke.md.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

# Keep in sync with src/gallery/main.cpp kVisualSmokePages.
VISUAL_PAGES = (
    "HomePage",
    "ButtonPage",
    "ContentDialogPage",
    "PitfallsPage",
    "ExamplesTemplatesPage",
)

GOLDENS_DIR = ROOT / "testdata" / "visual-smoke"


def _golden_path() -> Path:
    host = "windows" if sys.platform.startswith("win") else "linux"
    return GOLDENS_DIR / f"{host}-qt68.manifest.json"


def _validate_manifest(manifest: dict, *, require_pages: tuple[str, ...] = VISUAL_PAGES) -> list[str]:
    errors: list[str] = []
    pages = manifest.get("pages")
    if not isinstance(pages, dict):
        return ["manifest: missing pages object"]
    for name in require_pages:
        entry = pages.get(name)
        if not isinstance(entry, dict):
            errors.append(f"missing page {name}")
            continue
        sha = entry.get("sha256", "")
        if not isinstance(sha, str) or len(sha) != 64:
            errors.append(f"{name}: bad sha256")
        w = int(entry.get("width", 0))
        h = int(entry.get("height", 0))
        nbytes = int(entry.get("bytes", 0))
        if w < 320 or h < 240:
            errors.append(f"{name}: frame too small ({w}x{h})")
        if nbytes < 1024:
            errors.append(f"{name}: PNG too small ({nbytes} bytes)")
    return errors


def main() -> int:
    from smoke_gallery import find_gallery, pin_qt_on_path, resolve_platform

    parser = argparse.ArgumentParser(description="QWinUI3 Gallery visual smoke subset (1.62)")
    parser.add_argument("--build-dir", type=Path, default=ROOT / "build")
    parser.add_argument("--bin", type=Path, default=None)
    parser.add_argument(
        "--out-dir",
        type=Path,
        default=None,
        help="PNG/manifest output (default: build/visual-smoke-out)",
    )
    parser.add_argument("--timeout", type=float, default=180.0)
    parser.add_argument("--platform", default=None, help="QT_QPA_PLATFORM override")
    parser.add_argument(
        "--compare",
        action="store_true",
        help="Compare sha256 against local goldens (best-effort; fonts/DPI may drift)",
    )
    parser.add_argument(
        "--compare-strict",
        action="store_true",
        help="Like --compare but exit non-zero on hash mismatch (default --compare warns)",
    )
    parser.add_argument(
        "--update-goldens",
        action="store_true",
        help="Copy produced manifest into testdata/visual-smoke/ (maintainers)",
    )
    args = parser.parse_args()

    build_dir = args.build_dir.resolve()
    binary = args.bin if args.bin else find_gallery(build_dir)
    if not binary.is_file():
        print(f"error: binary not found: {binary}", file=sys.stderr)
        return 2

    out_dir = (args.out_dir or (build_dir / "visual-smoke-out")).resolve()
    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    platform_name, note = resolve_platform(args.platform)
    env = os.environ.copy()
    env["QT_QPA_PLATFORM"] = platform_name
    env["QWINUI3_KEEP_QPA_PLATFORM"] = "1"
    env.setdefault("QT_QUICK_CONTROLS_STYLE", "QWinUI3")
    # Stabilize DPR for local hash compares (still font/OS sensitive).
    env.setdefault("QT_SCALE_FACTOR", "1")
    env.setdefault("QT_ENABLE_HIGHDPI_SCALING", "0")
    pinned = pin_qt_on_path(env, build_dir)

    cmd = [str(binary), "--visual-smoke", f"--visual-smoke-dir={out_dir}"]
    print(f"visual-smoke: running {' '.join(cmd)} (platform={platform_name})")
    if note:
        print(f"visual-smoke: {note}")
    if pinned:
        print(f"visual-smoke: pinned Qt prefix {pinned}")

    try:
        proc = subprocess.run(
            cmd,
            cwd=str(binary.parent),
            env=env,
            timeout=args.timeout,
            check=False,
        )
    except subprocess.TimeoutExpired:
        print("error: visual-smoke timed out", file=sys.stderr)
        return 1

    if proc.returncode != 0:
        print(f"error: gallery --visual-smoke exited {proc.returncode}", file=sys.stderr)
        return proc.returncode if proc.returncode > 0 else 1

    manifest_path = out_dir / "manifest.json"
    if not manifest_path.is_file():
        print(f"error: missing {manifest_path}", file=sys.stderr)
        return 2

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    errors = _validate_manifest(manifest)
    if errors:
        print("error: visual-smoke manifest validation failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    for name in VISUAL_PAGES:
        png = out_dir / f"{name}.png"
        if not png.is_file() or png.stat().st_size < 1024:
            print(f"error: missing/empty PNG for {name}", file=sys.stderr)
            return 1

    print(f"visual-smoke: OK ({len(VISUAL_PAGES)} frames → {out_dir})")

    if args.update_goldens:
        GOLDENS_DIR.mkdir(parents=True, exist_ok=True)
        dest = _golden_path()
        shutil.copy2(manifest_path, dest)
        print(f"visual-smoke: updated goldens → {dest}")

    if args.compare or args.compare_strict:
        golden = _golden_path()
        if not golden.is_file():
            print(
                f"error: no golden at {golden} — run with --update-goldens once on this OS/Qt",
                file=sys.stderr,
            )
            return 2
        expected = json.loads(golden.read_text(encoding="utf-8"))
        exp_pages = expected.get("pages") or {}
        got_pages = manifest.get("pages") or {}
        mismatches: list[str] = []
        for name in VISUAL_PAGES:
            want = (exp_pages.get(name) or {}).get("sha256")
            got = (got_pages.get(name) or {}).get("sha256")
            if want != got:
                mismatches.append(f"{name}: expected {want}, got {got}")
        if mismatches:
            stream = sys.stderr
            print("visual-smoke: hash compare mismatch:", file=stream)
            for m in mismatches:
                print(f"  {m}", file=stream)
            print(
                "hint: fonts/DPI/timing differ — re-run with --update-goldens if intentional",
                file=stream,
            )
            if args.compare_strict:
                return 1
            print("visual-smoke: continuing (non-strict --compare)")
        else:
            print(f"visual-smoke: hash compare OK ({golden.name})")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
