#include "WindowHelper.h"

#include <QAbstractNativeEventFilter>
#include <QGuiApplication>
#include <QHash>
#include <QPointer>
#include <QScreen>
#include <QTimer>
#include <QVariant>
#include <QVariantList>
#include <QVector>
#include <QWindow>
#include <QtGlobal>

#ifdef Q_OS_WIN
#  include <Windows.h>
#  include <windowsx.h>
#  include <dwmapi.h>

#  ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#    define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#  endif
#  ifndef DWMWA_WINDOW_CORNER_PREFERENCE
#    define DWMWA_WINDOW_CORNER_PREFERENCE 33
#  endif
#  ifndef DWMWA_BORDER_COLOR
#    define DWMWA_BORDER_COLOR 34
#  endif
#  ifndef DWMWA_CAPTION_COLOR
#    define DWMWA_CAPTION_COLOR 35
#  endif
#  ifndef DWMWA_TEXT_COLOR
#    define DWMWA_TEXT_COLOR 36
#  endif
#  ifndef DWMWA_SYSTEMBACKDROP_TYPE
#    define DWMWA_SYSTEMBACKDROP_TYPE 38
#  endif
#  ifndef DWMWA_COLOR_NONE
#    define DWMWA_COLOR_NONE 0xFFFFFFFE
#  endif
#  ifndef DWMWA_COLOR_DEFAULT
#    define DWMWA_COLOR_DEFAULT 0xFFFFFFFF
#  endif
#  ifndef DWMWCP_ROUND
#    define DWMWCP_DEFAULT 0
#    define DWMWCP_DONOTROUND 1
#    define DWMWCP_ROUND 2
#    define DWMWCP_ROUNDSMALL 3
#  endif
#  ifndef DWMSBT_AUTO
#    define DWMSBT_AUTO 0
#    define DWMSBT_NONE 1
#    define DWMSBT_MAINWINDOW 2
#    define DWMSBT_TRANSIENTWINDOW 3
#    define DWMSBT_TABBEDWINDOW 4
#  endif

#ifndef WM_DPICHANGED
#  define WM_DPICHANGED 0x02E0
#endif

