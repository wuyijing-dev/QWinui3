# DashboardShell

Opinionated dashboard layout host (2.65 Wave A).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DashboardShell.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DashboardShell.qml)

**Category:** Shells & windows · **Library:** v2.65

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
DashboardShell {
    title: qsTr("Ops")
    subtitle: qsTr("Last 24h")
    filterPane: ColumnLayout {
        ComboBox { model: [qsTr("Last 24h"), qsTr("Last 7d")] }
    }
    kpiRow: MetricCompareRow {
        periodLabel: qsTr("vs last week")
        KpiTile { title: qsTr("Users"); value: 1284; compareValue: 1200 }
    }
    ChartCard { title: qsTr("Trend"); LineChart { values: series } }
}
```

## Notes

Title + KPI strip + body. Optional filterPane uses TwoPaneView (≥ filterBreakpoint
wide; otherwise SinglePane shows body — toggle filter via TwoPaneView APIs).
chartColumns is a layout hint for GridLayout children. Not the withdrawn Hub.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Page title |
| `subtitle` | `string` | Supporting subtitle |
| `kpiRow` | `alias` | KPI strip (MetricCompareRow / RowLayout of KpiTile) |
| `filterPane` | `alias` | Optional filter rail (TwoPaneView pane1) |
| `content` | `alias` | Chart / card body |
| `chartBreakpoint` | `int` | Hint for GridLayout columns in demos |
| `chartColumns` | `int` | — |
| `filterBreakpoint` | `int` | Wide mode threshold for filter \| body |
| `filterPaneWidth` | `real` | Preferred filter rail width when wide |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
