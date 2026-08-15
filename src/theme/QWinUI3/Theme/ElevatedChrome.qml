import QtQuick

// Rounded surface with soft shadow — no layer/MultiEffect.
// layer+MultiEffect on a radius Rectangle regenerates the FBO on size/color/border
// changes and briefly paints square corners; this chrome stays stable.
Item {
    id: root

    property color color: "#FFFFFF"
    property real radius: 8
    property color borderColor: "#0F000000"
    property int borderWidth: 1
    property bool elevated: true
    property real elevation: 2
    property real shadowOpacity: 0.12
    property alias antialiasing: face.antialiasing

    // Ambient contact shadow (offset copy)
    Rectangle {
        visible: root.elevated && root.elevation > 0
        z: -1
        x: 0
        y: root.elevation
        width: parent.width
        height: parent.height
        radius: root.radius
        color: Qt.rgba(0, 0, 0, root.shadowOpacity * 0.65)
        antialiasing: true
    }
    // Softer wider halo
    Rectangle {
        visible: root.elevated && root.elevation > 0
        z: -1
        x: -1
        y: Math.max(1, root.elevation * 0.45)
        width: parent.width + 2
        height: parent.height + 1
        radius: root.radius + 1
        color: Qt.rgba(0, 0, 0, root.shadowOpacity * 0.35)
        antialiasing: true
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
