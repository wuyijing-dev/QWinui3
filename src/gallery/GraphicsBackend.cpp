#include "GraphicsBackend.h"

#include <QWinUI3/Compat/QtCompatRhi.h>

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
    // Windows d3d11 · Linux vulkan · macOS metal — with runtime probe fallback.
    return QWinUI3::Compat::Rhi::defaultBackend();
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
    const bool probe = qEnvironmentVariableIntValue("QWINUI3_RHI_PROBE") != 0;

    QString backend;
    if (!cli.isEmpty()) {
        // Explicit CLI — always coerce (probe + fallback) so a bad --rhi still starts.
        backend = QWinUI3::Compat::Rhi::coerceAvailable(cli, defaultBackend());
        QWinUI3::Compat::Rhi::applyDirect(backend);
    } else if (!env.isEmpty()) {
        // Kit Bootstrap / user env already chose — do not re-probe on cold start (3.34).
        if (probe)
            backend = QWinUI3::Compat::Rhi::coerceAvailable(env, defaultBackend());
        else
            backend = env;
        QWinUI3::Compat::Rhi::applyDirect(backend);
    } else if (probe) {
        backend = defaultBackend();
        QWinUI3::Compat::Rhi::applyDirect(backend);
    } else {
        backend = QWinUI3::Compat::Rhi::preferredPlatformBackend();
        QWinUI3::Compat::Rhi::applyDirect(backend);
    }

    g_earlyBackend = backend;

    qInfo().noquote() << QStringLiteral(
                            "QWinUI3 Gallery RHI backend: %1 — change in Settings or --rhi opengl|vulkan|d3d11|d3d12")
                            .arg(backend);
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
        return QStringLiteral("OpenGL — best path for DWM Mica/Acrylic without edge artifacts.");
    if (m_active == QLatin1String("vulkan"))
        return QStringLiteral("Vulkan — Linux default when an ICD is present; alpha OK on many GPUs.");
    if (m_active == QLatin1String("d3d11"))
        return QStringLiteral("Direct3D 11 — Windows default; frost OK, may show a thin white edge.");
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
