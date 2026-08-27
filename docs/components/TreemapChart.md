# TreemapChart

Nested slice-and-dice treemap.

`import QWinUI3.Extras.Charts` · [`src/extras/QWinUI3/Extras/TreemapChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TreemapChart.qml)

**Category:** Charts & gauges · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `TreemapChart` — [`src/gallery/pages/TreemapChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TreemapChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
TreemapChart {
    slices: [
        { value: 42, label: qsTr("Apps") },
        { value: 18, label: qsTr("Media") }
    ]
}
```

## Notes

Experimental. ChartUtils.treemapRects. Prefer DonutChart for part-to-whole.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `slices` | `var` | — |
| `values` | `var` | — |
| `title` | `string` | — |
| `emptyText` | `string` | — |
| `interactive` | `bool` | — |
| `isInteractive` | `alias` | — |
| `hoverIndex` | `int` | — |
| `isEmpty` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `sliceClicked(int index, real value)` | — |

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
