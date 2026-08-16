# KpiTile

Compact dashboard KPI tile with optional delta and spark trend.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/KpiTile.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/KpiTile.qml)

**Category:** Charts & gauges · **Library:** v1.19

[← Component index](../components.md)

**Gallery:** `KpiTile` — [`src/gallery/pages/KpiTilePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/KpiTilePage.qml)

**Extends** `Control`.

## Example

```qml
KpiTile {
    id: kpi
    title: qsTr("Latency")
    value: 42
    unit: " ms"
    delta: -3.2
    deltaUnit: "%"
    trendValues: [48, 44, 46, 42, 40, 43, 42]
    cautionThreshold: 60
    criticalThreshold: 80
    invertThresholds: true
    badgeText: qsTr("p95")
    symbol: FluentIcons.Clock
}

// --- API ---
// signals: onClicked
// methods: setValue(v), pushTrend(v, maxPoints), clearTrend(), setValueAndTrend(v, maxPoints)
// kpi.pushTrend(41); kpi.severity
```

## Notes

Dashboard metric tile: title, value, unit, signed delta, optional Fluent symbol and sparkline.
Value thresholds drive severity/valueColor; pushTrend appends spark points; badgeText for status chip.
Delta color uses Theme success/critical (invertDeltaColors when lower is better).
Layout.fillWidth defaults to true inside Column/Row/Grid layouts.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `value` | `real` | Current value |
| `valuePrecision` | `int` | Digits after decimal for value text |
| `unit` | `string` | Value unit label |
| `caption` | `string` | Caption under the value row |
| `footer` | `string` | Footer line under the spark |
| `delta` | `real` | Signed change vs previous period (NaN to hide) |
| `deltaUnit` | `string` | Suffix for delta text (e.g. "%") |
| `deltaPrecision` | `int` | Digits after decimal for delta |
| `invertDeltaColors` | `bool` | When true, negative delta is success (lower-is-better metrics) |
| `trendValues` | `var` | Optional sparkline values (number[]) |
| `showTrend` | `bool` | Show sparkline when trendValues has 2+ points |
| `cautionThreshold` | `real` | Absolute caution threshold on value (-1 disables) |
| `criticalThreshold` | `real` | Absolute critical threshold on value (-1 disables) |
| `invertThresholds` | `bool` | When true, low values map to caution/critical |
| `badgeText` | `string` | Badge chip text (empty to hide) |
| `badgeSeverity` | `int` | Badge severity override: -1 = follow value severity, else 0/1/2 |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `accentColor` | `color` | Primary accent for spark / emphasis |
| `bordered` | `bool` | Draw card border |
| `elevated` | `bool` | Stronger elevation tint |
| `animateValue` | `bool` | Animate value text changes |
| `isInteractive` | `bool` | Alias of interactive |
| `interactive` | `alias` | Enable hover / click interaction |
| `pressed` | `bool` | Pressed visual state |
| `effectiveIconGlyph` | `string` | — |
| `animatedValue` | `real` | Animated display value |
| `formattedValue` | `string` | — |
| `hasDelta` | `bool` | — |
| `deltaPositive` | `bool` | — |
| `deltaColor` | `color` | — |
| `formattedDelta` | `string` | — |
| `severity` | `int` | 0 = ok, 1 = caution, 2 = critical (from absolute value thresholds) |
| `valueColor` | `color` | — |
| `effectiveBadgeSeverity` | `int` | — |
| `badgeColor` | `color` | — |
| `hasTrend` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `clicked()` | Emitted when the tile is activated |

### Methods

| Signature | Description |
| --- | --- |
| `setValue(v)` | Set value |
| `pushTrend(v, maxPoints)` | Append a sparkline point (keeps at most maxPoints) |
| `clearTrend()` | Clear sparkline |
| `setValueAndTrend(v, maxPoints)` | Set value and append to trend in one call |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
