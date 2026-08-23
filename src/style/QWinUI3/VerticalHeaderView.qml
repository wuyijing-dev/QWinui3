import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// VerticalHeaderView — Fluent styled VerticalHeaderView.
//
//   TableView {
//       id: table
//   }
//   VerticalHeaderView {
//       id: vheader
//       syncView: table
//       clip: true
//   }
//   // --- API ---
//   // vheader.syncView / model / clip
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls VerticalHeaderView.
//   Public API is the Qt Quick Controls VerticalHeaderView type; this file supplies visuals/metrics only.

T.VerticalHeaderView {
    id: control

    Accessible.role: Accessible.RowHeader
    Accessible.name: qsTr("Row header")

    clip: true
    boundsBehavior: Flickable.StopAtBounds

    implicitWidth: Math.max(1, contentWidth)
    implicitHeight: syncView ? syncView.height : 0

    delegate: Rectangle {
        id: cell
        // Data model
        required property var model
        implicitWidth: Math.max(48, textItem.implicitWidth + 24)
        implicitHeight: Theme.navItemHeight
        color: cellHover.hovered ? Theme.fillSubtleSecondary : Theme.bgAcrylic

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        HoverHandler { id: cellHover }

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: 1
            color: Theme.strokeDivider
        }

        Text {
            id: textItem
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: model.display ?? ""
            elide: Text.ElideRight
            color: Theme.textSecondary
            font.pixelSize: Theme.fontCaption
            font.weight: Theme.fontWeightSemiBold
        }
    }
}
