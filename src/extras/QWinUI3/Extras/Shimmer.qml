import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Shimmer — Skeleton shimmer placeholder.
//
//   Shimmer {
//       id: shim
//       width: 200; height: 16
//       active: true
//   }
//   // --- API ---
//   // shim.active
//
// @notes
//   Loading placeholder shimmer; active enables the animation.

T.Control {
    id: root

    enum Shape {
        Rectangle,
        Circle,
        TextLine
    }

    // Corner radius
    property real cornerRadius: Theme.cornerControl
    // Active state
    property bool active: true
    // Active / animating state
    property alias isActive: root.active
    // Shape variant
    property int shape: Shimmer.Rectangle
    // Auto-dismiss duration; 0 keeps open
    property int durationMs: 1400
    // Base / track color
    property color baseColor: Theme.fillSubtle
    // Sheen / highlight color
    property color sheenColor: Theme.dark ? "#28FFFFFF" : "#66FFFFFF"
    // Qt.Horizontal | Qt.Vertical
    property int direction: Qt.Horizontal

    implicitWidth: shape === Shimmer.Circle ? 40 : 160
    implicitHeight: shape === Shimmer.TextLine ? 12 : (shape === Shimmer.Circle ? 40 : 16)
    padding: 0
    Accessible.role: Accessible.StatusBar
    Accessible.name: qsTr("Loading")
    Accessible.description: active ? qsTr("Busy") : qsTr("Idle")

    contentItem: Item {
        clip: true

        Rectangle {
            anchors.fill: parent
            radius: root.shape === Shimmer.Circle ? width / 2
                  : (root.shape === Shimmer.TextLine ? height / 2 : root.cornerRadius)
            color: root.baseColor

            Rectangle {
                id: sheen
                width: root.direction === Qt.Vertical ? parent.width * 2 : parent.width * 0.45
                height: root.direction === Qt.Vertical ? parent.height * 0.45 : parent.height * 2
                rotation: root.direction === Qt.Vertical ? 0 : 20
                opacity: 0.55
                visible: root.active && !Theme.reducedMotion
                gradient: Gradient {
                    orientation: root.direction === Qt.Vertical ? Gradient.Vertical : Gradient.Horizontal
                    GradientStop { position: 0; color: "transparent" }
                    GradientStop {
                        position: 0.5
                        color: root.sheenColor
                    }
                    GradientStop { position: 1; color: "transparent" }
                }

                SequentialAnimation on x {
                    loops: Animation.Infinite
                    running: root.active && root.visible && !Theme.reducedMotion
                             && root.direction === Qt.Horizontal
                    NumberAnimation {
                        from: -sheen.width
                        to: root.width + sheen.width
                        duration: root.durationMs
                        easing.type: Easing.InOutSine
                    }
                    PauseAnimation { duration: Math.max(200, root.durationMs * 0.28) }
                }
                SequentialAnimation on y {
                    loops: Animation.Infinite
                    running: root.active && root.visible && !Theme.reducedMotion
                             && root.direction === Qt.Vertical
                    NumberAnimation {
                        from: -sheen.height
                        to: root.height + sheen.height
                        duration: root.durationMs
                        easing.type: Easing.InOutSine
                    }
                    PauseAnimation { duration: Math.max(200, root.durationMs * 0.28) }
                }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: root.active && root.visible && Theme.reducedMotion
                NumberAnimation { from: 0.45; to: 0.9; duration: 700; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.9; to: 0.45; duration: 700; easing.type: Easing.InOutSine }
            }
        }
    }

    background: Item {}
}
