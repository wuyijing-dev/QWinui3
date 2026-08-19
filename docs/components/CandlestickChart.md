# CandlestickChart

OHLC candlesticks for professional price series.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CandlestickChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CandlestickChart.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `CandlestickChart` — [`src/gallery/pages/CandlestickChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CandlestickChartPage.qml)

**Extends** `Control`.

## Example

```qml
CandlestickChart {
    candles: [
        { o: 100, h: 112, l: 96, c: 108 },
        { o: 108, h: 110, l: 101, c: 103 }
    ]
}
```

## Notes

Experimental Canvas OHLC. Not part of the stable six. ChartSeries is Y-only — pass objects.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `candles` | `var` | OHLC objects { o, h, l, c, label? } |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | — |
| `interactive` | `bool` | — |
| `isInteractive` | `alias` | — |
| `hoverIndex` | `int` | — |
| `upColor` | `color` | — |
| `downColor` | `color` | — |
| `showVolume` | `bool` | Draw volume bars when candles include v or volume |
| `isEmpty` | `bool` | — |

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
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
