#include <QCoreApplication>
#include <QCryptographicHash>
#include <QDir>
#include <QElapsedTimer>
#include <QEventLoop>
#include <QFile>
#include <QGuiApplication>
#include <QImage>
#include <QJsonDocument>
#include <QJsonObject>
#include <QLocale>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickItem>
#include <QQuickStyle>
#include <QQuickWindow>
#include <QTimer>
#include <QTranslator>
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

// Optional --lang <locale> (e.g. zh_CN). Looks for qwinui3_gallery_<locale>.qm (1.45).
static bool installGalleryTranslator(QGuiApplication &app, QTranslator *translator, const QString &lang)
{
    if (lang.isEmpty() || !translator)
        return false;

    const QString fileStem = QStringLiteral("qwinui3_gallery_%1").arg(lang);
    QStringList dirs;
    if (const QByteArray env = qgetenv("QWINUI3_GALLERY_TRANSLATIONS"); !env.isEmpty())
        dirs << QString::fromLocal8Bit(env);
    const QString appDir = QCoreApplication::applicationDirPath();
    dirs << (appDir + QStringLiteral("/translations"))
         << appDir
         << (appDir + QStringLiteral("/../src/gallery/translations"))
         << (appDir + QStringLiteral("/../../src/gallery/translations"))
         << (appDir + QStringLiteral("/../../../src/gallery/translations"));

    for (const QString &dir : dirs) {
        if (dir.isEmpty() || !QDir(dir).exists())
            continue;
        const QString qm = QDir(dir).filePath(fileStem + QStringLiteral(".qm"));
        if (translator->load(qm)) {
            app.installTranslator(translator);
            qInfo("QWinUI3 Gallery translator: %s", qPrintable(qm));
            return true;
        }
        if (translator->load(QLocale(lang),
                             QStringLiteral("qwinui3_gallery"),
                             QStringLiteral("_"),
                             dir)) {
            app.installTranslator(translator);
            qInfo("QWinUI3 Gallery translator (locale): %s in %s",
                  qPrintable(lang), qPrintable(dir));
            return true;
        }
    }
    qWarning("QWinUI3 Gallery: --lang=%s requested but no .qm found "
             "(run lrelease on src/gallery/translations/qwinui3_gallery_%s.ts)",
             qPrintable(lang), qPrintable(lang));
    return false;
}

// 1.62 — subset frame grab (keep in sync with scripts/smoke_visual.py VISUAL_PAGES).
static const char *const kVisualSmokePages[] = {
    "HomePage",
    "ButtonPage",
    "ContentDialogPage",
    "PitfallsPage",
    "ExamplesTemplatesPage",
    nullptr,
};

static int runVisualSmoke(QQmlApplicationEngine &engine, const QString &outDirPath)
{
    QDir outDir(outDirPath);
    if (!outDir.exists() && !outDir.mkpath(QStringLiteral("."))) {
        qWarning() << "visual-smoke: cannot create" << outDirPath;
        return 2;
    }

    QQuickWindow window;
    window.setTitle(QStringLiteral("QWinUI3 visual-smoke"));
    window.setColor(QColor(QStringLiteral("#F3F3F3")));
    window.resize(960, 640);
    window.setMinimumSize(QSize(960, 640));
    window.setMaximumSize(QSize(960, 640));
    window.show();
    QCoreApplication::processEvents();

    QJsonObject pagesJson;
    int pagesOk = 0;
    QElapsedTimer pageTimer;
    pageTimer.start();

    for (int i = 0; kVisualSmokePages[i]; ++i) {
        const QString typeName = QString::fromUtf8(kVisualSmokePages[i]);
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
            qWarning() << "visual-smoke compile failed:" << kVisualSmokePages[i]
                       << "status=" << int(typed.status()) << typed.errors();
            return 2;
        }
        QObject *obj = typed.create();
        if (!obj) {
            qWarning() << "visual-smoke create failed:" << kVisualSmokePages[i] << typed.errors();
            return 2;
        }
        QQuickItem *item = qobject_cast<QQuickItem *>(obj);
        if (!item) {
            qWarning() << "visual-smoke: not a QQuickItem:" << kVisualSmokePages[i];
            delete obj;
            return 2;
        }
        item->setParentItem(window.contentItem());
        item->setWidth(window.width());
        item->setHeight(window.height());

        // Wait for at least two presented frames so deferred effects settle.
        {
            QEventLoop loop;
            int frames = 0;
            QObject::connect(&window, &QQuickWindow::frameSwapped, &loop, [&]() {
                if (++frames >= 2)
                    loop.quit();
            });
            QTimer::singleShot(2000, &loop, &QEventLoop::quit);
            // Kick a redraw.
            window.update();
            loop.exec();
        }
        QCoreApplication::processEvents();

        const QImage img = window.grabWindow();
        if (img.isNull() || img.width() < 320 || img.height() < 240) {
            qWarning() << "visual-smoke grab failed:" << kVisualSmokePages[i]
                       << "size=" << img.size();
            delete obj;
            return 2;
        }

        const QString pngPath = outDir.filePath(typeName + QStringLiteral(".png"));
        if (!img.save(pngPath, "PNG")) {
            qWarning() << "visual-smoke save failed:" << pngPath;
            delete obj;
            return 2;
        }

        QFile pngFile(pngPath);
        if (!pngFile.open(QIODevice::ReadOnly)) {
            qWarning() << "visual-smoke read failed:" << pngPath;
            delete obj;
            return 2;
        }
        const QByteArray pngBytes = pngFile.readAll();
        pngFile.close();
        const QByteArray digest = QCryptographicHash::hash(pngBytes, QCryptographicHash::Sha256);

        QJsonObject entry;
        entry.insert(QStringLiteral("sha256"), QString::fromLatin1(digest.toHex()));
        entry.insert(QStringLiteral("width"), img.width());
        entry.insert(QStringLiteral("height"), img.height());
        entry.insert(QStringLiteral("bytes"), pngBytes.size());
        pagesJson.insert(typeName, entry);

        item->setParentItem(nullptr);
        delete obj;
        ++pagesOk;
        QCoreApplication::processEvents();
        qInfo("visual-smoke: %s ok (%dx%d, %d bytes)",
              qPrintable(typeName), img.width(), img.height(), int(pngBytes.size()));
    }

    QJsonObject root;
    root.insert(QStringLiteral("version"), QStringLiteral("1.62"));
    root.insert(QStringLiteral("width"), 960);
    root.insert(QStringLiteral("height"), 640);
    root.insert(QStringLiteral("pages"), pagesJson);

    const QString manifestPath = outDir.filePath(QStringLiteral("manifest.json"));
    QFile manifest(manifestPath);
    if (!manifest.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        qWarning() << "visual-smoke: cannot write" << manifestPath;
        return 2;
    }
    manifest.write(QJsonDocument(root).toJson(QJsonDocument::Indented));
    manifest.close();

    qInfo("QWinUI3 Gallery visual-smoke OK (pages=%d, grab=%lldms, out=%s)",
          pagesOk,
          static_cast<long long>(pageTimer.elapsed()),
          qPrintable(outDirPath));
    return 0;
}

