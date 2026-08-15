import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// StackPanel — Simple stack layout (orientation + spacing).
//
//   StackPanel { orientation: Qt.Vertical }

T.Control {
    id: root

    // Default children / content slot
    default property alias contentData: host.data
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Vertical
    // Edge paddings
    property int paddingEdges: 0
    // Cross-axis alignment: Horizontal → vertical align; Vertical → horizontal align
    property int alignment: Qt.AlignLeft | Qt.AlignTop
    // Qt layout direction
    property int layoutDirection: Qt.LeftToRight
    // When true (default for Vertical), stretch children along the cross axis to host size
    property bool stretchChildren: orientation === Qt.Vertical

    padding: paddingEdges
    spacing: Theme.spacing
    implicitWidth: Math.max(40, _contentW + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight, _contentH + topPadding + bottomPadding)
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Stack panel")

    // Number of children
    readonly property int childCount: {
        var n = 0
        for (var i = 0; i < host.children.length; ++i) {
            if (host.children[i] && host.children[i].visible)
                ++n
        }
        return n
    }

    property real _contentW: 40
    property real _contentH: Theme.controlHeight

    contentItem: Item {
        id: host
        onChildrenChanged: Qt.callLater(root.relayout)
        onWidthChanged: Qt.callLater(root.relayout)
        onHeightChanged: Qt.callLater(root.relayout)
    }

    onOrientationChanged: Qt.callLater(relayout)
    onSpacingChanged: Qt.callLater(relayout)
    onAlignmentChanged: Qt.callLater(relayout)
    onLayoutDirectionChanged: Qt.callLater(relayout)
    onStretchChildrenChanged: Qt.callLater(relayout)
    Component.onCompleted: Qt.callLater(relayout)

    // Child item width
    function childWidth(c) {
        if (c.implicitWidth > 0)
            return c.implicitWidth
        if (c.width > 0)
            return c.width
        return 80
    }

    // Child item height
    function childHeight(c) {
        if (c.implicitHeight > 0)
            return c.implicitHeight
        if (c.height > 0)
            return c.height
        return Theme.controlHeight
    }

    // Recompute layout
    function relayout() {
        var kids = []
        for (var i = 0; i < host.children.length; ++i) {
            var ch = host.children[i]
            if (ch && ch.visible)
                kids.push(ch)
        }
        if (layoutDirection === Qt.RightToLeft && orientation === Qt.Horizontal)
            kids.reverse()
        var gap = root.spacing
        if (orientation === Qt.Horizontal) {
            var x = 0
            var hMax = 0
            var naturalH = 0
            for (i = 0; i < kids.length; ++i)
                naturalH = Math.max(naturalH, childHeight(kids[i]))
            var layoutH = stretchChildren && host.height > 0 ? host.height : naturalH
            for (i = 0; i < kids.length; ++i) {
                var c = kids[i]
                var w = childWidth(c)
                var h = stretchChildren ? layoutH : childHeight(c)
                c.x = x
                if (stretchChildren) {
                    c.y = 0
                } else if (alignment & Qt.AlignVCenter) {
                    c.y = Math.max(0, (layoutH - h) / 2)
                } else if (alignment & Qt.AlignBottom) {
                    c.y = Math.max(0, layoutH - h)
                } else {
                    c.y = 0
                }
                c.width = w
                c.height = h
                x += w + (i < kids.length - 1 ? gap : 0)
                hMax = Math.max(hMax, h)
            }
            _contentW = Math.max(40, x)
            _contentH = Math.max(Theme.controlHeight, Math.max(hMax, naturalH))
        } else {
            var y = 0
            var naturalW = 0
            for (i = 0; i < kids.length; ++i)
                naturalW = Math.max(naturalW, childWidth(kids[i]))
            // Stretch to host when parent assigns a width (e.g. Layout.fillWidth),
            // but never push that stretched width back into implicitWidth.
            var layoutW = stretchChildren && host.width > 0 ? host.width : naturalW
            for (i = 0; i < kids.length; ++i) {
                c = kids[i]
                var cw = stretchChildren ? layoutW : childWidth(c)
                h = childHeight(c)
                if (stretchChildren) {
                    c.x = 0
                } else if (alignment & Qt.AlignHCenter) {
                    c.x = Math.max(0, (layoutW - cw) / 2)
                } else if (alignment & Qt.AlignRight) {
                    c.x = Math.max(0, layoutW - cw)
                } else {
                    c.x = 0
                }
                c.y = y
                c.width = cw
                c.height = h
                y += h + (i < kids.length - 1 ? gap : 0)
            }
            _contentW = Math.max(40, naturalW)
            _contentH = Math.max(Theme.controlHeight, y)
        }
    }

    background: Item {}
}
