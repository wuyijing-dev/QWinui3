# RichEdit

Fluent rich-text editor for mail / template / long notes (2.61).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RichEdit.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RichEdit.qml)

**Category:** Other · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `RichEdit` — [`src/gallery/pages/RichEditPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RichEditPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
RichEdit {
    id: body
    placeholderText: qsTr("Write your message…")
    onLinkActivated: (url) => Qt.openUrlExternally(url)
}
body.toggleBold()
body.insertLink("https://example.com")
```

## Notes

Experimental — basic HTML formatting (bold/italic/lists/links), paste sanitization,
IME-friendly TextEdit (FL-005). Not a Word-compatible engine. See docs/rich-edit-261.md.
The editor pane is a fixed viewport (ScrollView); it does not grow with contentHeight.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `text` | `alias` | — |
| `plainText` | `string` | — |
| `placeholderText` | `string` | — |
| `readOnly` | `bool` | — |
| `showToolbar` | `bool` | — |
| `sanitizePaste` | `bool` | — |
| `header` | `string` | — |
| `description` | `string` | — |
| `accessibleName` | `string` | — |

### Signals

| Signature | Description |
| --- | --- |
| `textEdited()` | — |
| `linkActivated(string url)` | — |
| `formattingChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `focusEditor()` | — |
| `clear()` | — |
| `wrapSelection(openTag, closeTag)` | — |
| `toggleBold()` | — |
| `toggleItalic()` | — |
| `insertUnorderedList()` | — |
| `insertLink(url)` | — |
| `insertTable(rows, cols)` | Insert a simple HTML table (2.69 D6) |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
