# FunnelChart

Conversion funnel from stage values.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FunnelChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FunnelChart.qml)

**Category:** Charts & gauges · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `FunnelChart` — [`src/gallery/pages/FunnelChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FunnelChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
FunnelChart {
    stages: [
        { value: 1200, label: qsTr("Visit") },
        { value: 480, label: qsTr("Signup") },
        { value: 96, label: qsTr("Paid") }
    ]
}
```

## Notes

Experimental Canvas funnel. Prefer DonutChart for part-to-whole without stages.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `stages` | `var` | Stage descriptors { value, label?, color? } |
| `values` | `var` | Convenience numeric values |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | — |
| `interactive` | `bool` | — |
| `isInteractive` | `alias` | — |
| `hoverIndex` | `int` | — |
| `valueUnit` | `string` | — |
| `unit` | `alias` | — |
| `isEmpty` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `stageClicked(int index, real value)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
