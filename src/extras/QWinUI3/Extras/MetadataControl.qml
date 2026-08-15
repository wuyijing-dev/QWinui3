import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// WinUI-style metadata block: stacked or flowed label/value pairs.
T.Control {
    id: root

    default property alias items: host.data
    property int orientation: Qt.Vertical
    property real itemSpacing: orientation === Qt.Horizontal
            ? Theme.spacingSection : Theme.spacingLoose
    property string header: ""
    property int paddingEdges: 0

    padding: paddingEdges
    implicitWidth: Math.max(120, Math.max(headerLabel.implicitWidth, host.implicitWidth) + leftPadding + rightPadding)
    implicitHeight: (header.length ? headerLabel.implicitHeight + 8 : 0)
                    + host.implicitHeight + topPadding + bottomPadding
    clip: false

    contentItem: Column {
        spacing: 8

        Text {
            id: headerLabel
            visible: root.header.length > 0
            width: parent.width
            text: root.header
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: root.enabled ? Theme.textPrimary : Theme.textDisabled
        }

        // Always LeftToRight. Vertical mode forces each child to full width so
        // items stack as rows (TopToBottom would wrap into columns when height is tight).
        Flow {
            id: host
            width: root.availableWidth > 0 ? root.availableWidth : implicitWidth
            spacing: root.itemSpacing
            flow: Flow.LeftToRight
            onChildrenChanged: Qt.callLater(root.syncChildren)
            onWidthChanged: Qt.callLater(root.syncChildren)
        }
    }

    background: Item {}

    onOrientationChanged: Qt.callLater(syncChildren)
    Component.onCompleted: Qt.callLater(syncChildren)

    function syncChildren() {
        var full = root.orientation === Qt.Vertical
        for (var i = 0; i < host.children.length; ++i) {
            var ch = host.children[i]
            if (!ch)
                continue
            if (ch.orientation !== undefined)
                ch.orientation = root.orientation
            if (full && host.width > 0)
                ch.width = host.width
            else if (!full)
                ch.width = ch.implicitWidth
        }
    }
}