namespace {

HWND hwndOf(QWindow *window)
{
    if (!window)
        return nullptr;
    // Never call winId() before the platform window exists — that forces CreateWindowEx
    // and races with later setFlags(), causing "CreateWindowEx failed" loops.
    if (!window->handle())
        return nullptr;
    return reinterpret_cast<HWND>(window->winId());
}

int frameBorderThickness(HWND hwnd)
{
    const UINT dpi = GetDpiForWindow(hwnd);
    return GetSystemMetricsForDpi(SM_CXFRAME, dpi)
         + GetSystemMetricsForDpi(SM_CXPADDEDBORDER, dpi);
}

COLORREF qColorToColorRef(const QColor &c)
{
    return RGB(c.red(), c.green(), c.blue());
}

// Undocumented but widely used Win10/11 acrylic / host-backdrop API.
// DWMWA_SYSTEMBACKDROP_TYPE often fails to show through Qt's RHI swapchain;
// composition accent blur reliably frosts the desktop behind the window.
enum WINDOWCOMPOSITIONATTRIB {
    WCA_ACCENT_POLICY = 19
};

enum ACCENT_STATE {
    ACCENT_DISABLED = 0,
    ACCENT_ENABLE_GRADIENT = 1,
    ACCENT_ENABLE_TRANSPARENTGRADIENT = 2,
    ACCENT_ENABLE_BLURBEHIND = 3,
    ACCENT_ENABLE_ACRYLICBLURBEHIND = 4,
    ACCENT_ENABLE_HOSTBACKDROP = 5
};

struct ACCENT_POLICY {
    int AccentState;
    DWORD AccentFlags;
    DWORD GradientColor; // AABBGGRR
    DWORD AnimationId;
};

struct WINDOWCOMPOSITIONATTRIBDATA {
    DWORD Attribute;
    PVOID Data;
    SIZE_T SizeOfData;
};

DWORD accentGradient(const QColor &c)
{
    return (DWORD(c.alpha()) << 24) | (DWORD(c.blue()) << 16) | (DWORD(c.green()) << 8)
         | DWORD(c.red());
}

bool setAccentPolicy(HWND hwnd, int accentState, DWORD gradientColor, DWORD accentFlags = 0)
{
    using SetWindowCompositionAttributeFn = BOOL(WINAPI *)(HWND, WINDOWCOMPOSITIONATTRIBDATA *);
    static SetWindowCompositionAttributeFn setAttr = nullptr;
    static bool resolved = false;
    if (!resolved) {
        resolved = true;
        if (HMODULE user32 = GetModuleHandleW(L"user32.dll")) {
            setAttr = reinterpret_cast<SetWindowCompositionAttributeFn>(
                GetProcAddress(user32, "SetWindowCompositionAttribute"));
        }
    }
    if (!setAttr || !hwnd)
        return false;

    ACCENT_POLICY policy{};
    policy.AccentState = accentState;
    policy.AccentFlags = accentFlags;
    policy.GradientColor = gradientColor;
    policy.AnimationId = 0;

    WINDOWCOMPOSITIONATTRIBDATA data{};
    data.Attribute = WCA_ACCENT_POLICY;
    data.Data = &policy;
    data.SizeOfData = sizeof(policy);
    return setAttr(hwnd, &data) == TRUE;
}

bool isWindows11_22H2OrGreater()
{
    using RtlGetVersionFn = LONG(WINAPI *)(OSVERSIONINFOW *);
    static RtlGetVersionFn rtlGetVersion = nullptr;
    static bool resolved = false;
    if (!resolved) {
        resolved = true;
        if (HMODULE ntdll = GetModuleHandleW(L"ntdll.dll")) {
            rtlGetVersion = reinterpret_cast<RtlGetVersionFn>(GetProcAddress(ntdll, "RtlGetVersion"));
        }
    }
    if (!rtlGetVersion)
        return false;
    OSVERSIONINFOW info{};
    info.dwOSVersionInfoSize = sizeof(info);
    if (rtlGetVersion(&info) != 0)
        return false;
    return info.dwMajorVersion > 10
        || (info.dwMajorVersion == 10 && info.dwBuildNumber >= 22621);
}

bool isWindows11OrGreater()
{
    using RtlGetVersionFn = LONG(WINAPI *)(OSVERSIONINFOW *);
    static RtlGetVersionFn rtlGetVersion = nullptr;
    static bool resolved = false;
    if (!resolved) {
        resolved = true;
        if (HMODULE ntdll = GetModuleHandleW(L"ntdll.dll")) {
            rtlGetVersion = reinterpret_cast<RtlGetVersionFn>(GetProcAddress(ntdll, "RtlGetVersion"));
        }
    }
    if (!rtlGetVersion)
        return false;
    OSVERSIONINFOW info{};
    info.dwOSVersionInfoSize = sizeof(info);
    if (rtlGetVersion(&info) != 0)
        return false;
    return info.dwMajorVersion > 10
        || (info.dwMajorVersion == 10 && info.dwBuildNumber >= 22000);
}

// Native Win11 materials — same recipe as FluentUI FluFrameless / Qt forum mica samples:
//   1) DwmExtendFrameIntoClientArea(-1)
//   2) DWMWA_SYSTEMBACKDROP_TYPE (38)
// Do NOT mix AccentPolicy acrylic with system backdrop (covers / breaks DWM mica).
#ifndef DWMWA_MICA_EFFECT
#  define DWMWA_MICA_EFFECT 1029
#endif

void applyNativeDwmBackdrop(HWND hwnd, bool /*dark*/, int backdrop)
{
    // Win11 system backdrop recipe (FluentUI / working Qt mica samples):
    //   1) Disable Win10 Accent + DwmEnableBlurBehindWindow
    //      (enabling blur-behind fights SYSTEMBACKDROP and kills Acrylic blur)
    //   2) DwmExtendFrameIntoClientArea(-1)
    //   3) DWMWA_SYSTEMBACKDROP_TYPE
    setAccentPolicy(hwnd, ACCENT_DISABLED, 0);

    DWM_BLURBEHIND bb{};
    bb.dwFlags = DWM_BB_ENABLE;
    bb.fEnable = FALSE;
    bb.hRgnBlur = nullptr;
    DwmEnableBlurBehindWindow(hwnd, &bb);

    const bool win11 = isWindows11OrGreater();
    const bool win11_22h2 = isWindows11_22H2OrGreater();

    MARGINS margins = { -1, -1, -1, -1 };
    DWORD backdropType = DWMSBT_NONE;
    bool useSystemBackdrop = false;
    bool useLegacyMica = false;

    switch (backdrop) {
    case WindowHelper::BackdropSolid:
    case WindowHelper::BackdropNone:
        margins = { 0, 0, 0, 0 };
        backdropType = DWMSBT_NONE;
        useSystemBackdrop = win11_22h2;
        break;
    case WindowHelper::BackdropTransparent:
        margins = { -1, -1, -1, -1 };
        backdropType = DWMSBT_NONE;
        useSystemBackdrop = win11_22h2;
        if (!win11) {
            setAccentPolicy(hwnd, ACCENT_ENABLE_BLURBEHIND, accentGradient(QColor(255, 255, 255, 80)), 0);
        }
        break;
    case WindowHelper::BackdropAcrylic:
        margins = { -1, -1, -1, -1 };
        if (win11) {
            // TRANSIENTWINDOW = Acrylic (blur of windows behind)
            backdropType = DWMSBT_TRANSIENTWINDOW;
            useSystemBackdrop = true;
        } else {
            setAccentPolicy(hwnd, ACCENT_ENABLE_ACRYLICBLURBEHIND,
                            accentGradient(QColor(252, 252, 252, 180)), 0);
        }
        break;
    case WindowHelper::BackdropMicaAlt:
        margins = { -1, -1, -1, -1 };
        if (win11_22h2) {
            backdropType = DWMSBT_TABBEDWINDOW;
            useSystemBackdrop = true;
        } else if (win11) {
            useLegacyMica = true;
        }
        break;
    case WindowHelper::BackdropAuto:
        margins = { -1, -1, -1, -1 };
        if (win11_22h2) {
            backdropType = DWMSBT_AUTO;
            useSystemBackdrop = true;
        } else if (win11) {
            useLegacyMica = true;
        }
        break;
    case WindowHelper::BackdropMica:
    default:
        margins = { -1, -1, -1, -1 };
        if (win11_22h2) {
            backdropType = DWMSBT_MAINWINDOW;
            useSystemBackdrop = true;
        } else if (win11) {
            useLegacyMica = true;
        } else {
            setAccentPolicy(hwnd, ACCENT_ENABLE_ACRYLICBLURBEHIND,
                            accentGradient(QColor(243, 243, 243, 200)), 0);
        }
        break;
    }

    const HRESULT hrExtend = DwmExtendFrameIntoClientArea(hwnd, &margins);
    if (FAILED(hrExtend))
        qWarning("DwmExtendFrameIntoClientArea failed: 0x%08lx", static_cast<unsigned long>(hrExtend));

    if (useLegacyMica) {
        const BOOL enable = TRUE;
        const HRESULT hrMica = DwmSetWindowAttribute(hwnd, DWMWA_MICA_EFFECT, &enable, sizeof(enable));
        if (FAILED(hrMica))
            qWarning("DWMWA_MICA_EFFECT failed: 0x%08lx", static_cast<unsigned long>(hrMica));
    }
    if (useSystemBackdrop || win11_22h2) {
        const HRESULT hr = DwmSetWindowAttribute(hwnd, DWMWA_SYSTEMBACKDROP_TYPE, &backdropType,
                                                 sizeof(backdropType));
        if (FAILED(hr)) {
            qWarning("DWMWA_SYSTEMBACKDROP_TYPE (%lu) failed: 0x%08lx",
                     static_cast<unsigned long>(backdropType),
                     static_cast<unsigned long>(hr));
        } else {
            // Re-extend after attribute — some Qt/DWM builds need the second pass.
            DwmExtendFrameIntoClientArea(hwnd, &margins);
            // Logging is done by caller via ChromeState when type changes.
        }
    }
}

struct ChromeState {
    QPointer<QWindow> window;
    // Hit-test regions in screen-logical coordinates (same space as Item.mapToGlobal).
    // Avoids maximize/fullscreen mismatch between QWindow::x/y and GetWindowRect.
    QRect titleBar;
    QRect minimizeButton;
    QRect maximizeButton;
    QRect closeButton;
    QVector<QRect> clientRects;
    bool dark = false;
    int backdrop = WindowHelper::BackdropSolid;
    int corner = WindowHelper::CornerRound;
    bool borderVisible = false;
    bool trackingNcLeave = false;
    int backdropGeneration = 0;
    DWORD lastLoggedBackdropType = 0xFFFFFFFFu;
};

class WinChromeFilter : public QAbstractNativeEventFilter
{
public:
    static WinChromeFilter *instance()
    {
        // Heap-allocated and intentionally leaked: a function-local static
        // destructor would run after QGuiApplication and can abort() on exit.
        static WinChromeFilter *filter = new WinChromeFilter;
        return filter;
    }

