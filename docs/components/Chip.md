# Chip

Compact selectable tag; optional close affordance.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Chip.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Chip.qml)

**Category:** Collections & data · **Library:** v1.80

[← Component index](../components.md)

**Gallery:** `Chip` — [`src/gallery/pages/ChipPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ChipPage.qml)

**Extends** `AbstractButton`.

## Example

```qml
Chip {
    text: qsTr("Tag")
    closable: true
    onCloseClicked: remove()
}

// --- API ---
// signals: onCloseClicked
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## Notes

Compact tag; closable emits closeClicked; appearance filled|outline; iconPlacement.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `closable` | `bool` | Shows a trailing close affordance |
| `isCloseButtonVisible` | `alias` | Alias of closable |
| `highlighted` | `bool` | Emphasized / selected chrome |
| `flat` | `bool` | Flat chrome without fill |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `avatarText` | `string` | Initials / short avatar text instead of an icon |
| `appearance` | `string` | filled \| outline |
| `chipSize` | `string` | small \| medium |
| `iconPlacement` | `string` | WinUI IconPlacement: left \| right |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

| Signature | Description |
| --- | --- |
| `closeClicked()` | Fired when the close glyph is clicked (does not uncheck) |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
