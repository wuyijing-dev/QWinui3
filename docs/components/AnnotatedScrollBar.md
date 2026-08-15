# AnnotatedScrollBar

Scroll area with a value label on the vertical scrollbar.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AnnotatedScrollBar.qml`](../../src/extras/QWinUI3/Extras/AnnotatedScrollBar.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
AnnotatedScrollBar {
    // flickable children…
}
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `contentData` | `alias` | Default children / content slot |
| `contentWidth` | `alias` | Flickable content width |
| `contentHeight` | `alias` | Flickable content height |
| `contentX` | `alias` | Flickable content X |
| `contentY` | `alias` | Flickable content Y |
| `flickable` | `alias` | Inner Flickable |
| `labels` | `var` | Optional map from scroll position (0..1) → label. Empty → percentage. |
| `labelFormat` | `string` | Format string / function for scrollbar label |
| `alwaysShowLabel` | `bool` | Keep scrollbar label visible |
| `scrollPosition` | `real` | Normalized scroll position |
| `currentLabel` | `string` | Label for the current value |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
