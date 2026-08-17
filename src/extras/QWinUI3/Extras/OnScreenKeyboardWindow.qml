import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// OnScreenKeyboardWindow — floating Win11-style OSK (1.82).
//
//   OnScreenKeyboardWindow {
//       systemWide: true   // Windows: SendInput into focused desktop apps
//       visible: true
//   }
//
// @notes
//   Same module as OnScreenKeyboard. Always-on-top tool window with
//   WS_EX_NOACTIVATE so taps do not steal focus. systemWide is Windows-only.

Window {
    id: root

    property alias systemWide: osk.systemWide
    property alias keyboardSize: osk.keyboardSize
    property alias layoutId: osk.layoutId
    property alias engine: osk.engine
    readonly property bool supportsSystemWide: osk.supportsSystemWide

    title: qsTr("On-screen keyboard")
    width: Math.max(560, osk.implicitWidth)
    height: Math.max(220, osk.implicitHeight)
    minimumWidth: 480
    minimumHeight: 180
    color: "transparent"
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
           | Qt.WindowDoesNotAcceptFocus
    visible: false

    function openFloating() {
        if (!visible) {
            show()
            raise()
        }
        Qt.callLater(function () {
            WindowHelper.setNoActivate(root, true)
        })
    }

    function closeFloating() {
        close()
    }

    onVisibleChanged: {
        if (visible)
            Qt.callLater(function () {
                WindowHelper.setNoActivate(root, true)
            })
    }

    Component.onCompleted: {
        if (visible)
            WindowHelper.setNoActivate(root, true)
    }

    OnScreenKeyboard {
        id: osk
        anchors.fill: parent
        anchors.margins: 0
        dragHostWindow: true
        showChrome: true
        hardwareInput: false
        onCloseRequested: root.closeFloating()
        onSettingsRequested: osk.settingsOpen = true
    }
}
