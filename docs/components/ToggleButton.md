# ToggleButton

Checkable button with Fluent chrome.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToggleButton.qml`](../../src/extras/QWinUI3/Extras/ToggleButton.qml)

[← Component index](../components.md)

**Extends** `Button`.

## Example

```qml
ToggleButton {
    id: toggle
    text: qsTr("Bold")
    checkable: true
    onToggled: apply()
}
// --- API ---
// toggle.checked / onToggled
```

## Notes

Checkable accent-capable toggle; checked / onToggled; isThreeState cycles checkState.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `iconSize` | `real` | Icon size in px |
| `isThreeState` | `bool` | WinUI IsThreeState — cycle Unchecked → Checked → PartiallyChecked |
| `checkState` | `int` | Explicit check state (QQC Button does not expose AbstractButton.checkState in QML) |
| `effectiveIconGlyph` | `string` | Resolved glyph string |
| `lightScheme` | `bool` | True in light theme |
| `accented` | `bool` | Use accent chrome |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Button`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `flat` / `highlighted`
- `clicked()`
- `pressAndHold()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
