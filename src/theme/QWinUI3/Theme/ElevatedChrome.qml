import QtQuick

// ElevatedChrome — Shared elevated shadow/border chrome.
//
//   ElevatedChrome { anchors.fill: parent }
//
// Intentionally avoids QtQuick.Effects/MultiEffect so distro Qt packages
// without qml6-module-qtquick-effects do not crash at startup.

Item {
    id: root

    // Primary color
    property color color: "#FFFFFF"
    // Corner radius
    property real radius: 8
    // Border color
    property color borderColor: "#0F000000"
    // Border width in px
    property int borderWidth: 1
    // Use elevated chrome
    property bool elevated: true
    // Elevation level
    property real elevation: 2
    // Shadow opacity
    property real shadowOpacity: 0.14
    // Shadow blur radius (kept for API compatibility; soft rect approx)
    property real shadowBlur: 0.9
    // Maximum blur radius (API compatibility)
    property int blurMax: 28
    // Enable antialiased drawing
    property alias antialiasing: face.antialiasing

    // Soft shadow stand-in (no MultiEffect dependency).
    Rectangle {
        id: shadowCaster
        anchors.fill: parent
        anchors.topMargin: Math.max(1, Math.round(root.elevation))
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        anchors.bottomMargin: -Math.max(1, Math.round(root.elevation))
        radius: root.radius
        color: Qt.rgba(0, 0, 0, root.elevated && root.elevation > 0 ? root.shadowOpacity : 0)
        visible: root.elevated && root.elevation > 0
        z: -1
    }

    Rectangle {
        id: face
        anchors.fill: parent
        radius: root.radius
        color: root.color
        border.width: root.borderWidth
        border.color: root.borderColor
        antialiasing: true
    }
}
