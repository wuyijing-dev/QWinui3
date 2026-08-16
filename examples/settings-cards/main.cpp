#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QDebug>
#include <QtQml/QQmlExtensionPlugin>

#include "WindowHelper.h"

Q_IMPORT_QML_PLUGIN(QWinUI3Plugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_ThemePlugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_ExtrasPlugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_PlatformPlugin)

int main(int argc, char *argv[])
{
    WindowHelper::configurePlatformEnvironment(argv[0]);
    qunsetenv("QT_IM_MODULE");
    qputenv("QT_QUICK_CONTROLS_STYLE", "QWinUI3");
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("QWinUI3"));
    QCoreApplication::setApplicationName(QStringLiteral("SettingsCardsExample"));
    QGuiApplication::setDesktopFileName(QStringLiteral("org.qwinui3.example.settingscards"));
    QQuickStyle::setStyle(QStringLiteral("QWinUI3"));

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QWinUI3.Examples.SettingsCards", "Main");
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load QWinUI3.Examples.SettingsCards/Main";
        return -1;
    }
    return app.exec();
}
