# SettingsView

Scrollable settings page host: title, subtitle, page padding. Children that declare
`Layout.fillWidth` (SettingsCard, SettingsGroup, DetailRow, …) stretch automatically.

```qml
SettingsView {
    title: qsTr("Settings")
    SettingsGroup {
        title: qsTr("Appearance")
        SettingsCard {
            title: qsTr("Dark mode")
            toggle: true
            checked: Theme.dark
            onToggled: Theme.dark = checked
        }
    }
}
```
