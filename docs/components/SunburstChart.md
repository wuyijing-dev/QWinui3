# SunburstChart

Two-level nested rings.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SunburstChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SunburstChart.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `SunburstChart` — [`src/gallery/pages/SunburstChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SunburstChartPage.qml)

**Extends** `Control`.

## Example

```qml
SunburstChart {
    slices: [
        { label: qsTr("Apps"), value: 40, children: [
            { label: qsTr("Photo"), value: 24 },
            { label: qsTr("Mail"), value: 16 }
        ]},
        { label: qsTr("System"), value: 20 }
    ]
}
```

## Notes

Experimental two-level sunburst. Prefer DonutChart for a single ring.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `slices` | `var` | — |
| `title` | `string` | — |
| `emptyText` | `string` | — |
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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
