import QtQuick
import QWinUI3.Theme

// WinUI RelativePanel: position children with sibling/panel alignment constraints.
// Child optional props: alignLeftWith, alignRightWith, alignTopWith, alignBottomWith,
// alignHorizontalCenterWith, alignVerticalCenterWith, leftOf, rightOf, above, below.
// Uses Item (not Control) so layout gap is not confused with Control.spacing (FINAL).
Item {
    id: root

    property real panelSpacing: 0
    property int paddingEdges: 0

    implicitWidth: 320
    implicitHeight: 240
    clip: true

    // Effective layout rect inset by paddingEdges
    readonly property real _x0: paddingEdges
    readonly property real _y0: paddingEdges
    readonly property real _x1: width - paddingEdges
    readonly property real _y1: height - paddingEdges
    readonly property real _innerW: Math.max(0, _x1 - _x0)
    readonly property real _innerH: Math.max(0, _y1 - _y0)

    onChildrenChanged: Qt.callLater(relayout)
    onWidthChanged: relayout()
    onHeightChanged: relayout()
    onPanelSpacingChanged: relayout()
    onPaddingEdgesChanged: relayout()
    Component.onCompleted: Qt.callLater(relayout)

    function isPanel(ref) {
        return !ref || ref === root
    }

    function leftEdge(ref) {
        return isPanel(ref) ? _x0 : ref.x
    }
    function rightEdge(ref) {
        return isPanel(ref) ? _x1 : (ref.x + ref.width)
    }
    function topEdge(ref) {
        return isPanel(ref) ? _y0 : ref.y
    }
    function bottomEdge(ref) {
        return isPanel(ref) ? _y1 : (ref.y + ref.height)
    }
    function centerX(ref) {
        return isPanel(ref) ? (_x0 + _innerW / 2) : (ref.x + ref.width / 2)
    }
    function centerY(ref) {
        return isPanel(ref) ? (_y0 + _innerH / 2) : (ref.y + ref.height / 2)
    }

    function preferredWidth(item) {
        if (item.implicitWidth > 0)
            return item.implicitWidth
        if (item.width > 0)
            return item.width
        return 80
    }

    function preferredHeight(item) {
        if (item.implicitHeight > 0)
            return item.implicitHeight
        if (item.height > 0)
            return item.height
        return Theme.controlHeight
    }

    function has(item, name) {
        return item[name] !== undefined && item[name] !== null
    }

    function relayout() {
        var gap = root.panelSpacing
        var list = []
        for (var i = 0; i < root.children.length; ++i) {
            var ch = root.children[i]
            if (ch && ch.visible)
                list.push(ch)
        }

        for (i = 0; i < list.length; ++i) {
            ch = list[i]
            ch.width = preferredWidth(ch)
            ch.height = preferredHeight(ch)
            if (!has(ch, "alignLeftWith") && !has(ch, "alignRightWith")
                    && !has(ch, "leftOf") && !has(ch, "rightOf")
                        && !has(ch, "alignHorizontalCenterWith"))
                ch.x = _x0
            if (!has(ch, "alignTopWith") && !has(ch, "alignBottomWith")
                    && !has(ch, "above") && !has(ch, "below")
                    && !has(ch, "alignVerticalCenterWith"))
                ch.y = _y0
        }

        for (var pass = 0; pass < 8; ++pass) {
            for (i = 0; i < list.length; ++i) {
                ch = list[i]
                var left = undefined
                var right = undefined
                var top = undefined
                var bottom = undefined

                if (has(ch, "alignLeftWith"))
                    left = leftEdge(ch.alignLeftWith)
                if (has(ch, "alignRightWith"))
                    right = rightEdge(ch.alignRightWith)
                if (has(ch, "alignTopWith"))
                    top = topEdge(ch.alignTopWith)
                if (has(ch, "alignBottomWith"))
                    bottom = bottomEdge(ch.alignBottomWith)

                if (has(ch, "leftOf"))
                    right = leftEdge(ch.leftOf) - gap
                if (has(ch, "rightOf"))
                    left = rightEdge(ch.rightOf) + gap
                if (has(ch, "above"))
                    bottom = topEdge(ch.above) - gap
                if (has(ch, "below"))
                    top = bottomEdge(ch.below) + gap

                if (left !== undefined && right !== undefined) {
                    ch.x = left
                    ch.width = Math.max(0, right - left)
                } else if (left !== undefined) {
                    ch.x = left
                } else if (right !== undefined) {
                    ch.x = right - ch.width
                } else if (has(ch, "alignHorizontalCenterWith")) {
                    ch.x = centerX(ch.alignHorizontalCenterWith) - ch.width / 2
                }

                if (top !== undefined && bottom !== undefined) {
                    ch.y = top
                    ch.height = Math.max(0, bottom - top)
                } else if (top !== undefined) {
                    ch.y = top
                } else if (bottom !== undefined) {
                    ch.y = bottom - ch.height
                } else if (has(ch, "alignVerticalCenterWith")) {
                    ch.y = centerY(ch.alignVerticalCenterWith) - ch.height / 2
                }
            }
        }
    }
}
