pragma Singleton
import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// ConnectedAnimationService — Register shared-element keys and play list→detail morphs.
//
//   ConnectedAnimationService.register("mail.hero", rowThumb)
//   ConnectedAnimationService.register("mail.hero", detailHero)
//   ConnectedAnimationService.play("mail.hero", function () { stack.push(detail) })
//
//   // --- API ---
//   // register(key, item), unregister(key, item?), play(key, onFinished?),
//   // playBetween(fromItem, toItem, onFinished?), clear()
//
// @notes
//   Uses a single ConnectedAnimation ghost parented to Overlay.overlay.
//   Same key may be registered twice (from + to); play() morphs first→last.

QtObject {
    id: root

    property var _map: ({})
    property var _anim: null
    property var _pendingFinished: null

    function register(key, item) {
        if (!key || !item)
            return
        var k = String(key)
        var entry = _map[k]
        if (!entry) {
            entry = { items: [] }
            _map[k] = entry
        }
        if (entry.items.indexOf(item) < 0)
            entry.items.push(item)
        _prune(k)
    }

    function unregister(key, item) {
        if (!key)
            return
        var k = String(key)
        var entry = _map[k]
        if (!entry)
            return
        if (!item) {
            delete _map[k]
            return
        }
        var idx = entry.items.indexOf(item)
        if (idx >= 0)
            entry.items.splice(idx, 1)
        if (!entry.items.length)
            delete _map[k]
    }

    function clear() {
        _map = ({})
    }

    function _prune(key) {
        var entry = _map[key]
        if (!entry)
            return
        var live = []
        for (var i = 0; i < entry.items.length; ++i) {
            var it = entry.items[i]
            if (it && it.width !== undefined)
                live.push(it)
        }
        entry.items = live
    }

    function _ends(key) {
        _prune(key)
        var entry = _map[key]
        if (!entry || entry.items.length < 1)
            return null
        if (entry.items.length === 1)
            return { from: entry.items[0], to: entry.items[0] }
        return {
            from: entry.items[0],
            to: entry.items[entry.items.length - 1]
        }
    }

    function play(key, onFinished) {
        var ends = _ends(key)
        if (!ends || !ends.from || !ends.to) {
            if (typeof onFinished === "function")
                onFinished()
            return false
        }
        return playBetween(ends.from, ends.to, onFinished)
    }

    function _overlayFor(item) {
        if (!item)
            return null
        try {
            if (item.Overlay && item.Overlay.overlay)
                return item.Overlay.overlay
        } catch (e) { }
        return null
    }

    function playBetween(fromItem, toItem, onFinished) {
        if (!fromItem || !toItem) {
            if (typeof onFinished === "function")
                onFinished()
            return false
        }
        if (Theme.reducedMotion) {
            if (typeof onFinished === "function")
                onFinished()
            return true
        }
        var overlay = _overlayFor(fromItem) || _overlayFor(toItem)
        if (!overlay) {
            if (typeof onFinished === "function")
                onFinished()
            return false
        }
        if (!_anim) {
            var comp = Qt.createComponent(Qt.resolvedUrl("ConnectedAnimation.qml"))
            if (comp.status !== Component.Ready) {
                if (typeof onFinished === "function")
                    onFinished()
                return false
            }
            _anim = comp.createObject(overlay)
        } else {
            _anim.parent = overlay
        }
        _anim.from = fromItem
        _anim.to = toItem
        try { _anim.finished.disconnect(_onFinished) } catch (e2) { }
        _pendingFinished = onFinished
        _anim.finished.connect(_onFinished)
        _anim.play()
        return true
    }

    function _onFinished() {
        var cb = _pendingFinished
        _pendingFinished = null
        if (typeof cb === "function")
            cb()
    }
}