int main(int argc, char *argv[])
{
    const bool smoke = hasArg(argc, argv, "--smoke");
    const bool visualSmoke = hasArg(argc, argv, "--visual-smoke");
    const bool startupLog = smoke || visualSmoke || hasArg(argc, argv, "--startup-log");
    const QString lang = argValue(argc, argv, "--lang");
    QString visualOut = argValue(argc, argv, "--visual-smoke-dir");
    QElapsedTimer wall;
    if (startupLog)
        wall.start();

    // CI / local smoke: pick a QPA that desktop kits actually ship.
    if (smoke || visualSmoke) {
#if defined(Q_OS_WIN)
        qputenv("QT_QPA_PLATFORM", "windows");
#else
        if (qEnvironmentVariableIsEmpty("QT_QPA_PLATFORM")
            || qgetenv("QT_QPA_PLATFORM") == "windows")
            qputenv("QT_QPA_PLATFORM", "offscreen");
#endif
        qputenv("QWINUI3_KEEP_QPA_PLATFORM", "1");
    }
    if (visualSmoke) {
        // Prefer stable DPR for hash compares (fonts/OS still differ).
        if (qEnvironmentVariableIsEmpty("QT_SCALE_FACTOR"))
            qputenv("QT_SCALE_FACTOR", "1");
        if (qEnvironmentVariableIsEmpty("QT_ENABLE_HIGHDPI_SCALING"))
            qputenv("QT_ENABLE_HIGHDPI_SCALING", "0");
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

    QTranslator galleryTranslator;
    if (!lang.isEmpty())
        installGalleryTranslator(app, &galleryTranslator, lang);

    const qint64 msAfterApp = startupLog ? wall.elapsed() : 0;

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

    const qint64 msAfterMain = startupLog ? wall.elapsed() : 0;
    if (startupLog) {
        qInfo("QWinUI3 Gallery startup: app=%lldms main=%lldms (pages still on-demand)",
              static_cast<long long>(msAfterApp),
              static_cast<long long>(msAfterMain));
    }

    // 1.62 — opt-in visual subset (PNGs + sha256). Not the default --smoke path.
    if (visualSmoke) {
        if (visualOut.isEmpty())
            visualOut = QDir(QCoreApplication::applicationDirPath())
                            .filePath(QStringLiteral("visual-smoke-out"));
        // Hide Main window so only the grab host is visible.
        for (QObject *root : engine.rootObjects()) {
            if (auto *w = qobject_cast<QQuickWindow *>(root))
                w->hide();
        }
        // Prefer quieter chrome for more stable frames (Home MultiEffect, timers).
        if (QObject *theme = engine.singletonInstance<QObject *>(u"QWinUI3.Theme"_qs, u"Theme"_qs)) {
            theme->setProperty("reducedMotion", true);
            theme->setProperty("followSystemAccessibility", false);
        }
        QCoreApplication::processEvents();
        return runVisualSmoke(engine, visualOut);
    }

    // Lightweight CI gate: Main loads, then critical Gallery pages instantiate (1.20).
    // Does not open the full catalog — see docs/ci-smoke.md / docs/performance.md (1.39).
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
            "AnimationsPage",
            "I18nRtlPage",
            "FontIconPage",
            "PitfallsPage",
            "ExamplesTemplatesPage",
            "SearchRecipesPage",
            "HighDpiPage",
            nullptr,
        };
        int pagesOk = 0;
        QElapsedTimer pageTimer;
        pageTimer.start();
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
        const qint64 msPages = pageTimer.elapsed();
        qInfo("QWinUI3 Gallery smoke OK (roots=%d, style=%s, pages=%d, main=%lldms, pages=%lldms, total=%lldms)",
              engine.rootObjects().size(),
              qPrintable(QQuickStyle::name()),
              pagesOk,
              static_cast<long long>(msAfterMain),
              static_cast<long long>(msPages),
              static_cast<long long>(wall.elapsed()));
        return 0;
    }

    return app.exec();
}
