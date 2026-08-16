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
/// - Windows: sanitize foreign `QT_QPA_PLATFORM` (unless `QWINUI3_ALLOW_FOREIGN_QPA`)
/// - Platform env (Wayland-first / DPI) via `WindowHelper::configurePlatformEnvironment`
/// - Prefer system IME (`QT_IM_MODULE` cleared)
/// - Sets `QT_QUICK_CONTROLS_STYLE=QWinUI3`
void configureEnvironment(const char *argv0 = nullptr);

/// Call **after** `QGuiApplication` exists.
/// - `QQuickStyle::setStyle("QWinUI3")`
/// - Loads Fluent icon fonts (`ThemeFonts::ensureLoaded`)
/// - Optional `appId`: Windows AppUserModelID + Linux desktop file name (no `.desktop`)
void configureApplication(const QString &appId = QString());

} // namespace QWinUI3
