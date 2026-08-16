import QtQuick

// ElevatedChrome — fallback when QtQuick.Effects is unavailable.
// Same public API as ElevatedChrome.qml (MultiEffect build); soft shadow omitted.

Item {
    id: root

    property color color: "#FFFFFF"
    property real radius: 8
    property color borderColor: "#0F000000"
    property int borderWidth: 1
    property bool elevated: true
    property real elevation: 2
    property real shadowOpacity: 0.14
    property real shadowBlur: 0.9
    property int blurMax: 28
    property alias antialiasing: face.antialiasing

    // Lightweight stand-in for elevation without MultiEffect.
    Rectangle {
        anchors.fill: parent
        anchors.margins: root.elevated && root.elevation > 0 ? -1 : 0
        radius: root.radius + 1
        color: "#00000000"
        border.width: root.elevated && root.elevation > 0 ? 1 : 0
        border.color: Qt.rgba(0, 0, 0, Math.min(0.2, root.shadowOpacity))
        z: -1
        visible: root.elevated && root.elevation > 0
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
