#include "WindowHelper.h"
#include "LinuxPortal.h"

#include <QWinUI3/Compat/QtCompatQml.h>
#include <QWinUI3/Compat/QtCompatVersion.h>

#include <cstdio>

#include <QClipboard>
#include <QCoreApplication>
#include <QDebug>
#include <QDesktopServices>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QGuiApplication>
#include <QJSEngine>
#include <QProcess>
#include <QQmlEngine>
#include <QQuickWindow>
#include <QScreen>
#include <QStyleHints>
#include <QUrl>
#include <QVariantMap>
#include <QWindow>

#if defined(Q_OS_WIN)
#  ifndef NOMINMAX
#    define NOMINMAX
#  endif
#  include <Windows.h>
#  include <shlobj.h>
#  include <shobjidl.h>
#  include <wininet.h>
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
    refreshColorScheme();
    refreshPowerStatus();
    refreshOnlineStatus();

    if (qGuiApp) {
        auto bindScreen = [this](QScreen *screen) {
            if (!screen)
                return;
            QObject::connect(screen, &QScreen::physicalDotsPerInchChanged,
                             this, &WindowHelper::screensChanged, Qt::UniqueConnection);
            QObject::connect(screen, &QScreen::logicalDotsPerInchChanged,
                             this, &WindowHelper::screensChanged, Qt::UniqueConnection);
            QObject::connect(screen, &QScreen::geometryChanged,
                             this, &WindowHelper::screensChanged, Qt::UniqueConnection);
        };
        for (QScreen *screen : QGuiApplication::screens())
            bindScreen(screen);
        QObject::connect(qGuiApp, &QGuiApplication::screenAdded, this,
                         [this, bindScreen](QScreen *screen) {
                             bindScreen(screen);
                             emit screensChanged();
                         });
        QObject::connect(qGuiApp, &QGuiApplication::screenRemoved, this, &WindowHelper::screensChanged);
        QObject::connect(qGuiApp, &QGuiApplication::primaryScreenChanged, this, &WindowHelper::screensChanged);
    }
#if defined(Q_OS_LINUX)
    LinuxPortal::watchColorSchemeChanges(this, SLOT(refreshColorScheme()));
#endif
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

QString WindowHelper::displayServer() const
{
#if defined(Q_OS_WIN)
    return QStringLiteral("windows");
#else
    const QString name = QGuiApplication::platformName();
    return name.isEmpty() ? QStringLiteral("unknown") : name;
#endif
}

bool WindowHelper::isWayland() const
{
    return displayServer().startsWith(QLatin1String("wayland"));
}

bool WindowHelper::isX11() const
{
    const QString ds = displayServer();
    return ds == QLatin1String("xcb") || ds.startsWith(QLatin1String("x11"));
}

bool WindowHelper::serverSideDecorations() const
{
    // Windows and Linux both use client-side Fluent chrome when customFrame is on.
    return !customFrame();
}

QString WindowHelper::desktopEnvironment() const
{
#if defined(Q_OS_LINUX)
    const QString desk = QString::fromLocal8Bit(qgetenv("XDG_CURRENT_DESKTOP"));
    if (!desk.isEmpty())
        return desk;
    return QString::fromLocal8Bit(qgetenv("DESKTOP_SESSION"));
#else
    return platformName();
#endif
}

QString WindowHelper::waylandDisplay() const
{
#if defined(Q_OS_LINUX)
    return QString::fromLocal8Bit(qgetenv("WAYLAND_DISPLAY"));
#else
    return {};
#endif
}

bool WindowHelper::portalAvailable() const
{
#if defined(Q_OS_LINUX)
    return LinuxPortal::available();
#else
    return false;
#endif
}

qreal WindowHelper::devicePixelRatio() const
{
    if (auto *screen = QGuiApplication::primaryScreen())
        return screen->devicePixelRatio();
    return 1.0;
}

qreal WindowHelper::devicePixelRatioForWindow(QObject *windowObject) const
{
    if (QWindow *window = resolveWindow(windowObject)) {
        if (QScreen *screen = window->screen())
            return screen->devicePixelRatio();
        return window->devicePixelRatio();
    }
    return devicePixelRatio();
}

void WindowHelper::notifyDisplayMetricsChanged()
{
    emit screensChanged();
}

