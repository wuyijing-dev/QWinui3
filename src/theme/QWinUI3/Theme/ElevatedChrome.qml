import QtQuick
import QtQuick.Effects

// Rounded surface with soft MultiEffect shadow on a sibling (not on the face).
// Face never uses layer — avoids square-corner flicker; shadow can regenerate safely.
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

    // Soft shadow caster: nearly invisible fill, MultiEffect paints the blur behind the face.
    Rectangle {
        id: shadowCaster
        anchors.fill: parent
        radius: root.radius
        color: "#01000000"
        visible: root.elevated && root.elevation > 0
        z: -1
        layer.enabled: visible
        layer.smooth: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: root.shadowBlur
            shadowOpacity: root.shadowOpacity
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: Math.max(1, root.elevation)
            blurMax: root.blurMax
            autoPaddingEnabled: true
        }
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
