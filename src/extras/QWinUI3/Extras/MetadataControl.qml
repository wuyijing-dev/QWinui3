import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// MetadataControl — Stacked or flowed label/value metadata block.
//
//   MetadataControl {
//       id: metadataControl
//       MetadataItem { label: qsTr("Author"); value: "Ada" }
//   }
//
//   // --- API ---
//   // methods: syncChildren()
//   // metadataControl.syncChildren()
//
// @notes
//   Host for MetadataItem rows (label/value pairs).

T.Control {
    id: root

    // Item list / children model
    default property alias items: host.data
    // Qt.Horizontal or Qt.Vertical
    property int orientation: Qt.Vertical
    // Spacing between items
    property real itemSpacing: orientation === Qt.Horizontal
            ? Theme.spacingSection : Theme.spacingLoose
    // Header label above the control
    property string header: ""
    // Edge paddings
    property int paddingEdges: 0

    padding: paddingEdges
    implicitWidth: Math.max(120, Math.max(headerLabel.implicitWidth, host.implicitWidth) + leftPadding + rightPadding)
    implicitHeight: (header.length ? headerLabel.implicitHeight + 8 : 0)
                    + host.implicitHeight + topPadding + bottomPadding
    clip: false
    Accessible.role: Accessible.Grouping
    Accessible.name: header.length ? header : qsTr("Metadata")

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

    // Synchronize child item state
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
