import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ToastHost — Hosts stacked Toasts.
//
//   ToastHost { id: toasts }
//   // toasts.show({ title: "Done", message: "OK" })

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

    // Emitted when a toast is closed
    signal toastClosed(string message)
    // Emitted when a toast action is clicked
    signal toastActionClicked(string message)

    implicitWidth: 360
    implicitHeight: column.implicitHeight
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
    // Show a warning toast
    function warningToast(message, title, actionText) {
        show(message, warning, title || qsTr("Warning"), actionText)
    }
    // Show an error toast
    function errorToast(message, title, actionText) {
        show(message, error, title || qsTr("Error"), actionText)
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
                // Body / message text
                required property string message
                // Status severity enum
                required property int severity
                // Primary title text
                required property string title
                // Optional action button label
                required property string actionText
                // Auto-dismiss duration; 0 keeps open
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
