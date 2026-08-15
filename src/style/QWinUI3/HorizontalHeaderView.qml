import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// HorizontalHeaderView — Fluent styled HorizontalHeaderView.
//
//   HorizontalHeaderView { }

T.HorizontalHeaderView {
    id: control
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    delegate: Rectangle {
        id: cell
        // Data model
        required property var model
        implicitWidth: 120
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
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: Theme.strokeDivider
        }

        Text {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            verticalAlignment: Text.AlignVCenter
            text: model.display ?? ""
            elide: Text.ElideRight
            color: Theme.textSecondary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            font.weight: Theme.fontWeightSemiBold
        }
    }
}
