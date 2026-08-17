# TextBlock

Fluent typography styles (title, body, caption…).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TextBlock.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TextBlock.qml)

**Category:** Input & forms · **Library:** v2.60

[← Component index](../components.md)

**Gallery:** `TextBlock` — [`src/gallery/pages/TextBlockPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TextBlockPage.qml)

**Extends** `Control`.

## Example

```qml
TextBlock {
    id: textBlock
    text: qsTr("Title"); style: title
    textWrapping: "wrap"              // WinUI TextWrapping
    textTrimming: "characterEllipsis" // WinUI TextTrimming
    maxLines: 2                       // WinUI MaxLines
}

// --- API ---
// methods: setStyleName(name)
// textBlock.setStyleName(name)
```

## Notes

Themed text helper (style/weight tokens); prefer for Fluent type ramps.
Long text: bind width (or Layout.fillWidth) then use textWrapping /
textTrimming / maxLines like WinUI TextBlock.

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
| `textWrapping` | `string` | WinUI TextWrapping: wrap \| noWrap \| wrapWholeWords |
| `textTrimming` | `string` | WinUI TextTrimming: none \| characterEllipsis \| wordEllipsis |
| `maxLines` | `int` | WinUI MaxLines — 0 = unlimited; with trimming, elides after N lines |
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
