# DashboardShell

Minimal dashboard layout host (2.52 preview; chart grid + filter rail in 2.65).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DashboardShell.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DashboardShell.qml)

**Category:** Shells & windows · **Library:** v2.54

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
DashboardShell {
    title: qsTr("Ops")
    subtitle: qsTr("Last 24h")
    kpiRow: RowLayout {
        KpiTile { title: qsTr("Users"); value: 1284 }
    }
    ContentCard { title: qsTr("Details") }
}
```

## Notes

Opinionated column: optional title block, KPI row slot, default body (charts/cards).
Experimental until 2.65 deepens grid + TwoPaneView filter rail — docs/first-app-252.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | — |
| `subtitle` | `string` | — |
| `kpiRow` | `alias` | — |
| `content` | `alias` | — |

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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