    void applyCornerPreference(HWND hwnd, int cornerPref)
    {
        if (!hwnd)
            return;
        int corner = DWMWCP_ROUND;
        switch (cornerPref) {
        case WindowHelper::CornerDoNotRound:
            corner = DWMWCP_DONOTROUND;
            break;
        case WindowHelper::CornerRoundSmall:
            corner = DWMWCP_ROUNDSMALL;
            break;
        case WindowHelper::CornerDefault:
            corner = DWMWCP_DEFAULT;
            break;
        case WindowHelper::CornerRound:
        default:
            corner = DWMWCP_ROUND;
            break;
        }
        DwmSetWindowAttribute(hwnd, DWMWA_WINDOW_CORNER_PREFERENCE, &corner, sizeof(corner));
    }

    void scheduleBackdropReapply(QWindow *window, bool dark, int backdrop, int delayMs = 80)
    {
        if (!window || m_shuttingDown || !m_states.contains(window))
            return;
        ChromeState &state = m_states[window];
        state.dark = dark;
        state.backdrop = backdrop;
        const int gen = ++state.backdropGeneration;
        const int cornerPref = state.corner;
        QTimer::singleShot(delayMs, qApp, [this, window, dark, backdrop, gen, cornerPref]() {
            if (m_shuttingDown || !m_states.contains(window))
                return;
            if (m_states[window].backdropGeneration != gen)
                return; // superseded by a newer schedule
            HWND h = hwndOf(window);
            if (!h)
                return;
            // Style/frame changes clear DWM corner — restore after Qt settles.
            applyCornerPreference(h, cornerPref);
            applyBorderColor(window);
            applyNativeDwmBackdrop(h, dark, backdrop);
        });
    }

