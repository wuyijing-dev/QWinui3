import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// SettingsToggleCard — SettingsCard with a built-in Switch action.
//
//   SettingsToggleCard {
//       title: qsTr("Dark mode")
//       description: qsTr("Use a dark appearance.")
//       symbol: FluentIcons.Brightness
//       checked: Theme.dark
//       onToggled: Theme.dark = checked
//   }
//
// @notes
//   Drops the action: Switch { … } boilerplate. Bind checked / onToggled like a Switch.

SettingsCard {
    id: root

    // Switch checked state
    property alias checked: toggle.checked
    // Mirror Switch.onToggled(checked)
    signal toggled(bool checked)

    action: Switch {
        id: toggle
        onToggled: root.toggled(checked)
    }
}
