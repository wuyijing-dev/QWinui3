# EntranceThemeTransition

WinUI-style page / section entrance (fade + rise + scale).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/EntranceThemeTransition.qml`](../../src/extras/QWinUI3/Extras/EntranceThemeTransition.qml)

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
EntranceThemeTransition {
    anchors.fill: parent
    Label { text: "Hello" }
}

// --- API ---
// methods: play(), reset()
// properties: running, offsetY, fromScale
```

## Notes

Prefer Theme.duration / reducedMotion. Attach to CatalogPage body or cards.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `content` | `alias` | — |
| `offsetY` | `real` | Vertical offset at start (px) |
| `fromScale` | `real` | Scale at start |
| `autoPlay` | `bool` | Play automatically when completed / made visible |
| `running` | `bool` | True while the enter animation is running |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `play()` | Run the entrance once |
| `reset()` | Jump to the pre-enter pose |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors` / `x` / `y`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
