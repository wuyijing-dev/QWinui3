# SettingsToggleCard

`SettingsCard` with a built-in `Switch` — no `action: Switch { … }` glue.

```qml
SettingsToggleCard {
    title: qsTr("Dark mode")
    checked: Theme.dark
    onToggled: Theme.dark = checked
}
```
