import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ToastHost — Hosts stacked Toasts with WinUI-style corner placement.
//
//   ToastHost {
//       id: toasts
//       placement: ToastHost.BottomRight
//   }
//   toasts.info(qsTr("Hello"))
//   toasts.success(qsTr("Done"))
//
//   // --- API ---
//   // methods: info/success/warning/error (+ *Toast aliases), show, clear, setPlacementName
//   // placement: BottomCenter | BottomRight | BottomLeft | TopRight | TopLeft | TopCenter
//
// @notes
//   Reparents to the window Overlay so placement is full-window (not page-local).
//   Visible stack up to maxVisible; extras wait in a pending queue and drain as slots free.
//   Do not also set anchors when using placement — they conflict.

T.Control {
    id: root

    // Max toasts shown at once; further show() calls wait in pendingQueue
    property int maxVisible: 3
    // Auto-dismiss duration; 0 keeps open
    property int durationMs: 3200
    // spacing is FINAL on Control — assign, do not redeclare
    spacing: Theme.spacing
    // Stack newest items on top of the visible column
    property bool newestOnTop: true
    // Edge inset from the window overlay
    property real placementMargin: 24

    // Corner / edge band placement
    enum Placement {
        BottomCenter,
        BottomRight,
        TopRight,
        TopCenter,
        BottomLeft,
        TopLeft
    }
    property int placement: ToastHost.BottomRight

    // Emitted when a toast is closed
    signal toastClosed(string message)
    // Emitted when a toast action is clicked
    signal toastActionClicked(string message)

    implicitWidth: 360
    implicitHeight: column.implicitHeight
    width: implicitWidth
    z: 2000
    Accessible.role: Accessible.AlertMessage
    Accessible.name: qsTr("Notifications")

    readonly property int informational: 0
    readonly property int success: 1
    readonly property int warning: 2
    readonly property int error: 3

    // Visible toast count
    readonly property int count: queue.count
    // Waiting behind maxVisible
    readonly property int pendingCount: pending.count
    // Visible + pending
    readonly property int totalCount: queue.count + pending.count

    readonly property bool _bottom: placement === ToastHost.BottomCenter
                                    || placement === ToastHost.BottomRight
                                    || placement === ToastHost.BottomLeft
    readonly property bool _center: placement === ToastHost.BottomCenter
                                    || placement === ToastHost.TopCenter
    readonly property bool _right: placement === ToastHost.BottomRight
                                   || placement === ToastHost.TopRight
    readonly property bool _left: placement === ToastHost.BottomLeft
                                  || placement === ToastHost.TopLeft

    // Window overlay — CatalogPage.overlay would otherwise clip placement to the pane.
    readonly property Item _windowOverlay: Overlay.overlay

    function _ensureWindowOverlayParent() {
        var o = root._windowOverlay
        if (o && root.parent !== o)
            root.parent = o
    }

    Component.onCompleted: root._ensureWindowOverlayParent()
    on_WindowOverlayChanged: root._ensureWindowOverlayParent()

    anchors.horizontalCenter: parent && _center ? parent.horizontalCenter : undefined
    anchors.right: parent && _right ? parent.right : undefined
    anchors.left: parent && _left ? parent.left : undefined
    anchors.bottom: parent && _bottom ? parent.bottom : undefined
    anchors.top: parent && !_bottom ? parent.top : undefined
    anchors.margins: placementMargin

    ListModel { id: queue }
    ListModel { id: pending }

    function setPlacementName(name) {
        switch (String(name || "").toLowerCase()) {
        case "bottomright":
        case "bottom-right":
            placement = ToastHost.BottomRight
            break
        case "bottomleft":
        case "bottom-left":
            placement = ToastHost.BottomLeft
            break
        case "topright":
        case "top-right":
            placement = ToastHost.TopRight
            break
        case "topleft":
        case "top-left":
            placement = ToastHost.TopLeft
            break
        case "topcenter":
        case "top-center":
            placement = ToastHost.TopCenter
            break
        case "bottomcenter":
        case "bottom-center":
        default:
            placement = ToastHost.BottomCenter
            break
        }
    }

    function _makeEntry(message, severity, title, actionText, dedupeId) {
        var entry = {
            "key": Date.now() + "-" + Math.random().toString(36).slice(2, 8),
            "message": message || "",
            "severity": severity === undefined ? informational : severity,
            "title": title || "",
            "actionText": actionText || "",
            "durationMs": root.durationMs
        }
        if (dedupeId && String(dedupeId).length)
            entry.dedupeId = String(dedupeId)
        return entry
    }

    function _pushVisible(entry) {
        if (newestOnTop)
            queue.insert(0, entry)
        else
            queue.append(entry)
    }

    function _drainPending() {
        while (queue.count < root.maxVisible && pending.count > 0) {
            var e = {
                "key": pending.get(0).key,
                "message": pending.get(0).message,
                "severity": pending.get(0).severity,
                "title": pending.get(0).title,
                "actionText": pending.get(0).actionText,
                "durationMs": pending.get(0).durationMs,
                "dedupeId": pending.get(0).dedupeId || ""
            }
            pending.remove(0)
            _pushVisible(e)
        }
    }

    // Enqueue a toast (shows immediately if under maxVisible, else waits).
    // Optional dedupeId skips enqueue when the same id is already visible or pending.
    function show(message, severity, title, actionText, dedupeId) {
        root._ensureWindowOverlayParent()
        if (dedupeId && String(dedupeId).length) {
            var id = String(dedupeId)
            for (var i = 0; i < queue.count; ++i) {
                if (queue.get(i).dedupeId === id)
                    return
            }
            for (var j = 0; j < pending.count; ++j) {
                if (pending.get(j).dedupeId === id)
                    return
            }
        }
        var entry = _makeEntry(message, severity, title, actionText, dedupeId)
        if (queue.count >= root.maxVisible) {
            pending.append(entry)
            return
        }
        _pushVisible(entry)
    }

    function info(message, title, actionText) {
        show(message, informational, title || qsTr("Information"), actionText)
    }
    function successToast(message, title, actionText) {
        show(message, success, title || qsTr("Success"), actionText)
    }
    function success(message, title, actionText) {
        successToast(message, title, actionText)
    }
    function warningToast(message, title, actionText) {
        show(message, warning, title || qsTr("Warning"), actionText)
    }
    function warning(message, title, actionText) {
        warningToast(message, title, actionText)
    }
    function errorToast(message, title, actionText) {
        show(message, error, title || qsTr("Error"), actionText)
    }
    function error(message, title, actionText) {
        errorToast(message, title, actionText)
    }

    function clear() {
        queue.clear()
        pending.clear()
    }

    contentItem: ColumnLayout {
        id: column
        spacing: root.spacing
        width: root.width
        layoutDirection: Qt.LeftToRight

        Repeater {
            model: queue

            delegate: Item {
                id: wrap
                required property int index
                required property string key
                required property string message
                required property int severity
                required property string title
                required property string actionText
                required property int durationMs

                Layout.fillWidth: true
                Layout.preferredHeight: toastItem.implicitHeight
                implicitWidth: toastItem.implicitWidth

                Toast {
                    id: toastItem
                    width: parent.width
                    title: wrap.title
                    message: wrap.message
                    severity: wrap.severity
                    durationMs: wrap.durationMs
                    actionText: wrap.actionText
                    slideFromBottom: root._bottom
                    Component.onCompleted: show(wrap.message, wrap.severity)
                    onActionClicked: root.toastActionClicked(wrap.message)
                    onClosed: {
                        root.toastClosed(wrap.message)
                        for (var i = 0; i < queue.count; ++i) {
                            if (queue.get(i).key === wrap.key) {
                                queue.remove(i)
                                break
                            }
                        }
                        Qt.callLater(function () { root._drainPending() })
                    }
                }
            }
        }
    }

    background: Item {}
}
