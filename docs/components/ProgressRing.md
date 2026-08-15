# ProgressRing

Circular progress / busy ring.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ProgressRing.qml`](../../src/extras/QWinUI3/Extras/ProgressRing.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
ProgressRing {
    id: ring
    indeterminate: true
    // value: 0.4 when determinate
}
// --- API ---
// ring.value / indeterminate
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `indeterminate` | `bool` | Show indeterminate animation when true |
| `isActive` | `bool` | WinUI-style: Active sweeps; Paused holds a partial arc without spinning |
| `strokeWidth` | `real` | Stroke thickness in px |
| `fillColor` | `color` | Primary fill / progress color |
| `trackColor` | `color` | Track / remaining color |
| `showValue` | `bool` | Show numeric value label |
| `valueLabel` | `string` | Optional value caption |
| `size` | `real` | Diameter or box size in px |
| `spinning` | `bool` | True while indeterminate ring spins |
| `progressSweep` | `real` | Determinate arc sweep degrees |
| `formattedValue` | `string` | Formatted value string |

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
