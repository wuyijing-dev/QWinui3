#include "WindowHelper.h"

#include <QGuiApplication>
#include <QJSEngine>
#include <QQmlEngine>
#include <QQuickWindow>
#include <QScreen>
#include <QWindow>

#if defined(Q_OS_WIN)
#  include <Windows.h>
#endif

namespace {

void setWindowFlagsSafe(QWindow *window, Qt::WindowFlags want)
{
    if (!window || window->flags() == want)
        return;
    // If the HWND already exists, recreating via setFlags is what triggers
    // CreateWindowEx failure loops on Windows. Prefer skipping when visible.
    if (window->handle() && window->isVisible()) {
        // Allow Stay-on-top toggles without a full flag replace when possible.
        const Qt::WindowFlags cur = window->flags();
        const Qt::WindowFlags curated = (cur & ~Qt::WindowStaysOnTopHint)
                | (want & Qt::WindowStaysOnTopHint);
        if (curated == want) {
            window->setFlag(Qt::WindowStaysOnTopHint, want.testFlag(Qt::WindowStaysOnTopHint));
            return;
        }
        qWarning("WindowHelper: refusing setFlags on visible window (hwnd live); want=0x%llx have=0x%llx",
                 static_cast<unsigned long long>(int(want)),
                 static_cast<unsigned long long>(int(cur)));
        return;
    }
    const bool wasVisible = window->isVisible();
    window->setFlags(want);
    if (wasVisible)
        window->setVisible(true);
}

} // namespace

WindowHelper *WindowHelper::create(QQmlEngine *, QJSEngine *)
{
    return new WindowHelper;
}

WindowHelper::WindowHelper(QObject *parent)
    : QObject(parent)
    , m_windowColor(Qt::transparent)
{
#if defined(Q_OS_WIN)
    m_windowColor = QColor(0, 0, 0, 0);
#else
    m_windowColor = QColor();
#endif
    refreshTint();
    refreshWallpaper();
    refreshAccessibility();
}

QString WindowHelper::platformName() const
{
#if defined(Q_OS_WIN)
    return QStringLiteral("windows");
#elif defined(Q_OS_LINUX)
    return QStringLiteral("linux");
#else
    return QStringLiteral("other");
#endif
}

bool WindowHelper::isWindows() const
{
#if defined(Q_OS_WIN)
    return true;
#else
    return false;
#endif
}

bool WindowHelper::isLinux() const
{
#if defined(Q_OS_LINUX)
    return true;
#else
    return false;
#endif
}

bool WindowHelper::customFrame() const
{
#if defined(Q_OS_WIN)
    return true;
#else
    return false;
#endif
}

bool WindowHelper::nativeChrome() const
{
#if defined(Q_OS_WIN)
    return true;
#else
    return false;
#endif
}

bool WindowHelper::supportsBackdrop() const
{
#if defined(Q_OS_WIN)
    return true;
#else
    return false;
#endif
}

int WindowHelper::recommendedFlags() const
{
#if defined(Q_OS_WIN)
    return int(Qt::Window | Qt::FramelessWindowHint);
#else
    return int(Qt::Window);
#endif
}

QColor WindowHelper::windowColor() const
{
    return m_windowColor;
}

QColor WindowHelper::contentTint() const
{
    return m_contentTint;
}

QColor WindowHelper::titleBarTint() const
{
    return m_titleBarTint;
}

bool WindowHelper::frostEnabled() const
{
    return m_backdrop != BackdropSolid && m_backdrop != BackdropNone;
}

qreal WindowHelper::frostBlur() const
{
    switch (m_backdrop) {
    case BackdropAcrylic:
        return 1.0;
    case BackdropTransparent:
        return 0.45;
    case BackdropMicaAlt:
        return 0.72;
    case BackdropAuto:
    case BackdropMica:
        return 0.82;
    default:
        return 0.0;
    }
}

qreal WindowHelper::frostSaturation() const
{
    switch (m_backdrop) {
    case BackdropAcrylic:
        return 1.15;
    case BackdropTransparent:
        return 1.0;
    case BackdropMica:
    case BackdropMicaAlt:
    case BackdropAuto:
        return 0.85; // Mica is less saturated
    default:
        return 1.0;
    }
}

