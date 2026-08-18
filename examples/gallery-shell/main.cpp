#include <QCoreApplication>
#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>
#include <QDebug>
#include <cstring>

#include "Bootstrap.h"

QWINUI3_IMPORT_QML_PLUGINS

static QString argValue(int argc, char *argv[], const char *flag)
{
    const QByteArray key(flag);
    for (int i = 1; i < argc; ++i) {
        if (!argv[i])
            continue;
        const QByteArray a(argv[i]);
        if (a == key && i + 1 < argc && argv[i + 1])
            return QString::fromLocal8Bit(argv[i + 1]);
        if (a.startsWith(key + '='))
            return QString::fromLocal8Bit(a.mid(key.size() + 1));
    }
    return {};
}

// Optional --lang <locale> (2.12 consumer recipe). Prefers :/i18n from qt_add_translations,
// then translations/ beside the exe (windeploy / package layout).
static bool installShellTranslator(QGuiApplication &app, QTranslator *translator, const QString &lang)
{
    if (lang.isEmpty() || !translator)
        return false;

    const QString fileStem = QStringLiteral("qwinui3_gallery_shell_%1").arg(lang);
    const QString resourceQm = QStringLiteral(":/i18n/") + fileStem + QStringLiteral(".qm");
    if (translator->load(resourceQm)) {
        app.installTranslator(translator);
        qInfo("GalleryShell translator: %s", qPrintable(resourceQm));
        return true;
    }

    const QString appDir = QCoreApplication::applicationDirPath();
    const QStringList dirs = {
        appDir + QStringLiteral("/translations"),
        appDir,
    };
    for (const QString &dir : dirs) {
        const QString qm = QDir(dir).filePath(fileStem + QStringLiteral(".qm"));
        if (translator->load(qm)) {
            app.installTranslator(translator);
            qInfo("GalleryShell translator: %s", qPrintable(qm));
            return true;
        }
    }

    qWarning("GalleryShell: --lang=%s but no .qm (rebuild after editing .ts — docs/i18n-rtl.md)",
             qPrintable(lang));
    return false;
}

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]);
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("QWinUI3"));
    QCoreApplication::setApplicationName(QStringLiteral("GalleryShellExample"));
    QWinUI3::configureApplication(QStringLiteral("org.qwinui3.example.galleryshell"));
    // Retail profile for shipping apps — docs/developer-diagnostics.md (2.44).
    // FrameStatsMonitor::instance()->applyRetailProfile();
    // FrameStatsMonitor::applyCli(argc, argv); // optional internal QA overrides

    const QString lang = argValue(argc, argv, "--lang");
    QTranslator shellTranslator;
    if (!lang.isEmpty())
        installShellTranslator(app, &shellTranslator, lang);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QWinUI3.Examples.GalleryShell", "Main");
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load QWinUI3.Examples.GalleryShell/Main";
        return -1;
    }
    return app.exec();
}
