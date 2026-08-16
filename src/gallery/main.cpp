#include <QCoreApplication>
#include <QDir>
#include <QEventLoop>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickStyle>
#include <QTimer>
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

// Published build/qwinui3_gallery.exe sits one level above src/*/QWinUI3 modules.
// qt.conf may omit Gallery — always add the known build-tree import roots.
static void addBuildTreeImportPaths(QQmlEngine &engine)
{
    const QString root = QCoreApplication::applicationDirPath();
    const QStringList candidates = {
        root,
        root + QStringLiteral("/src/gallery"),
        root + QStringLiteral("/src/platform"),
        root + QStringLiteral("/src/extras"),
        root + QStringLiteral("/src/theme"),
        root + QStringLiteral("/src/style"),
    };
    for (const QString &path : candidates) {
        if (QDir(path).exists())
            engine.addImportPath(path);
    }
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
    addBuildTreeImportPaths(engine);
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
        qWarning() << "Import paths:" << engine.importPathList();
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
            const QString typeName = QString::fromUtf8(kCriticalPages[i]);
            // Load the page document directly (same path NavigationView uses via module).
            // Avoid "import Module; Type {}" which can leave QQmlComponent Loading.
            QQmlComponent typed(
                &engine,
                QUrl(QStringLiteral("qrc:/qt/qml/QWinUI3/Gallery/pages/%1.qml").arg(typeName)));
            if (typed.isLoading()) {
                QEventLoop loop;
                QObject::connect(&typed, &QQmlComponent::statusChanged, &loop, &QEventLoop::quit);
                QTimer::singleShot(8000, &loop, &QEventLoop::quit);
                loop.exec();
            }
            if (typed.isError() || typed.status() != QQmlComponent::Ready) {
                qWarning() << "smoke page compile failed:" << kCriticalPages[i]
                           << "status=" << int(typed.status()) << typed.errors();
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
