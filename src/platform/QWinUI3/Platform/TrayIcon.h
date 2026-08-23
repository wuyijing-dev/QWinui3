#pragma once

#include <QObject>
#include <QString>
#include <QUrl>
#include <QtQml/qqmlregistration.h>

#if defined(Q_OS_WIN)
#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <windows.h>
#  include <shellapi.h>
#endif

#if defined(Q_OS_LINUX) && defined(QWINUI3_HAS_DBUS)
class StatusNotifierItem;
#endif

// TrayIcon — System tray icon + balloon / notify-send bridge.
//
//   TrayIcon { trayVisible: true; tooltip: qsTr("App"); iconName: "dialog-information" }
//   tray.notifySystem(title, body, icon)  // icon: 0 info, 1 warning, 2 error
//   onTrayActivated: (reason) => { … }
//     Windows: WM_LBUTTONUP / DBLCLK / RBUTTONUP
//     Linux SNI: 1=Activate, 2=ContextMenu, 3=SecondaryActivate
//
// See docs/system-integration.md.
class TrayIcon : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool trayVisible READ trayVisible WRITE setTrayVisible NOTIFY trayVisibleChanged)
    Q_PROPERTY(QString tooltip READ tooltip WRITE setTooltip NOTIFY tooltipChanged)
    Q_PROPERTY(QUrl iconSource READ iconSource WRITE setIconSource NOTIFY iconSourceChanged)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)
    Q_PROPERTY(bool supportsMessages READ supportsMessages CONSTANT)
    Q_PROPERTY(bool supportsPersistentTray READ supportsPersistentTray CONSTANT)
    Q_PROPERTY(bool persistentTrayActive READ persistentTrayActive NOTIFY persistentTrayActiveChanged)

public:
    explicit TrayIcon(QObject *parent = nullptr);
    ~TrayIcon() override;

    bool trayVisible() const { return m_visible; }
    void setTrayVisible(bool visible);

    QString tooltip() const { return m_tooltip; }
    void setTooltip(const QString &tooltip);

    QUrl iconSource() const { return m_iconSource; }
    void setIconSource(const QUrl &url);

    QString iconName() const { return m_iconName; }
    void setIconName(const QString &name);

    bool supportsMessages() const;
    bool supportsPersistentTray() const;
    bool persistentTrayActive() const;

    // Show a tray balloon (Windows) or portal/notify-send (Linux).
    // icon: 0 = info, 1 = warning, 2 = error (Win NIIF_*; Linux severity ignored).
    Q_INVOKABLE void notifySystem(const QString &title, const QString &message, int icon = 0);
    // Linux: flat [id, label, …] action buttons for org.freedesktop.Notifications (2.69 F4)
    Q_INVOKABLE void notifySystemWithActions(const QString &title, const QString &message,
                                             const QStringList &actions, int icon = 0);

signals:
    void trayVisibleChanged();
    void tooltipChanged();
    void iconSourceChanged();
    void iconNameChanged();
    void persistentTrayActiveChanged();
    void trayActivated(int reason);
    void notified(const QString &title, const QString &message);

protected:
    bool event(QEvent *event) override;

private:
    void ensureCreated();
    void destroyIcon();
    void applyTooltip();
    void applyIconName();

    bool m_visible = false;
    QString m_tooltip;
    QUrl m_iconSource;
    QString m_iconName;
#if defined(Q_OS_WIN)
    NOTIFYICONDATAW m_nid {};
    bool m_created = false;
    HWND m_hwnd = nullptr;
    static LRESULT CALLBACK TrayWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
    static TrayIcon *instanceFromHwnd(HWND hwnd);
#elif defined(Q_OS_LINUX) && defined(QWINUI3_HAS_DBUS)
    StatusNotifierItem *m_sni = nullptr;
#endif
};
