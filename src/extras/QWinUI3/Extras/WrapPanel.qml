import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: root

    default property alias contentData: flow.data
    property int orientation: Qt.Horizontal
    property real itemWidth: -1
    property real itemHeight: -1
    property int paddingEdges: 0
    property int layoutDirection: Qt.LeftToRight

    padding: paddingEdges
    spacing: Theme.spacing
    implicitWidth: Math.max(100, flow.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight, flow.implicitHeight + topPadding + bottomPadding)

    contentItem: Flow {
        id: flow
        spacing: root.spacing
        flow: root.orientation === Qt.Vertical ? Flow.TopToBottom : Flow.LeftToRight
        layoutDirection: root.layoutDirection
        width: root.availableWidth

        // Optional uniform size for direct children
        onChildrenChanged: root._applyItemSize()
    }

    function _applyItemSize() {
        if (itemWidth < 0 && itemHeight < 0)
            return
        for (var i = 0; i < flow.children.length; ++i) {
            var ch = flow.children[i]
            if (!ch || !ch.visible)
                continue
            if (itemWidth >= 0)
                ch.width = itemWidth
            if (itemHeight >= 0)
                ch.height = itemHeight
        }
    }

    onItemWidthChanged: _applyItemSize()
    onItemHeightChanged: _applyItemSize()
    onSpacingChanged: {
        if (flow)
            _applyItemSize()
    }

    background: Item {}
}