    void logBackdropIfChanged(QWindow *window, int backdrop)
    {
        if (!window || !m_states.contains(window))
            return;
        DWORD type = DWMSBT_NONE;
        switch (backdrop) {
        case WindowHelper::BackdropAcrylic: type = DWMSBT_TRANSIENTWINDOW; break;
        case WindowHelper::BackdropMicaAlt: type = DWMSBT_TABBEDWINDOW; break;
        case WindowHelper::BackdropAuto: type = DWMSBT_AUTO; break;
        case WindowHelper::BackdropMica: type = DWMSBT_MAINWINDOW; break;
        case WindowHelper::BackdropTransparent:
        case WindowHelper::BackdropSolid:
        case WindowHelper::BackdropNone:
        default: type = DWMSBT_NONE; break;
        }
        ChromeState &state = m_states[window];
        if (state.lastLoggedBackdropType == type)
            return;
        state.lastLoggedBackdropType = type;
        qInfo("DWM system backdrop applied: type=%lu", static_cast<unsigned long>(type));
    }

    void attach(QWindow *window, WindowHelper *helper)
    {
        if (!window || !helper || m_shuttingDown)
            return;
        if (m_helper.data() != helper) {
            m_helper = helper;
            QObject::connect(helper, &QObject::destroyed, qApp, [this]() {
                m_helper.clear();
            });
        }
        const bool first = !m_states.contains(window);
        ChromeState &state = m_states[window];
        state.window = window;
        if (!m_installed && qApp) {
            qApp->installNativeEventFilter(this);
            m_installed = true;
        }
        if (!m_quitHooked && qApp) {
            m_quitHooked = true;
            QObject::connect(qApp, &QGuiApplication::aboutToQuit, qApp, [this]() {
                shutdown();
            });
        }

        const HWND hwnd = hwndOf(window);
        bindHwnd(window);
        if (!first)
            return;

        // Capture HWND now — never call winId() from the destroyed handler.
        QObject::connect(window, &QObject::destroyed, qApp, [this, window, hwnd]() {
            detachWindow(window, hwnd);
        });
        QObject::connect(window, &QWindow::visibleChanged, qApp, [this, window](bool visible) {
            if (m_shuttingDown || !visible || !m_states.contains(window) || !m_helper)
                return;
            bindHwnd(window);
            const ChromeState &state = m_states[window];
            applyAttributes(window, state.dark, state.backdrop);
        });
        QObject::connect(window, &QWindow::activeChanged, qApp, [this, window]() {
            if (m_shuttingDown || !m_helper || !m_states.contains(window))
                return;
            m_helper->setWindowActive(window->isActive());
            applyBorderColor(window);
            // One deferred re-apply on focus-in only (no burst of timers).
            if (window->isActive()) {
                const ChromeState &state = m_states[window];
                scheduleBackdropReapply(window, state.dark, state.backdrop, 80);
            }
        });
    }

    void shutdown()
    {
        if (m_shuttingDown)
            return;
        m_shuttingDown = true;
        m_helper.clear();
        m_states.clear();
        m_hwndMap.clear();
        if (m_installed && qApp) {
            qApp->removeNativeEventFilter(this);
            m_installed = false;
        }
    }

