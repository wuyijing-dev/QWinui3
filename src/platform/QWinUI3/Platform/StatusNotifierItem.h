#pragma once

#include <QObject>
#include <QString>

#if defined(Q_OS_LINUX) && defined(QWINUI3_HAS_DBUS)

#include <QDBusObjectPath>

// Minimal org.kde.StatusNotifierItem for persistent Linux tray (KDE / SNI hosts).
class StatusNotifierItem : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.kde.StatusNotifierItem")
    Q_PROPERTY(QString Category READ category CONSTANT)
    Q_PROPERTY(QString Id READ id CONSTANT)
    Q_PROPERTY(QString Title READ title)
    Q_PROPERTY(QString Status READ status CONSTANT)
    Q_PROPERTY(QString IconName READ iconName)
    Q_PROPERTY(QString IconThemePath READ iconThemePath CONSTANT)
    Q_PROPERTY(QString AttentionIconName READ attentionIconName CONSTANT)
    Q_PROPERTY(QString OverlayIconName READ overlayIconName CONSTANT)
    Q_PROPERTY(QString AttentionMovieName READ attentionMovieName CONSTANT)
    Q_PROPERTY(QDBusObjectPath Menu READ menu CONSTANT)
    Q_PROPERTY(bool ItemIsMenu READ itemIsMenu CONSTANT)
    Q_PROPERTY(int WindowId READ windowId CONSTANT)

public:
    explicit StatusNotifierItem(QObject *parent = nullptr);
    ~StatusNotifierItem() override;

    bool registerItem();
    void unregisterItem();
    bool isRegistered() const { return m_registered; }

    void setTitle(const QString &title);
    void setIconName(const QString &name);
    void setTooltip(const QString &tooltip);

    QString category() const { return QStringLiteral("ApplicationStatus"); }
    QString id() const;
    QString title() const { return m_title; }
    QString status() const { return QStringLiteral("Active"); }
    QString iconName() const { return m_iconName; }
    QString iconThemePath() const { return {}; }
    QString attentionIconName() const { return {}; }
    QString overlayIconName() const { return {}; }
    QString attentionMovieName() const { return {}; }
    // Empty menu path — apps handle Activate / ContextMenu via trayActivated.
    QDBusObjectPath menu() const { return QDBusObjectPath(QStringLiteral("/NO_DBUSMENU")); }
    bool itemIsMenu() const { return false; }
    int windowId() const { return 0; }

public Q_SLOTS:
    void Activate(int x, int y);
    void SecondaryActivate(int x, int y);
    void ContextMenu(int x, int y);
    void Scroll(int delta, const QString &orientation);

Q_SIGNALS:
    void NewTitle();
    void NewIcon();
    void NewAttentionIcon();
    void NewOverlayIcon();
    void NewToolTip();
    void NewStatus(const QString &status);

    // App-facing (TrayIcon bridges these). reason: 1=left, 2=context, 3=middle.
    void activated(int reason);

private:
    bool m_registered = false;
    QString m_serviceName;
    QString m_title;
    QString m_iconName = QStringLiteral("application-x-executable");
    QString m_tooltip;
};

#endif // Q_OS_LINUX && QWINUI3_HAS_DBUS
