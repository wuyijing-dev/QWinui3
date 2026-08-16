#include "WindowHelper.h"

#include <QWindow>

void WindowHelper::applyNative(QWindow *window, bool dark, int backdrop)
{
    // macOS / other: no DWM Mica/Acrylic yet. Keep Qt decorations; QML can still
    // use AcrylicSurface / frost overlays for in-client depth.
    Q_UNUSED(window);
    Q_UNUSED(dark);
    Q_UNUSED(backdrop);
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
    // Non-Windows: no native non-client hit-test. Title-bar interaction stays in QML.
    Q_UNUSED(windowObject);
    Q_UNUSED(titleBar);
    Q_UNUSED(minimizeButton);
    Q_UNUSED(maximizeButton);
    Q_UNUSED(closeButton);
    Q_UNUSED(clientRects);
}
