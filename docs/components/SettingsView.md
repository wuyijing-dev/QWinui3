# SettingsView

Scrollable settings host (title + padded column).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SettingsView.qml)

**Category:** Layout · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

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

## Notes

Owns ScrollView, page title, and horizontal padding. Put SettingsGroup /
SettingsCard / DetailRow as children — no Layout margins / fillWidth needed.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Page title (hidden when empty) |
| `subtitle` | `string` | Optional subtitle under the title |
| `pagePadding` | `real` | Horizontal / vertical padding for the content column |
| `sectionSpacing` | `real` | Vertical spacing between groups |
| `contentData` | `alias` | Default children (settings groups / cards) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
