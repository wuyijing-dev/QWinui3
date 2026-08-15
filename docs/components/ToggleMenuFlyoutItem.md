# ToggleMenuFlyoutItem

Checkable MenuFlyout item.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToggleMenuFlyoutItem.qml`](../../src/extras/QWinUI3/Extras/ToggleMenuFlyoutItem.qml)

[← Component index](../components.md)

**Extends** `MenuItem`.

## Example

```qml
MenuFlyout {
    ToggleMenuFlyoutItem {
        id: wrap
        text: qsTr("Word wrap")
        checked: true
        onToggled: applyWrap(wrap.checked)
    }
}
// --- API ---
// wrap.checked / onToggled / text
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `keyboardAcceleratorText` | `string` | Accelerator caption (Ctrl+C) |
| `keyVisualAccelerator` | `bool` | Show KeyVisual for accelerator |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `MenuItem`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `triggered()`
- `checkable` / `checked`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
