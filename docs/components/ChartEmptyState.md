# ChartEmptyState

Fluent empty / loading / error placeholder for ChartCard (2.65).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartEmptyState.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ChartEmptyState.qml)

**Category:** Status & feedback · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
ChartCard {
    title: qsTr("Revenue")
    ChartEmptyState {
        state: "empty"
        title: qsTr("No data yet")
        message: qsTr("Connect a source or widen the date range.")
        actionText: qsTr("Refresh")
        onActionClicked: reload()
    }
}
```

## Notes

state: "empty" | "loading" | "error". Optional actionText emits actionClicked.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `state` | `string` | Visual mode: empty \| loading \| error |
| `title` | `string` | Primary title |
| `message` | `string` | Supporting message |
| `actionText` | `string` | Optional action button label (hidden when empty) |
| `symbol` | `var` | FluentIcons symbol override (empty → default per state) |

### Signals

| Signature | Description |
| --- | --- |
| `actionClicked()` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
