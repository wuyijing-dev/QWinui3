#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

#include <QQuickWindow>

// FrameStatsMonitor — FPS / frame-time / RHI readout for Gallery and retail diagnostics (singleton).
class FrameStatsMonitor : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY changed)
    Q_PROPERTY(bool inTitleBar READ inTitleBar WRITE setInTitleBar NOTIFY changed)
    Q_PROPERTY(bool showRhi READ showRhi WRITE setShowRhi NOTIFY changed)
    Q_PROPERTY(bool persistSettings READ persistSettings WRITE setPersistSettings NOTIFY changed)
    Q_PROPERTY(bool retailMode READ retailMode WRITE setRetailMode NOTIFY changed)
    Q_PROPERTY(qreal fps READ fps NOTIFY changed)
    Q_PROPERTY(qreal frameTimeMs READ frameTimeMs NOTIFY changed)
    Q_PROPERTY(QString rhiBackend READ rhiBackend NOTIFY changed)
    Q_PROPERTY(QString rhiLabel READ rhiLabel NOTIFY changed)

public:
    explicit FrameStatsMonitor(QObject *parent = nullptr);

    static FrameStatsMonitor *create(QQmlEngine *engine, QJSEngine *scriptEngine);
    static FrameStatsMonitor *instance();

    static void applyCli(int &argc, char **argv);

    bool enabled() const;
    void setEnabled(bool on);

    bool inTitleBar() const;
    void setInTitleBar(bool inTitleBar);

    bool showRhi() const;
    void setShowRhi(bool on);

    bool persistSettings() const;
    void setPersistSettings(bool on);

    bool retailMode() const;
    void setRetailMode(bool on);

    Q_INVOKABLE void applyRetailProfile();

    qreal fps() const;
    qreal frameTimeMs() const;

    QString rhiBackend() const;
    QString rhiLabel() const;

    Q_INVOKABLE void attachWindow(QQuickWindow *window);

signals:
    void changed();

private:
    void bindWindow(QQuickWindow *window);
    void onFrameSwapped();
    void refreshRhi();
    void updateFrameConnection();
    bool wantsSampling() const;
    void loadSettings();
    void saveSettings();

    static FrameStatsMonitor *s_instance;

    QQuickWindow *m_window = nullptr;
    QMetaObject::Connection m_frameConn;

    bool m_enabled = false;
    bool m_inTitleBar = true;
    bool m_showRhi = false;
    bool m_persistSettings = true;
    bool m_retailMode = false;
    qreal m_fps = 0.0;
    qreal m_frameTimeMs = 0.0;
    QString m_rhiBackend;
    QString m_rhiLabel;

    bool m_haveLastFrame = false;
    qint64 m_lastFrameNs = 0;
    int m_frameCount = 0;
    qreal m_accumMs = 0.0;
};
