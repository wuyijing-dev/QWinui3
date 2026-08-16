import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// SwipeView — Fluent styled SwipeView.
//
//   SwipeView {
//       id: pages
//       anchors.fill: parent
//       Item { Label { text: "1" } }
//       Item { Label { text: "2" } }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls SwipeView.
//   Public API is the Qt Quick Controls SwipeView type; this file supplies visuals/metrics only.

T.SwipeView {
    id: control

    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Swipe view")
    Accessible.description: qsTr("Page %1 of %2").arg(control.currentIndex + 1).arg(control.count)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: 0
    padding: 0

    contentItem: ListView {
        model: control.contentModel
        implicitWidth: control.contentWidth
        implicitHeight: control.contentHeight
        currentIndex: control.currentIndex
        orientation: control.orientation
        spacing: control.spacing
        snapMode: ListView.SnapOneItem
        boundsBehavior: Flickable.StopAtBounds
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: 0
        highlightMoveDuration: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionSlow)
        clip: true
    }

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
