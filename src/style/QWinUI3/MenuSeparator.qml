import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// MenuSeparator — Fluent styled MenuSeparator.
//
//   Menu {
//       MenuItem { text: qsTr("A") }
//       MenuSeparator { }
//       MenuItem { text: qsTr("B") }
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls MenuSeparator.
//   Public API is the Qt Quick Controls MenuSeparator type; this file supplies visuals/metrics only.

T.MenuSeparator {
    id: control

    Accessible.role: Accessible.Separator
    Accessible.name: qsTr("Separator")

    implicitWidth: 180
    implicitHeight: 9
    padding: 4
    leftPadding: 12
    rightPadding: 12

    contentItem: Rectangle {
        implicitHeight: 1
        color: Theme.strokeDivider
        opacity: 0.9
    }
}
