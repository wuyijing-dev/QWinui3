#pragma once

#include <QString>

// QWinUI3 bootstrap — one-call kit setup for consumer mains.
//
//   #include "Bootstrap.h"
//   #include <QGuiApplication>
//   #include <QQmlApplicationEngine>
//
//   QWINUI3_IMPORT_QML_PLUGINS
//
//   int main(int argc, char *argv[])
//   {
//       QWinUI3::configureEnvironment(argv[0]); // BEFORE QGuiApplication
//       QGuiApplication app(argc, argv);
//       QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));
//       QQmlApplicationEngine engine;
//       engine.loadFromModule("MyApp", "Main");
//       return app.exec();
//   }
//
// Links: qwinui3_platform (pulls theme + QuickControls2).

#include <QtQml/QQmlExtensionPlugin>

/// Static-link / plugin import for all QWinUI3 QML modules (style + theme + extras + platform).
#ifndef QWINUI3_IMPORT_QML_PLUGINS
#  define QWINUI3_IMPORT_QML_PLUGINS \
      Q_IMPORT_QML_PLUGIN(QWinUI3Plugin) \
      Q_IMPORT_QML_PLUGIN(QWinUI3_ThemePlugin) \
      Q_IMPORT_QML_PLUGIN(QWinUI3_ExtrasPlugin) \
      Q_IMPORT_QML_PLUGIN(QWinUI3_PlatformPlugin)
#endif

namespace QWinUI3 {

/// Call **before** constructing `QGuiApplication`.
/// Minimal cold path (3.34 S10) — no optional host probes before first frame:
/// - Prints a one-shot welcome ASCII banner (set `QWINUI3_NO_BANNER=1` to skip)
/// - Windows: sanitize foreign `QT_QPA_PLATFORM` (unless `QWINUI3_ALLOW_FOREIGN_QPA`)
/// - Platform env (Wayland-first / DPI) via `WindowHelper::configurePlatformEnvironment`
/// - Prefer system IME (`QT_IM_MODULE` cleared)
/// - Sets `QT_QUICK_CONTROLS_STYLE=QWinUI3`
/// - Soft RHI default when `QSG_RHI_BACKEND` empty (`preferredPlatformBackend`, no probe).
///   Set `QWINUI3_RHI_PROBE=1` for the legacy probe + fallback chain.
void configureEnvironment(const char *argv0 = nullptr);

/// Call **after** `QGuiApplication` exists.
/// - `QQuickStyle::setStyle("QWinUI3")`
/// - Loads Fluent icon fonts (`ThemeFonts::ensureLoaded`)
/// - Applies WinUI-aligned UI font stack (`ThemeFonts::applyApplicationFont`)
/// - Optional `appId`: Windows AppUserModelID + Linux desktop file name (no `.desktop`)
///
/// The kit does **not** enforce a single-instance mutex by default. Gallery and
/// consumer exes may launch multiple processes; `WebView2Host` uses a per-pid
/// user-data folder by default.
///
/// Opt-in single-instance (2.74): set `QWINUI3_SINGLE_INSTANCE=1` and call
/// `WindowHelper.tryBecomeSingleInstancePrimary(appId)` (or construct
/// `SingleInstance` and `tryBecomePrimary`) — see docs/single-instance.md.
void configureApplication(const QString &appId = QString());

} // namespace QWinUI3
