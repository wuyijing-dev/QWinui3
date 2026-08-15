import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// WrapPanel — Flow / wrap layout.
//
//   WrapPanel {
//       Repeater { model: 8; Chip { text: modelData } }
//   }

T.Control {
    id: root

    // Default children / content slot
    default property alias contentData: flow.data
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Horizontal
    // Item Width
    property real itemWidth: -1
    // Item Height
    property real itemHeight: -1
    // Edge paddings
    property int paddingEdges: 0
    // Qt layout direction
    property int layoutDirection: Qt.LeftToRight

    padding: paddingEdges
    spacing: Theme.spacing
    implicitWidth: Math.max(100, flow.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight, flow.implicitHeight + topPadding + bottomPadding)
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Wrap panel")

    // Number of children
    readonly property int childCount: {
        var n = 0
        for (var i = 0; i < flow.children.length; ++i) {
            if (flow.children[i] && flow.children[i].visible)
                ++n
        }
        return n
    }

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
