#include "WindowHelper.h"

#include <QWindow>

// Linux: keep system server-side decorations. Optional dark preference is a no-op
// here; apps rely on Qt/desktop portal theming.
void WindowHelper::applyNative(QWindow *window, bool dark, int backdrop)
{
    Q_UNUSED(window);
    Q_UNUSED(dark);
    Q_UNUSED(backdrop);
}