QUrl WindowHelper::desktopWallpaperUrl() const
{
    return m_wallpaperUrl;
}

QRect WindowHelper::virtualDesktopGeometry() const
{
#if defined(Q_OS_WIN)
    return QRect(GetSystemMetrics(SM_XVIRTUALSCREEN),
                 GetSystemMetrics(SM_YVIRTUALSCREEN),
                 GetSystemMetrics(SM_CXVIRTUALSCREEN),
                 GetSystemMetrics(SM_CYVIRTUALSCREEN));
#else
    if (auto *screen = QGuiApplication::primaryScreen())
        return screen->virtualGeometry();
    return {};
#endif
}

void WindowHelper::refreshWallpaper()
{
    QUrl url;
#if defined(Q_OS_WIN)
    wchar_t path[MAX_PATH + 1] = {};
    if (SystemParametersInfoW(SPI_GETDESKWALLPAPER, MAX_PATH, path, 0) && path[0] != L'\0')
        url = QUrl::fromLocalFile(QString::fromWCharArray(path));
#endif
    if (url == m_wallpaperUrl)
        return;
    m_wallpaperUrl = url;
    emit wallpaperChanged();
}

void WindowHelper::refreshAccessibility()
{
    bool reduced = false;
    bool highContrast = false;
#if defined(Q_OS_WIN)
    BOOL anim = TRUE;
    if (SystemParametersInfoW(SPI_GETCLIENTAREAANIMATION, 0, &anim, 0))
        reduced = anim == FALSE;

    HIGHCONTRASTW hc = {};
    hc.cbSize = sizeof(hc);
    if (SystemParametersInfoW(SPI_GETHIGHCONTRAST, sizeof(hc), &hc, 0))
        highContrast = (hc.dwFlags & HCF_HIGHCONTRASTON) != 0;
#endif
    if (reduced == m_systemReducedMotion && highContrast == m_systemHighContrast)
        return;
    m_systemReducedMotion = reduced;
    m_systemHighContrast = highContrast;
    emit accessibilityChanged();
}

void WindowHelper::refreshTint()
{
    QColor content;
    QColor title;
    QColor host = QColor(0, 0, 0, 0);

    switch (m_backdrop) {
    case BackdropAcrylic:
        // Keep washes light so native DWM + wallpaper frost remain visible.
        // Title and content share one tint — a heavier title wash reads as a seam line.
        content = m_dark ? QColor(32, 32, 32, 40) : QColor(249, 249, 249, 48);
        title = content;
        break;
    case BackdropMicaAlt:
        content = m_dark ? QColor(32, 32, 32, 50) : QColor(243, 243, 243, 58);
        title = content;
        break;
    case BackdropTransparent:
        content = QColor(0, 0, 0, 0);
        title = content;
        break;
    case BackdropNone:
    case BackdropSolid:
        content = m_dark ? QColor(32, 32, 32, 255) : QColor(243, 243, 243, 255);
        title = content;
        host = content;
        break;
    case BackdropAuto:
    case BackdropMica:
    default:
        content = m_dark ? QColor(32, 32, 32, 52) : QColor(243, 243, 243, 60);
        title = content;
        break;
    }

#if !defined(Q_OS_WIN)
    content = m_dark ? QColor(0x20, 0x20, 0x20) : QColor(0xF3, 0xF3, 0xF3);
    title = m_dark ? QColor(0x2C, 0x2C, 0x2C) : QColor(0xF9, 0xF9, 0xF9);
    host = content;
#endif

    const bool tintChanged = content != m_contentTint || title != m_titleBarTint;
    const bool hostChanged = host != m_windowColor;
    m_contentTint = content;
    m_titleBarTint = title;
    m_windowColor = host;
    if (tintChanged)
        emit contentTintChanged();
    if (hostChanged)
        emit windowColorChanged();
}

void WindowHelper::setBackdropMode(int backdrop)
{
    if (backdrop < BackdropAuto || backdrop > BackdropSolid)
        backdrop = BackdropSolid;
    const bool changed = (m_backdrop != backdrop);
    m_backdrop = backdrop;
    refreshTint();
    if (changed)
        emit backdropChanged();
    reapply();
}

