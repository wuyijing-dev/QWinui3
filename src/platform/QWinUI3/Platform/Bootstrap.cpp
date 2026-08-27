#include "Bootstrap.h"
#include "WelcomeBanner.h"
#include "WindowHelper.h"

#include <QWinUI3/Compat/QtCompatDpi.h>
#include <QWinUI3/Compat/QtCompatRhi.h>

#include <QCoreApplication>
#include <QGuiApplication>
#include <QPixmapCache>
#include <QQuickStyle>

#include "ThemeFonts.h"

namespace QWinUI3 {

namespace {

void sanitizeWindowsQpa()
{
#if defined(Q_OS_WIN)
    // Cursor / CI shells often export QT_QPA_PLATFORM=offscreen (or xcb).
    // Desktop MSVC kits and windeploy trees typically only ship qwindows.dll.
    if (qEnvironmentVariableIsSet("QWINUI3_ALLOW_FOREIGN_QPA"))
        return;
    const QByteArray p = qgetenv("QT_QPA_PLATFORM").trimmed().toLower();
    if (p.isEmpty() || p == "windows" || p == "direct2d")
        return;
    qputenv("QT_QPA_PLATFORM", "windows");
#endif
}

void applyHighDpiPolicyEarly()
{
    // Same PassThrough on Qt 6.5 … 6.11+ (see QtCompatDpi.h).
    Compat::Dpi::applyKitPolicyEarly();
}

// 3.47 H16 — bound decoded Image / pixmap RSS; quality unchanged.
// Default 16384 KB. QWINUI3_PIXMAP_CACHE_KB>0 overrides; =0 leaves Qt's default alone.
void applyPixmapCacheLimit()
{
    constexpr int kDefaultKb = 16384;
    const QByteArray raw = qgetenv("QWINUI3_PIXMAP_CACHE_KB");
    if (raw.isEmpty()) {
        QPixmapCache::setCacheLimit(kDefaultKb);
        return;
    }
    bool ok = false;
    const int kb = raw.toInt(&ok);
    if (!ok || kb < 0)
        return;
    if (kb == 0)
        return; // leave Qt default
    QPixmapCache::setCacheLimit(kb);
}

} // namespace

void configureEnvironment(const char *argv0)
{
    sanitizeWindowsQpa();
    applyHighDpiPolicyEarly();
    printWelcomeBanner();
    WindowHelper::configurePlatformEnvironment(argv0);
    // Prefer system IME over Qt Virtual Keyboard (GPL/Commercial).
    qunsetenv("QT_IM_MODULE");
    qputenv("QT_QUICK_CONTROLS_STYLE", "QWinUI3");

    // Soft platform RHI default when unset (no Vulkan/D3D host probe — 3.34 S10).
    // Opt in to the old probe+fallback chain with QWINUI3_RHI_PROBE=1.
    // Apps/CLI may still set QSG_RHI_BACKEND or call Compat::Rhi::apply beforehand.
    if (qEnvironmentVariableIsEmpty("QSG_RHI_BACKEND")) {
        if (qEnvironmentVariableIntValue("QWINUI3_RHI_PROBE") != 0)
            Compat::Rhi::apply(Compat::Rhi::defaultBackend());
        else
            Compat::Rhi::applyDirect(Compat::Rhi::preferredPlatformBackend());
    }
}

void configureApplication(const QString &appId)
{
    QQuickStyle::setStyle(QStringLiteral("QWinUI3"));
    applyPixmapCacheLimit();
    ThemeFonts::ensureLoaded();
    ThemeFonts::applyApplicationFont();

    if (appId.isEmpty())
        return;

    WindowHelper::setAppUserModelId(appId);
    if (QGuiApplication::instance())
        QGuiApplication::setDesktopFileName(appId);
}

} // namespace QWinUI3
