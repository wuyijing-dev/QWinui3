# ProgressRing

Circular progress / busy ring (WinUI Minimum / Maximum / IsActive).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ProgressRing.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ProgressRing.qml)

**Category:** Status & feedback · **Library:** v1.72

[← Component index](../components.md)

**Gallery:** `ProgressRing` — [`src/gallery/pages/ProgressRingPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ProgressRingPage.qml)

**Extends** `Control`.

## Example

```qml
ProgressRing {
    id: ring
    value: 65; minimum: 0; maximum: 100
    showValue: true
    // indeterminate: true
}
```

## Notes

Circular progress; indeterminate or determinate value in [minimum, maximum] (WinUI).
Legacy 0..1 still works with default minimum=0 maximum=1. isActive pauses indeterminate spin.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value (WinUI Value) |
| `minimum` | `real` | WinUI Minimum |
| `maximum` | `real` | WinUI Maximum |
| `indeterminate` | `bool` | Show indeterminate animation when true (WinUI IsIndeterminate) |
| `isActive` | `bool` | WinUI IsActive — Active sweeps; Paused holds a partial arc without spinning |
| `isIndeterminate` | `alias` | Alias of indeterminate |
| `strokeWidth` | `real` | Stroke thickness in px |
| `fillColor` | `color` | Primary fill / progress color |
| `trackColor` | `color` | Track / remaining color |
| `showValue` | `bool` | Show numeric value label |
| `valueLabel` | `string` | Optional value caption |
| `size` | `real` | Diameter or box size in px |
| `normalized` | `real` | Normalized 0..1 progress |
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
