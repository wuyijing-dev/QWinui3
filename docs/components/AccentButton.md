# AccentButton

Accent-colored CTA with optional Fluent symbol (2.66 A1 appearances).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AccentButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AccentButton.qml)

**Category:** Buttons & commands · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `AccentButton` — [`src/gallery/pages/AccentButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AccentButtonPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Button`.

## Example

```qml
AccentButton {
    id: saveBtn
    text: qsTr("Save")
    symbol: FluentIcons.Save
    appearance: "filled"   // filled | subtle | outline | ghost
    onClicked: save()
}
```

## Notes

Prefer symbol: FluentIcons.* over iconGlyph. Default appearance is filled (solid accent).
Inherits Button appearance API (2.66 A1).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `iconSize` | `real` | Icon size in px |
| `effectiveIconGlyph` | `string` | Resolved glyph string |
| `lightScheme` | `bool` | True in light theme |

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

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
