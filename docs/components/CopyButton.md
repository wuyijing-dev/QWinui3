# CopyButton

Copies textToCopy and flashes a success glyph.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CopyButton.qml`](../../src/extras/QWinUI3/Extras/CopyButton.qml)

[← Component index](../components.md)

## Usage

```qml
CopyButton { textToCopy: code }
```

## Properties

- `textToCopy: string` — Clipboard payload to copy
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `idleGlyph: string` — Glyph before copy succeeds
- `doneGlyph: string` — Glyph shown after copy
- `feedbackMs: int` — Success feedback duration in ms
- `copied: bool` — Emitted after a successful copy
- `iconOnly: bool` — Hide text; show glyph only

## Signals

- `copyCompleted(string text)` — Copy Completed
- `copyFailed()` — Copy Failed

## Methods

- `copy(optionalText)` — Copy

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
