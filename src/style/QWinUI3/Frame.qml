import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Frame — Fluent styled Frame.
//
//   Frame {
//       id: frame
//       Label { text: qsTr("Framed content") }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Frame.
//   Must declare implicitWidth/Height like Basic — otherwise Layout hosts collapse
//   to ~0 and children paint over siblings (e.g. Gallery “Source code”).

T.Frame {
    id: control


    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Frame")
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Theme.spacingLoose
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerOverlay
        border.width: 1
        border.color: Theme.strokeCard
        // Give empty frames a stable minimum so they are visible in Layouts.
        implicitWidth: 120
        implicitHeight: 40
    }
}
