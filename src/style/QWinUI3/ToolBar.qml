import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// ToolBar — Fluent styled ToolBar.
//
//   ToolBar {
//       Row {
//           ToolButton { text: qsTr("Back") }
//           ToolSeparator { }
//           ToolButton { text: qsTr("Forward") }
//       }
//   }

T.ToolBar {
    id: control
    implicitHeight: 48
    padding: 4
    spacing: Theme.spacing
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: Rectangle {
        color: Theme.bgAcrylic
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: Theme.dark ? "#12FFFFFF" : "#0F000000"
            opacity: 0.6
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
