# SettingsToggleCard

Thin alias for `SettingsCard { toggle: true }`. Prefer the latter in new code.

Gallery **SettingsGroup** page and `examples/settings-cards` demonstrate the
toggle API end-to-end.

```qml
SettingsCard {
    title: qsTr("Dark mode")
    toggle: true
    checked: Theme.dark
    onToggled: Theme.dark = checked
}
```

See also [`SettingsCard.md`](SettingsCard.md), [`SettingsView.md`](SettingsView.md).
