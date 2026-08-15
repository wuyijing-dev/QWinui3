import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Page — Fluent styled Page.
//
//   Page {
//       header: Label { text: qsTr("Title"); leftPadding: 16; topPadding: 12 }
//       Label { anchors.centerIn: parent; text: qsTr("Content") }
//   }

T.Page {
    id: control
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: Rectangle {
        color: Theme.bgLayer
    }
}
