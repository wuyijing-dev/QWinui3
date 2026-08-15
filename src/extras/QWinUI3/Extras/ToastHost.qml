import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Corner toast queue host. Call show() to enqueue notifications.
T.Control {
    id: root

    property int maxVisible: 3
    property int durationMs: 3200
    property int spacing: Theme.spacing
    property bool newestOnTop: true

    signal toastClosed(string message)
    signal toastActionClicked(string message)

    implicitWidth: 360
    implicitHeight: column.implicitHeight
    z: 2000

    readonly property int informational: 0
    readonly property int success: 1
    readonly property int warning: 2
    readonly property int error: 3

    readonly property int count: queue.count

    ListModel { id: queue }

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
