import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// WrapPanel — Flow / wrap layout.
//
//   WrapPanel {
//       id: wrap
//       width: parent.width
//       itemSpacing: 8
//       horizontalSpacing: 12
//       verticalSpacing: 6
//       Repeater {
//           model: 12
//           Chip { text: "Tag " + index }
//       }
//   }
//   // --- API ---
//   // wrap.itemSpacing / horizontalSpacing / verticalSpacing / orientation
//
// @notes
//   Wrapping flow of children; itemSpacing / horizontalSpacing / verticalSpacing / orientation.
//   implicitWidth is the single-line natural width (not availableWidth) to avoid Layout loops.

T.Control {
    id: root

    // Default children / content slot
    default property alias contentData: host.data
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Horizontal
    // Item width
    property real itemWidth: -1
    // Item height
    property real itemHeight: -1
    // Edge paddings
    property int paddingEdges: 0
    // Qt layout direction
    property int layoutDirection: Qt.LeftToRight
    // Uniform spacing alias (WinUI ItemSpacing)
    property alias itemSpacing: root.spacing
    // Gap between items on a line (<0 → spacing)
    property real horizontalSpacing: -1
    // Gap between wrapped lines (<0 → spacing)
    property real verticalSpacing: -1

    // Measured preferred size — must not read availableWidth/width (binding loop).
    property real _naturalWidth: 100
    property real _laidOutHeight: Theme.controlHeight

    padding: paddingEdges
    spacing: Theme.spacing
    implicitWidth: Math.max(100, _naturalWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight, _laidOutHeight + topPadding + bottomPadding)
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Wrap panel")

    readonly property real _hGap: horizontalSpacing >= 0 ? horizontalSpacing : spacing
    readonly property real _vGap: verticalSpacing >= 0 ? verticalSpacing : spacing

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
        // Control assigns width/height from available* — do not bind implicit* to them.
        onChildrenChanged: Qt.callLater(function () {
            if (root)
                root.relayout()
        })
        onWidthChanged: Qt.callLater(function () {
            if (root)
                root.relayout()
        })
    }

    function _visibleKids() {
        var list = []
        for (var i = 0; i < host.children.length; ++i) {
            var ch = host.children[i]
            if (ch && ch.visible)
                list.push(ch)
        }
        return list
    }

    function _applyItemSize(ch) {
        if (itemWidth >= 0)
            ch.width = itemWidth
        if (itemHeight >= 0)
            ch.height = itemHeight
    }

    function _childSize(ch) {
        return {
            w: ch.width > 0 ? ch.width : (ch.implicitWidth || 0),
            h: ch.height > 0 ? ch.height : (ch.implicitHeight || 0)
        }
    }

    // Recompute wrapped layout
    function relayout() {
        var kids = _visibleKids()
        var avail = Math.max(0, host.width)
        var hGap = _hGap
        var vGap = _vGap
        var rtl = layoutDirection === Qt.RightToLeft
        var maxW = 0
        var maxH = 0
        var natural = 0

        if (orientation === Qt.Vertical) {
            var x = 0
            var y = 0
            var colW = 0
            var naturalH = 0
            for (var i = 0; i < kids.length; ++i) {
                var ch = kids[i]
                _applyItemSize(ch)
                var sz = _childSize(ch)
                var iw = sz.w
                var ih = sz.h
                naturalH += ih + (i ? vGap : 0)
                if (y > 0 && avail > 0 && y + ih > avail) {
                    y = 0
                    x += colW + hGap
                    colW = 0
                }
                ch.x = rtl ? Math.max(0, avail - x - iw) : x
                ch.y = y
                y += ih + vGap
                colW = Math.max(colW, iw)
                maxW = Math.max(maxW, x + colW)
                maxH = Math.max(maxH, y - vGap)
            }
            root._naturalWidth = Math.max(100, kids.length ? maxW : 100)
            // Prefer unwrapped column height when unconstrained; laid-out height when wrapping.
            root._laidOutHeight = Math.max(0, avail > 0 ? maxH : naturalH)
            return
        }

        // Horizontal wrap (default) — natural width = single-line sum (no wrap).
        for (var m = 0; m < kids.length; ++m) {
            _applyItemSize(kids[m])
            var ns = _childSize(kids[m])
            natural += ns.w + (m ? hGap : 0)
        }

        var cx = 0
        var cy = 0
        var rowH = 0
        var lineItems = []
        function flushLine() {
            if (!rtl || lineItems.length === 0) {
                lineItems = []
                return
            }
            var used = 0
            for (var k = 0; k < lineItems.length; ++k)
                used += lineItems[k].w + (k ? hGap : 0)
            var start = Math.max(0, avail - used)
            var px = start
            for (var j = 0; j < lineItems.length; ++j) {
                lineItems[j].item.x = px
                px += lineItems[j].w + hGap
            }
            lineItems = []
        }

        for (var n = 0; n < kids.length; ++n) {
            var child = kids[n]
            _applyItemSize(child)
            var cs = _childSize(child)
            var cw = cs.w
            var chh = cs.h
            if (cx > 0 && avail > 0 && cx + cw > avail) {
                flushLine()
                cx = 0
                cy += rowH + vGap
                rowH = 0
            }
            child.y = cy
            if (rtl) {
                lineItems.push({ item: child, w: cw })
            } else {
                child.x = cx
            }
            cx += cw + hGap
            rowH = Math.max(rowH, chh)
            maxW = Math.max(maxW, cx - hGap)
        }
        flushLine()
        maxH = cy + rowH

        root._naturalWidth = Math.max(100, natural)
        root._laidOutHeight = Math.max(0, maxH)
    }

    onItemWidthChanged: Qt.callLater(function () {
        if (root)
            root.relayout()
    })
    onItemHeightChanged: Qt.callLater(function () {
        if (root)
            root.relayout()
    })
    onSpacingChanged: Qt.callLater(function () {
        if (root)
            root.relayout()
    })
    onHorizontalSpacingChanged: Qt.callLater(function () {
        if (root)
            root.relayout()
    })
    onVerticalSpacingChanged: Qt.callLater(function () {
        if (root)
            root.relayout()
    })
    onOrientationChanged: Qt.callLater(function () {
        if (root)
            root.relayout()
    })
    onLayoutDirectionChanged: Qt.callLater(function () {
        if (root)
            root.relayout()
    })
    onWidthChanged: Qt.callLater(function () {
        if (root)
            root.relayout()
    })
    Component.onCompleted: Qt.callLater(function () {
        if (root)
            root.relayout()
    })

    background: Item {}
}