    void detachWindow(QWindow *window, HWND hwnd)
    {
        m_states.remove(window);
        if (hwnd)
            m_hwndMap.remove(hwnd);
        for (auto it = m_hwndMap.begin(); it != m_hwndMap.end(); ) {
            if (it.value() == window)
                it = m_hwndMap.erase(it);
            else
                ++it;
        }
    }

    void bindHwnd(QWindow *window)
    {
        if (!window || m_shuttingDown)
            return;
        HWND hwnd = hwndOf(window);
        if (!hwnd)
            return;
        m_hwndMap.insert(hwnd, window);
        applyWindowStyle(window);
        if (m_states.contains(window)) {
            applyCornerPreference(hwnd, m_states[window].corner);
            applyBorderColor(window);
        }
    }

    void updateHitTest(QWindow *window,
                       const QRect &titleBar,
                       const QRect &minimizeButton,
                       const QRect &maximizeButton,
                       const QRect &closeButton,
                       const QVector<QRect> &clientRects)
    {
        if (!window)
            return;
        // Title-bar QML often reports layout before install() attaches the filter.
        // Accept the layout anyway so caption drag works once the HWND is live.
        if (!m_states.contains(window)) {
            if (!m_helper)
                return;
            attach(window, m_helper);
        }
        if (!m_states.contains(window))
            return;
        ChromeState &state = m_states[window];
        state.titleBar = titleBar;
        state.minimizeButton = minimizeButton;
        state.maximizeButton = maximizeButton;
        state.closeButton = closeButton;
        state.clientRects = clientRects;
    }

    void applyAttributes(QWindow *window, bool dark, int backdrop)
    {
        if (!window || !m_helper || m_shuttingDown)
            return;
        ChromeState &state = m_states[window];
        state.window = window;
        state.dark = dark;
        state.backdrop = backdrop;
        state.corner = m_helper->cornerPreference();
        state.borderVisible = m_helper->borderVisible();

        HWND hwnd = hwndOf(window);
        if (!hwnd)
            return;

        BOOL useDark = dark ? TRUE : FALSE;
        DwmSetWindowAttribute(hwnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &useDark, sizeof(useDark));

        // Custom caption chrome: COLOR_NONE so DWM does not paint an opaque
        // default caption plate into the extended client area (reads as no frost).
        const bool frosted = backdrop != WindowHelper::BackdropSolid
            && backdrop != WindowHelper::BackdropNone;
        const DWORD captionColor = frosted ? DWMWA_COLOR_NONE : DWMWA_COLOR_DEFAULT;
        DwmSetWindowAttribute(hwnd, DWMWA_CAPTION_COLOR, &captionColor, sizeof(captionColor));
        DwmSetWindowAttribute(hwnd, DWMWA_TEXT_COLOR, &captionColor, sizeof(captionColor));

        // Style first — SWP_FRAMECHANGED resets DWM corner preference.
        applyWindowStyle(window);
        applyCornerPreference(hwnd, state.corner);
        applyBorderColor(window);
        applyNativeDwmBackdrop(hwnd, dark, backdrop);
        logBackdropIfChanged(window, backdrop);

        // Qt 6.8 may overwrite early DWM calls after show/flags — reapply corner + backdrop.
        scheduleBackdropReapply(window, dark, backdrop, 80);
        scheduleBackdropReapply(window, dark, backdrop, 250);
    }

    void applyBorderColor(QWindow *window)
    {
        if (!window || !m_helper || m_shuttingDown || !m_states.contains(window))
            return;
        HWND hwnd = hwndOf(window);
        if (!hwnd)
            return;

        const ChromeState &state = m_states[window];
        // Frosted hosts: hide the DWM border. Light-theme DWM borders read as a
        // white ring and flash again on focus changes; Main.qml draws a stable
        // 1px frame instead when borderVisible is true.
        const bool frosted = state.backdrop != WindowHelper::BackdropSolid
            && state.backdrop != WindowHelper::BackdropNone;
        DWORD border = DWMWA_COLOR_DEFAULT;
        if (!state.borderVisible || frosted) {
            border = DWMWA_COLOR_NONE;
        } else if (!window->isActive()) {
            border = state.dark ? qColorToColorRef(QColor(0x45, 0x45, 0x45))
                                : qColorToColorRef(QColor(0xA0, 0xA0, 0xA0));
        } else {
            border = state.dark ? qColorToColorRef(QColor(0x60, 0x60, 0x60))
                                : qColorToColorRef(QColor(0x8A, 0x8A, 0x8A));
        }
        DwmSetWindowAttribute(hwnd, DWMWA_BORDER_COLOR, &border, sizeof(border));
    }