void WindowHelper::setCornerPreference(int corner)
{
    if (corner < CornerDefault || corner > CornerRoundSmall)
        corner = CornerRound;
    const bool changed = (m_corner != corner);
    m_corner = corner;
    if (changed)
        emit cornerPreferenceChanged();
    reapply();
}

void WindowHelper::setBorderVisible(bool visible)
{
    if (m_borderVisible == visible)
        return;
    m_borderVisible = visible;
    emit borderVisibleChanged();
    reapply();
}

void WindowHelper::setCaptionHover(int button)
{
    if (m_captionHover == button)
        return;
    m_captionHover = button;
    emit captionHoverChanged();
}

void WindowHelper::setCaptionPressed(int button)
{
    if (m_captionPressed == button)
        return;
    m_captionPressed = button;
    emit captionPressedChanged();
}

void WindowHelper::setWindowActive(bool active)
{
    if (m_windowActive == active)
        return;
    m_windowActive = active;
    emit windowActiveChanged();
}

QWindow *WindowHelper::resolveWindow(QObject *windowObject) const
{
    auto *window = qobject_cast<QWindow *>(windowObject);
    if (!window)
        window = windowObject ? windowObject->property("window").value<QWindow *>() : nullptr;
    if (!window) {
        if (auto *quick = qobject_cast<QQuickWindow *>(windowObject))
            window = quick;
    }
    return window;
}

QWindow *WindowHelper::currentWindow() const
{
    return m_window;
}

void WindowHelper::install(QObject *windowObject, bool dark, int backdrop)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return;

    m_window = window;
    m_dark = dark;
    if (backdrop < BackdropAuto || backdrop > BackdropSolid)
        backdrop = BackdropSolid;
    if (m_backdrop != backdrop) {
        m_backdrop = backdrop;
        emit backdropChanged();
    }
    refreshTint();

#if defined(Q_OS_WIN)
    // Only touch Frameless when missing — avoids redundant HWND recreation.
    if (!window->flags().testFlag(Qt::FramelessWindowHint))
        setWindowFlagsSafe(window, window->flags() | Qt::FramelessWindowHint);
    if (auto *quick = qobject_cast<QQuickWindow *>(window)) {
        // Frosted hosts must clear with zero alpha or DWM materials stay hidden.
        const bool frosted = m_backdrop != BackdropSolid && m_backdrop != BackdropNone;
        quick->setColor(frosted ? QColor(0, 0, 0, 0) : m_windowColor);
    }
#else
    if (auto *quick = qobject_cast<QQuickWindow *>(window))
        quick->setColor(m_windowColor.isValid() ? m_windowColor : QColor(Qt::white));
#endif

    // UniqueConnection cannot be used with lambdas — disconnect then reconnect.
    QObject::disconnect(window, &QWindow::activeChanged, this, nullptr);
    QObject::connect(window, &QWindow::activeChanged, this, [this]() {
        if (m_window)
            setWindowActive(m_window->isActive());
    });
    QObject::connect(window, &QObject::destroyed, this, [this, window]() {
        if (m_window == window)
            m_window = nullptr;
    });
    setWindowActive(window->isActive());

    applyNative(window, m_dark, m_backdrop);
}

int WindowHelper::flagsForParadigm(int paradigm) const
{
    return flagsForConfig(paradigm, PresenterOverlapped, false);
}

int WindowHelper::flagsForConfig(int paradigm, int presenter, bool alwaysOnTop) const
{
    int base = 0;
#if defined(Q_OS_WIN)
    const int frameless = int(Qt::FramelessWindowHint);
#else
    const int frameless = 0;
#endif

    if (presenter == PresenterCompactOverlay)
        paradigm = ParadigmTool;

    switch (paradigm) {
    case ParadigmDialog:
        base = int(Qt::Dialog) | frameless;
        break;
    case ParadigmTool:
        base = int(Qt::Tool) | frameless;
        break;
    case ParadigmStandard:
    default:
        base = int(Qt::Window) | frameless;
        break;
    }

    if (alwaysOnTop || presenter == PresenterCompactOverlay)
        base |= int(Qt::WindowStaysOnTopHint);

    return base;
}

