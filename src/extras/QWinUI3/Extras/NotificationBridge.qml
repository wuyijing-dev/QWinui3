import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Platform

// NotificationBridge — Mirror in-app ToastHost to OS notifications (Win balloon / Linux portal).
//
//   NotificationBridge {
//       id: bridge
//       toastHost: toasts
//       mirrorToSystem: true
//   }
//   bridge.info(qsTr("Saved"), qsTr("Document"))
//   // or: toasts.info(...); bridge.mirrorLast(...) via show()
//
//   // --- API ---
//   // mirrorToSystem, appName, trayVisible
//   // methods: show/info/success/warning/error, notifySystem(title, message, icon)
//   // signals: systemNotified(string, string)
//
// @notes
//   Uses TrayIcon.notifySystem → Windows balloon / org.freedesktop.Notifications /
//   notify-send. When toastHost is set, show() also enqueues an in-app toast.

T.Control {
    id: root

    property var toastHost: null
    property bool mirrorToSystem: true
    property bool toastInApp: true
    property string appName: Qt.application.displayName || Qt.application.name || "QWinUI3"
    property alias trayVisible: tray.trayVisible
    property alias tooltip: tray.tooltip
    property alias iconSource: tray.iconSource
    property alias supportsMessages: tray.supportsMessages

    readonly property int informational: 0
    readonly property int success: 1
    readonly property int warning: 2
    readonly property int error: 3

    signal systemNotified(string title, string message)
    signal toastClosed(string message)
    signal toastActionClicked(string message)

    implicitWidth: 0
    implicitHeight: 0
    visible: false
    Accessible.ignored: true

    TrayIcon {
        id: tray
        trayVisible: false
        tooltip: root.appName
        onNotified: function (title, message) {
            root.systemNotified(title, message)
        }
    }

    function notifySystem(title, message, icon) {
        tray.notifySystem(title || root.appName, message || "", icon === undefined ? 0 : icon)
    }

    function _systemIcon(severity) {
        // TrayIcon: 0 info, 1 warning, 2 error (convention used by Win NIIF_*)
        if (severity === error)
            return 2
        if (severity === warning)
            return 1
        return 0
    }

    function show(message, severity, title, actionText) {
        var sev = severity === undefined ? informational : severity
        var t = title || ""
        var m = message || ""
        if (toastInApp && toastHost && toastHost.show)
            toastHost.show(m, sev, t, actionText || "")
        if (mirrorToSystem)
            notifySystem(t.length ? t : root.appName, m, _systemIcon(sev))
    }

    function info(message, title, actionText) {
        show(message, informational, title || qsTr("Information"), actionText)
    }
    function success(message, title, actionText) {
        show(message, success, title || qsTr("Success"), actionText)
    }
    function warning(message, title, actionText) {
        show(message, warning, title || qsTr("Warning"), actionText)
    }
    function error(message, title, actionText) {
        show(message, error, title || qsTr("Error"), actionText)
    }

    // Attach listeners so ToastHost.info/success/... can optionally be mirrored
    // by calling bridge.mirrorFromHost after host show — prefer bridge.show().
    function mirrorHostShow(message, severity, title) {
        if (!mirrorToSystem)
            return
        notifySystem(title || root.appName, message || "", _systemIcon(severity))
    }

    background: Item {}
    contentItem: Item {}
}