    void applyWindowStyle(QWindow *window)
    {
        HWND hwnd = hwndOf(window);
        if (!hwnd)
            return;

        const LONG_PTR style = GetWindowLongPtrW(hwnd, GWL_STYLE);
        SetWindowLongPtrW(hwnd, GWL_STYLE,
                          (style | WS_THICKFRAME | WS_MAXIMIZEBOX | WS_MINIMIZEBOX | WS_SYSMENU
                           | WS_OVERLAPPED)
                              & ~WS_CAPTION);
        const LONG_PTR ex = GetWindowLongPtrW(hwnd, GWL_EXSTYLE);
        SetWindowLongPtrW(hwnd, GWL_EXSTYLE, ex & ~WS_EX_CLIENTEDGE);
        SetWindowPos(hwnd, nullptr, 0, 0, 0, 0,
                     SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER
                         | SWP_NOACTIVATE);
    }

    void ensureNcTracking(HWND hwnd, ChromeState &state)
    {
        if (state.trackingNcLeave)
            return;
        TRACKMOUSEEVENT tme{};
        tme.cbSize = sizeof(tme);
        tme.dwFlags = TME_LEAVE | TME_NONCLIENT;
        tme.hwndTrack = hwnd;
        if (TrackMouseEvent(&tme))
            state.trackingNcLeave = true;
    }

