#include "FrameStatsMonitor.h"

#include <QWinUI3/Compat/QtCompatRhi.h>

#include <QCoreApplication>
#include <QElapsedTimer>
#include <QQmlEngine>
#include <QQuickWindow>
#include <QSGRendererInterface>
#include <QSettings>
#include <cstring>

FrameStatsMonitor *FrameStatsMonitor::s_instance = nullptr;

FrameStatsMonitor::FrameStatsMonitor(QObject *parent)
    : QObject(parent)
{
    loadSettings();
}

FrameStatsMonitor *FrameStatsMonitor::create(QQmlEngine *, QJSEngine *)
{
    auto *self = instance();
    QQmlEngine::setObjectOwnership(self, QQmlEngine::CppOwnership);
    return self;
}

FrameStatsMonitor *FrameStatsMonitor::instance()
{
    if (!s_instance)
        s_instance = new FrameStatsMonitor;
    return s_instance;
}

void FrameStatsMonitor::applyCli(int &argc, char **argv)
{
    for (int i = 1; i < argc; ++i) {
        if (!argv[i])
            continue;
        if (std::strcmp(argv[i], "--show-fps") == 0) {
            instance()->setEnabled(true);
            continue;
        }
        if (std::strcmp(argv[i], "--fps-overlay") == 0) {
            instance()->setEnabled(true);
            instance()->setInTitleBar(false);
            continue;
        }
        if (std::strcmp(argv[i], "--show-rhi") == 0) {
            instance()->setShowRhi(true);
            instance()->setEnabled(true);
            continue;
        }
        if (std::strcmp(argv[i], "--show-diagnostics") == 0) {
            instance()->setEnabled(true);
            instance()->setShowRhi(true);
            continue;
        }
        if (std::strcmp(argv[i], "--retail-diagnostics") == 0) {
            instance()->applyRetailProfile();
            continue;
        }
    }
}

bool FrameStatsMonitor::enabled() const
{
    return m_enabled;
}

void FrameStatsMonitor::setEnabled(bool on)
{
    if (m_enabled == on)
        return;
    m_enabled = on;
    if (!m_enabled) {
        m_fps = 0.0;
        m_frameTimeMs = 0.0;
        m_haveLastFrame = false;
        m_frameCount = 0;
        m_accumMs = 0.0;
    } else if (m_showRhi || m_rhiBackend.isEmpty()) {
        refreshRhi();
    }
    updateFrameConnection();
    saveSettings();
    emit changed();
}

bool FrameStatsMonitor::inTitleBar() const
{
    return m_inTitleBar;
}

void FrameStatsMonitor::setInTitleBar(bool inTitleBar)
{
    if (m_inTitleBar == inTitleBar)
        return;
    m_inTitleBar = inTitleBar;
    saveSettings();
    emit changed();
}

bool FrameStatsMonitor::showRhi() const
{
    return m_showRhi;
}

void FrameStatsMonitor::setShowRhi(bool on)
{
    if (m_showRhi == on)
        return;
    m_showRhi = on;
    if (m_showRhi)
        refreshRhi();
    updateFrameConnection();
    saveSettings();
    emit changed();
}

bool FrameStatsMonitor::persistSettings() const
{
    return m_persistSettings;
}

void FrameStatsMonitor::setPersistSettings(bool on)
{
    if (m_persistSettings == on)
        return;
    m_persistSettings = on;
    emit changed();
}

bool FrameStatsMonitor::retailMode() const
{
    return m_retailMode;
}

void FrameStatsMonitor::setRetailMode(bool on)
{
    if (m_retailMode == on)
        return;
    m_retailMode = on;
    if (m_retailMode) {
        m_enabled = false;
        m_showRhi = false;
    }
    emit changed();
}

void FrameStatsMonitor::applyRetailProfile()
{
    setRetailMode(true);
    setPersistSettings(false);
    setEnabled(false);
    setShowRhi(false);
    if (!QCoreApplication::instance())
        return;
    QSettings settings;
    settings.remove(QStringLiteral("performance/showFps"));
    settings.remove(QStringLiteral("performance/fpsInTitleBar"));
    settings.remove(QStringLiteral("performance/showRhiInBadge"));
}

qreal FrameStatsMonitor::fps() const
{
    return m_fps;
}

