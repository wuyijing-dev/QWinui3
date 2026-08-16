import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Page — Fluent styled Page.
//
//   Page {
//       header: Label { text: qsTr("Title"); leftPadding: 16; topPadding: 12 }
//       Label { anchors.centerIn: parent; text: qsTr("Content") }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Page.
//   Public API is the Qt Quick Controls Page type; this file supplies visuals/metrics only.

T.Page {
    id: control

    Accessible.role: Accessible.Pane
    Accessible.name: control.title.length ? control.title : qsTr("Page")

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: Rectangle {
        color: Theme.bgLayer
    }
}
