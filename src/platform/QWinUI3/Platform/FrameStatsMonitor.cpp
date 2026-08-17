#include "FrameStatsMonitor.h"

#include <QCoreApplication>
#include <QElapsedTimer>
#include <QQmlEngine>
#include <QQuickWindow>
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
    }
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

qreal FrameStatsMonitor::fps() const
{
    return m_fps;
}

qreal FrameStatsMonitor::frameTimeMs() const
{
    return m_frameTimeMs;
}

void FrameStatsMonitor::loadSettings()
{
    if (!QCoreApplication::instance())
        return;
    QSettings settings;
    m_enabled = settings.value(QStringLiteral("performance/showFps"), false).toBool();
    m_inTitleBar = settings.value(QStringLiteral("performance/fpsInTitleBar"), true).toBool();
}

void FrameStatsMonitor::saveSettings()
{
    if (!QCoreApplication::instance())
        return;
    QSettings settings;
    settings.setValue(QStringLiteral("performance/showFps"), m_enabled);
    settings.setValue(QStringLiteral("performance/fpsInTitleBar"), m_inTitleBar);
}

void FrameStatsMonitor::attachWindow(QQuickWindow *window)
{
    bindWindow(window);
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

    if (!m_window)
        return;

    m_frameConn = connect(m_window, &QQuickWindow::frameSwapped, this, [this]() {
        onFrameSwapped();
    });
}

void FrameStatsMonitor::onFrameSwapped()
{
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
