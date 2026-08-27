# RadioButton

Fluent / WinUI 3 RadioButton with optional description caption.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RadioButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/RadioButton.qml)

**Category:** Styled controls · **Library:** v3.18

[← Component index](../components.md)

**Gallery:** `RadioButton` — [`src/gallery/pages/RadioButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RadioButtonPage.qml)

## Example

```qml
ButtonGroup { id: powerGroup }
RadioButton {
    text: qsTr("Balanced")
    description: qsTr("Good default for most PCs.")
    checked: true
    ButtonGroup.group: powerGroup
}
```

## QWinUI3 properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `description` | `string` | `""` | Caption under the label |
| `header` | alias | | Alias of Qt `text` |

## Inherited from Qt `RadioButton`

- `text` · `checked` · `ButtonGroup.group`
- `toggled()` · `clicked()`

## Notes

Group exclusive selection with **ButtonGroup**, or use model-driven **RadioButtons** (`header` / `model` / `selectedIndex`) for WinUI-style option lists. Indicator aligns to the first text line when a description is present.

---
*Updated for 3.18 description.*
