# Button

Fluent / WinUI 3 Button (appearances, icon, loading).

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Button.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Button.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `Button` — [`src/gallery/pages/ButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ButtonPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
Button {
    text: qsTr("Save")
    leadingSymbol: FluentIcons.Save
    appearance: "filled"   // filled | subtle | outline | ghost
    onClicked: save()
}

Button {
    text: qsTr("Submit")
    loading: true
}
```

## Notes

Appearances + optional leading Fluent icon. loading shows BusyIndicator and blocks click.
Accent chrome: highlighted: true (or AccentButton).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `loading` | `bool` | Async action in flight — disables click and shows inline ring |
| `appearance` | `string` | Visual variant: filled \| subtle \| outline \| ghost \| "" (legacy) |
| `leadingSymbol` | `var` | Leading FluentIcons symbol (preferred) or raw glyph |
| `leadingGlyph` | `string` | — |
| `preserveWidthWhileLoading` | `bool` | Keep width stable while loading (avoids toolbar reflow) |
| `accented` | `bool` | Use accent chrome |
| `lightScheme` | `bool` | True in light theme |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
