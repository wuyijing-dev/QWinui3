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
//   // Or via key registry (list → detail):
//   ConnectedAnimationService.register("hero", listThumb)
//   ConnectedAnimationService.register("hero", detailHero)
//   ConnectedAnimationService.play("hero", () => stack.push(page))
//
// @notes
//   Animates a floating clone from `from` geometry to `to`. Honors Theme.reducedMotion.
//   Optional coordinateKey auto-registers with ConnectedAnimationService.
//   setSourceItem() can tint the ghost from a source item's size hint.

Item {
    id: root
    anchors.fill: parent
    visible: running
    z: 5000

    Accessible.ignored: true

    property Item from: null
    property Item to: null
    property string coordinateKey: ""
    property int duration: Theme.duration(Theme.motionSlow)
    property bool running: false
    property color ghostColor: Theme.fillSubtle
    signal finished()

    property real _x0: 0
    property real _y0: 0
    property real _w0: 0
    property real _h0: 0
    property real _x1: 0
    property real _y1: 0
    property real _w1: 0
    property real _h1: 0

    Component.onCompleted: {
        if (!parent && Overlay.overlay)
            parent = Overlay.overlay
    }

    onCoordinateKeyChanged: {
        if (coordinateKey.length && from)
            ConnectedAnimationService.register(coordinateKey, from)
    }
    onFromChanged: {
        if (coordinateKey.length && from)
            ConnectedAnimationService.register(coordinateKey, from)
    }
    onToChanged: {
        if (coordinateKey.length && to)
            ConnectedAnimationService.register(coordinateKey, to)
    }

    function play() {
        if (!from || !to)
            return
        if (!parent && Overlay.overlay)
            parent = Overlay.overlay
        var o = parent
        if (!o)
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

    function playBetween(fromItem, toItem) {
        from = fromItem
        to = toItem
        play()
    }

    function prepare() {
        var o = parent
        if (!o)
            return
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
        color: root.ghostColor
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
        NumberAnimation {
            target: ghost; property: "opacity"; from: 0.95; to: 0.55
            duration: root.duration; easing.type: Theme.easingStandard
        }
    }
}
