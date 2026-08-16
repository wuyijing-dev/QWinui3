import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ItemsRepeater — Thin WinUI-style virtualizing repeater over ListView.
//
//   ItemsRepeater {
//       model: bigModel
//       orientation: Qt.Vertical
//       delegate: ListTile { title: model.title }
//   }
//
//   // --- API ---
//   // properties: model, delegate, orientation, spacing, cacheBuffer
//   // aliases: contentX/Y, count, currentIndex
//
// @notes
//   Prefer this for large models; ItemsView adds selection / EmptyState recipe on top.

T.Control {
    id: root

    // List / array / QAbstractItemModel
    property alias model: list.model
    // Item delegate component
    property alias delegate: list.delegate
    // Qt.Vertical or Qt.Horizontal
    property alias orientation: list.orientation
    // Spacing between items
    property alias spacing: list.spacing
    // Extra cache outside the viewport
    property alias cacheBuffer: list.cacheBuffer
    // Current index
    property alias currentIndex: list.currentIndex
    // Item count
    readonly property alias count: list.count
    property alias contentX: list.contentX
    property alias contentY: list.contentY
    property alias contentWidth: list.contentWidth
    property alias contentHeight: list.contentHeight

    // Emitted when an item is clicked (if delegate forwards)
    signal itemClicked(int index)

    implicitWidth: 280
    implicitHeight: 200
    padding: 0
    clip: true

    contentItem: ListView {
        id: list
        anchors.fill: parent
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        spacing: 0
        cacheBuffer: Theme.navItemHeight * 8
        ScrollBar.vertical: ScrollBar {
            policy: list.orientation === Qt.Vertical ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
        }
        ScrollBar.horizontal: ScrollBar {
            policy: list.orientation === Qt.Horizontal ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
        }
        highlightMoveDuration: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionFast)
    }

    background: Item {}
}
