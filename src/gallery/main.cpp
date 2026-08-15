#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QDebug>
#include <QtQml/QQmlExtensionPlugin>

#include "GraphicsBackend.h"

Q_IMPORT_QML_PLUGIN(QWinUI3Plugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_ThemePlugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_ExtrasPlugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_PlatformPlugin)

int main(int argc, char *argv[])
{
    GraphicsBackend::applyEarly(argc, argv);

    // Do not load Qt Virtual Keyboard (GPL/Commercial); use system IME instead.
    qunsetenv("QT_IM_MODULE");
    qputenv("QT_QUICK_CONTROLS_STYLE", "QWinUI3");
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("QWinUI3"));
    QCoreApplication::setApplicationName(QStringLiteral("Gallery"));
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
