# SwipeAction

Action revealed by SwipeControl.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SwipeAction.qml`](../../src/extras/QWinUI3/Extras/SwipeAction.qml)

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
SwipeControl {
    SwipeAction {
        text: qsTr("Delete")
        symbol: FluentIcons.Delete
        onTriggered: remove()
    }
    Label { text: qsTr("Row") }
}
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `text` | `string` | Display / input text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `color` | `color` | Primary color |
| `textColor` | `color` | Badge / content text color |
| `leading` | `bool` | Leading content slot |
| `effectiveGlyph` | `string` | Resolved glyph string |

### Signals

| Signature | Description |
| --- | --- |
| `clicked()` | Emitted when clicked |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors` / `x` / `y`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
