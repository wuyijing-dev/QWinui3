import QtQuick
import QtQuick.Effects
import QtQuick.Window
import QWinUI3.Theme

// ElevatedChrome — Shared elevated shadow/border chrome (WinUI-style soft shadow).
//
//   ElevatedChrome { anchors.fill: parent }
//
// Requires QtQuick.Effects (MultiEffect) when QWINUI3_HAVE_QUICK_EFFECTS is on.
// Without Effects, CMake substitutes ElevatedChrome_Simple.qml (same API, no blur).
// MultiEffect deferred one frame; skipped when Theme.reducedMotion (1.89).
// Layer FBO released when chrome / window is not shown (3.47 H16) — blur defaults unchanged.
// Debian/Ubuntu: sudo apt install qml6-module-qtquick-effects libqt6quickeffects6

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
    // Shadow blur radius
    property real shadowBlur: 0.9
    // Maximum blur radius
    property int blurMax: 28
    // Enable antialiased drawing
    property alias antialiasing: face.antialiasing

    property bool _shadowReady: false
    readonly property bool _windowShown: !Window.window || Window.window.visible

    Component.onCompleted: Qt.callLater(function () {
        if (root)
            root._shadowReady = true
    })

    // Soft shadow caster: nearly invisible fill, MultiEffect paints the blur behind the face.
    Rectangle {
        id: shadowCaster
        anchors.fill: parent
        radius: root.radius
        color: "#01000000"
        visible: root.elevated && root.elevation > 0 && !Theme.reducedMotion
                 && root.visible && root._windowShown
        z: -1
        // 3.47 H16 — free layer FBO when not shown; same blur when visible.
        layer.enabled: visible && root._shadowReady
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
