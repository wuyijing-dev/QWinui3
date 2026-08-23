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
    QCoreApplication::setOrganizationName(QStringLiteral("Example"));
    QCoreApplication::setApplicationName(QStringLiteral("MyQWinUI3App"));
    QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));

    // Optional single-instance (2.74): QWINUI3_SINGLE_INSTANCE=1 + SingleInstance —
    // docs/single-instance.md. Default is multi-instance.

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MyApp", "Main");
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load MyApp/Main";
        return -1;
    }
    return app.exec();
}
