# ContentCard

Surface card with title, subtitle, symbol, and body slot.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ContentCard.qml)

**Category:** Layout · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `ContentCard` — [`src/gallery/pages/ContentCardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ContentCardPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

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

## Notes

Surface card with title/subtitle/symbol and body slot.

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
| `cornerRadius` | `real` | Card corner radius (binds ElevatedChrome) |
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
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
