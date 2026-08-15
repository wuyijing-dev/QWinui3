import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Frame — Fluent styled Frame.
//
//   Frame {
//       Label { text: qsTr("Framed content") }
//   }

T.Frame {
    id: control
    padding: Theme.spacing
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: Rectangle {
        color: Theme.bgAcrylic
        radius: Theme.cornerOverlay
        border.width: 1
        border.color: Theme.strokeCard
    }
}
