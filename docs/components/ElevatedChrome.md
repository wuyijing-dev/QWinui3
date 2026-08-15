# ElevatedChrome

Shared elevated shadow/border chrome.

`import QWinUI3.Theme` · [`src/theme/QWinUI3/Theme/ElevatedChrome.qml`](../../src/theme/QWinUI3/Theme/ElevatedChrome.qml)

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `Item`.

## Example

```qml
ElevatedChrome { anchors.fill: parent }
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `color` | `color` | Primary color |
| `radius` | `real` | Corner radius |
| `borderColor` | `color` | Border color |
| `borderWidth` | `int` | Border width in px |
| `elevated` | `bool` | Use elevated chrome |
| `elevation` | `real` | Elevation level |
| `shadowOpacity` | `real` | Shadow opacity |
| `shadowBlur` | `real` | Shadow blur radius |
| `blurMax` | `int` | Maximum blur radius |
| `antialiasing` | `alias` | Enable antialiased drawing |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors` / `x` / `y`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
