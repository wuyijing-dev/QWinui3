#include "Bootstrap.h"
#include "WelcomeBanner.h"
#include "WindowHelper.h"

#include <QCoreApplication>
#include <QGuiApplication>
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
    // Must run before QGuiApplication. Prefer the API over the env var: during
    // QGuiApplication construction instance() is already non-null, so re-applying
    // QT_SCALE_FACTOR_ROUNDING_POLICY from the environment warns.
    if (QCoreApplication::instance())
        return;
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(
            Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
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
}

void configureApplication(const QString &appId)
{
    QQuickStyle::setStyle(QStringLiteral("QWinUI3"));
    ThemeFonts::ensureLoaded();

    if (appId.isEmpty())
        return;

    WindowHelper::setAppUserModelId(appId);
    if (QGuiApplication::instance())
        QGuiApplication::setDesktopFileName(appId);
}

} // namespace QWinUI3
