import QtQuick
import QWinUI3.Theme

// ContentThemeTransition — Cross-fade + slight horizontal shift when swapping content.
//
//   ContentThemeTransition {
//       id: transition
//       anchors.fill: parent
//       contentKey: currentPageId
//       Label { text: "…" }
//   }
//
//   // --- API ---
//   // properties: contentKey, offsetX, autoPlay
//   // methods: play(), reset()
//
// @notes
//   Change contentKey (or call play) after replacing children to animate in.

Item {
    id: root

    default property alias content: host.data

    // Change this when content identity changes to re-run the transition
    property var contentKey: 0
    // Horizontal offset at start (px); positive enters from the right
    property real offsetX: 12
    // Play automatically when contentKey changes / completed
    property bool autoPlay: true
    readonly property bool running: anim.running

    opacity: 1
    transform: Translate { id: slide; x: 0 }

    onContentKeyChanged: {
        if (autoPlay)
            Qt.callLater(play)
    }

    Component.onCompleted: {
        if (autoPlay)
            Qt.callLater(play)
    }

    function play() {
        if (Theme.reducedMotion) {
            root.opacity = 1
            slide.x = 0
            return
        }
        reset()
        anim.restart()
    }

    function reset() {
        anim.stop()
        root.opacity = 0
        slide.x = root.offsetX
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
            target: slide
            property: "x"
            to: 0
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }

    Item {
        id: host
        anchors.fill: parent
    }
}
