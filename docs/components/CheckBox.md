# CheckBox

Fluent / WinUI 3 CheckBox (description, three-state).

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/CheckBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/CheckBox.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `CheckBox` — [`src/gallery/pages/CheckBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CheckBoxPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
CheckBox {
    text: qsTr("Remember me")
    description: qsTr("Stay signed in on this device.")
    checked: true
}

CheckBox {
    text: qsTr("Select all")
    tristate: true   // or isThreeState: true
    checkState: Qt.PartiallyChecked
}
```

## Notes

Fluent chrome with optional description caption. isThreeState aliases Qt tristate.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `description` | `string` | Supporting caption under the label (Fluent settings pattern) |
| `header` | `alias` | WinUI Header alias of text |
| `isThreeState` | `alias` | WinUI IsThreeState alias of tristate |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