qreal FrameStatsMonitor::frameTimeMs() const
{
    return m_frameTimeMs;
}

QString FrameStatsMonitor::rhiBackend() const
{
    return m_rhiBackend;
}

QString FrameStatsMonitor::rhiLabel() const
{
    return m_rhiLabel;
}

void FrameStatsMonitor::loadSettings()
{
    if (!QCoreApplication::instance())
        return;
    QSettings settings;
    if (m_retailMode) {
        m_enabled = false;
        m_showRhi = false;
        m_inTitleBar = settings.value(QStringLiteral("performance/fpsInTitleBar"), true).toBool();
        return;
    }
    m_enabled = settings.value(QStringLiteral("performance/showFps"), false).toBool();
    m_inTitleBar = settings.value(QStringLiteral("performance/fpsInTitleBar"), true).toBool();
    m_showRhi = settings.value(QStringLiteral("performance/showRhiInBadge"), false).toBool();
}

void FrameStatsMonitor::saveSettings()
{
    if (!QCoreApplication::instance() || !m_persistSettings || m_retailMode)
        return;
    QSettings settings;
    settings.setValue(QStringLiteral("performance/showFps"), m_enabled);
    settings.setValue(QStringLiteral("performance/fpsInTitleBar"), m_inTitleBar);
    settings.setValue(QStringLiteral("performance/showRhiInBadge"), m_showRhi);
}

void FrameStatsMonitor::attachWindow(QQuickWindow *window)
{
    bindWindow(window);
}

void FrameStatsMonitor::refreshRhi()
{
    QString backend;
    if (m_window) {
        if (auto *rif = m_window->rendererInterface()) {
            backend = QWinUI3::Compat::Rhi::backendForGraphicsApi(rif->graphicsApi());
        }
    }
    if (backend.isEmpty()) {
        backend = QWinUI3::Compat::Rhi::normalize(
            QString::fromUtf8(qgetenv("QSG_RHI_BACKEND")));
    }

    const QString label = backend.isEmpty()
            ? QString()
            : QWinUI3::Compat::Rhi::displayName(backend);

    const bool backendChanged = backend != m_rhiBackend;
    const bool labelChanged = label != m_rhiLabel;
    m_rhiBackend = backend;
    m_rhiLabel = label;

    if (backendChanged || labelChanged)
        emit changed();
}

bool FrameStatsMonitor::wantsSampling() const
{
    // 3.38 S15 — connect frameSwapped only when FPS or RHI readout is active.
    return m_enabled || m_showRhi;
}

void FrameStatsMonitor::updateFrameConnection()
{
    if (m_frameConn)
        QObject::disconnect(m_frameConn);
    m_frameConn = {};
    if (!m_window || !wantsSampling())
        return;

    m_frameConn = connect(m_window, &QQuickWindow::frameSwapped, this, [this]() {
        onFrameSwapped();
    });
}

void FrameStatsMonitor::bindWindow(QQuickWindow *window)
{
    if (m_window == window)
        return;

    if (m_frameConn)
        QObject::disconnect(m_frameConn);
    m_frameConn = {};
    m_window = window;
    m_haveLastFrame = false;
    m_frameCount = 0;
    m_accumMs = 0.0;

    if (wantsSampling())
        refreshRhi();

    updateFrameConnection();
}

void FrameStatsMonitor::onFrameSwapped()
{
    if (!wantsSampling())
        return;

    if (m_showRhi && m_rhiBackend.isEmpty())
        refreshRhi();

    if (!m_enabled)
        return;

    static thread_local QElapsedTimer timer;
    if (!timer.isValid())
        timer.start();

    const qint64 nowNs = timer.nsecsElapsed();
    if (m_haveLastFrame) {
        const qreal dtMs = qreal(nowNs - m_lastFrameNs) / 1'000'000.0;
        if (dtMs > 0.0 && dtMs < 1000.0) {
            m_frameTimeMs = dtMs;
            m_frameCount++;
            m_accumMs += dtMs;
            if (m_accumMs >= 500.0) {
                m_fps = (m_frameCount * 1000.0) / m_accumMs;
                m_frameCount = 0;
                m_accumMs = 0.0;
                emit changed();
            } else {
                emit changed();
            }
        }
    }
    m_lastFrameNs = nowNs;
    m_haveLastFrame = true;
}
