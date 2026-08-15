import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Label — Fluent styled Label.
//
//   Label {
//       text: qsTr("Caption")
//       font.pixelSize: Theme.fontBody
//   }

T.Label {
    id: control
    color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    linkColor: Theme.accent
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    opacity: control.enabled ? 1 : 0.6
}
