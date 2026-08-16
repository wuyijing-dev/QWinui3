# SettingsView

Scrollable settings page host: title, padding, auto `Layout.fillWidth` for children.

```qml
SettingsView {
    title: qsTr("Settings")
    SettingsGroup {
        title: qsTr("Appearance")
        SettingsToggleCard {
            title: qsTr("Dark mode")
            checked: Theme.dark
            onToggled: Theme.dark = checked
        }
    }
}
```

No per-child `Layout.leftMargin` / `fillWidth` needed.
