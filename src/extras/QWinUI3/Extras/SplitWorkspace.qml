import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// SplitWorkspace — 2–3 resizable panes for IDE/ops layouts (3.03 W5).
//
//   SplitWorkspace {
//       paneCount: 3
//       orientation: Qt.Horizontal
//       minPaneWidth: 120
//       ratios: [0.25, 0.5, 0.25]
//       pane1: Rectangle { }
//       pane2: Rectangle { }
//       pane3: Rectangle { }
//   }
//
//   // --- API ---
//   // methods: focusNextPane(), focusPreviousPane(), focusPane(index),
//   //          setRatios(list), applyPreset(obj), snapshot()
//
// @notes
//   Pair with LayoutPreset for named QSettings restore (3.03 W6).
//   Focus chords: Ctrl+Alt+Left/Right (or Up/Down when vertical).

Item {
    id: root

    property int paneCount: 2
    property int orientation: Qt.Horizontal
    property real minPaneWidth: 120
    property real minPaneHeight: 80
    property var ratios: [0.5, 0.5]

    property Item pane1: null
    property Item pane2: null
    property Item pane3: null

    property int focusedPane: 0

    implicitWidth: 640
    implicitHeight: 360
    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Split workspace")

    readonly property int _effectiveCount: Math.max(2, Math.min(3, paneCount))

    function _paneAt(i) {
        if (i === 0)
            return pane1
        if (i === 1)
            return pane2
        return pane3
    }

    function snapshot() {
        return {
            paneCount: _effectiveCount,
            orientation: orientation === Qt.Vertical ? "vertical" : "horizontal",
            ratios: (ratios || []).slice(0, _effectiveCount)
        }
    }

    function applyPreset(obj) {
        if (!obj)
            return false
        if (obj.paneCount === 2 || obj.paneCount === 3)
            paneCount = obj.paneCount
        if (obj.orientation === "vertical" || obj.orientation === Qt.Vertical)
            orientation = Qt.Vertical
        else if (obj.orientation === "horizontal" || obj.orientation === Qt.Horizontal)
            orientation = Qt.Horizontal
        if (obj.ratios)
            setRatios(obj.ratios)
        else
            Qt.callLater(function () {
                if (root)
                    root._applySizes()
            })
        return true
    }

    function setRatios(list) {
        if (!list || !list.length)
            return
        var n = _effectiveCount
        var raw = []
        var sum = 0
        for (var i = 0; i < n; ++i) {
            var v = Number(list[i] !== undefined ? list[i] : (1 / n))
            if (!(v > 0))
                v = 1 / n
            raw.push(v)
            sum += v
        }
        if (sum <= 0)
            return
        var next = []
        for (var j = 0; j < n; ++j)
            next.push(raw[j] / sum)
        ratios = next
    }

    function focusPane(index) {
        var i = Math.max(0, Math.min(_effectiveCount - 1, index))
        focusedPane = i
        var p = _paneAt(i)
        if (p && typeof p.forceActiveFocus === "function")
            p.forceActiveFocus()
    }

    function focusNextPane() {
        focusPane((focusedPane + 1) % _effectiveCount)
    }

    function focusPreviousPane() {
        focusPane((focusedPane + _effectiveCount - 1) % _effectiveCount)
    }

    function _applySizes() {
        var n = _effectiveCount
        var r = ratios || []
        var horiz = orientation === Qt.Horizontal
        var total = horiz ? width : height
        if (total <= 0)
            return
        var minSz = horiz ? minPaneWidth : minPaneHeight
        var reserved = minSz * n
        var flexible = Math.max(0, total - reserved)
        var x = 0
        for (var i = 0; i < n; ++i) {
            var weight = Number(r[i] !== undefined ? r[i] : (1 / n))
            if (!(weight > 0))
                weight = 1 / n
            var w = minSz + flexible * weight
            if (i === n - 1)
                w = total - x
            var p = _paneAt(i)
            if (!p)
                continue
            if (p.parent !== host)
                p.parent = host
            p.visible = true
            if (horiz) {
                p.x = Math.round(x)
                p.y = 0
                p.width = Math.max(minSz, Math.round(w))
                p.height = height
                x += p.width
            } else {
                p.x = 0
                p.y = Math.round(x)
                p.width = width
                p.height = Math.max(minSz, Math.round(w))
                x += p.height
            }
        }
        if (pane3) {
            if (pane3.parent !== host)
                pane3.parent = host
            pane3.visible = n >= 3
        }
        _layoutHandles()
    }

    function _layoutHandles() {
        var horiz = orientation === Qt.Horizontal
        handle1.visible = _effectiveCount >= 2 && pane1 && pane2
        handle2.visible = _effectiveCount >= 3 && pane2 && pane3
        if (handle1.visible) {
            if (horiz) {
                handle1.width = 6
                handle1.height = height
                handle1.x = pane1.x + pane1.width - 3
                handle1.y = 0
            } else {
                handle1.width = width
                handle1.height = 6
                handle1.x = 0
                handle1.y = pane1.y + pane1.height - 3
            }
        }
        if (handle2.visible) {
            if (horiz) {
                handle2.width = 6
                handle2.height = height
                handle2.x = pane2.x + pane2.width - 3
                handle2.y = 0
            } else {
                handle2.width = width
                handle2.height = 6
                handle2.x = 0
                handle2.y = pane2.y + pane2.height - 3
            }
        }
    }

    function _dragSplit(handleIndex, delta) {
        var n = _effectiveCount
        var horiz = orientation === Qt.Horizontal
        var total = horiz ? width : height
        if (total <= 0)
            return
        var minSz = horiz ? minPaneWidth : minPaneHeight
        var sizes = []
        for (var i = 0; i < n; ++i) {
            var p = _paneAt(i)
            sizes.push(p ? (horiz ? p.width : p.height) : minSz)
        }
        var a = handleIndex
        var b = handleIndex + 1
        if (b >= n)
            return
        var pair = sizes[a] + sizes[b]
        var na = Math.min(Math.max(minSz, sizes[a] + delta), pair - minSz)
        sizes[a] = na
        sizes[b] = pair - na
        var next = []
        for (var j = 0; j < n; ++j)
            next.push(sizes[j] / total)
        ratios = next
    }

    onWidthChanged: Qt.callLater(function () {
        if (root)
            root._applySizes()
    })
    onHeightChanged: Qt.callLater(function () {
        if (root)
            root._applySizes()
    })
    onPaneCountChanged: Qt.callLater(function () {
        if (!root)
            return
        setRatios(ratios && ratios.length ? ratios : [0.5, 0.5])
        _applySizes()
    })
    onOrientationChanged: Qt.callLater(function () {
        if (root)
            root._applySizes()
    })
    onPane1Changed: Qt.callLater(function () {
        if (root)
            root._applySizes()
    })
    onPane2Changed: Qt.callLater(function () {
        if (root)
            root._applySizes()
    })
    onPane3Changed: Qt.callLater(function () {
        if (root)
            root._applySizes()
    })
    onRatiosChanged: Qt.callLater(function () {
        if (root)
            root._applySizes()
    })
    Component.onCompleted: Qt.callLater(function () {
        if (root)
            root._applySizes()
    })

    Shortcut {
        sequences: ["Ctrl+Alt+Right", "Ctrl+Alt+Down"]
        onActivated: root.focusNextPane()
    }
    Shortcut {
        sequences: ["Ctrl+Alt+Left", "Ctrl+Alt+Up"]
        onActivated: root.focusPreviousPane()
    }

    Item {
        id: host
        anchors.fill: parent
        clip: true
    }

    component SplitHandle: Rectangle {
        id: h
        property int splitIndex: 0
        z: 10
        color: Theme.strokeDivider
        opacity: ma.containsMouse || ma.pressed ? 1 : 0.4
        MouseArea {
            id: ma
            anchors.fill: parent
            anchors.margins: -4
            hoverEnabled: true
            cursorShape: root.orientation === Qt.Horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
            property real _prev: 0
            onPressed: function (mouse) {
                var pt = mapToItem(root, mouse.x, mouse.y)
                _prev = root.orientation === Qt.Horizontal ? pt.x : pt.y
            }
            onPositionChanged: function (mouse) {
                if (!pressed)
                    return
                var pt = mapToItem(root, mouse.x, mouse.y)
                var cur = root.orientation === Qt.Horizontal ? pt.x : pt.y
                root._dragSplit(h.splitIndex, cur - _prev)
                _prev = cur
            }
        }
    }

    SplitHandle {
        id: handle1
        splitIndex: 0
    }
    SplitHandle {
        id: handle2
        splitIndex: 1
    }
}
