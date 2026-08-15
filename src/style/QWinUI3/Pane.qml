import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Pane — Fluent styled Pane.
//
//   Pane {
//       padding: Theme.paddingControlH
//       Label { text: qsTr("Pane body") }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Pane.
//   Public API is the Qt Quick Controls Pane type; this file supplies visuals/metrics only.

T.Pane {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Theme.spacingLoose
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerCard
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 2
        shadowOpacity: Theme.dark ? 0.22 : 0.08
    }
}
