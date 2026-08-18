import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Platform

// NotificationBridge — Mirror in-app ToastHost to OS notifications (Win balloon / Linux portal).
//
//   NotificationBridge {
//       id: bridge
//       toastHost: toasts
//       notificationCenter: center
//       recordInCenter: true
//       mirrorToSystem: true
//   }
//   bridge.info(qsTr("Saved"), qsTr("Document"))
//
//   // --- API ---
//   // toastHost, notificationCenter, recordInCenter, defaultCategory
//   // mirrorToSystem, appName, trayVisible
//   // methods: show/info/success/warning/error, notifySystem(title, message, icon)
//   // signals: systemNotified(string, string)
//
// @notes
//   Uses TrayIcon.notifySystem → Windows balloon / org.freedesktop.Notifications /
//   notify-send. When toastHost is set, show() also enqueues an in-app toast.
//   When notificationCenter is set (2.63), show() also appends grouped history.
//   Prefer bridge.info/success/warning/error for LoB apps. See docs/notification-center-263.md.
T.Control {
    id: root

    property var toastHost: null
    property var notificationCenter: null
    property bool recordInCenter: true
    property string defaultCategory: ""
    property bool mirrorToSystem: true
    property bool toastInApp: true
    property string appName: Qt.application.displayName || Qt.application.name || "QWinUI3"
    property alias trayVisible: tray.trayVisible
    property alias tooltip: tray.tooltip
    property alias iconSource: tray.iconSource
    property alias supportsMessages: tray.supportsMessages

    readonly property int severityInformational: 0
    readonly property int severitySuccess: 1
    readonly property int severityWarning: 2
    readonly property int severityError: 3

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
        if (severity === severityError)
            return 2
        if (severity === severityWarning)
            return 1
        return 0
    }

    function _recordCenter(title, message, severity, dedupeId, actionText) {
        if (!notificationCenter || !recordInCenter || !notificationCenter.addNotification)
            return
        var cat = defaultCategory.length ? defaultCategory : qsTr("General")
        var item = {
            title: title && title.length ? title : root.appName,
            message: message || "",
            category: cat,
            severity: severity === undefined ? severityInformational : severity
        }
        if (dedupeId && String(dedupeId).length)
            item.id = String(dedupeId)
        if (actionText && actionText.length)
            item.actionText = actionText
        notificationCenter.addNotification(item)
    }

    function show(message, severity, title, actionText, dedupeId) {
        var sev = severity === undefined ? severityInformational : severity
        var t = title || ""
        var m = message || ""
        if (toastInApp && toastHost && toastHost.show)
            toastHost.show(m, sev, t, actionText || "", dedupeId)
        if (mirrorToSystem)
            notifySystem(t.length ? t : root.appName, m, _systemIcon(sev))
        root._recordCenter(t.length ? t : root.appName, m, sev, dedupeId, actionText)
    }

    function info(message, title, actionText, dedupeId) {
        show(message, severityInformational, title || qsTr("Information"), actionText, dedupeId)
    }
    function success(message, title, actionText, dedupeId) {
        show(message, severitySuccess, title || qsTr("Success"), actionText, dedupeId)
    }
    function warning(message, title, actionText, dedupeId) {
        show(message, severityWarning, title || qsTr("Warning"), actionText, dedupeId)
    }
    function error(message, title, actionText, dedupeId) {
        show(message, severityError, title || qsTr("Error"), actionText, dedupeId)
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