QString WindowHelper::paradigmName(int paradigm) const
{
    switch (paradigm) {
    case ParadigmDialog:
        return QStringLiteral("dialog");
    case ParadigmTool:
        return QStringLiteral("tool");
    case ParadigmStandard:
    default:
        return QStringLiteral("standard");
    }
}

void WindowHelper::centerOnScreen(QObject *windowObject)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return;
    QScreen *screen = window->screen();
    if (!screen)
        screen = QGuiApplication::primaryScreen();
    if (!screen)
        return;
    const QRect ag = screen->availableGeometry();
    const QSize sz = window->size();
    window->setPosition(ag.x() + (ag.width() - sz.width()) / 2,
                        ag.y() + (ag.height() - sz.height()) / 2);
}

void WindowHelper::installParadigm(QObject *windowObject, int paradigm, bool dark, int backdrop)
{
    installParadigmEx(windowObject, paradigm, dark, backdrop, PresenterOverlapped, false);
}

void WindowHelper::installParadigmEx(QObject *windowObject, int paradigm, bool dark, int backdrop,
                                     int presenter, bool alwaysOnTop)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return;

    if (presenter == PresenterCompactOverlay)
        paradigm = ParadigmTool;

    const Qt::WindowFlags want = Qt::WindowFlags(flagsForConfig(paradigm, presenter, alwaysOnTop));
    setWindowFlagsSafe(window, want);

    switch (paradigm) {
    case ParadigmDialog:
        window->setMinimumSize(QSize(320, 200));
        if (window->width() < 360)
            window->resize(480, 320);
        break;
    case ParadigmTool:
        window->setMinimumSize(QSize(240, 160));
        if (window->width() < 280)
            window->resize(360, 280);
        break;
    case ParadigmStandard:
    default:
        // Don't force a large minimum on compact/fullscreen hosts.
        if (presenter == PresenterOverlapped)
            window->setMinimumSize(QSize(480, 320));
        break;
    }

    install(windowObject, dark, backdrop);

    if (paradigm == ParadigmDialog || paradigm == ParadigmTool
        || presenter == PresenterCompactOverlay)
        centerOnScreen(windowObject);
}

void WindowHelper::setDarkMode(QObject *windowObject, bool dark)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        window = m_window;
    if (!window)
        return;
    m_window = window;
    m_dark = dark;
    refreshTint();
#if defined(Q_OS_WIN)
    if (auto *quick = qobject_cast<QQuickWindow *>(window)) {
        const bool frosted = m_backdrop != BackdropSolid && m_backdrop != BackdropNone;
        quick->setColor(frosted ? QColor(0, 0, 0, 0) : m_windowColor);
    }
#endif
    applyNative(window, m_dark, m_backdrop);
}

void WindowHelper::setBackdrop(QObject *windowObject, int backdrop)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        window = m_window;
    if (backdrop < BackdropAuto || backdrop > BackdropSolid)
        backdrop = BackdropSolid;
    const bool changed = (m_backdrop != backdrop);
    m_backdrop = backdrop;
    if (changed)
        emit backdropChanged();
    refreshTint();
    if (!window)
        return;
    m_window = window;
#if defined(Q_OS_WIN)
    if (auto *quick = qobject_cast<QQuickWindow *>(window)) {
        const bool frosted = m_backdrop != BackdropSolid && m_backdrop != BackdropNone;
        quick->setColor(frosted ? QColor(0, 0, 0, 0) : m_windowColor);
    }
#endif
    applyNative(window, m_dark, m_backdrop);
}

void WindowHelper::setCornerStyle(QObject *windowObject, int corner)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        window = m_window;
    setCornerPreference(corner);
    if (!window)
        return;
    m_window = window;
    applyNative(window, m_dark, m_backdrop);
}

void WindowHelper::reapply(QObject *windowObject)
{
    QWindow *window = windowObject ? resolveWindow(windowObject) : m_window;
    if (!window)
        return;
    m_window = window;
    refreshTint();
#if defined(Q_OS_WIN)
    if (auto *quick = qobject_cast<QQuickWindow *>(window)) {
        const bool frosted = m_backdrop != BackdropSolid && m_backdrop != BackdropNone;
        quick->setColor(frosted ? QColor(0, 0, 0, 0) : m_windowColor);
    }
#endif
    applyNative(window, m_dark, m_backdrop);
}

