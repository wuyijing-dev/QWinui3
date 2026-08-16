import QtQuick
import QWinUI3.Theme

// EntranceThemeTransition — WinUI-style page / section entrance (fade + rise + scale).
//
//   EntranceThemeTransition {
//       anchors.fill: parent
//       Label { text: "Hello" }
//   }
//
//   // --- API ---
//   // methods: play(), reset()
//   // properties: running, offsetY, fromScale
//
// @notes
//   Prefer Theme.duration / reducedMotion. Attach to CatalogPage body or cards.

Item {
    id: root

    default property alias content: host.data

    // Vertical offset at start (px)
    property real offsetY: 16
    // Scale at start
    property real fromScale: 0.98
    // Play automatically when completed / made visible
    property bool autoPlay: true
    // True while the enter animation is running
    readonly property bool running: anim.running

    opacity: 0
    transform: [
        Translate { id: rise; y: root.offsetY },
        Scale {
            id: zoom
            origin.x: root.width / 2
            origin.y: root.height / 2
            xScale: root.fromScale
            yScale: root.fromScale
        }
    ]

    // Run the entrance once
    function play() {
        if (Theme.reducedMotion) {
            root.opacity = 1
            rise.y = 0
            zoom.xScale = 1
            zoom.yScale = 1
            return
        }
        reset()
        anim.restart()
    }

    // Jump to the pre-enter pose
    function reset() {
        anim.stop()
        root.opacity = 0
        rise.y = root.offsetY
        zoom.xScale = root.fromScale
        zoom.yScale = root.fromScale
    }

    Component.onCompleted: {
        if (autoPlay)
            Qt.callLater(play)
    }

    onVisibleChanged: {
        if (visible && autoPlay)
            Qt.callLater(play)
    }

    ParallelAnimation {
        id: anim
        NumberAnimation {
            target: root
            property: "opacity"
            to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            target: rise
            property: "y"
            to: 0
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
        NumberAnimation {
            target: zoom
            property: "xScale"
            to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEmphasized
        }
        NumberAnimation {
            target: zoom
            property: "yScale"
            to: 1
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEmphasized
        }
    }

    Item {
        id: host
        anchors.fill: parent
    }
}
