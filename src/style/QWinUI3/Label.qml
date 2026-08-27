import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// Label — Fluent styled Label.
//
//   Label {
//       text: qsTr("Caption")
//       font.pixelSize: Theme.fontBody
//   }
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls Label.
//   Public API is the Qt Quick Controls Label type; this file supplies visuals/metrics only.

T.Label {
    id: control

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text
    color: control.enabled ? Theme.textPrimary : Theme.textDisabled
    linkColor: Theme.accent
    font: Theme.uiFontFor(Theme.fontBody)
    opacity: control.enabled ? 1 : 0.6
}
