import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

T.MenuBar {
    id: control

    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding

    spacing: 2
    padding: 4
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    delegate: MenuBarItem {}

    contentItem: Row {
        spacing: control.spacing
        Repeater {
            model: control.contentModel
        }
    }

    background: Rectangle {
        color: Theme.bgAcrylic
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: Theme.dark ? "#12FFFFFF" : "#0F000000"
            opacity: 0.55
        }
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: Theme.strokeDivider
        }
    }
}
