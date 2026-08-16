#include "WebView2Host.h"

#include <QGuiApplication>
#include <QQuickWindow>
#include <algorithm>
#include <cmath>

#if QWINUI3_WEBVIEW2_IMPL

#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <windows.h>
#  include <wrl.h>
#  include <WebView2.h>

using Microsoft::WRL::Callback;
using Microsoft::WRL::ComPtr;

class WebView2Host::Impl
{
public:
    explicit Impl(WebView2Host *q)
        : q(q)
    {
    }

    ~Impl()
    {
        destroy();
    }

    void destroy()
    {
        if (controller) {
            controller->Close();
            controller.Reset();
        }
        webView.Reset();
        if (childHwnd) {
            DestroyWindow(childHwnd);
            childHwnd = nullptr;
        }
        parentHwnd = nullptr;
        ready = false;
        lastX = lastY = lastW = lastH = -1;
        hadRegion = false;
    }

    void ensureChild(HWND parent)
    {
        if (childHwnd && parentHwnd == parent)
            return;
        destroy();
        parentHwnd = parent;
        if (!parent)
            return;

        static ATOM atom = 0;
        if (!atom) {
            WNDCLASSW wc = {};
            wc.lpfnWndProc = DefWindowProcW;
            wc.hInstance = GetModuleHandleW(nullptr);
            wc.lpszClassName = L"QWinUI3.WebView2Host";
            atom = RegisterClassW(&wc);
        }

        childHwnd = CreateWindowExW(0,
                                    L"QWinUI3.WebView2Host",
                                    L"",
                                    WS_CHILD | WS_VISIBLE,
                                    0, 0, 1, 1,
                                    parent,
                                    nullptr,
                                    GetModuleHandleW(nullptr),
                                    nullptr);
        if (!childHwnd) {
            q->setStatus(QObject::tr("Failed to create WebView2 host window."));
            return;
        }

        syncGeometry();

        HRESULT hr = CreateCoreWebView2EnvironmentWithOptions(
            nullptr, nullptr, nullptr,
            Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
                [this](HRESULT result, ICoreWebView2Environment *env) -> HRESULT {
                    if (FAILED(result) || !env) {
                        q->setStatus(QObject::tr("WebView2 Runtime missing or failed to start."));
                        return result;
                    }
                    return env->CreateCoreWebView2Controller(
                        childHwnd,
                        Callback<ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
                            [this](HRESULT result, ICoreWebView2Controller *ctrl) -> HRESULT {
                                if (FAILED(result) || !ctrl) {
                                    q->setStatus(QObject::tr("Failed to create WebView2 controller."));
                                    return result;
                                }
                                controller = ctrl;
                                controller->get_CoreWebView2(&webView);
                                if (!webView) {
                                    q->setStatus(QObject::tr("WebView2 core unavailable."));
                                    return E_FAIL;
                                }

                                ComPtr<ICoreWebView2Settings> settings;
                                webView->get_Settings(&settings);
                                if (settings) {
                                    settings->put_IsStatusBarEnabled(FALSE);
                                    settings->put_AreDefaultContextMenusEnabled(TRUE);
                                }

                                syncGeometry();
                                ready = true;
                                q->setStatus(QObject::tr("Ready"));

                                EventRegistrationToken token = {};
                                webView->add_NavigationStarting(
                                    Callback<ICoreWebView2NavigationStartingEventHandler>(
                                        [this](ICoreWebView2 *, ICoreWebView2NavigationStartingEventArgs *) -> HRESULT {
                                            q->m_loading = true;
                                            emit q->loadingChanged();
                                            return S_OK;
                                        })
                                        .Get(),
                                    &token);
                                webView->add_NavigationCompleted(
                                    Callback<ICoreWebView2NavigationCompletedEventHandler>(
                                        [this](ICoreWebView2 *, ICoreWebView2NavigationCompletedEventArgs *args) -> HRESULT {
                                            BOOL ok = TRUE;
                                            if (args)
                                                args->get_IsSuccess(&ok);
                                            refreshNavState();
                                            q->m_loading = false;
                                            emit q->loadingChanged();
                                            emit q->navigationCompleted(ok);
                                            return S_OK;
                                        })
                                        .Get(),
                                    &token);
                                webView->add_DocumentTitleChanged(
                                    Callback<ICoreWebView2DocumentTitleChangedEventHandler>(
                                        [this](ICoreWebView2 *sender, IUnknown *) -> HRESULT {
                                            if (!sender)
                                                return S_OK;
                                            LPWSTR title = nullptr;
                                            sender->get_DocumentTitle(&title);
                                            q->m_title = title ? QString::fromWCharArray(title) : QString();
                                            if (title)
                                                CoTaskMemFree(title);
                                            emit q->documentTitleChanged();
                                            return S_OK;
                                        })
                                        .Get(),
                                    &token);

                                if (q->m_source.isValid())
                                    navigate(q->m_source);
                                return S_OK;
                            })
                            .Get());
                })
                .Get());

        if (FAILED(hr))
            q->setStatus(QObject::tr("CreateCoreWebView2Environment failed (0x%1).")
                             .arg(quint32(hr), 8, 16, QLatin1Char('0')));
    }

    // Visible scene rect after intersecting clip: true ancestors (e.g. ScrollView).
    QRectF clippedSceneRect() const
    {
        const QRectF itemScene = q->mapRectToScene(QRectF(0, 0, q->width(), q->height()));
        QRectF visible = itemScene;
        for (QQuickItem *p = q->parentItem(); p; p = p->parentItem()) {
            if (p->clip()) {
                const QRectF pr = p->mapRectToScene(QRectF(0, 0, p->width(), p->height()));
                visible = visible.intersected(pr);
                if (visible.isEmpty())
                    return visible;
            }
        }
        if (QQuickWindow *win = q->window()) {
            if (QQuickItem *ci = win->contentItem())
                visible = visible.intersected(QRectF(0, 0, ci->width(), ci->height()));
        }
        return visible;
    }

    void syncGeometry()
    {
        if (!childHwnd || !q->window())
            return;

        const qreal dpr = q->window()->devicePixelRatio();
        const QRectF itemScene = q->mapRectToScene(QRectF(0, 0, q->width(), q->height()));
        const QRectF visibleScene = clippedSceneRect();

        const bool show = q->isVisible() && q->opacity() > 0.01
                          && itemScene.width() >= 1 && itemScene.height() >= 1
                          && !visibleScene.isEmpty();

        if (!show) {
            ShowWindow(childHwnd, SW_HIDE);
            if (controller)
                controller->put_IsVisible(FALSE);
            lastX = lastY = lastW = lastH = -1;
            return;
        }

        const int x = int(std::lround(itemScene.x() * dpr));
        const int y = int(std::lround(itemScene.y() * dpr));
        const int w = int(std::lround(std::max<qreal>(1, itemScene.width()) * dpr));
        const int h = int(std::lround(std::max<qreal>(1, itemScene.height()) * dpr));

        if (x != lastX || y != lastY || w != lastW || h != lastH) {
            SetWindowPos(childHwnd, nullptr, x, y, w, h,
                         SWP_NOZORDER | SWP_NOACTIVATE);
            lastX = x;
            lastY = y;
            lastW = w;
            lastH = h;
        }
        ShowWindow(childHwnd, SW_SHOWNOACTIVATE);

        // Clip the HWND to the visible intersection so ScrollView does not leak pixels.
        const QRectF localVis = visibleScene.translated(-itemScene.x(), -itemScene.y());
        const int rx = int(std::lround(localVis.x() * dpr));
        const int ry = int(std::lround(localVis.y() * dpr));
        const int rw = int(std::lround(std::max<qreal>(1, localVis.width()) * dpr));
        const int rh = int(std::lround(std::max<qreal>(1, localVis.height()) * dpr));
        const bool needsClip = rx > 0 || ry > 0 || rw < w || rh < h;
        if (needsClip) {
            HRGN rgn = CreateRectRgn(rx, ry, rx + rw, ry + rh);
            if (rgn) {
                SetWindowRgn(childHwnd, rgn, TRUE);
                hadRegion = true;
            }
        } else if (hadRegion) {
            SetWindowRgn(childHwnd, nullptr, TRUE);
            hadRegion = false;
        }

        if (controller) {
            RECT bounds{0, 0, w, h};
            controller->put_Bounds(bounds);
            controller->put_IsVisible(TRUE);
        }
    }

    void navigate(const QUrl &url)
    {
        if (!webView || !url.isValid())
            return;
        const QString s = url.toString();
        webView->Navigate(reinterpret_cast<LPCWSTR>(s.utf16()));
    }

    void reload()
    {
        if (webView)
            webView->Reload();
    }

    void stop()
    {
        if (webView)
            webView->Stop();
    }

    void goBack()
    {
        if (webView)
            webView->GoBack();
    }

    void goForward()
    {
        if (webView)
            webView->GoForward();
    }

    void refreshNavState()
    {
        BOOL back = FALSE;
        BOOL forward = FALSE;
        if (webView) {
            webView->get_CanGoBack(&back);
            webView->get_CanGoForward(&forward);
        }
        const bool b = back;
        const bool f = forward;
        if (b != q->m_canGoBack || f != q->m_canGoForward) {
            q->m_canGoBack = b;
            q->m_canGoForward = f;
            emit q->navigationChanged();
        }
        if (webView) {
            LPWSTR src = nullptr;
            webView->get_Source(&src);
            if (src) {
                const QUrl u = QUrl(QString::fromWCharArray(src));
                CoTaskMemFree(src);
                if (u != q->m_source) {
                    q->m_source = u;
                    emit q->sourceChanged();
                }
            }
        }
    }

    WebView2Host *q = nullptr;
    HWND parentHwnd = nullptr;
    HWND childHwnd = nullptr;
    ComPtr<ICoreWebView2Controller> controller;
    ComPtr<ICoreWebView2> webView;
    bool ready = false;
    int lastX = -1;
    int lastY = -1;
    int lastW = -1;
    int lastH = -1;
    bool hadRegion = false;
};

