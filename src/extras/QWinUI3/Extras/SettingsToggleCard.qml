import QtQuick

// SettingsToggleCard — Convenience alias for SettingsCard { toggle: true }.
//
//   SettingsToggleCard {
//       title: qsTr("Dark mode")
//       checked: Theme.dark
//       onToggled: Theme.dark = checked
//   }
//
// Prefer SettingsCard { toggle: true } in new code.
// Accessible CheckBox + keyboard live on SettingsCard when toggle: true.

SettingsCard {
    id: root
    toggle: true
    // Accessible CheckBox + keyboard live on SettingsCard when toggle: true.
}
