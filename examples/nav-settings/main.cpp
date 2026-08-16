#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "Bootstrap.h"

QWINUI3_IMPORT_QML_PLUGINS

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]);
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("QWinUI3"));
    QCoreApplication::setApplicationName(QStringLiteral("NavSettingsExample"));
    QWinUI3::configureApplication(QStringLiteral("org.qwinui3.example.navsettings"));

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QWinUI3.Examples.NavSettings", "Main");
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load QWinUI3.Examples.NavSettings/Main";
        return -1;
    }
    return app.exec();
}
