# InfoBadge

Count / status / glyph badge.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/InfoBadge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/InfoBadge.qml)

**Category:** Status & feedback · **Library:** v1.80

[← Component index](../components.md)

**Gallery:** `InfoBadge` — [`src/gallery/pages/InfoBadgePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/InfoBadgePage.qml)

**Extends** `Control`.

## Example

```qml
InfoBadge {
    id: infoBadge
    value: 3; severity: informational
}

// --- API ---
// methods: setSeverityName(name), bump()
// infoBadge.setSeverityName(name)
// infoBadge.bump()
```

## Notes

Dot / value / glyph badge; severity styles the fill; value < 0 may hide digits.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `informational` | `int` | Informational severity constant |
| `success` | `int` | Success severity constant |
| `warning` | `int` | Warning severity constant |
| `error` | `int` | Error severity constant |
| `attention` | `int` | Attention severity constant |
| `neutral` | `int` | Neutral severity constant |
| `severity` | `int` | informational \| success \| warning \| error \| attention \| neutral |
| `value` | `int` | Numeric count; shown when text/symbol are empty (clamped by maxValue) |
| `text` | `string` | Explicit badge label (wins over value) |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `maxValue` | `int` | Clamp / overflow threshold for counts |
| `badgeColor` | `color` | Badge fill color |
| `textColor` | `color` | Badge / content text color |
| `severityName` | `string` | Severity as string name |
| `effectiveIconGlyph` | `string` | Resolved glyph string |
| `dot` | `bool` | Dot / pip indicator |
| `hideWhenEmpty` | `bool` | Hide when value/text empty |
| `displayText` | `string` | Text shown to the user |
| `isEmpty` | `bool` | True when there is no data |
| `isOpen` | `bool` | Open / visible state |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setSeverityName(name)` | Set severity from a string name |
| `bump()` | Nudge value by one step |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
