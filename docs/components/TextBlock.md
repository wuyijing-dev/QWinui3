# TextBlock

Fluent typography styles (title, body, caption…).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TextBlock.qml`](../../src/extras/QWinUI3/Extras/TextBlock.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
TextBlock {
    id: textBlock
    text: qsTr("Title"); style: title
}

// --- API ---
// methods: setStyleName(name)
// textBlock.setStyleName(name)
```

## Notes

Themed text helper (style/weight tokens); prefer for Fluent type ramps.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `caption` | `int` | Caption under / beside the value |
| `body` | `int` | Body style |
| `bodyStrong` | `int` | Body strong style |
| `subtitle` | `int` | Secondary subtitle text |
| `title` | `int` | Primary title text |
| `titleLarge` | `int` | Title large style |
| `display` | `int` | Display typography style |
| `text` | `string` | Display / input text |
| `style` | `int` | Typography style token |
| `isTextSelectionEnabled` | `bool` | WinUI IsTextSelectionEnabled — uses TextEdit when true (Label has no selectByMouse) |
| `textTrimming` | `string` | none \| characterEllipsis \| wordEllipsis |
| `maxLines` | `int` | Maximum wrapped line count |
| `color` | `color` | Primary color |
| `styleName` | `string` | Current style name |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setStyleName(name)` | Set style by name |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
