# DumbbellChart

Before/after pairs on a shared category axis.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DumbbellChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DumbbellChart.qml)

**Category:** Charts & gauges · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `DumbbellChart` — [`src/gallery/pages/DumbbellChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DumbbellChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
DumbbellChart {
    pairs: [
        { label: qsTr("East"), from: 42, to: 58 },
        { label: qsTr("West"), from: 31, to: 29 }
    ]
}
```

## Notes

Experimental. Prefer BarChart.series grouped columns for more than two states.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `pairs` | `var` | — |
| `title` | `string` | — |
| `emptyText` | `string` | — |
| `fromName` | `string` | — |
| `toName` | `string` | — |
| `fromColor` | `color` | — |
| `toColor` | `color` | — |
| `interactive` | `bool` | — |
| `isInteractive` | `alias` | — |
| `hoverIndex` | `int` | — |
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
