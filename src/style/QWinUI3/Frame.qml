import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Frame — Fluent styled Frame.
//
//   Frame {
//       id: frame
//       padding: Theme.paddingControlH
//       Label { text: qsTr("Framed content") }
//   }
//   // --- API ---
//   // inherits Frame/Pane: padding, background, contentItem
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Frame.
//   Public API is the Qt Quick Controls Frame type; this file supplies visuals/metrics only.

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
