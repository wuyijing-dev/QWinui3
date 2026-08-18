import QtQuick
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// WindowShellDecoration — fallback when QtQuick.Effects is unavailable at build time.
// Same public API as WindowShellDecoration.qml (MultiEffect build); soft shadow omitted.

Item {
    id: root

    property var targetWindow: null

    readonly property bool active: WindowHelper.clientShellDecoration
    readonly property bool expanded: active && targetWindow
                                     && WindowHelper.shellChromeExpanded(targetWindow)
    readonly property real cornerRadius: expanded ? WindowHelper.shellCornerRadius() : 0
    readonly property color frameFill: Theme.bgLayer
    readonly property color frameBorder: Theme.strokeDivider

    Rectangle {
        id: frame
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.frameFill
        border.width: root.cornerRadius > 0 ? Math.max(1, Theme.strokeHairline) : 0
        border.color: root.frameBorder
        antialiasing: true
    }

    // Flat rim stand-in for drop shadow (matches ElevatedChrome_Simple pattern).
    Rectangle {
        anchors.fill: frame
        anchors.topMargin: 2
        visible: root.active && root.expanded
        radius: frame.radius
        color: Theme.dark ? "#44000000" : "#33000000"
        z: -1
    }
}
