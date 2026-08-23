#pragma once

#include <QQuickItem>
#include <QUrl>
#include <QtQml/qqmlregistration.h>

#if defined(Q_OS_WIN) && defined(QWINUI3_HAS_WEBVIEW2)
#  define QWINUI3_WEBVIEW2_IMPL 1
#else
#  define QWINUI3_WEBVIEW2_IMPL 0
#endif

class QQuickWindow;

// WebView2Host — HWND-backed Edge WebView2 under a QQuickItem (Windows only).
//
//   WebView2Host {
//       source: "https://example.com"
//       anchors.fill: parent
//   }
//
// Lifecycle: creates a child HWND + controller when attached to a window; destroys
// on scene detach. Geometry follows mapToScene each frame (ScrollView / Flickable)
// and clips to clip:true ancestors.
//
// User data: default AppLocalDataLocation/WebView2Host/p<pid> (multi-exe safe).
// Override with userDataFolder for a shared single-instance profile.
//
// Missing Runtime: runtimeInstalled is false; statusMessage explains; Gallery shows EmptyState.
// Focus: when the item gains activeFocus, focus moves into the browser (and back on blur).
// Stable (1.18): Windows + Evergreen Runtime; see docs/webview2.md soak checklist.
//
class WebView2Host : public QQuickItem
{
    Q_OBJECT
    QML_NAMED_ELEMENT(WebView2Host)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString documentTitle READ documentTitle NOTIFY documentTitleChanged)
    Q_PROPERTY(bool canGoBack READ canGoBack NOTIFY navigationChanged)
    Q_PROPERTY(bool canGoForward READ canGoForward NOTIFY navigationChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    // Compile-time: built with QWINUI3_HAS_WEBVIEW2 on Windows.
    Q_PROPERTY(bool available READ available CONSTANT)
    // Evergreen Runtime present on the machine (false → install UX).
    Q_PROPERTY(bool runtimeInstalled READ runtimeInstalled NOTIFY runtimeInstalledChanged)
    // Controller created and ready to Navigate.
    Q_PROPERTY(bool ready READ ready NOTIFY readyChanged)
    Q_PROPERTY(bool runtimeMissing READ runtimeMissing NOTIFY statusMessageChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)
    Q_PROPERTY(QString runtimeDownloadUrl READ runtimeDownloadUrl CONSTANT)
    // Empty (default): AppLocalDataLocation/WebView2Host/p<pid> — safe for multi-instance.
    // Set a fixed path only when the app is single-instance or you manage locking yourself.
    Q_PROPERTY(QString userDataFolder READ userDataFolder WRITE setUserDataFolder NOTIFY userDataFolderChanged)

public:
    explicit WebView2Host(QQuickItem *parent = nullptr);
    ~WebView2Host() override;

    static bool sdkBuilt();
    static bool queryRuntimeInstalled();
    static QString evergreenDownloadUrl();
    // Default per-process folder under AppLocalDataLocation (multi-exe safe).
    static QString defaultUserDataFolder();

    bool available() const { return sdkBuilt(); }
    bool runtimeInstalled() const { return m_runtimeInstalled; }
    bool ready() const { return m_ready; }
    bool runtimeMissing() const;

    QUrl source() const { return m_source; }
    void setSource(const QUrl &url);

    QString userDataFolder() const { return m_userDataFolder; }
    void setUserDataFolder(const QString &path);

    QString documentTitle() const { return m_title; }
    bool canGoBack() const { return m_canGoBack; }
    bool canGoForward() const { return m_canGoForward; }
    bool loading() const { return m_loading; }
    QString statusMessage() const { return m_status; }
    QString runtimeDownloadUrl() const { return evergreenDownloadUrl(); }

    Q_INVOKABLE void reload();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void goBack();
    Q_INVOKABLE void goForward();
    Q_INVOKABLE void navigate(const QUrl &url);
    Q_INVOKABLE void refreshRuntimeProbe();
    Q_INVOKABLE void focusBrowser();
    Q_INVOKABLE void blurBrowser();

signals:
    void sourceChanged();
    void documentTitleChanged();
    void navigationChanged();
    void loadingChanged();
    void statusMessageChanged();
    void navigationCompleted(bool success);
    void runtimeInstalledChanged();
    void readyChanged();
    void userDataFolderChanged();

protected:
    void itemChange(ItemChange change, const ItemChangeData &value) override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;
    void componentComplete() override;
    void focusInEvent(QFocusEvent *event) override;
    void focusOutEvent(QFocusEvent *event) override;

private:
    void setStatus(const QString &msg);
    void setReady(bool on);
    void ensureHost();
    void destroyHost();
    void syncChildGeometry();
    void navigateInternal(const QUrl &url);
    void bindWindow(QQuickWindow *win);
    void unbindWindow();
    void applyBrowserFocus(bool wantFocus);

    QUrl m_source{QStringLiteral("https://www.microsoft.com/edge/webview")};
    QString m_userDataFolder; // empty → defaultUserDataFolder() at env create
    QString m_title;
    QString m_status;
    bool m_canGoBack = false;
    bool m_canGoForward = false;
    bool m_loading = false;
    bool m_completed = false;
    bool m_runtimeInstalled = false;
    bool m_ready = false;
    QMetaObject::Connection m_frameConn;
    QMetaObject::Connection m_widthConn;
    QMetaObject::Connection m_heightConn;
    QMetaObject::Connection m_screenConn;

#if QWINUI3_WEBVIEW2_IMPL
    class Impl;
    friend class Impl;
    Impl *m_impl = nullptr;
#endif
};