void WindowHelper::configurePlatformEnvironment(const char *argv0)
{
    qInfo().noquote() << "QWinUI3:" << QWinUI3::Compat::Qml::supportRangeString()
                      << QStringLiteral("(built with Qt %1.%2.%3)")
                             .arg(QWinUI3::Compat::qtVersionMajor())
                             .arg(QWinUI3::Compat::qtVersionMinor())
                             .arg(QWinUI3::Compat::qtVersionPatch());

#if defined(Q_OS_LINUX)
    // Stale Windows-style qt.conf next to the binary forces Plugins=./plugins
    // (empty) and breaks every QPA plugin. Strip it before QGuiApplication.
    if (argv0 && argv0[0] != '\0') {
        const QString appDir = QFileInfo(QString::fromLocal8Bit(argv0)).absolutePath();
        const QString confPath = appDir + QStringLiteral("/qt.conf");
        if (QFile::exists(confPath)) {
            QFile conf(confPath);
            if (conf.open(QIODevice::ReadOnly)) {
                const QByteArray body = conf.readAll();
                conf.close();
                const bool broken = body.contains("Prefix = .")
                        || body.contains("Prefix=.")
                        || body.contains("Plugins = plugins")
                        || body.contains("Plugins=plugins");
                if (broken) {
                    QFile::remove(confPath);
                    qWarning("QWinUI3: removed broken %s (it blocked Qt platform plugins)",
                             qPrintable(confPath));
                }
            }
        }
    }

    auto pluginRoots = []() -> QStringList {
        QStringList roots;
        const QByteArray extra = qgetenv("QT_PLUGIN_PATH");
        if (!extra.isEmpty()) {
            for (const QByteArray &part : extra.split(':')) {
                if (!part.isEmpty())
                    roots << QString::fromLocal8Bit(part);
            }
        }
        if (const QByteArray prefix = qgetenv("QTDIR"); !prefix.isEmpty())
            roots << QString::fromLocal8Bit(prefix) + QStringLiteral("/plugins");
        if (const QByteArray prefix = qgetenv("CMAKE_PREFIX_PATH"); !prefix.isEmpty()) {
            for (const QByteArray &part : prefix.split(':')) {
                if (!part.isEmpty()) {
                    roots << QString::fromLocal8Bit(part) + QStringLiteral("/plugins");
                    roots << QString::fromLocal8Bit(part) + QStringLiteral("/lib/qt6/plugins");
                }
            }
        }
        roots << QStringLiteral("/usr/lib/x86_64-linux-gnu/qt6/plugins")
              << QStringLiteral("/usr/lib/aarch64-linux-gnu/qt6/plugins")
              << QStringLiteral("/usr/lib/qt6/plugins")
              << QStringLiteral("/usr/lib64/qt6/plugins");
        return roots;
    };

    auto hasPlatform = [](const QString &root, const char *file) -> bool {
        return QFile::exists(root + QLatin1Char('/') + QLatin1String(file));
    };

    // Force a real plugin root so Qt does not search "".
    QString chosenPlugins;
    for (const QString &root : pluginRoots()) {
        if (hasPlatform(root, "platforms/libqxcb.so")
                || hasPlatform(root, "platforms/libqwayland-generic.so")
                || hasPlatform(root, "platforms/libqwayland.so")) {
            chosenPlugins = root;
            break;
        }
    }
    if (!chosenPlugins.isEmpty()) {
        const QByteArray previous = qgetenv("QT_PLUGIN_PATH");
        if (previous.isEmpty())
            qputenv("QT_PLUGIN_PATH", chosenPlugins.toLocal8Bit());
        else if (!QByteArray(previous).startsWith(chosenPlugins.toLocal8Bit()))
            qputenv("QT_PLUGIN_PATH", chosenPlugins.toLocal8Bit() + ':' + previous);
    }

    const bool waylandPlugin = !chosenPlugins.isEmpty()
            && (hasPlatform(chosenPlugins, "platforms/libqwayland-generic.so")
                || hasPlatform(chosenPlugins, "platforms/libqwayland.so")
                || hasPlatform(chosenPlugins, "platforms/libqwayland-egl.so"));
    const bool xcbPlugin = !chosenPlugins.isEmpty()
            && hasPlatform(chosenPlugins, "platforms/libqxcb.so");

    if (qEnvironmentVariableIsEmpty("QT_QPA_PLATFORM")) {
        const QByteArray session = qgetenv("XDG_SESSION_TYPE").toLower();
        const bool waylandSession = session == "wayland"
                || !qEnvironmentVariableIsEmpty("WAYLAND_DISPLAY");
        if (waylandSession && waylandPlugin)
            qputenv("QT_QPA_PLATFORM", "wayland;xcb");
        else if (xcbPlugin)
            qputenv("QT_QPA_PLATFORM", "xcb");
        else if (waylandPlugin)
            qputenv("QT_QPA_PLATFORM", "wayland");
        else
            qputenv("QT_QPA_PLATFORM", "xcb");
    } else if (!waylandPlugin && xcbPlugin
               && qgetenv("QT_QPA_PLATFORM").contains("wayland")
               && !qEnvironmentVariableIsSet("QWINUI3_KEEP_QPA_PLATFORM")) {
        qputenv("QT_QPA_PLATFORM", "xcb");
        qWarning("QWinUI3: Wayland QPA plugin missing; using xcb. Install qt6-wayland.");
    }

    if (qEnvironmentVariableIsEmpty("QT_WAYLAND_DISABLE_WINDOWDECORATION"))
        qputenv("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1");
#else
    Q_UNUSED(argv0);
#endif

    // Fractional display scale (Windows 125%/150%, Wayland) — before QGuiApplication.
    if (qEnvironmentVariableIsEmpty("QT_SCALE_FACTOR_ROUNDING_POLICY"))
        qputenv("QT_SCALE_FACTOR_ROUNDING_POLICY", "PassThrough");
}

