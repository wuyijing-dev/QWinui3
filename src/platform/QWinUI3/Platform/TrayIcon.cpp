#include "TrayIcon.h"
#include "LinuxPortal.h"

#include <QCoreApplication>
#include <QEvent>
#include <QGuiApplication>
#include <QProcess>
#include <QWindow>

#if defined(Q_OS_WIN)
#  include <shellapi.h>
#endif

#if defined(Q_OS_WIN)
namespace {
constexpr UINT kTrayIconId = 1;
constexpr UINT kTrayCallback = WM_APP + 42;
}
#endif

TrayIcon::TrayIcon(QObject *parent)
    : QObject(parent)
{
#if defined(Q_OS_WIN)
    ZeroMemory(&m_nid, sizeof(m_nid));
#endif
}

TrayIcon::~TrayIcon()
{
    destroyIcon();
}

bool TrayIcon::supportsMessages() const
{
#if defined(Q_OS_WIN) || defined(Q_OS_LINUX)
    return true;
#else
    return false;
#endif
}

void TrayIcon::setTrayVisible(bool visible)
{
    if (m_visible == visible)
        return;
    m_visible = visible;
    if (m_visible)
        ensureCreated();
    else
        destroyIcon();
    emit trayVisibleChanged();
}

void TrayIcon::setTooltip(const QString &tooltip)
{
    if (m_tooltip == tooltip)
        return;
    m_tooltip = tooltip;
    applyTooltip();
    emit tooltipChanged();
}

void TrayIcon::setIconSource(const QUrl &url)
{
    if (m_iconSource == url)
        return;
    m_iconSource = url;
    emit iconSourceChanged();
    if (m_visible) {
        destroyIcon();
        ensureCreated();
    }
}

void TrayIcon::notifySystem(const QString &title, const QString &message, int icon)
{
    Q_UNUSED(icon);
    emit notified(title, message);
#if defined(Q_OS_WIN)
    ensureCreated();
    if (!m_created)
        return;
    m_nid.uFlags = NIF_INFO;
    wcsncpy_s(m_nid.szInfoTitle, reinterpret_cast<LPCWSTR>(title.utf16()), _TRUNCATE);
    wcsncpy_s(m_nid.szInfo, reinterpret_cast<LPCWSTR>(message.utf16()), _TRUNCATE);
    m_nid.dwInfoFlags = NIIF_INFO;
    Shell_NotifyIconW(NIM_MODIFY, &m_nid);
    m_nid.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
#elif defined(Q_OS_LINUX)
    if (LinuxPortal::notify(QCoreApplication::applicationName(), title, message))
        return;
    QStringList args;
    if (!title.isEmpty())
        args << title;
    args << (message.isEmpty() ? QStringLiteral(" ") : message);
    QProcess::startDetached(QStringLiteral("notify-send"), args);
#else
    Q_UNUSED(title);
    Q_UNUSED(message);
#endif
}

bool TrayIcon::event(QEvent *event)
{
    return QObject::event(event);
}

void TrayIcon::applyTooltip()
{
#if defined(Q_OS_WIN)
    if (!m_created)
        return;
    wcsncpy_s(m_nid.szTip, reinterpret_cast<LPCWSTR>(m_tooltip.utf16()), _TRUNCATE);
    m_nid.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
    Shell_NotifyIconW(NIM_MODIFY, &m_nid);
#endif
}

void TrayIcon::ensureCreated()
{
#if defined(Q_OS_WIN)
    if (m_created || !m_visible)
        return;

    HINSTANCE inst = GetModuleHandleW(nullptr);
    WNDCLASSW wc {};
    wc.lpfnWndProc = TrayWndProc;
    wc.hInstance = inst;
    wc.lpszClassName = L"QWinUI3TrayIconHost";
    RegisterClassW(&wc);

    m_hwnd = CreateWindowExW(0, L"QWinUI3TrayIconHost", L"", 0, 0, 0, 0, 0,
                             HWND_MESSAGE, nullptr, inst, this);
    if (!m_hwnd)
        return;

    SetWindowLongPtrW(m_hwnd, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(this));

    ZeroMemory(&m_nid, sizeof(m_nid));
    m_nid.cbSize = sizeof(m_nid);
    m_nid.hWnd = m_hwnd;
    m_nid.uID = kTrayIconId;
    m_nid.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
    m_nid.uCallbackMessage = kTrayCallback;
    m_nid.hIcon = LoadIconW(nullptr, IDI_APPLICATION);
    wcsncpy_s(m_nid.szTip, reinterpret_cast<LPCWSTR>(m_tooltip.utf16()), _TRUNCATE);
    if (Shell_NotifyIconW(NIM_ADD, &m_nid))
        m_created = true;
#elif defined(Q_OS_LINUX)
    // No persistent StatusNotifierItem yet — notify-send covers notifySystem.
    Q_UNUSED(m_visible);
#endif
}

void TrayIcon::destroyIcon()
{
#if defined(Q_OS_WIN)
    if (m_created) {
        Shell_NotifyIconW(NIM_DELETE, &m_nid);
        m_created = false;
    }
    if (m_hwnd) {
        DestroyWindow(m_hwnd);
        m_hwnd = nullptr;
    }
#endif
}

#if defined(Q_OS_WIN)
TrayIcon *TrayIcon::instanceFromHwnd(HWND hwnd)
{
    return reinterpret_cast<TrayIcon *>(GetWindowLongPtrW(hwnd, GWLP_USERDATA));
}

LRESULT CALLBACK TrayIcon::TrayWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    if (msg == kTrayCallback) {
        if (TrayIcon *self = instanceFromHwnd(hwnd)) {
            const UINT mouse = LOWORD(lParam);
            if (mouse == WM_LBUTTONUP || mouse == WM_LBUTTONDBLCLK || mouse == WM_RBUTTONUP)
                emit self->trayActivated(int(mouse));
        }
        return 0;
    }
    if (msg == WM_DESTROY)
        return 0;
    return DefWindowProcW(hwnd, msg, wParam, lParam);
}
#endif
