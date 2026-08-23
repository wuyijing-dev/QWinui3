# AcrylicSurface

Frosted pane; keep translucent under system Mica/Acrylic.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AcrylicSurface.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AcrylicSurface.qml)

**Category:** Layout · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `AcrylicSurface` — [`src/gallery/pages/AcrylicSurfacePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AcrylicSurfacePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Pane`.

## Example

```qml
AcrylicSurface {
    id: pane
    anchors.fill: parent
    elevated: true
    tintOpacity: 0.8
    Label { anchors.centerIn: parent; text: qsTr("Frosted") }
}
// --- API ---
// pane.elevated / tintOpacity
// children fill the acrylic surface
```

## Notes

Frosted pane for content; keep translucent under system Mica/Acrylic backdrops.
elevated / tintOpacity tune the material; children fill the surface.

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

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
