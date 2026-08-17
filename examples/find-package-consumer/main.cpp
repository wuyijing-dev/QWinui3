#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

#include <QWinUI3/Bootstrap.h>

// Shared kits load QML plugins from qml/ — do not Q_IMPORT_QML_PLUGIN here.

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]);
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("QWinUI3"));
    QCoreApplication::setApplicationName(QStringLiteral("FindPackageConsumer"));
    QWinUI3::configureApplication(QStringLiteral("org.qwinui3.example.findpackage"));

    QQmlApplicationEngine engine;
#ifdef QWINUI3_QML_ROOT
    engine.addImportPath(QString::fromUtf8(QWINUI3_QML_ROOT));
#endif
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QWinUI3.Examples.FindPackageConsumer", "Main");
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load FindPackageConsumer/Main";
        return -1;
    }
    return app.exec();
}