#endif // QWINUI3_WEBVIEW2_IMPL

WebView2Host::WebView2Host(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, false);
    setAcceptedMouseButtons(Qt::AllButtons);
#if QWINUI3_WEBVIEW2_IMPL
    m_impl = new Impl(this);
    setStatus(tr("Initializing WebView2…"));
#else
    setStatus(tr("WebView2 is Windows-only (build with QWINUI3_BUILD_WEBVIEW2=ON)."));
#endif
}

WebView2Host::~WebView2Host()
{
    unbindWindow();
#if QWINUI3_WEBVIEW2_IMPL
    destroyHost();
    delete m_impl;
    m_impl = nullptr;
#endif
}

bool WebView2Host::runtimeAvailable()
{
#if QWINUI3_WEBVIEW2_IMPL
    return true;
#else
    return false;
#endif
}

void WebView2Host::setSource(const QUrl &url)
{
    if (m_source == url)
        return;
    m_source = url;
    emit sourceChanged();
    navigateInternal(url);
}

void WebView2Host::reload()
{
#if QWINUI3_WEBVIEW2_IMPL
    if (m_impl)
        m_impl->reload();
#endif
}

void WebView2Host::stop()
{
#if QWINUI3_WEBVIEW2_IMPL
    if (m_impl)
        m_impl->stop();
#endif
}

