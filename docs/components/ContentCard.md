# ContentCard

Surface card with title, subtitle, symbol, and body slot.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentCard.qml`](../../src/extras/QWinUI3/Extras/ContentCard.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
ContentCard {
    title: qsTr("Card")
    Label { text: qsTr("Body") }
}

// --- API ---
// signals: onClicked
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `headerIcon` | `string` | Header icon glyph |
| `footer` | `alias` | Footer text |
| `isClickable` | `bool` | Emit clicked when activated |
| `contentData` | `alias` | Default children / content slot |
| `effectiveHeaderIcon` | `string` | Resolved header icon |

### Signals

| Signature | Description |
| --- | --- |
| `clicked()` | Emitted when clicked |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
