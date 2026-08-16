# InfoButton

Icon button that opens a TeachingTip.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/InfoButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/InfoButton.qml)

**Category:** Buttons & commands · **Library:** v1.10

[← Component index](../components.md)

**Gallery:** `InfoButton` — [`src/gallery/pages/InfoButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/InfoButtonPage.qml)

**Extends** `IconButton`.

## Example

```qml
InfoButton {
    tipTitle: qsTr("Density")
    tipSubtitle: qsTr("Compact shrinks control metrics.")
}

// --- API ---
// tipTitle / tipSubtitle / tipSymbol, isOpen, open()/close()
// property alias tip: teachingTip
```

## Notes

Fluent Info glyph; hosts TeachingTip anchored to itself (overlay-parented). Prefer for settings help.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `tipTitle` | `string` | — |
| `tipSubtitle` | `string` | — |
| `tipSymbol` | `var` | — |
| `tip` | `alias` | — |
| `isOpen` | `alias` | — |
| `preferredPlacement` | `int` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `open()` | — |
| `close()` | — |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
