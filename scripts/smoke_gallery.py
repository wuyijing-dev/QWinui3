#!/usr/bin/env python3
"""Lightweight Gallery smoke: binary exists, modules load, Main instantiates (--smoke).

  python scripts/smoke_gallery.py
  python scripts/smoke_gallery.py --build-dir build

On Windows:
  - Never keep an inherited QT_QPA_PLATFORM=offscreen — desktop kits only ship
    qwindows.dll (dialog: "Available platform plugins are: windows.").
  - Prepend the CMake-configured Qt bin ahead of PATH so tools like
    ST-Link / CubeProgrammer / a second Qt kit cannot load a mismatched Qt6Core.
  Gallery itself also coerces foreign QPA values to windows on Win32.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def find_gallery(build_dir: Path) -> Path:
    names = ("qwinui3_gallery.exe", "qwinui3_gallery")
    candidates = [
        build_dir / names[0],
        build_dir / names[1],
        build_dir / "src" / "gallery" / names[0],
        build_dir / "src" / "gallery" / names[1],
    ]
    for c in candidates:
        if c.is_file():
            return c
    found = list(build_dir.rglob("qwinui3_gallery.exe")) + list(build_dir.rglob("qwinui3_gallery"))
    found = [p for p in found if p.is_file()]
    if not found:
        raise FileNotFoundError(f"qwinui3_gallery not found under {build_dir}")
    return max(found, key=lambda p: p.stat().st_mtime)


def qt_prefix_from_cache(build_dir: Path) -> Path | None:
    cache = build_dir / "CMakeCache.txt"
    if not cache.is_file():
        return None
    text = cache.read_text(encoding="utf-8", errors="replace")
    for key in ("CMAKE_PREFIX_PATH:UNINITIALIZED=", "CMAKE_PREFIX_PATH:PATH=", "Qt6_DIR:PATH="):
        m = re.search(rf"^{re.escape(key)}(.+)$", text, re.MULTILINE)
        if not m:
            continue
        raw = m.group(1).strip().split(";")[0].strip()
        if not raw:
            continue
        p = Path(raw)
        if key.startswith("Qt6_DIR") and p.name == "Qt6":
            # .../lib/cmake/Qt6 → prefix
            p = p.parent.parent.parent
        if (p / "bin").is_dir() or (p / "lib").is_dir():
            return p
    return None


def resolve_platform(cli_platform: str | None) -> tuple[str, str | None]:
    """Return (platform, note_about_override)."""
    if cli_platform:
        return cli_platform, None

    inherited = os.environ.get("QT_QPA_PLATFORM", "").strip()
    if sys.platform.startswith("win"):
        if inherited in ("", "windows"):
            return "windows", None
        return "windows", f"ignored inherited QT_QPA_PLATFORM={inherited!r}"
    if inherited:
        return inherited, None
    return "offscreen", None


def pin_qt_on_path(env: dict[str, str], build_dir: Path) -> str | None:
    if not sys.platform.startswith("win"):
        return None
    prefix = qt_prefix_from_cache(build_dir)
    if prefix is None:
        return None
    qt_bin = prefix / "bin"
    qt_plugins = prefix / "plugins"
    if not qt_bin.is_dir():
        return None
    path = env.get("PATH", "")
    env["PATH"] = str(qt_bin) + os.pathsep + path
    env["QTDIR"] = str(prefix)
    if qt_plugins.is_dir():
        env["QT_PLUGIN_PATH"] = str(qt_plugins)
    return str(prefix)


def main() -> int:
    parser = argparse.ArgumentParser(description="Run QWinUI3 Gallery --smoke")
    parser.add_argument("--build-dir", type=Path, default=ROOT / "build")
    parser.add_argument("--bin", type=Path, default=None, help="Gallery binary path")
    parser.add_argument("--timeout", type=float, default=120.0, help="Seconds before kill")
    parser.add_argument(
        "--platform",
        default=None,
        help="QT_QPA_PLATFORM (Windows default: windows; Linux default: offscreen)",
    )
    args = parser.parse_args()

    binary = args.bin if args.bin else find_gallery(args.build_dir)
    if not binary.is_file():
        print(f"error: binary not found: {binary}", file=sys.stderr)
        return 2

    platform, note = resolve_platform(args.platform)
    env = os.environ.copy()
    env["QT_QPA_PLATFORM"] = platform
    env["QWINUI3_KEEP_QPA_PLATFORM"] = "1"
    env.setdefault("QT_QUICK_CONTROLS_STYLE", "QWinUI3")
    pinned = pin_qt_on_path(env, args.build_dir.resolve())

    cmd = [str(binary), "--smoke"]
    print(f"smoke: running {' '.join(cmd)} (platform={platform})")
    if note:
        print(f"smoke: {note}")
    if pinned:
        print(f"smoke: pinned Qt prefix {pinned}")

    # 1.20 — catalog integrity (no Qt) before launching the binary.
    catalog_script = ROOT / "scripts" / "smoke_catalog.py"
    if catalog_script.is_file():
        cat = subprocess.run(
            [sys.executable, str(catalog_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cat.returncode != 0:
            print("error: smoke_catalog.py failed", file=sys.stderr)
            return cat.returncode if cat.returncode > 0 else 1
        print("smoke: catalog integrity OK")

    # 1.45 — translation seed catalogs (no Qt / lrelease required).
    trans_script = ROOT / "scripts" / "check_gallery_translations.py"
    if trans_script.is_file():
        tr = subprocess.run(
            [sys.executable, str(trans_script)],
            cwd=str(ROOT),
            check=False,
        )
        if tr.returncode != 0:
            print("error: check_gallery_translations.py failed", file=sys.stderr)
            return tr.returncode if tr.returncode > 0 else 1
        print("smoke: translation seeds OK")

    # 2.35 — localization wave 4 (de_DE seed + 2.21…2.34 page qsTr rules).
    loc4_script = ROOT / "scripts" / "check_localization_wave4.py"
    if loc4_script.is_file():
        loc4 = subprocess.run(
            [sys.executable, str(loc4_script)],
            cwd=str(ROOT),
            check=False,
        )
        if loc4.returncode != 0:
            print("error: check_localization_wave4.py failed", file=sys.stderr)
            return loc4.returncode if loc4.returncode > 0 else 1
        print("smoke: localization wave 4 OK")

    # 2.13 — security-trust wave 2 docs + FileDropZone MIME API.
    sec_script = ROOT / "scripts" / "check_security_trust.py"
    if sec_script.is_file():
        sec = subprocess.run(
            [sys.executable, str(sec_script)],
            cwd=str(ROOT),
            check=False,
        )
        if sec.returncode != 0:
            print("error: check_security_trust.py failed", file=sys.stderr)
            return sec.returncode if sec.returncode > 0 else 1
        print("smoke: security-trust wave 2 OK")

    # 2.36 — security-trust wave 3 (FileTree/TreeDataGrid path trust + WebView2 downloads).
    sec3_script = ROOT / "scripts" / "check_security_trust_wave3.py"
    if sec3_script.is_file():
        sec3 = subprocess.run(
            [sys.executable, str(sec3_script)],
            cwd=str(ROOT),
            check=False,
        )
        if sec3.returncode != 0:
            print("error: check_security_trust_wave3.py failed", file=sys.stderr)
            return sec3.returncode if sec3.returncode > 0 else 1
        print("smoke: security-trust wave 3 OK")

    # 2.14 — multi-window / modal stack harden.
    mw_script = ROOT / "scripts" / "check_multi_window.py"
    if mw_script.is_file():
        mw = subprocess.run(
            [sys.executable, str(mw_script)],
            cwd=str(ROOT),
            check=False,
        )
        if mw.returncode != 0:
            print("error: check_multi_window.py failed", file=sys.stderr)
            return mw.returncode if mw.returncode > 0 else 1
        print("smoke: multi-window harden OK")

    # 2.15 — high-DPI wave 3 readout + docs.
    hdpi_script = ROOT / "scripts" / "check_high_dpi.py"
    if hdpi_script.is_file():
        hdpi = subprocess.run(
            [sys.executable, str(hdpi_script)],
            cwd=str(ROOT),
            check=False,
        )
        if hdpi.returncode != 0:
            print("error: check_high_dpi.py failed", file=sys.stderr)
            return hdpi.returncode if hdpi.returncode > 0 else 1
        print("smoke: high-DPI wave 3 OK")

    # 2.16 — command & search wave 2 perf + keyboard polish.
    cs_script = ROOT / "scripts" / "check_command_search.py"
    if cs_script.is_file():
        cs = subprocess.run(
            [sys.executable, str(cs_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cs.returncode != 0:
            print("error: check_command_search.py failed", file=sys.stderr)
            return cs.returncode if cs.returncode > 0 else 1
        print("smoke: command-search wave 2 OK")

    # 2.17 — Style polish / token audit.
    sp_script = ROOT / "scripts" / "check_style_polish.py"
    if sp_script.is_file():
        sp = subprocess.run(
            [sys.executable, str(sp_script)],
            cwd=str(ROOT),
            check=False,
        )
        if sp.returncode != 0:
            print("error: check_style_polish.py failed", file=sys.stderr)
            return sp.returncode if sp.returncode > 0 else 1
        print("smoke: style-polish OK")

    # 2.18 — performance wave 5 (DataTable / ListDetailsView / NavigationView).
    pw5_script = ROOT / "scripts" / "check_performance_wave5.py"
    if pw5_script.is_file():
        pw5 = subprocess.run(
            [sys.executable, str(pw5_script)],
            cwd=str(ROOT),
            check=False,
        )
        if pw5.returncode != 0:
            print("error: check_performance_wave5.py failed", file=sys.stderr)
            return pw5.returncode if pw5.returncode > 0 else 1
        print("smoke: performance wave 5 OK")

    # 2.19 — component docs + catalog refresh.
    cat_refresh = ROOT / "scripts" / "check_catalog_refresh.py"
    if cat_refresh.is_file():
        cr = subprocess.run(
            [sys.executable, str(cat_refresh)],
            cwd=str(ROOT),
            check=False,
        )
        if cr.returncode != 0:
            print("error: check_catalog_refresh.py failed", file=sys.stderr)
            return cr.returncode if cr.returncode > 0 else 1
        print("smoke: catalog refresh OK")

    # 2.21 — TreeDataGrid experimental + tree-data docs.
    tdg_script = ROOT / "scripts" / "check_tree_data_grid.py"
    if tdg_script.is_file():
        tdg = subprocess.run(
            [sys.executable, str(tdg_script)],
            cwd=str(ROOT),
            check=False,
        )
        if tdg.returncode != 0:
            print("error: check_tree_data_grid.py failed", file=sys.stderr)
            return tdg.returncode if tdg.returncode > 0 else 1
        print("smoke: tree-data-grid OK")

    # 2.22 — dashboard responsive layout recipes.
    dash_script = ROOT / "scripts" / "check_dashboard_recipes.py"
    if dash_script.is_file():
        dash = subprocess.run(
            [sys.executable, str(dash_script)],
            cwd=str(ROOT),
            check=False,
        )
        if dash.returncode != 0:
            print("error: check_dashboard_recipes.py failed", file=sys.stderr)
            return dash.returncode if dash.returncode > 0 else 1
        print("smoke: dashboard recipes OK")

    # 2.23 — BreadcrumbBar + NavigationView path sync.
    crumb_script = ROOT / "scripts" / "check_breadcrumb_integration.py"
    if crumb_script.is_file():
        crumb = subprocess.run(
            [sys.executable, str(crumb_script)],
            cwd=str(ROOT),
            check=False,
        )
        if crumb.returncode != 0:
            print("error: check_breadcrumb_integration.py failed", file=sys.stderr)
            return crumb.returncode if crumb.returncode > 0 else 1
        print("smoke: breadcrumb integration OK")

    # 2.24 — ItemsWrapGrid variable-size wrap.
    iwg_script = ROOT / "scripts" / "check_items_wrap_grid.py"
    if iwg_script.is_file():
        iwg = subprocess.run(
            [sys.executable, str(iwg_script)],
            cwd=str(ROOT),
            check=False,
        )
        if iwg.returncode != 0:
            print("error: check_items_wrap_grid.py failed", file=sys.stderr)
            return iwg.returncode if iwg.returncode > 0 else 1
        print("smoke: items-wrap-grid OK")

    # 2.25 — forms / settings industry templates.
    form_script = ROOT / "scripts" / "check_form_templates.py"
    if form_script.is_file():
        form = subprocess.run(
            [sys.executable, str(form_script)],
            cwd=str(ROOT),
            check=False,
        )
        if form.returncode != 0:
            print("error: check_form_templates.py failed", file=sys.stderr)
            return form.returncode if form.returncode > 0 else 1
        print("smoke: form templates OK")

    # 2.26 — charts deferred sibling compose recipes.
    charts_script = ROOT / "scripts" / "check_charts_recipes.py"
    if charts_script.is_file():
        charts = subprocess.run(
            [sys.executable, str(charts_script)],
            cwd=str(ROOT),
            check=False,
        )
        if charts.returncode != 0:
            print("error: check_charts_recipes.py failed", file=sys.stderr)
            return charts.returncode if charts.returncode > 0 else 1
        print("smoke: charts recipes OK")

    # 2.27 — notification center + feedback wave 3.
    notify_script = ROOT / "scripts" / "check_notification_feedback.py"
    if notify_script.is_file():
        notify = subprocess.run(
            [sys.executable, str(notify_script)],
            cwd=str(ROOT),
            check=False,
        )
        if notify.returncode != 0:
            print("error: check_notification_feedback.py failed", file=sys.stderr)
            return notify.returncode if notify.returncode > 0 else 1
        print("smoke: notification feedback OK")

    # 2.28 — performance wave 6 (shell + navigation trim).
    pw6_script = ROOT / "scripts" / "check_performance_wave6.py"
    if pw6_script.is_file():
        pw6 = subprocess.run(
            [sys.executable, str(pw6_script)],
            cwd=str(ROOT),
            check=False,
        )
        if pw6.returncode != 0:
            print("error: check_performance_wave6.py failed", file=sys.stderr)
            return pw6.returncode if pw6.returncode > 0 else 1
        print("smoke: performance wave 6 OK")

    # 2.29 — accessibility wave 5 (TreeDataGrid / FileTree / ItemsWrapGrid / BreadcrumbBar).
    a11y_script = ROOT / "scripts" / "check_accessibility_wave5.py"
    if a11y_script.is_file():
        a11y = subprocess.run(
            [sys.executable, str(a11y_script)],
            cwd=str(ROOT),
            check=False,
        )
        if a11y.returncode != 0:
            print("error: check_accessibility_wave5.py failed", file=sys.stderr)
            return a11y.returncode if a11y.returncode > 0 else 1
        print("smoke: accessibility wave 5 OK")

    # 2.30 — mid-2.x checkpoint (checkpoint-230.md audit).
    cp230_script = ROOT / "scripts" / "check_checkpoint_230.py"
    if cp230_script.is_file():
        cp230 = subprocess.run(
            [sys.executable, str(cp230_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cp230.returncode != 0:
            print("error: check_checkpoint_230.py failed", file=sys.stderr)
            return cp230.returncode if cp230.returncode > 0 else 1
        print("smoke: checkpoint 2.30 OK")

    # 2.31 — CalendarView month grid + selection modes.
    cal_script = ROOT / "scripts" / "check_calendar_view.py"
    if cal_script.is_file():
        cal = subprocess.run(
            [sys.executable, str(cal_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cal.returncode != 0:
            print("error: check_calendar_view.py failed", file=sys.stderr)
            return cal.returncode if cal.returncode > 0 else 1
        print("smoke: calendar-view OK")

    # 2.32 — Media + WebView2 field matrix + policy recipes.
    mw_script = ROOT / "scripts" / "check_media_webview_harden.py"
    if mw_script.is_file():
        mw = subprocess.run(
            [sys.executable, str(mw_script)],
            cwd=str(ROOT),
            check=False,
        )
        if mw.returncode != 0:
            print("error: check_media_webview_harden.py failed", file=sys.stderr)
            return mw.returncode if mw.returncode > 0 else 1
        print("smoke: media/webview harden OK")

    # 2.33 — Linux portal & tray wave 3 regression suite.
    linux_script = ROOT / "scripts" / "check_linux_portal_tray.py"
    if linux_script.is_file():
        linux = subprocess.run(
            [sys.executable, str(linux_script)],
            cwd=str(ROOT),
            check=False,
        )
        if linux.returncode != 0:
            print("error: check_linux_portal_tray.py failed", file=sys.stderr)
            return linux.returncode if linux.returncode > 0 else 1
        print("smoke: linux portal/tray OK")

    # 2.34 — Packaging & CI consumer matrix (docs + workflow anchors).
    pcm_script = ROOT / "scripts" / "check_packaging_consumer_matrix.py"
    if pcm_script.is_file():
        pcm = subprocess.run(
            [sys.executable, str(pcm_script)],
            cwd=str(ROOT),
            check=False,
        )
        if pcm.returncode != 0:
            print("error: check_packaging_consumer_matrix.py failed", file=sys.stderr)
            return pcm.returncode if pcm.returncode > 0 else 1
        print("smoke: packaging consumer matrix OK")

    # 2.37 — PipsPager + FlipView carousel recipes + reducedMotion demos.
    carousel_script = ROOT / "scripts" / "check_pips_pager_carousel.py"
    if carousel_script.is_file():
        car = subprocess.run(
            [sys.executable, str(carousel_script)],
            cwd=str(ROOT),
            check=False,
        )
        if car.returncode != 0:
            print("error: check_pips_pager_carousel.py failed", file=sys.stderr)
            return car.returncode if car.returncode > 0 else 1
        print("smoke: pips pager / carousel OK")

    # 2.38 — theme overrides & branding wave 2.
    theme2_script = ROOT / "scripts" / "check_theme_overrides_wave2.py"
    if theme2_script.is_file():
        th2 = subprocess.run(
            [sys.executable, str(theme2_script)],
            cwd=str(ROOT),
            check=False,
        )
        if th2.returncode != 0:
            print("error: check_theme_overrides_wave2.py failed", file=sys.stderr)
            return th2.returncode if th2.returncode > 0 else 1
        print("smoke: theme overrides wave 2 OK")

    # 2.39 — Gallery catalog expansion (2.21…2.38 matrix + recentlyShipped + Pitfalls).
    catalog_exp_script = ROOT / "scripts" / "check_gallery_catalog_expansion.py"
    if catalog_exp_script.is_file():
        cexp = subprocess.run(
            [sys.executable, str(catalog_exp_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cexp.returncode != 0:
            print("error: check_gallery_catalog_expansion.py failed", file=sys.stderr)
            return cexp.returncode if cexp.returncode > 0 else 1
        print("smoke: gallery catalog expansion OK")

    # 2.40 — performance wave 7 (collection debounce/filter paths).
    perf7_script = ROOT / "scripts" / "check_performance_wave7.py"
    if perf7_script.is_file():
        p7 = subprocess.run(
            [sys.executable, str(perf7_script)],
            cwd=str(ROOT),
            check=False,
        )
        if p7.returncode != 0:
            print("error: check_performance_wave7.py failed", file=sys.stderr)
            return p7.returncode if p7.returncode > 0 else 1
        print("smoke: performance wave 7 OK")

    # 2.41 — command palette + menu bar wave 3 (large lists + shortcut discovery).
    cmd3_script = ROOT / "scripts" / "check_command_menu_wave3.py"
    if cmd3_script.is_file():
        cm3 = subprocess.run(
            [sys.executable, str(cmd3_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cm3.returncode != 0:
            print("error: check_command_menu_wave3.py failed", file=sys.stderr)
            return cm3.returncode if cm3.returncode > 0 else 1
        print("smoke: command/menu wave 3 OK")

    # 2.42 — SwipeControl deepen (thresholds + nested scroll + teaching).
    swipe_script = ROOT / "scripts" / "check_swipe_control_deepen.py"
    if swipe_script.is_file():
        sw = subprocess.run(
            [sys.executable, str(swipe_script)],
            cwd=str(ROOT),
            check=False,
        )
        if sw.returncode != 0:
            print("error: check_swipe_control_deepen.py failed", file=sys.stderr)
            return sw.returncode if sw.returncode > 0 else 1
        print("smoke: SwipeControl deepen OK")

    # 2.43 — multi-window + onboarding (coach + z-order + Settings).
    mwo_script = ROOT / "scripts" / "check_multi_window_onboarding.py"
    if mwo_script.is_file():
        mwo = subprocess.run(
            [sys.executable, str(mwo_script)],
            cwd=str(ROOT),
            check=False,
        )
        if mwo.returncode != 0:
            print("error: check_multi_window_onboarding.py failed", file=sys.stderr)
            return mwo.returncode if mwo.returncode > 0 else 1
        print("smoke: multi-window + onboarding OK")

    # Strategy + icons/dashboard expansion (post-2.43 docs track).
    rs_script = ROOT / "scripts" / "check_roadmap_strategy.py"
    if rs_script.is_file():
        rs = subprocess.run(
            [sys.executable, str(rs_script)],
            cwd=str(ROOT),
            check=False,
        )
        if rs.returncode != 0:
            print("error: check_roadmap_strategy.py failed", file=sys.stderr)
            return rs.returncode if rs.returncode > 0 else 1
        print("smoke: roadmap strategy OK")

    plan_script = ROOT / "scripts" / "check_planning_ia.py"
    if plan_script.is_file():
        pl = subprocess.run(
            [sys.executable, str(plan_script)],
            cwd=str(ROOT),
            check=False,
        )
        if pl.returncode != 0:
            print("error: check_planning_ia.py failed", file=sys.stderr)
            return pl.returncode if pl.returncode > 0 else 1
        print("smoke: planning IA OK")

    cda_script = ROOT / "scripts" / "check_charts_dashboard_arc.py"
    if cda_script.is_file():
        cda = subprocess.run(
            [sys.executable, str(cda_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cda.returncode != 0:
            print("error: check_charts_dashboard_arc.py failed", file=sys.stderr)
            return cda.returncode if cda.returncode > 0 else 1
        print("smoke: charts/dashboard arc OK")

    cce_script = ROOT / "scripts" / "check_component_capabilities_expansion.py"
    if cce_script.is_file():
        cce = subprocess.run(
            [sys.executable, str(cce_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cce.returncode != 0:
            print("error: check_component_capabilities_expansion.py failed", file=sys.stderr)
            return cce.returncode if cce.returncode > 0 else 1
        print("smoke: component capabilities expansion OK")

    ide_script = ROOT / "scripts" / "check_icons_dashboard_expansion.py"
    if ide_script.is_file():
        ide = subprocess.run(
            [sys.executable, str(ide_script)],
            cwd=str(ROOT),
            check=False,
        )
        if ide.returncode != 0:
            print("error: check_icons_dashboard_expansion.py failed", file=sys.stderr)
            return ide.returncode if ide.returncode > 0 else 1
        print("smoke: icons/dashboard expansion OK")

    # 2.44 — developer diagnostics (retail profile + FrameStats promote).
    diag_script = ROOT / "scripts" / "check_developer_diagnostics.py"
    if diag_script.is_file():
        dg = subprocess.run(
            [sys.executable, str(diag_script)],
            cwd=str(ROOT),
            check=False,
        )
        if dg.returncode != 0:
            print("error: check_developer_diagnostics.py failed", file=sys.stderr)
            return dg.returncode if dg.returncode > 0 else 1
        print("smoke: developer diagnostics OK")

    # 2.45 — experimental → stable sweep (FL-004 badges + docs).
    exp_script = ROOT / "scripts" / "check_experimental_sweep.py"
    if exp_script.is_file():
        ex = subprocess.run(
            [sys.executable, str(exp_script)],
            cwd=str(ROOT),
            check=False,
        )
        if ex.returncode != 0:
            print("error: check_experimental_sweep.py failed", file=sys.stderr)
            return ex.returncode if ex.returncode > 0 else 1
        print("smoke: experimental sweep OK")

    # 2.46 — Docs IA v2 + recipes hub regroup.
    ia_script = ROOT / "scripts" / "check_docs_ia_v2.py"
    if ia_script.is_file():
        ia = subprocess.run(
            [sys.executable, str(ia_script)],
            cwd=str(ROOT),
            check=False,
        )
        if ia.returncode != 0:
            print("error: check_docs_ia_v2.py failed", file=sys.stderr)
            return ia.returncode if ia.returncode > 0 else 1
        print("smoke: docs IA v2 OK")

    # 2.47 — field harden buffer (checkpoint P0/P1 triage).
    fh_script = ROOT / "scripts" / "check_field_harden_247.py"
    if fh_script.is_file():
        fh = subprocess.run(
            [sys.executable, str(fh_script)],
            cwd=str(ROOT),
            check=False,
        )
        if fh.returncode != 0:
            print("error: check_field_harden_247.py failed", file=sys.stderr)
            return fh.returncode if fh.returncode > 0 else 1
        print("smoke: field harden 2.47 OK")

    # 2.48 — friction-only slot (FL-009 dashboard compose decision).
    fs_script = ROOT / "scripts" / "check_friction_slot_248.py"
    if fs_script.is_file():
        fs = subprocess.run(
            [sys.executable, str(fs_script)],
            cwd=str(ROOT),
            check=False,
        )
        if fs.returncode != 0:
            print("error: check_friction_slot_248.py failed", file=sys.stderr)
            return fs.returncode if fs.returncode > 0 else 1
        print("smoke: friction slot 2.48 OK")

    # 2.49 — performance wave 8 + tranche-1 sign-off.
    pw8_script = ROOT / "scripts" / "check_performance_wave8.py"
    if pw8_script.is_file():
        pw8 = subprocess.run(
            [sys.executable, str(pw8_script)],
            cwd=str(ROOT),
            check=False,
        )
        if pw8.returncode != 0:
            print("error: check_performance_wave8.py failed", file=sys.stderr)
            return pw8.returncode if pw8.returncode > 0 else 1
        print("smoke: performance wave 8 OK")

    # 2.50 — tranche-1 checkpoint (checkpoint-250.md).
    cp250_script = ROOT / "scripts" / "check_checkpoint_250.py"
    if cp250_script.is_file():
        cp250 = subprocess.run(
            [sys.executable, str(cp250_script)],
            cwd=str(ROOT),
            check=False,
        )
        if cp250.returncode != 0:
            print("error: check_checkpoint_250.py failed", file=sys.stderr)
            return cp250.returncode if cp250.returncode > 0 else 1
        print("smoke: checkpoint 2.50 OK")

    # 1.46 — shared packaging contracts / docs (no Qt / no package build).
    pkg_script = ROOT / "scripts" / "check_shared_package.py"
    if pkg_script.is_file():
        pk = subprocess.run(
            [sys.executable, str(pkg_script)],
            cwd=str(ROOT),
            check=False,
        )
        if pk.returncode != 0:
            print("error: check_shared_package.py failed", file=sys.stderr)
            return pk.returncode if pk.returncode > 0 else 1
        print("smoke: shared package contracts OK")

    # 1.52 — recipe / ROADMAP / maturity markdown links (no Qt).
    docs_script = ROOT / "scripts" / "check_docs_links.py"
    if docs_script.is_file():
        docs = subprocess.run(
            [sys.executable, str(docs_script)],
            cwd=str(ROOT),
            check=False,
        )
        if docs.returncode != 0:
            print("error: check_docs_links.py failed", file=sys.stderr)
            return docs.returncode if docs.returncode > 0 else 1
        print("smoke: docs links OK")

    try:
        proc = subprocess.run(
            cmd,
            cwd=str(binary.parent),
            env=env,
            timeout=args.timeout,
            check=False,
        )
    except subprocess.TimeoutExpired:
        print(f"error: smoke timed out after {args.timeout}s", file=sys.stderr)
        return 124

    if proc.returncode != 0:
        print(f"error: smoke exited {proc.returncode}", file=sys.stderr)
        return proc.returncode if proc.returncode > 0 else 1

    print("smoke: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
