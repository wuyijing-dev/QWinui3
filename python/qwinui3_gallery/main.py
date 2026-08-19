"""Python port of src/gallery/main.cpp — load QWinUI3.Gallery/Main.

  python examples/python-gallery/main.py
  python -m qwinui3_gallery --smoke
"""

from __future__ import annotations

import argparse
import os
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from qwinui3 import (  # noqa: E402
    QtCore,
    QtGui,
    QtQml,
    QtQuickControls2,
    binding_name,
    configure_application,
    configure_environment,
    qt_version,
    setup_engine,
)
from qwinui3_gallery.gallery_language import set_startup_locale_override  # noqa: E402
from qwinui3_gallery.graphics_backend import apply_early, sync_after_app  # noqa: E402
from qwinui3_gallery.qml_module import get_module_dir, stage_gallery_qml  # noqa: E402
from qwinui3_gallery.types import register_types  # noqa: E402

CRITICAL_PAGES = (
    "HomePage",
    "ButtonPage",
    "ContentDialogPage",
    "DataTablePage",
    "FormValidationPage",
    "CommandPalettePage",
    "AccessibilityPage",
    "SystemIntegrationPage",
    "WebView2Page",
    "ChartsPage",
    "DialogsFlyoutsPage",
    "AnimationsPage",
    "I18nRtlPage",
    "FontIconPage",
    "PitfallsPage",
    "ExamplesTemplatesPage",
    "SearchBoxPage",
    "HighDpiPage",
    "MultiWindowPage",
    "StyleSpotCheckPage",
    "PerformancePage",
)


def _parse_args(argv: list[str]) -> argparse.Namespace:
    p = argparse.ArgumentParser(description="QWinUI3 Gallery (PySide6 / PyQt6)")
    p.add_argument("--kit", default=None, help="Shared kit root (qml/ + bin/)")
    p.add_argument(
        "--binding",
        choices=("pyside6", "pyqt6"),
        default=None,
        help="Force PySide6 or PyQt6",
    )
    p.add_argument("--smoke", action="store_true", help="Load Main + critical pages, then exit")
    p.add_argument("--startup-log", action="store_true")
    p.add_argument("--lang", default="", help="Startup locale, e.g. zh_CN")
    p.epilog = "Also: --rhi opengl|vulkan|d3d11|d3d12 (same as the C++ Gallery)."
    return p.parse_known_args(argv)[0]


def _smoke_pages(engine) -> int:
    pages_ok = 0
    t0 = time.perf_counter()
    for name in CRITICAL_PAGES:
        page_url = QtCore.QUrl.fromLocalFile(str(get_module_dir() / "pages" / f"{name}.qml"))
        typed = QtQml.QQmlComponent(engine, page_url)
        if typed.isLoading():
            loop = QtCore.QEventLoop()
            typed.statusChanged.connect(loop.quit)
            QtCore.QTimer.singleShot(8000, loop.quit)
            loop.exec()
        status = typed.status()
        if typed.isError() or status != QtQml.QQmlComponent.Status.Ready:
            print(
                f"smoke page compile failed: {name} status={status} {typed.errors()}",
                file=sys.stderr,
            )
            return 2
        obj = typed.create()
        if obj is None:
            print(f"smoke page create failed: {name} {typed.errors()}", file=sys.stderr)
            return 2
        obj.deleteLater()
        pages_ok += 1
        QtCore.QCoreApplication.processEvents()
    ms = int((time.perf_counter() - t0) * 1000)
    print(f"python gallery smoke pages={pages_ok} pages_ms={ms}", flush=True)
    return 0


def main(argv: list[str] | None = None) -> int:
    argv = argv if argv is not None else sys.argv[1:]
    args = _parse_args(argv)
    smoke = args.smoke
    startup_log = smoke or args.startup_log
    wall0 = time.perf_counter() if startup_log else 0.0

    if smoke:
        if sys.platform == "win32":
            os.environ["QT_QPA_PLATFORM"] = "windows"
        elif not os.environ.get("QT_QPA_PLATFORM") or os.environ.get("QT_QPA_PLATFORM") == "windows":
            os.environ["QT_QPA_PLATFORM"] = "offscreen"
        os.environ["QWINUI3_KEEP_QPA_PLATFORM"] = "1"

    kit = configure_environment(kit=args.kit, binding=args.binding)
    apply_early(sys.argv)

    app = QtGui.QGuiApplication(sys.argv)
    QtCore.QCoreApplication.setOrganizationName("QWinUI3")
    QtCore.QCoreApplication.setApplicationName("Gallery")
    configure_application("org.qwinui3.gallery")
    sync_after_app()

    if args.lang:
        set_startup_locale_override(args.lang)

    ms_after_app = int((time.perf_counter() - wall0) * 1000) if startup_log else 0

    import_root = stage_gallery_qml()
    engine = QtQml.QQmlApplicationEngine()
    setup_engine(engine, kit)
    engine.addImportPath(str(import_root))
    register_types(engine)

    def _warn(warnings) -> None:
        for err in warnings:
            print(err.toString(), file=sys.stderr)

    engine.warnings.connect(_warn)
    engine.objectCreationFailed.connect(
        lambda: QtCore.QCoreApplication.exit(-1),
        QtCore.Qt.ConnectionType.QueuedConnection,
    )

    if hasattr(engine, "loadFromModule"):
        engine.loadFromModule("QWinUI3.Gallery", "Main")
    else:
        engine.load(QtCore.QUrl.fromLocalFile(str(get_module_dir() / "Main.qml")))

    if not engine.rootObjects():
        print("Failed to load QWinUI3.Gallery/Main", file=sys.stderr)
        print(f"Style: {QtQuickControls2.QQuickStyle.name()}", file=sys.stderr)
        print(f"Import paths: {engine.importPathList()}", file=sys.stderr)
        print(f"binding={binding_name()} Qt={qt_version()} kit={kit}", file=sys.stderr)
        return -1

    ms_after_main = int((time.perf_counter() - wall0) * 1000) if startup_log else 0
    if startup_log:
        print(
            f"QWinUI3 Gallery startup: app={ms_after_app}ms main={ms_after_main}ms "
            f"(pages still on-demand) binding={binding_name()} Qt={qt_version()}",
            flush=True,
        )

    if smoke:
        QtCore.QCoreApplication.processEvents()
        rc = _smoke_pages(engine)
        if rc != 0:
            return rc
        print(
            f"QWinUI3 Gallery smoke OK (roots={len(engine.rootObjects())}, "
            f"style={QtQuickControls2.QQuickStyle.name()}, "
            f"binding={binding_name()}, kit={kit})",
            flush=True,
        )
        return 0

    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
