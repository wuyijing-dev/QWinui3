# AcrylicSurface

Frosted pane; keep translucent under system Mica/Acrylic.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AcrylicSurface.qml`](../../src/extras/QWinUI3/Extras/AcrylicSurface.qml)

[← Component index](../components.md)

**Extends** `Pane`.

## Example

```qml
AcrylicSurface {
    elevated: true
    // children…
}
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `elevated` | `bool` | Stronger elevation / card tint |
| `bordered` | `bool` | Draw a border when true |
| `showLuminantEdge` | `bool` | Show luminant edge highlight |
| `cornerRadius` | `real` | Corner radius |
| `tintColor` | `color` | Tint overlay color |
| `frostOpacity` | `real` | Frost overlay opacity |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Pane`

Also available (base type / Qt Quick Controls):

- `padding`
- `background`
- `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
