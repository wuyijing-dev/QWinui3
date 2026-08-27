# ComboBox

Fluent / WinUI 3 ComboBox (Header, editable, ShowError chrome).

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ComboBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ComboBox.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `ComboBox` — [`src/gallery/pages/ComboBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ComboBoxPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
ComboBox {
    header: qsTr("Color")
    model: ["Red", "Green", "Blue"]
    onActivated: (index) => apply(index)
}
```

## Notes

Header / description / errorMessage around the field; filled | outline appearance.
editable uses an inline TextInput. FormLayout left headers: HeaderedComboBox.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `header` | `string` | WinUI Header — label above the field |
| `description` | `string` | Supporting caption under the header (hidden while errorMessage is set) |
| `errorMessage` | `string` | Validation message — critical caption; also paints error chrome |
| `hasError` | `bool` | Form validation error flag (also treated as error when errorMessage is set) |
| `appearance` | `string` | Visual variant: filled \| outline \| "" (filled default) |
| `lightScheme` | `bool` | True in light theme (legacy) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
