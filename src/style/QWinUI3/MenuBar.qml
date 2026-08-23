import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// MenuBar — Fluent styled MenuBar.
//
//   ApplicationWindow {
//       menuBar: MenuBar {
//           Menu {
//               title: qsTr("File")
//               MenuItem { text: qsTr("Exit") }
//           }
//       }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls MenuBar.
//   Public API is the Qt Quick Controls MenuBar type; this file supplies visuals/metrics only.

T.MenuBar {
    id: control

    Accessible.role: Accessible.MenuBar
    Accessible.name: qsTr("Menu bar")

    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding

    spacing: 2
    padding: 4
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
