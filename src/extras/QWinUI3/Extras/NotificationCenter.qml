import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// NotificationCenter — In-app notification drawer with grouping (2.27 / 2.63).
//
//   NotificationCenter {
//       id: center
//       model: notifications
//       maxHistory: 100
//       onNotificationClicked: (index, item) => { … }
//   }
//   center.addNotification({
//       id: "build-42",
//       title: qsTr("Build finished"),
//       message: qsTr("Release 2.63 succeeded."),
//       category: qsTr("CI"),
//       severity: center.success
//   })
//   center.open()
//
//   // --- API ---
//   // properties: model, groupRole, isOpen, unreadCount, maxHistory, dedupeIdRole
//   // methods: open(), close(), markRead(i), markAllRead(), clear(), clearRead(),
//   //          addNotification(item), push(item)
//   // signals: notificationClicked, notificationActionClicked, cleared
//
// @notes
//   Experimental — dismissible history + category groups (FL-007). Complements
//   ToastHost (transient) and InfoBarHost (inline). Pair with NotificationBridge
//   recordInCenter (2.63). Not an OS notification center. See docs/notification-center-263.md.
T.Control {
    id: notificationCenter

    property var model: []
    property string groupRole: "category"
    property string dedupeIdRole: "id"
    property int maxHistory: 100
    property alias edge: drawer.edge
    property alias drawerWidth: drawer.width

    readonly property int informational: 0
    readonly property int success: 1
    readonly property int warning: 2
    readonly property int error: 3

    readonly property bool isOpen: drawer.opened
    readonly property int unreadCount: {
        var n = 0
        var m = model || []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (it && !it.read)
                ++n
        }
        return n
    }

    readonly property var groupedModel: {
        var order = []
        var map = ({})
        var m = model || []
        var role = groupRole || "category"
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it)
                continue
            var cat = it[role] ? String(it[role]) : qsTr("General")
            if (!map[cat]) {
                map[cat] = []
                order.push(cat)
            }
            map[cat].push({ index: i, data: it })
        }
        var out = []
        for (var j = 0; j < order.length; ++j) {
            var c = order[j]
            out.push({ category: c, items: map[c] })
        }
        return out
    }

    signal notificationClicked(int index, var item)
    signal notificationActionClicked(int index, var item)
    signal cleared()

    implicitWidth: 0
    implicitHeight: 0
    visible: false
    Accessible.ignored: true

    function open() { drawer.open() }
    function close() { drawer.close() }

    function markRead(index) {
        var m = (model || []).slice()
        if (index < 0 || index >= m.length || !m[index])
            return
        var copy = Object.assign({}, m[index])
        if (copy.read)
            return
        copy.read = true
        m[index] = copy
        model = m
    }

    function markAllRead() {
        var m = model || []
        var changed = false
        var next = []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (!it) {
                next.push(it)
                continue
            }
            if (!it.read) {
                next.push(Object.assign({}, it, { read: true }))
                changed = true
            } else {
                next.push(it)
            }
        }
        if (changed)
            model = next
    }

    function clear() {
        if (!model || !model.length)
            return
        model = []
        cleared()
    }

    function clearRead() {
        var m = model || []
        var next = []
        for (var i = 0; i < m.length; ++i) {
            var it = m[i]
            if (it && !it.read)
                next.push(it)
        }
        if (next.length !== m.length) {
            model = next
            if (!next.length)
                cleared()
        }
    }

    function addNotification(item) {
        var entry = item || {}
        if (entry.read === undefined)
            entry = Object.assign({}, entry, { read: false })
        var m = (model || []).slice()
        var role = dedupeIdRole || "id"
        if (entry[role] !== undefined && String(entry[role]).length) {
            var id = String(entry[role])
            for (var i = 0; i < m.length; ++i) {
                if (m[i] && String(m[i][role]) === id) {
                    m[i] = Object.assign({}, m[i], entry, { read: false })
                    model = _trimHistory(m)
                    return
                }
            }
        }
        m.unshift(entry)
        model = _trimHistory(m)
    }

    function _trimHistory(m) {
        var cap = maxHistory
        if (cap <= 0 || m.length <= cap)
            return m
        return m.slice(0, cap)
    }

    function push(item) {
        addNotification(item)
    }

    function _severityColor(sev) {
        if (sev === success)
            return Theme.systemSuccess
        if (sev === warning)
            return Theme.systemCaution
        if (sev === error)
            return Theme.systemCritical
        return Theme.accent
    }

    Drawer {
        id: drawer
        parent: Overlay.overlay
        edge: Qt.RightEdge
        width: Math.min(Theme.dp(360), (Overlay.overlay ? Overlay.overlay.width : 1280) * 0.9)
        modal: true
        dim: true
        interactive: true
        Accessible.role: Accessible.Pane
        Accessible.name: qsTr("Notification center")

        contentItem: ColumnLayout {
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                Layout.margins: Theme.spacingSection
                spacing: Theme.spacing
                Text {
                    Layout.fillWidth: true
                    text: qsTr("Notifications")
                    font.pixelSize: Theme.fontTitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }
                InfoBadge {
                    visible: notificationCenter.unreadCount > 0
                    value: notificationCenter.unreadCount
                    severity: InfoBadge.attention
                }
                Button {
                    flat: true
                    text: qsTr("Mark all read")
                    enabled: notificationCenter.unreadCount > 0
                    onClicked: notificationCenter.markAllRead()
                }
                Button {
                    flat: true
                    text: qsTr("Clear read")
                    onClicked: notificationCenter.clearRead()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.strokeDivider
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: availableWidth
                background: null

                ColumnLayout {
                    width: parent.width
                    spacing: Theme.spacingLoose

                    EmptyState {
                        Layout.fillWidth: true
                        Layout.topMargin: Theme.spacingSection
                        visible: !(notificationCenter.model && notificationCenter.model.length)
                        title: qsTr("No notifications")
                        message: qsTr("Toasts stay transient — this drawer keeps dismissible history grouped by category.")
                    }

                    Repeater {
                        model: notificationCenter.groupedModel
                        delegate: ColumnLayout {
                            required property var modelData
                            Layout.fillWidth: true
                            spacing: Theme.spacing

                            Text {
                                Layout.fillWidth: true
                                Layout.leftMargin: Theme.spacingSection
                                Layout.rightMargin: Theme.spacingSection
                                text: modelData.category
                                font.pixelSize: Theme.fontCaption
                                font.weight: Theme.fontWeightSemiBold
                                color: Theme.textSecondary
                            }

                            Repeater {
                                model: modelData.items
                                delegate: ListTile {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.leftMargin: Theme.spacing
                                    Layout.rightMargin: Theme.spacing
                                    readonly property int rowIndex: modelData.index
                                    readonly property var row: modelData.data
                                    title: row.title || qsTr("Notification")
                                    subtitle: row.message || ""
                                    symbol: row.symbol || FluentIcons.Ringer
                                    isSelected: !row.read
                                    onClicked: {
                                        notificationCenter.markRead(rowIndex)
                                        notificationCenter.notificationClicked(rowIndex, row)
                                    }
                                    leading: Rectangle {
                                        width: 4
                                        height: parent.height * 0.6
                                        radius: 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: notificationCenter._severityColor(row.severity !== undefined
                                                                   ? row.severity : notificationCenter.informational)
                                        opacity: row.read ? 0.35 : 1
                                    }
                                    trailing: Button {
                                        visible: !!(row.actionText && String(row.actionText).length)
                                        flat: true
                                        text: row.actionText || ""
                                        onClicked: notificationCenter.notificationActionClicked(rowIndex, row)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.strokeDivider
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.margins: Theme.spacingSection
                spacing: Theme.spacing
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Clear all")
                    onClicked: notificationCenter.clear()
                }
                Button {
                    highlighted: true
                    text: qsTr("Close")
                    onClicked: drawer.close()
                }
            }
        }
    }

    background: Item {}
    contentItem: Item {}
}
