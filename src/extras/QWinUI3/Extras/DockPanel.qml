import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// DockPanel — Dock children Top/Bottom/Left/Right/Fill.
//
//   DockPanel {
//       Rectangle { DockPanel.dock: DockPanel.Top; height: 40 }
//       Rectangle { DockPanel.dock: DockPanel.Fill }
//   }

T.Control {
    id: root

    // Item.left/top/right/bottom are FINAL in Qt 6 — use enum instead
    enum Dock {
        Left = 1,
        Top,
        Right,
        Bottom,
        Fill
    }

    // Default children / content slot
    default property alias contentData: host.data
    // WinUI LastChildFill: last non-edge child fills the remaining region
    property bool lastChildFill: true
    // Edge paddings
    property int paddingEdges: 0

    padding: paddingEdges
    spacing: 0
    implicitWidth: 240
    implicitHeight: 180
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Dock panel")

    // Number of children
    readonly property int childCount: {
        var n = 0
        for (var i = 0; i < host.children.length; ++i) {
            if (host.children[i] && host.children[i].visible)
                ++n
        }
        return n
    }

    contentItem: Item {
        id: host
        onChildrenChanged: Qt.callLater(root.relayout)
        onWidthChanged: root.relayout()
        onHeightChanged: root.relayout()
    }

    onSpacingChanged: relayout()
    onLastChildFillChanged: Qt.callLater(relayout)
    onPaddingEdgesChanged: Qt.callLater(relayout)
    onWidthChanged: relayout()
    onHeightChanged: relayout()

    // Dock Of
    function dockOf(item) {
        if (item.dock === undefined || item.dock === null)
            return lastChildFill ? -1 : DockPanel.Fill
        return item.dock
    }

    // Relayout
    function relayout() {
        var lefts = [], tops = [], rights = [], bottoms = [], fills = [], undocked = []
        for (var i = 0; i < host.children.length; ++i) {
            var ch = host.children[i]
            if (!ch || !ch.visible)
                continue
            var d = dockOf(ch)
            switch (d) {
            case DockPanel.Left: lefts.push(ch); break
            case DockPanel.Top: tops.push(ch); break
            case DockPanel.Right: rights.push(ch); break
            case DockPanel.Bottom: bottoms.push(ch); break
            case DockPanel.Fill: fills.push(ch); break
            default: undocked.push(ch); break
            }
        }
        if (lastChildFill && undocked.length) {
            fills.push(undocked.pop())
            // remaining undocked keep natural size at origin of fill region later
        }

        var x0 = 0, y0 = 0, x1 = host.width, y1 = host.height
        var gap = root.spacing

        for (i = 0; i < tops.length; ++i) {
            var t = tops[i]
            var th = t.implicitHeight > 0 ? t.implicitHeight : (t.height > 0 ? t.height : Theme.controlHeight)
            t.x = x0; t.y = y0; t.width = Math.max(0, x1 - x0); t.height = th
            y0 += th + gap
        }
        for (i = 0; i < bottoms.length; ++i) {
            var b = bottoms[i]
            var bh = b.implicitHeight > 0 ? b.implicitHeight : (b.height > 0 ? b.height : Theme.controlHeight)
            y1 -= bh
            b.x = x0; b.y = y1; b.width = Math.max(0, x1 - x0); b.height = bh
            y1 -= gap
        }
        for (i = 0; i < lefts.length; ++i) {
            var l = lefts[i]
            var lw = l.implicitWidth > 0 ? l.implicitWidth : (l.width > 0 ? l.width : 120)
            l.x = x0; l.y = y0; l.width = lw; l.height = Math.max(0, y1 - y0)
            x0 += lw + gap
        }
        for (i = 0; i < rights.length; ++i) {
            var r = rights[i]
            var rw = r.implicitWidth > 0 ? r.implicitWidth : (r.width > 0 ? r.width : 120)
            x1 -= rw
            r.x = x1; r.y = y0; r.width = rw; r.height = Math.max(0, y1 - y0)
            x1 -= gap
        }
        for (i = 0; i < undocked.length; ++i) {
            var u = undocked[i]
            var uw = u.implicitWidth > 0 ? u.implicitWidth : (u.width > 0 ? u.width : 80)
            var uh = u.implicitHeight > 0 ? u.implicitHeight : (u.height > 0 ? u.height : Theme.controlHeight)
            u.x = x0
            u.y = y0
            u.width = uw
            u.height = uh
        }
        for (i = 0; i < fills.length; ++i) {
            var f = fills[i]
            f.x = x0; f.y = y0
            f.width = Math.max(0, x1 - x0)
            f.height = Math.max(0, y1 - y0)
        }
    }

    Component.onCompleted: Qt.callLater(relayout)
    background: Item {}
}