void WindowHelper::setDesktopFileName(const QString &desktopFileName)
{
    if (desktopFileName.isEmpty())
        return;
    QGuiApplication::setDesktopFileName(desktopFileName);
}

void WindowHelper::requestActivateWindow(QObject *windowObject)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return;
    window->requestActivate();
    window->raise();
}

void WindowHelper::setTransientParent(QObject *windowObject, QObject *parentWindowObject)
{
    QWindow *window = resolveWindow(windowObject);
    QWindow *parent = resolveWindow(parentWindowObject);
    if (!window)
        return;
    window->setTransientParent(parent);
}

bool WindowHelper::openExternalUrl(const QString &url)
{
    if (url.isEmpty())
        return false;
#if defined(Q_OS_LINUX)
    if (LinuxPortal::tryOpenUri(url, QString()))
        return true;
#endif
    return QDesktopServices::openUrl(QUrl(url));
}

void WindowHelper::requestUserAttention(QObject *windowObject, bool continuous)
{
    QWindow *window = resolveWindow(windowObject);
    if (!window)
        return;
#if defined(Q_OS_WIN)
    HWND hwnd = reinterpret_cast<HWND>(window->winId());
    if (!hwnd)
        return;
    FLASHWINFO fi {};
    fi.cbSize = sizeof(fi);
    fi.hwnd = hwnd;
    fi.dwFlags = continuous ? (FLASHW_ALL | FLASHW_TIMERNOFG) : (FLASHW_ALL | FLASHW_TIMERNOFG);
    fi.uCount = continuous ? 0 : 3;
    fi.dwTimeout = 0;
    FlashWindowEx(&fi);
#else
    Q_UNUSED(continuous);
    window->requestActivate();
    window->raise();
    window->alert(continuous ? 0 : 3000);
#endif
}

bool WindowHelper::revealFileInFolder(const QString &path)
{
    if (path.isEmpty())
        return false;
    const QFileInfo info(path);
    const QString abs = info.absoluteFilePath();
#if defined(Q_OS_WIN)
    const QString native = QDir::toNativeSeparators(abs);
    return QProcess::startDetached(
            QStringLiteral("explorer.exe"),
            {QStringLiteral("/select,%1").arg(native)});
#elif defined(Q_OS_LINUX)
    QStringList uris;
    uris << QUrl::fromLocalFile(abs).toString();
    if (LinuxPortal::tryShowItems(uris))
        return true;
    const QString dir = info.isDir() ? abs : info.absolutePath();
    return QDesktopServices::openUrl(QUrl::fromLocalFile(dir));
#else
    const QString dir = info.isDir() ? abs : info.absolutePath();
    return QDesktopServices::openUrl(QUrl::fromLocalFile(dir));
#endif
}