void WebView2Host::goBack()
{
#if QWINUI3_WEBVIEW2_IMPL
    if (m_impl)
        m_impl->goBack();
#endif
}

void WebView2Host::goForward()
{
#if QWINUI3_WEBVIEW2_IMPL
    if (m_impl)
        m_impl->goForward();
#endif
}

void WebView2Host::navigate(const QUrl &url)
{
    setSource(url);
}

void WebView2Host::setStatus(const QString &msg)
{
    if (m_status == msg)
        return;
    m_status = msg;
    emit statusMessageChanged();
}

void WebView2Host::bindWindow(QQuickWindow *win)
{
    unbindWindow();
    if (!win)
        return;
    // frameSwapped covers scroll/flick (afterAnimating alone may skip non-animated frames).
    m_frameConn = connect(win, &QQuickWindow::frameSwapped,
                          this, &WebView2Host::syncChildGeometry,
                          Qt::QueuedConnection);
    m_widthConn = connect(win, &QQuickWindow::widthChanged,
                          this, &WebView2Host::syncChildGeometry);
    m_heightConn = connect(win, &QQuickWindow::heightChanged,
                           this, &WebView2Host::syncChildGeometry);
}

void WebView2Host::unbindWindow()
{
    if (m_frameConn)
        disconnect(m_frameConn);
    if (m_widthConn)
        disconnect(m_widthConn);
    if (m_heightConn)
        disconnect(m_heightConn);
    m_frameConn = {};
    m_widthConn = {};
    m_heightConn = {};
}

void WebView2Host::ensureHost()
{
#if QWINUI3_WEBVIEW2_IMPL
    if (!m_impl || !window())
        return;
    const HWND parent = reinterpret_cast<HWND>(window()->winId());
    m_impl->ensureChild(parent);
#endif
}

void WebView2Host::destroyHost()
{
#if QWINUI3_WEBVIEW2_IMPL
    if (m_impl)
        m_impl->destroy();
#endif
}

void WebView2Host::syncChildGeometry()
{
#if QWINUI3_WEBVIEW2_IMPL
    if (m_impl)
        m_impl->syncGeometry();
#endif
}

void WebView2Host::navigateInternal(const QUrl &url)
{
#if QWINUI3_WEBVIEW2_IMPL
    if (m_impl && m_impl->ready)
        m_impl->navigate(url);
#else
    Q_UNUSED(url);
#endif
}

void WebView2Host::componentComplete()
{
    QQuickItem::componentComplete();
    m_completed = true;
    bindWindow(window());
    ensureHost();
    syncChildGeometry();
}

void WebView2Host::itemChange(ItemChange change, const ItemChangeData &value)
{
    QQuickItem::itemChange(change, value);
    if (change == ItemSceneChange) {
        bindWindow(window());
        if (window())
            ensureHost();
        else
            destroyHost();
        syncChildGeometry();
    } else if (change == ItemVisibleHasChanged) {
        syncChildGeometry();
    }
}

void WebView2Host::geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QQuickItem::geometryChange(newGeometry, oldGeometry);
    syncChildGeometry();
}
