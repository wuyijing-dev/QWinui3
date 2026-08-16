#pragma once

#include <QQuickItem>
#include <QUrl>
#include <QtQml/qqmlregistration.h>

#if defined(Q_OS_WIN) && defined(QWINUI3_HAS_WEBVIEW2)
#  define QWINUI3_WEBVIEW2_IMPL 1
#else
#  define QWINUI3_WEBVIEW2_IMPL 0
#endif

// WebView2Host — HWND-backed Edge WebView2 under a QQuickItem (Windows only).
class WebView2Host : public QQuickItem
{
    Q_OBJECT
    QML_NAMED_ELEMENT(WebView2Host)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString documentTitle READ documentTitle NOTIFY documentTitleChanged)
    Q_PROPERTY(bool canGoBack READ canGoBack NOTIFY navigationChanged)
    Q_PROPERTY(bool canGoForward READ canGoForward NOTIFY navigationChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(bool available READ available CONSTANT)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)

public:
    explicit WebView2Host(QQuickItem *parent = nullptr);
    ~WebView2Host() override;

    static bool runtimeAvailable();
    bool available() const { return runtimeAvailable(); }

    QUrl source() const { return m_source; }
    void setSource(const QUrl &url);

    QString documentTitle() const { return m_title; }
    bool canGoBack() const { return m_canGoBack; }
    bool canGoForward() const { return m_canGoForward; }
    bool loading() const { return m_loading; }
    QString statusMessage() const { return m_status; }

    Q_INVOKABLE void reload();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void goBack();
    Q_INVOKABLE void goForward();
    Q_INVOKABLE void navigate(const QUrl &url);

signals:
    void sourceChanged();
    void documentTitleChanged();
    void navigationChanged();
    void loadingChanged();
    void statusMessageChanged();
    void navigationCompleted(bool success);
    void availableChanged(); // unused CONSTANT — kept for QML binding symmetry

protected:
    void itemChange(ItemChange change, const ItemChangeData &value) override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;
    void componentComplete() override;

private:
    void setStatus(const QString &msg);
    void ensureHost();
    void destroyHost();
    void syncChildGeometry();
    void navigateInternal(const QUrl &url);

    QUrl m_source{QStringLiteral("https://www.microsoft.com/edge/webview")};
    QString m_title;
    QString m_status;
    bool m_canGoBack = false;
    bool m_canGoForward = false;
    bool m_loading = false;
    bool m_completed = false;

#if QWINUI3_WEBVIEW2_IMPL
    class Impl;
    friend class Impl;
    Impl *m_impl = nullptr;
#endif
};
