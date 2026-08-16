#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickStyle>
#include <QDebug>
#include <cstring>

#include "Bootstrap.h"
#include "GraphicsBackend.h"

QWINUI3_IMPORT_QML_PLUGINS

static bool hasArg(int argc, char *argv[], const char *flag)
{
    for (int i = 1; i < argc; ++i) {
        if (argv[i] && std::strcmp(argv[i], flag) == 0)
            return true;
    }
    return false;
}

int main(int argc, char *argv[])
{
    const bool smoke = hasArg(argc, argv, "--smoke");

    // CI / local smoke: pick a QPA that desktop kits actually ship.
    if (smoke) {
#if defined(Q_OS_WIN)
        qputenv("QT_QPA_PLATFORM", "windows");
#else
        if (qEnvironmentVariableIsEmpty("QT_QPA_PLATFORM")
            || qgetenv("QT_QPA_PLATFORM") == "windows")
            qputenv("QT_QPA_PLATFORM", "offscreen");
#endif
        qputenv("QWINUI3_KEEP_QPA_PLATFORM", "1");
    }

    // One-call kit setup (style + Wayland/DPI + IME) — before QGuiApplication.
    QWinUI3::configureEnvironment(argv[0]);
    // RHI / surface format only — Gallery-specific; do not touch QSettings yet.
    GraphicsBackend::applyEarly(argc, argv);

    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("QWinUI3"));
    QCoreApplication::setApplicationName(QStringLiteral("Gallery"));
    QWinUI3::configureApplication(QStringLiteral("org.qwinui3.gallery"));

    // Safe now that QCoreApplication exists.
    GraphicsBackend::syncAfterApp();

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

    // Lightweight CI gate: Main loads, then critical Gallery pages instantiate (1.20).
    // No pixel diffs — see docs/ci-smoke.md.
    if (smoke) {
        QCoreApplication::processEvents();
        static const char *const kCriticalPages[] = {
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
            "I18nRtlPage",
            nullptr,
        };
        int pagesOk = 0;
        for (int i = 0; kCriticalPages[i]; ++i) {
            const QByteArray typeName(kCriticalPages[i]);
            QQmlComponent typed(&engine);
            typed.setData(QByteArrayLiteral("import QWinUI3.Gallery\n") + typeName
                              + QByteArrayLiteral(" {}\n"),
                          QUrl(QStringLiteral("qwinui3-smoke://%1").arg(QString::fromUtf8(typeName))));
            if (typed.isError()) {
                qWarning() << "smoke page compile failed:" << kCriticalPages[i] << typed.errors();
                return 2;
            }
            QObject *obj = typed.create();
            if (!obj) {
                qWarning() << "smoke page create failed:" << kCriticalPages[i] << typed.errors();
                return 2;
            }
            delete obj;
            ++pagesOk;
            QCoreApplication::processEvents();
        }
        qInfo("QWinUI3 Gallery smoke OK (roots=%d, style=%s, pages=%d)",
              engine.rootObjects().size(),
              qPrintable(QQuickStyle::name()),
              pagesOk);
        return 0;
    }

    return app.exec();
}
