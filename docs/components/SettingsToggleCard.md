# SettingsToggleCard

Thin alias for `SettingsCard { toggle: true }`. Prefer the latter in new code.

```qml
SettingsCard {
    title: qsTr("Dark mode")
    toggle: true
    checked: Theme.dark
    onToggled: Theme.dark = checked
}
```
