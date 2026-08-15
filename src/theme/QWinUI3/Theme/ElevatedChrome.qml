import QtQuick
import QtQuick.Effects

// ElevatedChrome — Shared elevated shadow/border chrome.
//
//   ElevatedChrome { anchors.fill: parent }

Item {
    id: root

    // Color
    property color color: "#FFFFFF"
    // Corner radius
    property real radius: 8
    // Border Color
    property color borderColor: "#0F000000"
    // Border Width
    property int borderWidth: 1
    // Elevated
    property bool elevated: true
    // Elevation
    property real elevation: 2
    // Shadow Opacity
    property real shadowOpacity: 0.14
    // Shadow Blur
    property real shadowBlur: 0.9
    // Blur Max
    property int blurMax: 28
    // Antialiasing
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
