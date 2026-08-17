# MenuFlyoutHeader

Non-interactive MenuFlyout section header.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuFlyoutHeader.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MenuFlyoutHeader.qml)

**Category:** Dialogs & flyouts · **Library:** v1.74

[← Component index](../components.md)

**Extends** `MenuItem`.

## Example

```qml
MenuFlyout {
    MenuFlyoutHeader { text: qsTr("Actions") }
    MenuFlyoutItem { text: qsTr("Edit") }
}
```

## Notes

Non-interactive section header inside MenuFlyout.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `MenuItem`

Also available (base type / Qt Quick Controls):

- `text`
- `triggered()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