void WindowHelper::copyText(const QString &text)
{
    if (auto *clip = QGuiApplication::clipboard())
        clip->setText(text);
}

QString WindowHelper::clipboardText() const
{
    if (auto *clip = QGuiApplication::clipboard())
        return clip->text();
    return {};
}

void WindowHelper::systemBeep()
{
#if defined(Q_OS_WIN)
    MessageBeep(MB_OK);
#elif defined(Q_OS_LINUX)
    // QGuiApplication::beep() is not available on all Qt builds (no Widgets).
    fputc('\a', stderr);
    fflush(stderr);
#else
    fputc('\a', stderr);
    fflush(stderr);
#endif
}

bool WindowHelper::inhibitIdle(const QString &reason)
{
    if (m_idleInhibited)
        return true;
#if defined(Q_OS_WIN)
    Q_UNUSED(reason);
    if (SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED)) {
        m_idleInhibited = true;
        m_idleCookie = 1;
        emit idleInhibitedChanged();
        return true;
    }
    return false;
#elif defined(Q_OS_LINUX)
    quint32 cookie = 0;
    if (!LinuxPortal::tryInhibitIdle(QCoreApplication::applicationName(), reason, &cookie))
        return false;
    m_idleCookie = cookie;
    m_idleInhibited = true;
    emit idleInhibitedChanged();
    return true;
#else
    Q_UNUSED(reason);
    return false;
#endif
}

void WindowHelper::releaseIdleInhibit()
{
    if (!m_idleInhibited)
        return;
#if defined(Q_OS_WIN)
    SetThreadExecutionState(ES_CONTINUOUS);
#elif defined(Q_OS_LINUX)
    LinuxPortal::tryUninhibitIdle(m_idleCookie);
#endif
    m_idleCookie = 0;
    m_idleInhibited = false;
    emit idleInhibitedChanged();
}

void WindowHelper::setAppUserModelId(const QString &appId)
{
#if defined(Q_OS_WIN)
    if (appId.isEmpty())
        return;
    SetCurrentProcessExplicitAppUserModelID(reinterpret_cast<PCWSTR>(appId.utf16()));
#else
    // Align Wayland/X11 desktop id when callers use the same string.
    if (!appId.isEmpty())
        QGuiApplication::setDesktopFileName(appId);
#endif
}

void WindowHelper::addToRecentDocuments(const QString &path)
{
    if (path.isEmpty())
        return;
#if defined(Q_OS_WIN)
    SHAddToRecentDocs(SHARD_PATHW, path.utf16());
#elif defined(Q_OS_LINUX)
    // Best-effort: ask the file manager to note the item (also used for reveal).
    LinuxPortal::tryShowItems({QUrl::fromLocalFile(QFileInfo(path).absoluteFilePath()).toString()});
#else
    Q_UNUSED(path);
#endif
}

void WindowHelper::clearRecentDocuments()
{
#if defined(Q_OS_WIN)
    SHAddToRecentDocs(SHARD_PATHW, nullptr);
#endif
}

int WindowHelper::screenCount() const
{
    return QGuiApplication::screens().size();
}

QVariantList WindowHelper::screensInfo() const
{
    QVariantList out;
    QScreen *primary = QGuiApplication::primaryScreen();
    const auto screens = QGuiApplication::screens();
    for (QScreen *screen : screens) {
        if (!screen)
            continue;
        QVariantMap m;
        m.insert(QStringLiteral("name"), screen->name());
        m.insert(QStringLiteral("manufacturer"), screen->manufacturer());
        m.insert(QStringLiteral("model"), screen->model());
        m.insert(QStringLiteral("geometry"), screen->geometry());
        m.insert(QStringLiteral("availableGeometry"), screen->availableGeometry());
        m.insert(QStringLiteral("dpr"), screen->devicePixelRatio());
        m.insert(QStringLiteral("refreshRate"), screen->refreshRate());
        m.insert(QStringLiteral("primary"), screen == primary);
        out.push_back(m);
    }
    return out;
}

