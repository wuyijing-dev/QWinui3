# AppBarButton

CommandBar icon button with label position overrides.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AppBarButton.qml`](../../src/extras/QWinUI3/Extras/AppBarButton.qml)

[← Component index](../components.md)

## Usage

```qml
AppBarButton {
    text: qsTr("Add")
    symbol: FluentIcons.Add
}
```

## Properties

- `labelPosition: string` — Override CommandBar.defaultLabelPosition when set (bottom | right | collapsed)
- `effectiveLabelPosition: string` — Resolved label position

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
