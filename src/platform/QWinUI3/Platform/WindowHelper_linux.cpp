#include "WindowHelper.h"

#include <QGuiApplication>
#include <QQuickWindow>
#include <QStyleHints>
#include <QSurfaceFormat>
#include <QWindow>

// Linux / Wayland: client-side Fluent chrome (Frameless + PlatformTitleBar).
// Detection: WindowHelper.displayServer / wayland / x11.
void WindowHelper::applyNative(QWindow *window, bool dark, int backdrop)
{
    if (!window)
        return;

    // Keep Frameless so the compositor does not draw an extra title bar.
    if (!window->flags().testFlag(Qt::FramelessWindowHint))
        window->setFlag(Qt::FramelessWindowHint, true);

    const bool wantAlpha = backdrop != BackdropSolid && backdrop != BackdropNone;
    if (wantAlpha) {
        // QWindow has no setColor; only QQuickWindow does.
        if (auto *quick = qobject_cast<QQuickWindow *>(window)) {
            quick->setColor(QColor(0, 0, 0, 0));
            // Request an alpha buffer so Mutter/KWin can composite translucency.
            // Only effective before the platform window is fully created.
            if (!quick->handle()) {
                QSurfaceFormat fmt = quick->format();
                if (fmt.alphaBufferSize() < 8) {
                    fmt.setAlphaBufferSize(8);
                    quick->setFormat(fmt);
                }
            }
        }
    }

    // Advertise preferred color scheme to Qt platform theme / portals.
    if (auto *hints = QGuiApplication::styleHints())
        hints->setColorScheme(dark ? Qt::ColorScheme::Dark : Qt::ColorScheme::Light);
}

void WindowHelper::setTaskbarProgress(QObject *windowObject, double value)
{
    Q_UNUSED(windowObject);
    Q_UNUSED(value);
}

void WindowHelper::setTaskbarProgressState(QObject *windowObject, int state)
{
    Q_UNUSED(windowObject);
    Q_UNUSED(state);
}

void WindowHelper::clearTaskbarProgress(QObject *windowObject)
{
    Q_UNUSED(windowObject);
}

void WindowHelper::setTaskbarOverlayText(QObject *windowObject, const QString &text)
{
    Q_UNUSED(windowObject);
    Q_UNUSED(text);
}

void WindowHelper::clearTaskbarOverlay(QObject *windowObject)
{
    Q_UNUSED(windowObject);
}

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
