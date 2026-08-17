import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// OnScreenKeyboardWindow — floating Win11-style OSK (1.83).
//
//   OnScreenKeyboardWindow { visible: true }
//   // Windows: systemWide defaults ON (SendInput into the focused desktop app).
//   // Docked OnScreenKeyboard stays in-app (systemWide default off).
//
// @notes
//   Always-on-top tool window with WS_EX_NOACTIVATE so taps do not steal focus.
//   systemWide is Windows-only; Linux floating is in-app only.

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

    function applyNoActivate() {
        WindowHelper.setNoActivate(root, true)
    }

    function openFloating() {
        if (!visible)
            show()
        applyNoActivate()
        Qt.callLater(applyNoActivate)
    }

    function closeFloating() {
        close()
    }

    onVisibleChanged: {
        if (visible)
            applyNoActivate()
    }

    onActiveChanged: {
        // Qt may still mark the window active; keep HWND no-activate.
        if (visible)
            applyNoActivate()
    }

    Component.onCompleted: {
        if (visible)
            applyNoActivate()
    }

    OnScreenKeyboard {
        id: osk
        anchors.fill: parent
        anchors.margins: 0
        dragHostWindow: true
        showChrome: true
        hardwareInput: false
        // Floating host is for other apps — enable SendInput when the OS allows it.
        systemWide: supportsSystemWide
        onCloseRequested: root.closeFloating()
        onSettingsRequested: osk.settingsOpen = true
    }
}
