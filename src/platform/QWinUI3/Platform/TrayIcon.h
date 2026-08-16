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

// TrayIcon — System tray icon + balloon / notify-send bridge.
class TrayIcon : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool trayVisible READ trayVisible WRITE setTrayVisible NOTIFY trayVisibleChanged)
    Q_PROPERTY(QString tooltip READ tooltip WRITE setTooltip NOTIFY tooltipChanged)
    Q_PROPERTY(QUrl iconSource READ iconSource WRITE setIconSource NOTIFY iconSourceChanged)
    Q_PROPERTY(bool supportsMessages READ supportsMessages CONSTANT)

public:
    explicit TrayIcon(QObject *parent = nullptr);
    ~TrayIcon() override;

    bool trayVisible() const { return m_visible; }
    void setTrayVisible(bool visible);

    QString tooltip() const { return m_tooltip; }
    void setTooltip(const QString &tooltip);

    QUrl iconSource() const { return m_iconSource; }
    void setIconSource(const QUrl &url);

    bool supportsMessages() const;

    // Show a tray balloon (Windows) or notify-send (Linux)
    Q_INVOKABLE void notifySystem(const QString &title, const QString &message, int icon = 0);

signals:
    void trayVisibleChanged();
    void tooltipChanged();
    void iconSourceChanged();
    void trayActivated(int reason);
    void notified(const QString &title, const QString &message);

protected:
    bool event(QEvent *event) override;

private:
    void ensureCreated();
    void destroyIcon();
    void applyTooltip();

    bool m_visible = false;
    QString m_tooltip;
    QUrl m_iconSource;
#if defined(Q_OS_WIN)
    NOTIFYICONDATAW m_nid {};
    bool m_created = false;
    HWND m_hwnd = nullptr;
    static LRESULT CALLBACK TrayWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
    static TrayIcon *instanceFromHwnd(HWND hwnd);
#endif
};
