import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// ConnectedAnimation — Shared-element style morph between two items (same window).
//
//   ConnectedAnimation {
//       id: anim
//       from: card
//       to: detailHero
//       onFinished: stack.push(detailPage)
//   }
//   anim.play()
//
// @notes
//   Animates a floating clone from `from` geometry to `to`. Honors Theme.reducedMotion.

Item {
    id: root
    parent: Overlay.overlay
    anchors.fill: parent
    visible: running
    z: 5000

    Accessible.ignored: true

    property Item from: null
    property Item to: null
    property int duration: Theme.duration(Theme.motionSlow)
    property bool running: false
    signal finished()

    property real _x0: 0
    property real _y0: 0
    property real _w0: 0
    property real _h0: 0
    property real _x1: 0
    property real _y1: 0
    property real _w1: 0
    property real _h1: 0

    function play() {
        if (!from || !to || !Overlay.overlay)
            return
        if (Theme.reducedMotion) {
            finished()
            return
        }
        prepare()
        running = true
        ghost.x = _x0
        ghost.y = _y0
        ghost.width = _w0
        ghost.height = _h0
        ghost.opacity = 1
        anim.restart()
    }

    function prepare() {
        var o = Overlay.overlay
        var g0 = from.mapToItem(o, 0, 0)
        var g1 = to.mapToItem(o, 0, 0)
        _x0 = g0.x; _y0 = g0.y
        _w0 = Math.max(1, from.width); _h0 = Math.max(1, from.height)
        _x1 = g1.x; _y1 = g1.y
        _w1 = Math.max(1, to.width); _h1 = Math.max(1, to.height)
    }

    Rectangle {
        id: ghost
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
        opacity: 0
    }

    ParallelAnimation {
        id: anim
        onStopped: {
            root.running = false
            ghost.opacity = 0
            root.finished()
        }
        NumberAnimation {
            target: ghost; property: "x"; to: root._x1
            duration: root.duration; easing.type: Theme.easingEmphasized
        }
        NumberAnimation {
            target: ghost; property: "y"; to: root._y1
            duration: root.duration; easing.type: Theme.easingEmphasized
        }
        NumberAnimation {
            target: ghost; property: "width"; to: root._w1
            duration: root.duration; easing.type: Theme.easingStandard
        }
        NumberAnimation {
            target: ghost; property: "height"; to: root._h1
            duration: root.duration; easing.type: Theme.easingStandard
        }
    }
}