void WindowHelper::refreshPowerStatus()
{
    int level = -1;
    bool battery = false;
#if defined(Q_OS_WIN)
    SYSTEM_POWER_STATUS status {};
    if (GetSystemPowerStatus(&status)) {
        if (status.BatteryFlag != 128 /* unknown */) {
            if (status.BatteryLifePercent != 255)
                level = int(status.BatteryLifePercent);
            battery = status.ACLineStatus == 0;
        }
    }
#elif defined(Q_OS_LINUX)
    const QStringList candidates = {
        QStringLiteral("/sys/class/power_supply/BAT0"),
        QStringLiteral("/sys/class/power_supply/BAT1"),
        QStringLiteral("/sys/class/power_supply/battery")
    };
    for (const QString &base : candidates) {
        QFile cap(base + QStringLiteral("/capacity"));
        if (!cap.open(QIODevice::ReadOnly))
            continue;
        bool ok = false;
        const int v = QString::fromUtf8(cap.readAll().trimmed()).toInt(&ok);
        if (ok)
            level = qBound(0, v, 100);
        QFile st(base + QStringLiteral("/status"));
        if (st.open(QIODevice::ReadOnly)) {
            const QByteArray s = st.readAll().trimmed().toLower();
            battery = (s == "discharging" || s == "not charging");
        } else {
            battery = level >= 0;
        }
        break;
    }
#endif
    if (level == m_batteryLevel && battery == m_onBattery)
        return;
    m_batteryLevel = level;
    m_onBattery = battery;
    emit powerChanged();
}

void WindowHelper::refreshOnlineStatus()
{
    bool online = true;
#if defined(Q_OS_WIN)
    DWORD flags = 0;
    online = InternetGetConnectedState(&flags, 0) == TRUE;
#elif defined(Q_OS_LINUX)
    online = false;
    QDir net(QStringLiteral("/sys/class/net"));
    const QStringList entries = net.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QString &iface : entries) {
        if (iface == QLatin1String("lo"))
            continue;
        QFile state(QStringLiteral("/sys/class/net/%1/operstate").arg(iface));
        if (state.open(QIODevice::ReadOnly)
            && state.readAll().trimmed() == QByteArrayLiteral("up")) {
            online = true;
            break;
        }
    }
#endif
    if (online == m_isOnline)
        return;
    m_isOnline = online;
    emit onlineChanged();
}

void WindowHelper::setSnapLayoutsEnabled(bool enabled)
{
    if (m_snapLayoutsEnabled == enabled)
        return;
    m_snapLayoutsEnabled = enabled;
    emit snapLayoutsEnabledChanged();
}

bool WindowHelper::customFrame() const
{
#if defined(Q_OS_WIN) || defined(Q_OS_LINUX)
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
#if defined(Q_OS_WIN) || defined(Q_OS_LINUX)
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
#elif defined(Q_OS_LINUX)
    // GNOME / portals often expose picture-uri; strip quotes from gsettings output.
    QProcess gsettings;
    gsettings.start(QStringLiteral("gsettings"),
                    {QStringLiteral("get"),
                     QStringLiteral("org.gnome.desktop.background"),
                     QStringLiteral("picture-uri")});
    if (gsettings.waitForFinished(400)) {
        QString out = QString::fromUtf8(gsettings.readAllStandardOutput()).trimmed();
        if (out.startsWith(QLatin1Char('\'')) && out.endsWith(QLatin1Char('\'')) && out.size() >= 2)
            out = out.mid(1, out.size() - 2);
        if (!out.isEmpty() && out != QLatin1String("''"))
            url = QUrl(out);
    }
#endif
    if (url == m_wallpaperUrl)
        return;
    m_wallpaperUrl = url;
    emit wallpaperChanged();
}

