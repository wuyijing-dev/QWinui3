#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickStyle>
#include <QDebug>
#include <QtQml/QQmlExtensionPlugin>
#include <cstring>

#include "GraphicsBackend.h"
#include "WindowHelper.h"
#include "ThemeFonts.h"

Q_IMPORT_QML_PLUGIN(QWinUI3Plugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_ThemePlugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_ExtrasPlugin)
Q_IMPORT_QML_PLUGIN(QWinUI3_PlatformPlugin)

static bool hasArg(int argc, char *argv[], const char *flag)
{
    for (int i = 1; i < argc; ++i) {
        if (argv[i] && std::strcmp(argv[i], flag) == 0)
            return true;
    }
    return false;
}

static void sanitizeWindowsQpa()
{
#if defined(Q_OS_WIN)
    // Cursor / CI shells often export QT_QPA_PLATFORM=offscreen (or xcb).
    // Desktop MSVC kits and windeploy trees typically only ship qwindows.dll →
    // "Available platform plugins are: windows."
    // Opt out only with QWINUI3_ALLOW_FOREIGN_QPA=1 (KEEP alone is not enough —
    // Cursor may leave KEEP + offscreen together).
    if (qEnvironmentVariableIsSet("QWINUI3_ALLOW_FOREIGN_QPA"))
        return;
    const QByteArray p = qgetenv("QT_QPA_PLATFORM").trimmed().toLower();
    if (p.isEmpty() || p == "windows" || p == "direct2d")
        return;
    qputenv("QT_QPA_PLATFORM", "windows");
#endif
}

int main(int argc, char *argv[])
{
    const bool smoke = hasArg(argc, argv, "--smoke");

    // Always sanitize on Windows — not only --smoke (normal Gallery runs hit the
    // same Cursor/CI offscreen inheritance and show the fatal QPA dialog).
    sanitizeWindowsQpa();

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

    // Linux: Wayland-first QPA + client-side chrome (must run before QGuiApplication).
    // Smoke already set QT_QPA_PLATFORM when needed — configure leaves non-empty values alone.
    WindowHelper::configurePlatformEnvironment(argv[0]);
    // RHI / surface format only — do not touch QSettings or QObject singletons yet.
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

    // Safe now that QCoreApplication exists.
    GraphicsBackend::syncAfterApp();
    ThemeFonts::ensureLoaded();

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
