pragma Singleton
import QtQuick
import QWinUI3.Platform

// PlatformCapability — Runtime feature probe (2.67 F1).
//
//   if (PlatformCapability.mica)
//       WindowHelper.backdrop = WindowHelper.BackdropMica
//   else if (PlatformCapability.blur)
//       /* frost / solid fallback */
//
//   PlatformCapability.has("tray")
//   PlatformCapability.degradationHint("mica")
//
// @notes
//   Honest capability map for Mica / Acrylic / frost blur / tray / WebView2 / SNI.
//   UI should degrade when a flag is false — do not assume Win11 materials on Linux.

QtObject {
    id: root

    // DWM Mica / Acrylic materials available (WindowHelper.supportsBackdrop)
    readonly property bool mica: WindowHelper.supportsBackdrop
    readonly property bool acrylic: WindowHelper.supportsBackdrop
    // Qt Quick Effects frost / client shell blur path
    readonly property bool blur: WindowHelper.shellQuickEffectsAvailable
                                 || WindowHelper.frostEnabled
    // System tray host type is available on this build
    readonly property bool tray: true
    // Persistent tray (Windows notify icon / Linux SNI when linked)
    readonly property bool persistentTray: WindowHelper.windows || WindowHelper.linux
    // WebView2 host compiled-in and meaningful on Windows
    readonly property bool webView: WindowHelper.windows
    // Linux StatusNotifierItem path (tray on Plasma / many desktops)
    readonly property bool sni: WindowHelper.linux
    // Client-side Fluent chrome (vs SSD)
    readonly property bool clientChrome: WindowHelper.customFrame
    // Portal file / parent window helpers
    readonly property bool portal: WindowHelper.portalAvailable

    // Query by name: mica | acrylic | blur | frost | tray | webview | webview2 | sni | portal
    function has(name) {
        switch (String(name || "").toLowerCase()) {
        case "mica":
        case "acrylic":
            return mica
        case "blur":
        case "frost":
            return blur
        case "tray":
            return tray
        case "persistenttray":
            return persistentTray
        case "webview":
        case "webview2":
            return webView
        case "sni":
            return sni
        case "portal":
            return portal
        case "clientchrome":
        case "customframe":
            return clientChrome
        default:
            return false
        }
    }

    // Short UI copy when a capability is missing
    function degradationHint(name) {
        var key = String(name || "").toLowerCase()
        if (has(key))
            return ""
        switch (key) {
        case "mica":
        case "acrylic":
            return qsTr("System backdrop materials are unavailable — using solid / frosted chrome.")
        case "blur":
        case "frost":
            return qsTr("Blur effects are unavailable — using opaque surfaces.")
        case "webview":
        case "webview2":
            return qsTr("WebView2 is Windows-only; open links in the system browser.")
        case "sni":
            return qsTr("StatusNotifierItem is Linux-only.")
        case "tray":
        case "persistenttray":
            return qsTr("System tray may be limited on this desktop.")
        case "portal":
            return qsTr("XDG portal helpers are unavailable.")
        default:
            return qsTr("This platform capability is unavailable.")
        }
    }
}
