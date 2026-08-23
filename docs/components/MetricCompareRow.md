# MetricCompareRow

Side-by-side KpiTile row with a shared period caption (2.65).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MetricCompareRow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MetricCompareRow.qml)

**Category:** Other · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
MetricCompareRow {
    periodLabel: qsTr("vs last week")
    KpiTile { title: qsTr("Revenue"); value: 128; compareValue: 110 }
    KpiTile { title: qsTr("Orders"); value: 42; compareValue: 40 }
}
```

## Notes

Compose host for dashboard KPI compare strips. Put KpiTile (or any Item) as children.
periodLabel draws once above the row; tiles keep their own compareValue / delta.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `periodLabel` | `string` | Shared period caption above the KPI row |
| `tileSpacing` | `real` | Horizontal spacing between tiles |
| `content` | `alias` | Children (typically KpiTile) |

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
