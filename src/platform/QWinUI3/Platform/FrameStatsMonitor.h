#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

#include <QQuickWindow>

class FrameStatsMonitor : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY changed)
    Q_PROPERTY(bool inTitleBar READ inTitleBar WRITE setInTitleBar NOTIFY changed)
    Q_PROPERTY(qreal fps READ fps NOTIFY changed)
    Q_PROPERTY(qreal frameTimeMs READ frameTimeMs NOTIFY changed)

public:
    explicit FrameStatsMonitor(QObject *parent = nullptr);

    static FrameStatsMonitor *create(QQmlEngine *engine, QJSEngine *scriptEngine);
    static FrameStatsMonitor *instance();

    static void applyCli(int &argc, char **argv);

    bool enabled() const;
    void setEnabled(bool on);

    bool inTitleBar() const;
    void setInTitleBar(bool inTitleBar);

    qreal fps() const;
    qreal frameTimeMs() const;

    Q_INVOKABLE void attachWindow(QQuickWindow *window);

signals:
    void changed();

private:
    void bindWindow(QQuickWindow *window);
    void onFrameSwapped();
    void loadSettings();
    void saveSettings();

    static FrameStatsMonitor *s_instance;

    QQuickWindow *m_window = nullptr;
    QMetaObject::Connection m_frameConn;

    bool m_enabled = false;
    bool m_inTitleBar = true;
    qreal m_fps = 0.0;
    qreal m_frameTimeMs = 0.0;

    bool m_haveLastFrame = false;
    qint64 m_lastFrameNs = 0;
    int m_frameCount = 0;
    qreal m_accumMs = 0.0;
};
