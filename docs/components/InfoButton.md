# InfoButton

Icon button that opens a TeachingTip.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/InfoButton.qml`](../../src/extras/QWinUI3/Extras/InfoButton.qml)

[← Component index](../components.md)

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

Fluent Info glyph; hosts TeachingTip anchored to itself. Prefer for settings help.

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
