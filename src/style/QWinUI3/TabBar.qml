import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// TabBar — Fluent styled TabBar.
//
//   TabBar {
//       TabButton { text: qsTr("Home") }
//       TabButton { text: qsTr("Settings") }
//   }

T.TabBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: 2
    contentHeight: 36
    padding: 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    contentItem: ListView {
        model: control.contentModel
        currentIndex: control.currentIndex
        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickIfNeeded
        snapMode: ListView.SnapToItem
        highlightMoveDuration: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionNormal)
        highlightResizeDuration: Theme.reducedMotion ? 0 : Theme.duration(Theme.motionNormal)
    }

    background: Rectangle {
        color: Theme.fillSubtleSecondary
        radius: Theme.cornerControl

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: Theme.strokeDivider
        }
    }
}