    bool nativeEventFilter(const QByteArray &eventType, void *message, qintptr *result) override
    {
        if (m_shuttingDown)
            return false;
        if (eventType != "windows_generic_MSG" && eventType != "windows_dispatcher_MSG")
            return false;

        MSG *msg = static_cast<MSG *>(message);
        if (!msg || !result)
            return false;

        QWindow *window = m_hwndMap.value(msg->hwnd);
        if (!window) {
            for (auto it = m_states.begin(); it != m_states.end(); ++it) {
                if (hwndOf(it.key()) == msg->hwnd) {
                    window = it.key();
                    m_hwndMap.insert(msg->hwnd, window);
                    break;
                }
            }
        }
        if (!window || !m_states.contains(window))
            return false;

        ChromeState &state = m_states[window];
        const qreal dpr = window->devicePixelRatio();

        switch (msg->message) {
        case WM_NCCALCSIZE: {
            if (msg->wParam != TRUE)
                return false;
            auto *params = reinterpret_cast<NCCALCSIZE_PARAMS *>(msg->lParam);
            if (IsZoomed(msg->hwnd)) {
                HMONITOR monitor = MonitorFromWindow(msg->hwnd, MONITOR_DEFAULTTONEAREST);
                MONITORINFO info{ sizeof(MONITORINFO) };
                if (GetMonitorInfoW(monitor, &info)) {
                    params->rgrc[0] = info.rcWork;
                } else {
                    const int border = frameBorderThickness(msg->hwnd);
                    params->rgrc[0].left += border;
                    params->rgrc[0].top += border;
                    params->rgrc[0].right -= border;
                    params->rgrc[0].bottom -= border;
                }
            }
            *result = 0;
            return true;
        }
        case WM_NCHITTEST: {
            // lParam is screen physical pixels — compare against screen-logical
            // rects from QML (mapToGlobal) scaled by DPR. Do not use QWindow::x/y;
            // maximize/fullscreen often disagree with GetWindowRect.
            POINT pt{ GET_X_LPARAM(msg->lParam), GET_Y_LPARAM(msg->lParam) };
            RECT wr{};
            GetWindowRect(msg->hwnd, &wr);
            const int x = pt.x - wr.left;
            const int y = pt.y - wr.top;
            const int w = wr.right - wr.left;
            const int h = wr.bottom - wr.top;
            const bool maximized = IsZoomed(msg->hwnd);
            const bool fullscreen = window->visibility() == QWindow::FullScreen;
            const int border = (maximized || fullscreen) ? 0 : frameBorderThickness(msg->hwnd);

            auto containsScreen = [&](const QRect &r) {
                if (!r.isValid() || r.isEmpty())
                    return false;
                const int l = qRound(r.x() * dpr);
                const int t = qRound(r.y() * dpr);
                const int rw = qRound(r.width() * dpr);
                const int rh = qRound(r.height() * dpr);
                return pt.x >= l && pt.y >= t && pt.x < l + rw && pt.y < t + rh;
            };

            if (!maximized && !fullscreen) {
                const bool left = x < border;
                const bool right = x >= w - border;
                const bool top = y < border;
                const bool bottom = y >= h - border;
                if (top && left) {
                    *result = HTTOPLEFT;
                    return true;
                }
                if (top && right) {
                    *result = HTTOPRIGHT;
                    return true;
                }
                if (bottom && left) {
                    *result = HTBOTTOMLEFT;
                    return true;
                }
                if (bottom && right) {
                    *result = HTBOTTOMRIGHT;
                    return true;
                }
                if (left) {
                    *result = HTLEFT;
                    return true;
                }
                if (right) {
                    *result = HTRIGHT;
                    return true;
                }
                if (top) {
                    *result = HTTOP;
                    return true;
                }
                if (bottom) {
                    *result = HTBOTTOM;
                    return true;
                }
            }

            // Caption buttons: return HTCLIENT so Qt/QML owns input and hover.
            // HTMAXBUTTON/HTCLOSE/HTMINBUTTON make Win11 paint the native caption
            // button chrome — on translucent Mica/Acrylic that shows as an opaque
            // white rectangle over the custom glyph (especially on press/hover).
            // Trade-off: Snap Layouts flyout on maximize hover is unavailable.
            if (containsScreen(state.closeButton)
                || containsScreen(state.maximizeButton)
                || containsScreen(state.minimizeButton)) {
                if (m_helper)
                    m_helper->setCaptionHover(WindowHelper::CaptionNone);
                *result = HTCLIENT;
                return true;
            }

            for (const QRect &clientRect : state.clientRects) {
                if (containsScreen(clientRect)) {
                    if (m_helper)
                        m_helper->setCaptionHover(WindowHelper::CaptionNone);
                    *result = HTCLIENT;
                    return true;
                }
            }

            if (containsScreen(state.titleBar)) {
                if (m_helper)
                    m_helper->setCaptionHover(WindowHelper::CaptionNone);
                ensureNcTracking(msg->hwnd, state);
                *result = HTCAPTION;
                return true;
            }

            if (m_helper)
                m_helper->setCaptionHover(WindowHelper::CaptionNone);
            *result = HTCLIENT;
            return true;
        }
        case WM_NCLBUTTONDOWN: {
            const int ht = static_cast<int>(msg->wParam);
            if (ht == HTMINBUTTON || ht == HTMAXBUTTON || ht == HTCLOSE) {
                if (m_helper) {
                    if (ht == HTMINBUTTON)
                        m_helper->setCaptionPressed(WindowHelper::CaptionMinimize);
                    else if (ht == HTMAXBUTTON)
                        m_helper->setCaptionPressed(WindowHelper::CaptionMaximize);
                    else
                        m_helper->setCaptionPressed(WindowHelper::CaptionClose);
                }
                *result = 0;
                return true;
            }
            return false;
        }
        case WM_NCLBUTTONUP: {
            const int ht = static_cast<int>(msg->wParam);
            if (m_helper)
                m_helper->setCaptionPressed(WindowHelper::CaptionNone);
            if (ht == HTMINBUTTON) {
                ShowWindow(msg->hwnd, SW_MINIMIZE);
                *result = 0;
                return true;
            }
            if (ht == HTMAXBUTTON) {
                if (IsZoomed(msg->hwnd))
                    ShowWindow(msg->hwnd, SW_RESTORE);
                else
                    ShowWindow(msg->hwnd, SW_MAXIMIZE);
                *result = 0;
                return true;
            }
            if (ht == HTCLOSE) {
                PostMessageW(msg->hwnd, WM_CLOSE, 0, 0);
                *result = 0;
                return true;
            }
            return false;
        }
        case WM_NCLBUTTONDBLCLK: {
            // DefWindowProc toggles maximize on HTCAPTION; eat caption-button doubles.
            const int ht = static_cast<int>(msg->wParam);
            if (ht == HTMINBUTTON || ht == HTMAXBUTTON || ht == HTCLOSE) {
                *result = 0;
                return true;
            }
            return false;
        }
        case WM_NCMOUSEMOVE:
            ensureNcTracking(msg->hwnd, state);
            return false;
        case WM_NCMOUSELEAVE:
            state.trackingNcLeave = false;
            if (m_helper) {
                m_helper->setCaptionHover(WindowHelper::CaptionNone);
                m_helper->setCaptionPressed(WindowHelper::CaptionNone);
            }
            return false;
        case WM_NCACTIVATE: {
            // Update active chrome visuals, but do not eat the message — Qt/DWM
            // need the default handling during teardown and activation.
            if (m_helper)
                m_helper->setWindowActive(msg->wParam != FALSE);
            applyBorderColor(window);
            if (msg->wParam != FALSE)
                scheduleBackdropReapply(window, state.dark, state.backdrop, 80);
            return false;
        }
        case WM_NCRBUTTONUP: {
            if (msg->wParam != HTCAPTION)
                return false;
            const HMENU menu = GetSystemMenu(msg->hwnd, FALSE);
            if (!menu)
                return false;
            const bool zoomed = IsZoomed(msg->hwnd);
            EnableMenuItem(menu, SC_RESTORE, MF_BYCOMMAND | (zoomed ? MF_ENABLED : MF_GRAYED));
            EnableMenuItem(menu, SC_MOVE, MF_BYCOMMAND | (zoomed ? MF_GRAYED : MF_ENABLED));
            EnableMenuItem(menu, SC_SIZE, MF_BYCOMMAND | (zoomed ? MF_GRAYED : MF_ENABLED));
            EnableMenuItem(menu, SC_MAXIMIZE, MF_BYCOMMAND | (zoomed ? MF_GRAYED : MF_ENABLED));
            EnableMenuItem(menu, SC_MINIMIZE, MF_BYCOMMAND | MF_ENABLED);
            EnableMenuItem(menu, SC_CLOSE, MF_BYCOMMAND | MF_ENABLED);
            const int cmd = TrackPopupMenu(
                menu,
                TPM_RETURNCMD | TPM_LEFTBUTTON | TPM_RIGHTBUTTON,
                GET_X_LPARAM(msg->lParam),
                GET_Y_LPARAM(msg->lParam),
                0,
                msg->hwnd,
                nullptr);
            if (cmd)
                PostMessageW(msg->hwnd, WM_SYSCOMMAND, cmd, 0);
            *result = 0;
            return true;
        }
        case WM_GETMINMAXINFO: {
            auto *mmi = reinterpret_cast<MINMAXINFO *>(msg->lParam);
            HMONITOR monitor = MonitorFromWindow(msg->hwnd, MONITOR_DEFAULTTONEAREST);
            MONITORINFO info{ sizeof(MONITORINFO) };
            if (!GetMonitorInfoW(monitor, &info))
                return false;
            const RECT &work = info.rcWork;
            const RECT &monitorRect = info.rcMonitor;
            mmi->ptMaxPosition.x = work.left - monitorRect.left;
            mmi->ptMaxPosition.y = work.top - monitorRect.top;
            mmi->ptMaxSize.x = work.right - work.left;
            mmi->ptMaxSize.y = work.bottom - work.top;
            *result = 0;
            return true;
        }
        case WM_DPICHANGED: {
            // Let Qt handle resize; refresh border metrics via style change.
            applyWindowStyle(window);
            return false;
        }
        case WM_DWMCOMPOSITIONCHANGED:
        case WM_DWMCOLORIZATIONCOLORCHANGED:
            if (m_helper)
                applyAttributes(window, state.dark, state.backdrop);
            return false;
        default:
            break;
        }
        return false;
    }

private:
    WinChromeFilter() = default;
    bool m_installed = false;
    bool m_quitHooked = false;
    bool m_shuttingDown = false;
    QPointer<WindowHelper> m_helper;
    QHash<QWindow *, ChromeState> m_states;
    QHash<HWND, QWindow *> m_hwndMap;
};

} // namespace
#endif // Q_OS_WIN

