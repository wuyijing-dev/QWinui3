# CopyButton

Copies textToCopy and flashes a success glyph.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CopyButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CopyButton.qml)

**Category:** Buttons & commands · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `CopyButton` — [`src/gallery/pages/CopyButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CopyButtonPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `AbstractButton`.

## Example

```qml
CopyButton {
    id: copyButton
    textToCopy: code
    onCopyCompleted: (text) => { /* … */ }
    onCopyFailed: { /* … */ }
}

// --- API ---
// signals: onCopyCompleted, onCopyFailed
// methods: copy(optionalText)
// copyButton.copy()
// copyButton.copy("override text")
// inherits AbstractButton (+ text, enabled, clicked, …)
```

## Notes

Copies textToCopy (or copy(text)); flashes doneGlyph; copyCompleted/copyFailed.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `textToCopy` | `string` | Clipboard payload to copy |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `idleGlyph` | `string` | Glyph before copy succeeds |
| `doneGlyph` | `string` | Glyph shown after copy |
| `feedbackMs` | `int` | Success feedback duration in ms |
| `copied` | `bool` | Emitted after a successful copy |
| `iconOnly` | `bool` | Hide text; show glyph only |

### Signals

| Signature | Description |
| --- | --- |
| `copyCompleted(string text)` | Emitted after a successful copy |
| `copyFailed()` | Emitted when copy fails |

### Methods

| Signature | Description |
| --- | --- |
| `copy(optionalText)` | Copy to clipboard |

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
