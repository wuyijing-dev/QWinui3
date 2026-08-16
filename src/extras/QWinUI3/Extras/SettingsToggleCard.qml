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

SettingsCard {
    id: root
    toggle: true

    Accessible.role: Accessible.CheckBox
    Accessible.checkable: true
    Accessible.checked: root.checked
}
