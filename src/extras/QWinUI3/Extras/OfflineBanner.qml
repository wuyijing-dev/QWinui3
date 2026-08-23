import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// OfflineBanner — InfoBar bound to WindowHelper.isOnline (2.78).
//
//   OfflineBanner { }
//   OfflineBanner { pollMs: 5000 }
//
// @notes
//   Calls WindowHelper.refreshOnlineStatus on a timer.
//   User dismiss sticks while still offline; banner returns when going offline again
//   after a reconnect (or forceShow).

Item {
    id: root

    property int pollMs: 4000
    property bool forceShow: false
    property string title: qsTr("You're offline")
    property string message: qsTr("Network looks unavailable. Some actions may fail until you reconnect.")
    property bool closableWhenOffline: true

    property bool _userDismissed: false

    readonly property bool online: WindowHelper.isOnline
    readonly property bool isOpen: forceShow || (!online && !_userDismissed)

    implicitWidth: 400
    implicitHeight: bar.visible ? bar.implicitHeight : 0
    Accessible.role: Accessible.AlertMessage
    Accessible.name: title

    signal retryClicked()
    signal dismissed()

    function refresh() {
        WindowHelper.refreshOnlineStatus()
    }

    onOnlineChanged: {
        if (online)
            _userDismissed = false
    }

    Timer {
        interval: Math.max(1000, root.pollMs)
        running: root.visible || !root.online
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()

    InfoBar {
        id: bar
        anchors.left: parent.left
        anchors.right: parent.right
        severity: 2 // InfoBar warning
        title: root.title
        message: root.message
        isOpen: root.isOpen
        closable: root.closableWhenOffline || root.forceShow
        collapseWhenClosed: true
        actionText: qsTr("Retry")
        onActionClicked: {
            root.refresh()
            root.retryClicked()
        }
        onCloseClicked: {
            root._userDismissed = true
            root.dismissed()
        }
    }
}
