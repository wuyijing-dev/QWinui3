#pragma once

#include "WebView2Host.h"

#include <QtQml/qqmlregistration.h>

// Registers WebView2Host on QWinUI3.Platform.WebView2 (3.35 S12).
// Import that URI before instantiating WebView2Host — not part of Platform cold path.
struct WebView2HostQml
{
    Q_GADGET
    QML_NAMED_ELEMENT(WebView2Host)
    QML_FOREIGN(WebView2Host)
};
