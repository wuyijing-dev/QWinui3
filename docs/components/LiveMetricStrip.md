# LiveMetricStrip

Throttled live KPI row with ring buffers + compare-period (3.05 G1).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LiveMetricStrip.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/LiveMetricStrip.qml)

**Category:** Status & feedback · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
LiveMetricStrip {
    id: live
    intervalMs: 1200
    running: true
    maxPoints: 16
    compareLag: 8
    periodLabel: qsTr("vs prior window")
    metrics: [
        { key: "cpu", title: qsTr("CPU"), unit: "%",
          cautionThreshold: 75, criticalThreshold: 90, symbol: FluentIcons.Sync }
    ]
    onTick: {
        live.pushSample("cpu", measuredCpu)
    }
}

// --- API ---
// signals: tick(), samplePushed(string key, real value)
// methods: pushSample(key, value), pushSamples(map), clearBuffers(),
//          start(), stop(), tickOnce(), tileForKey(key)
```

## Notes

Owns a throttle Timer so apps do not hand-roll per-tile refresh.
Each metric key keeps a ring buffer (maxPoints). compareValue is the sample
compareLag steps back (or the oldest point). autoDeltaPercent sets delta vs compare.
Prefer this over MetricCompareRow + ad-hoc Timer for ops / real-time dashboards (FL-014).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `periodLabel` | `string` | Shared period caption above the KPI row |
| `tileSpacing` | `real` | Horizontal spacing between tiles |
| `intervalMs` | `int` | Throttle interval for onTick (ms). Floor 250 to avoid busy loops. |
| `running` | `bool` | When true, internal Timer emits tick() |
| `maxPoints` | `int` | Ring buffer capacity per metric |
| `compareLag` | `int` | Samples back used for compareValue (1 = previous sample) |
| `autoDeltaPercent` | `bool` | When true, delta = percent change vs compareValue |
| `deltaPrecision` | `int` | Digits for auto delta |
| `liveBadgeText` | `string` | Apply badgeText "LIVE" when running (empty string to skip) |
| `metrics` | `var` | Metric definitions: [{ key, title, unit?, valuePrecision?, …KpiTile props }] |
| `lastTickMs` | `real` | Last tick wall time (ms since epoch); 0 before first tick |
| `sampleCount` | `int` | Diagnostic: total pushSample calls this session |
| `metricCount` | `int` | — |
| `isLive` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `tick()` | Fired on each throttle interval (and tickOnce) |
| `samplePushed(string key, real value)` | Fired after a successful pushSample |

### Methods

| Signature | Description |
| --- | --- |
| `start()` | — |
| `stop()` | — |
| `tickOnce()` | — |
| `clearBuffers()` | — |
| `tileForKey(key)` | — |
| `pushSample(key, value)` | Push one sample for a metric key — updates value, trend, compare, delta |
| `pushSamples(map)` | Push many samples: { key: value, … } |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
