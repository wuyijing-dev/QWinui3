# CheckBox

Fluent / WinUI 3 CheckBox with optional description and three-state (select-all) support.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/CheckBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/CheckBox.qml)

**Category:** Styled controls · **Library:** v3.18

[← Component index](../components.md)

**Gallery:** `CheckBox` — [`src/gallery/pages/CheckBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CheckBoxPage.qml)

## Example

```qml
CheckBox {
    text: qsTr("Send diagnostic data")
    description: qsTr("Helps improve reliability.")
    checked: true
}

CheckBox {
    text: qsTr("Select all")
    isThreeState: true   // alias of tristate
    checkState: Qt.PartiallyChecked
}
```

## QWinUI3 properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `description` | `string` | `""` | Caption under the label |
| `header` | alias | | Alias of Qt `text` |
| `isThreeState` | alias | | Alias of Qt `tristate` (WinUI IsThreeState) |

## Inherited from Qt `CheckBox`

- `text` · `checked` · `checkState` · `tristate`
- `toggled()` · `clicked()`

## Notes

Indicator aligns to the first text line when a description is present. Honors `Theme.reducedMotion` on check / indeterminate animations.

---
*Updated for 3.18 description / isThreeState.*
