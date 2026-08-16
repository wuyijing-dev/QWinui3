import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ToastHost — Hosts stacked Toasts with WinUI-style corner placement.
//
//   ToastHost {
//       id: toasts
//       placement: ToastHost.BottomCenter
//   }
//   toasts.info(qsTr("Hello"))
//   toasts.success(qsTr("Done"))
//
//   // --- API ---
//   // methods: info/success/warning/error (+ *Toast aliases), show, clear
//   // placement: BottomCenter | BottomRight | TopRight | TopCenter
//
// @notes
//   Default placement is bottom-center (Gallery / WinUI toast band).
//   Do not also set anchors when using placement — they conflict.

T.Control {
    id: root

    // Max visible items before overflow
    property int maxVisible: 3
    // Auto-dismiss duration; 0 keeps open
    property int durationMs: 3200
    // spacing is FINAL on Control — assign, do not redeclare
    spacing: Theme.spacing
    // Stack newest items on top
    property bool newestOnTop: true
    // Edge inset from the overlay parent
    property real placementMargin: 24

    // BottomCenter / BottomRight / TopRight / TopCenter
    enum Placement {
        BottomCenter,
        BottomRight,
        TopRight,
        TopCenter
    }
    property int placement: ToastHost.BottomCenter

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

    // Informational severity constant
    readonly property int informational: 0
    // Success severity constant
    readonly property int success: 1
    // Warning severity constant
    readonly property int warning: 2
    // Error severity constant
    readonly property int error: 3

    // Item count
    readonly property int count: queue.count

    readonly property bool _bottom: placement === ToastHost.BottomCenter
                                    || placement === ToastHost.BottomRight
    readonly property bool _center: placement === ToastHost.BottomCenter
                                    || placement === ToastHost.TopCenter
    readonly property bool _right: placement === ToastHost.BottomRight
                                   || placement === ToastHost.TopRight

    anchors.horizontalCenter: parent && _center ? parent.horizontalCenter : undefined
    anchors.right: parent && _right ? parent.right : undefined
    anchors.left: undefined
    anchors.bottom: parent && _bottom ? parent.bottom : undefined
    anchors.top: parent && !_bottom ? parent.top : undefined
    anchors.margins: placementMargin

    ListModel { id: queue }

    // Show the control
    function show(message, severity, title, actionText) {
        while (queue.count >= root.maxVisible) {
            if (newestOnTop)
                queue.remove(queue.count - 1)
            else
                queue.remove(0)
        }
        var entry = {
            "key": Date.now() + "-" + queue.count,
            "message": message || "",
            "severity": severity === undefined ? informational : severity,
            "title": title || "",
            "actionText": actionText || "",
            "durationMs": root.durationMs
        }
        if (newestOnTop)
            queue.insert(0, entry)
        else
            queue.append(entry)
    }

    // Show an informational toast / tip
    function info(message, title, actionText) {
        show(message, informational, title || qsTr("Information"), actionText)
    }
    // Show a success toast
    function successToast(message, title, actionText) {
        show(message, success, title || qsTr("Success"), actionText)
    }
    // Docs / WinUI-style alias
    function success(message, title, actionText) {
        successToast(message, title, actionText)
    }
    // Show a warning toast
    function warningToast(message, title, actionText) {
        show(message, warning, title || qsTr("Warning"), actionText)
    }
    function warning(message, title, actionText) {
        warningToast(message, title, actionText)
    }
    // Show an error toast
    function errorToast(message, title, actionText) {
        show(message, error, title || qsTr("Error"), actionText)
    }
    function error(message, title, actionText) {
        errorToast(message, title, actionText)
    }

    // Clear text or selection
    function clear() {
        queue.clear()
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
                    }
                }
            }
        }
    }

    background: Item {}
}
