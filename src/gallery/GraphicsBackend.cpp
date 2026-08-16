#include "GraphicsBackend.h"

#include <QWinUI3/Compat/QtCompatQml.h>
#include <QWinUI3/Compat/QtCompatRhi.h>
#include <QWinUI3/Compat/QtCompatVersion.h>

#include <QCoreApplication>
#include <QGuiApplication>
#include <QProcess>
#include <QQmlEngine>
#include <QSettings>
#include <QDebug>

namespace {
GraphicsBackend *g_instance = nullptr;
QString g_earlyBackend;
} // namespace

GraphicsBackend::GraphicsBackend(QObject *parent)
    : QObject(parent)
{
    m_preferred = readStoredPreferred();
    if (m_preferred.isEmpty())
        m_preferred = defaultBackend();
    m_active = QWinUI3::Compat::Rhi::normalize(QString::fromUtf8(qgetenv("QSG_RHI_BACKEND")));
    if (m_active.isEmpty())
        m_active = m_preferred;
}

GraphicsBackend *GraphicsBackend::create(QQmlEngine *, QJSEngine *)
{
    auto *self = instance();
    QQmlEngine::setObjectOwnership(self, QQmlEngine::CppOwnership);
    return self;
}

GraphicsBackend *GraphicsBackend::instance()
{
    if (!g_instance)
        g_instance = new GraphicsBackend;
    return g_instance;
}

QString GraphicsBackend::normalize(const QString &name)
{
    return QWinUI3::Compat::Rhi::normalize(name);
}

QString GraphicsBackend::defaultBackend()
{
#if defined(Q_OS_WIN)
    // OpenGL is the most reliable path for per-pixel alpha + DWM materials.
    return QStringLiteral("opengl");
#else
    return QStringLiteral("opengl");
#endif
}

QStringList GraphicsBackend::platformBackends()
{
    return QWinUI3::Compat::Rhi::platformBackends();
}

QString GraphicsBackend::readStoredPreferred()
{
    // QSettings requires QCoreApplication — never call before QGuiApplication.
    if (!QCoreApplication::instance())
        return {};
    QSettings settings(QStringLiteral("QWinUI3"), QStringLiteral("Gallery"));
    return normalize(settings.value(QStringLiteral("graphics/rhiBackend")).toString());
}

void GraphicsBackend::writeStoredPreferred(const QString &backend)
{
    if (!QCoreApplication::instance())
        return;
    QSettings settings(QStringLiteral("QWinUI3"), QStringLiteral("Gallery"));
    settings.setValue(QStringLiteral("graphics/rhiBackend"), backend);
}

QString GraphicsBackend::parseCli(int &argc, char **argv)
{
    QString chosen;
    for (int i = 1; i < argc; ++i) {
        const QString arg = QString::fromLocal8Bit(argv[i]);
        QString value;
        if (arg == QLatin1String("--rhi") || arg == QLatin1String("-rhi")) {
            if (i + 1 < argc)
                value = QString::fromLocal8Bit(argv[++i]);
        } else if (arg.startsWith(QLatin1String("--rhi="))) {
            value = arg.mid(6);
        }
        const QString normalized = normalize(value);
        if (!normalized.isEmpty())
            chosen = normalized;
    }
    return chosen;
}

void GraphicsBackend::apply(const QString &backend)
{
    QWinUI3::Compat::Rhi::apply(backend);
}

QString GraphicsBackend::applyEarly(int &argc, char **argv)
{
    const QString cli = parseCli(argc, argv);
    const QString env = normalize(QString::fromUtf8(qgetenv("QSG_RHI_BACKEND")));
    // Intentionally skip QSettings / instance() here — both need QCoreApplication.

    QString backend;
    if (!cli.isEmpty())
        backend = cli;
    else if (!env.isEmpty())
        backend = env;
    else
        backend = defaultBackend();

    backend = QWinUI3::Compat::Rhi::coerceAvailable(backend, defaultBackend());

    apply(backend);
    g_earlyBackend = backend;

    qInfo().nospace() << "QWinUI3 Gallery RHI backend: " << backend
                      << " (" << QWinUI3::Compat::Qml::supportRangeString()
                      << "; change in Settings or pass --rhi opengl|vulkan|d3d11|d3d12)";
    return backend;
}

void GraphicsBackend::syncAfterApp()
{
    auto *self = instance();
    const QString stored = readStoredPreferred();
    self->m_active = g_earlyBackend.isEmpty() ? defaultBackend() : g_earlyBackend;
    self->m_preferred = stored.isEmpty() ? self->m_active : stored;
    // If the user saved a different backend, keep it as preferred (restart to apply).
    // Re-apply only when no CLI/env forced the early choice and a stored value exists.
    if (qEnvironmentVariableIsEmpty("QSG_RHI_BACKEND") && stored.isEmpty() == false
        && g_earlyBackend == defaultBackend() && stored != self->m_active) {
        // Too late to change RHI safely; surface via restartRequired.
        self->m_preferred = stored;
    }
    emit self->changed();
}

QString GraphicsBackend::active() const
{
    return m_active;
}

QString GraphicsBackend::preferred() const
{
    return m_preferred;
}

void GraphicsBackend::setPreferred(const QString &backend)
{
    const QString normalized = normalize(backend);
    if (normalized.isEmpty() || !platformBackends().contains(normalized))
        return;
    if (normalized == m_preferred)
        return;
    m_preferred = normalized;
    writeStoredPreferred(normalized);
    emit changed();
}

QStringList GraphicsBackend::available() const
{
    return platformBackends();
}

bool GraphicsBackend::restartRequired() const
{
    return !m_preferred.isEmpty() && m_preferred != m_active;
}

QString GraphicsBackend::hint() const
{
    if (m_active == QLatin1String("opengl"))
        return QStringLiteral("OpenGL — recommended for DWM frost without edge artifacts.");
    if (m_active == QLatin1String("vulkan"))
        return QStringLiteral("Vulkan — alpha OK on many GPUs; border workarounds are limited.");
    if (m_active == QLatin1String("d3d11"))
        return QStringLiteral("Direct3D 11 — frost works; may show a thin white edge ring.");
    if (m_active == QLatin1String("d3d12")) {
#if QWINUI3_HAVE_RHI_D3D12
        return QStringLiteral("Direct3D 12 — frost works; may show a thin white edge ring.");
#else
        return QStringLiteral("Direct3D 12 — requires Qt 6.6+ (unavailable in this build).");
#endif
    }
    if (m_active == QLatin1String("metal"))
        return QStringLiteral("Metal — macOS default path.");
    return {};
}

void GraphicsBackend::restartApplication()
{
    const QString program = QCoreApplication::applicationFilePath();
    QStringList args = QCoreApplication::arguments();
    if (!args.isEmpty())
        args.removeFirst();
    // Drop a previous --rhi so the saved preference / fresh CLI wins cleanly.
    QStringList filtered;
    for (int i = 0; i < args.size(); ++i) {
        const QString &a = args.at(i);
        if (a == QLatin1String("--rhi") || a == QLatin1String("-rhi")) {
            ++i;
            continue;
        }
        if (a.startsWith(QLatin1String("--rhi=")))
            continue;
        filtered << a;
    }
    filtered.prepend(QStringLiteral("--rhi=%1").arg(m_preferred));
    QProcess::startDetached(program, filtered);
    QCoreApplication::quit();
}
