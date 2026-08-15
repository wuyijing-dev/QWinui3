# AppBarButton

CommandBar icon button with label position overrides.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AppBarButton.qml`](../../src/extras/QWinUI3/Extras/AppBarButton.qml)

[← Component index](../components.md)

**Extends** `IconicButton`.

## Example

```qml
AppBarButton {
    text: qsTr("Add")
    symbol: FluentIcons.Add
}
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `labelPosition` | `string` | Override CommandBar.defaultLabelPosition when set (bottom \| right \| collapsed) |
| `effectiveLabelPosition` | `string` | Resolved label position |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