void WindowHelper::refreshColorScheme()
{
    bool prefersDark = false;
#if defined(Q_OS_WIN)
    // AppsUseLightTheme = 0 → dark
    HKEY key = nullptr;
    if (RegOpenKeyExW(HKEY_CURRENT_USER,
                      L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
                      0, KEY_READ, &key) == ERROR_SUCCESS) {
        DWORD value = 1;
        DWORD size = sizeof(value);
        if (RegQueryValueExW(key, L"AppsUseLightTheme", nullptr, nullptr,
                             reinterpret_cast<LPBYTE>(&value), &size) == ERROR_SUCCESS)
            prefersDark = value == 0;
        RegCloseKey(key);
    }
#elif defined(Q_OS_LINUX)
    bool known = false;
    // Prefer xdg-desktop-portal Settings (works under Flatpak / Wayland).
    uint portalScheme = 0;
    if (LinuxPortal::tryReadColorScheme(&portalScheme)) {
        if (portalScheme == 1) { // prefer-dark
            prefersDark = true;
            known = true;
        } else if (portalScheme == 2) { // prefer-light
            prefersDark = false;
            known = true;
        }
    }
    if (!known) {
        QProcess gsettings;
        gsettings.start(QStringLiteral("gsettings"),
                        {QStringLiteral("get"),
                         QStringLiteral("org.gnome.desktop.interface"),
                         QStringLiteral("color-scheme")});
        if (gsettings.waitForFinished(400)) {
            const QByteArray out = gsettings.readAllStandardOutput().trimmed();
            if (out.contains("prefer-dark")) {
                prefersDark = true;
                known = true;
            } else if (out.contains("prefer-light") || out.contains("default")) {
                prefersDark = false;
                known = true;
            }
        }
    }
    if (!known) {
        QProcess kread;
        kread.start(QStringLiteral("kreadconfig5"),
                    {QStringLiteral("--file"), QStringLiteral("kdeglobals"),
                     QStringLiteral("--group"), QStringLiteral("General"),
                     QStringLiteral("--key"), QStringLiteral("ColorScheme")});
        if (kread.waitForFinished(400)) {
            const QByteArray out = kread.readAllStandardOutput().toLower();
            if (out.contains("dark")) {
                prefersDark = true;
                known = true;
            }
        }
    }
    if (!known) {
        if (auto *hints = QGuiApplication::styleHints()) {
            const auto scheme = hints->colorScheme();
            if (scheme == Qt::ColorScheme::Dark)
                prefersDark = true;
            else if (scheme == Qt::ColorScheme::Light)
                prefersDark = false;
        }
    } else if (auto *hints = QGuiApplication::styleHints()) {
        // Keep Qt theme hints aligned with portal/gsettings when we know the preference.
        hints->setColorScheme(prefersDark ? Qt::ColorScheme::Dark : Qt::ColorScheme::Light);
    }
#endif
    if (prefersDark == m_systemPrefersDark)
        return;
    m_systemPrefersDark = prefersDark;
    emit colorSchemeChanged();
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
#elif defined(Q_OS_LINUX)
    // GNOME: org.gnome.desktop.a11y.interface / gtk-enable-animations (inverted)
    {
        QProcess gsettings;
        gsettings.start(QStringLiteral("gsettings"),
                        {QStringLiteral("get"),
                         QStringLiteral("org.gnome.desktop.interface"),
                         QStringLiteral("enable-animations")});
        if (gsettings.waitForFinished(400)) {
            const QByteArray out = gsettings.readAllStandardOutput().trimmed();
            if (out == "false")
                reduced = true;
        }
    }
    {
        QProcess gsettings;
        gsettings.start(QStringLiteral("gsettings"),
                        {QStringLiteral("get"),
                         QStringLiteral("org.gnome.desktop.a11y.interface"),
                         QStringLiteral("high-contrast")});
        if (gsettings.waitForFinished(400)) {
            const QByteArray out = gsettings.readAllStandardOutput().trimmed();
            if (out == "true")
                highContrast = true;
        }
    }
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

#if defined(Q_OS_WIN) || defined(Q_OS_LINUX)
    // Frameless + in-app Fluent caption (Windows DWM / Wayland CSD).
    if (!window->flags().testFlag(Qt::FramelessWindowHint))
        setWindowFlagsSafe(window, window->flags() | Qt::FramelessWindowHint);
    if (auto *quick = qobject_cast<QQuickWindow *>(window)) {
        // Frosted hosts must clear with zero alpha or materials stay hidden.
        const bool frosted = m_backdrop != BackdropSolid && m_backdrop != BackdropNone;
        quick->setColor(frosted ? QColor(0, 0, 0, 0)
                                : (m_windowColor.isValid() ? m_windowColor : QColor(Qt::white)));
    }
#else
    if (auto *quick = qobject_cast<QQuickWindow *>(window)) {
        const bool frosted = m_backdrop != BackdropSolid && m_backdrop != BackdropNone;
        quick->setColor(frosted ? QColor(0, 0, 0, 0)
                                : (m_windowColor.isValid() ? m_windowColor : QColor(Qt::white)));
    }
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
#if defined(Q_OS_WIN) || defined(Q_OS_LINUX)
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
