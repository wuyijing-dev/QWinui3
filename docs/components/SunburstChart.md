# SunburstChart

Two-level nested rings.

`import QWinUI3.Extras.Charts` · [`src/extras/QWinUI3/Extras/SunburstChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SunburstChart.qml)

**Category:** Charts & gauges · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `SunburstChart` — [`src/gallery/pages/SunburstChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SunburstChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

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

| Signature | Description |
| --- | --- |
| `requestRedraw()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