QString WindowHelper::backdropName(int backdrop) const
{
    switch (backdrop) {
    case BackdropAuto:
        return QStringLiteral("Auto");
    case BackdropNone:
        return QStringLiteral("None");
    case BackdropMica:
        return QStringLiteral("Mica");
    case BackdropAcrylic:
        return QStringLiteral("Acrylic");
    case BackdropMicaAlt:
        return QStringLiteral("MicaAlt");
    case BackdropTransparent:
        return QStringLiteral("Transparent");
    case BackdropSolid:
        return QStringLiteral("Solid");
    default:
        return QStringLiteral("Mica");
    }
}

void WindowHelper::setAlwaysOnTop(QObject *windowObject, bool on)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return;
    Qt::WindowFlags flags = window->flags();
    if (on)
        flags |= Qt::WindowStaysOnTopHint;
    else
        flags &= ~Qt::WindowStaysOnTopHint;
    setWindowFlagsSafe(window, flags);
}

bool WindowHelper::isAlwaysOnTop(QObject *windowObject) const
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return false;
    return window->flags().testFlag(Qt::WindowStaysOnTopHint);
}

int WindowHelper::titleBarHeightForOption(int option) const
{
    return option == TitleBarHeightStandard ? 32 : 48;
}

QString WindowHelper::titleBarHeightName(int option) const
{
    return option == TitleBarHeightStandard ? QStringLiteral("standard")
                                            : QStringLiteral("tall");
}

QString WindowHelper::presenterName(int kind) const
{
    switch (kind) {
    case PresenterFullScreen:
        return QStringLiteral("fullScreen");
    case PresenterCompactOverlay:
        return QStringLiteral("compactOverlay");
    case PresenterOverlapped:
    default:
        return QStringLiteral("overlapped");
    }
}

int WindowHelper::presenterKind(QObject *windowObject) const
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return PresenterOverlapped;
    if (window->visibility() == QWindow::FullScreen)
        return PresenterFullScreen;
    if (window->flags().testFlag(Qt::WindowStaysOnTopHint)
        && window->flags().testFlag(Qt::Tool))
        return PresenterCompactOverlay;
    return PresenterOverlapped;
}

void WindowHelper::setPresenter(QObject *windowObject, int kind)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return;

    switch (kind) {
    case PresenterFullScreen: {
        // Ensure a real HWND exists before fullscreen (avoids CreateWindowEx loops).
        if (!window->handle()) {
            window->setVisible(true);
            window->requestActivate();
        }
        Qt::WindowFlags flags = window->flags();
        flags &= ~Qt::WindowStaysOnTopHint;
        setWindowFlagsSafe(window, flags);
        window->showFullScreen();
        break;
    }
    case PresenterCompactOverlay: {
        if (window->visibility() == QWindow::FullScreen)
            window->showNormal();
        const Qt::WindowFlags want =
                Qt::WindowFlags(flagsForConfig(ParadigmTool, PresenterCompactOverlay, true));
        setWindowFlagsSafe(window, want);
        if (window->width() > 420 || window->height() > 320)
            window->resize(360, 240);
        window->setMinimumSize(QSize(240, 160));
        window->setVisible(true);
        window->raise();
        centerOnScreen(windowObject);
        break;
    }
    case PresenterOverlapped:
    default: {
        if (window->visibility() == QWindow::FullScreen)
            window->showNormal();
        Qt::WindowFlags flags = window->flags();
        flags &= ~Qt::WindowStaysOnTopHint;
        setWindowFlagsSafe(window, flags);
        window->setVisible(true);
        break;
    }
    }
}

#if !defined(Q_OS_WIN)
void WindowHelper::updateHitTestLayout(QObject *windowObject,
                                       const QRect &titleBar,
                                       const QRect &minimizeButton,
                                       const QRect &maximizeButton,
                                       const QRect &closeButton,
                                       const QVariantList &clientRects)
{
    Q_UNUSED(windowObject);
    Q_UNUSED(titleBar);
    Q_UNUSED(minimizeButton);
    Q_UNUSED(maximizeButton);
    Q_UNUSED(closeButton);
    Q_UNUSED(clientRects);
}
#endif
