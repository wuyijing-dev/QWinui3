#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QDebug>
#include <QtQml/QQmlExtensionPlugin>

#include "GraphicsBackend.h"
#include "WindowHelper.h"

Q_IMPORT_QML_PLUGIN(QWinUI3Plugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_ThemePlugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_ExtrasPlugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_PlatformPlugin)

int main(int argc, char *argv[])
{
    // Linux: Wayland-first QPA + client-side chrome (must run before QGuiApplication).
    WindowHelper::configurePlatformEnvironment();
    GraphicsBackend::applyEarly(argc, argv);

    // Do not load Qt Virtual Keyboard (GPL/Commercial); use system IME instead.
    qunsetenv("QT_IM_MODULE");
    qputenv("QT_QUICK_CONTROLS_STYLE", "QWinUI3");
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("QWinUI3"));
    QCoreApplication::setApplicationName(QStringLiteral("Gallery"));
    // Wayland app_id / desktop entry id (without .desktop suffix).
    QGuiApplication::setDesktopFileName(QStringLiteral("org.qwinui3.gallery"));
    // Windows taskbar grouping / toast identity (call early).
    WindowHelper::setAppUserModelId(QStringLiteral("org.qwinui3.gallery"));
    QQuickStyle::setStyle(QStringLiteral("QWinUI3"));

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::warnings,
                     [](const QList<QQmlError> &warnings) {
                         for (const QQmlError &e : warnings)
                             qWarning() << e.toString();
                     });
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("QWinUI3.Gallery", "Main");
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load QWinUI3.Gallery/Main";
        qWarning() << "Style:" << QQuickStyle::name();
        return -1;
    }
    return app.exec();
}