void WindowHelper::applyNative(QWindow *window, bool dark, int backdrop)
{
    if (!window)
        return;

#ifdef Q_OS_WIN
    WinChromeFilter::instance()->attach(window, this);
    WinChromeFilter::instance()->applyAttributes(window, dark, backdrop);
#else
    Q_UNUSED(dark);
    Q_UNUSED(backdrop);
#endif
}

void WindowHelper::updateHitTestLayout(QObject *windowObject,
                                       const QRect &titleBar,
                                       const QRect &minimizeButton,
                                       const QRect &maximizeButton,
                                       const QRect &closeButton,
                                       const QVariantList &clientRects)
{
#ifdef Q_OS_WIN
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return;
    QVector<QRect> rects;
    rects.reserve(clientRects.size());
    for (const QVariant &value : clientRects) {
        if (value.canConvert<QRect>())
            rects.push_back(value.toRect());
        else if (value.canConvert<QRectF>())
            rects.push_back(value.toRectF().toRect());
    }
    WinChromeFilter::instance()->attach(window, this);
    WinChromeFilter::instance()->updateHitTest(window, titleBar, minimizeButton,
                                               maximizeButton, closeButton, rects);
#else
    Q_UNUSED(windowObject);
    Q_UNUSED(titleBar);
    Q_UNUSED(minimizeButton);
    Q_UNUSED(maximizeButton);
    Q_UNUSED(closeButton);
    Q_UNUSED(clientRects);
#endif
}
