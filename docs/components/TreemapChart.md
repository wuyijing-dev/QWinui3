# TreemapChart

Nested slice-and-dice treemap.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TreemapChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TreemapChart.qml)

**Category:** Collections & data · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `TreemapChart` — [`src/gallery/pages/TreemapChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TreemapChartPage.qml)

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

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
