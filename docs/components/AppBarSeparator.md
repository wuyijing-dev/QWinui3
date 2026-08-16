# AppBarSeparator

Thin separator for CommandBar / AppBar rows.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AppBarSeparator.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AppBarSeparator.qml)

**Category:** Buttons & commands · **Library:** v1.18

[← Component index](../components.md)

**Gallery:** `AppBarSeparator` — [`src/gallery/pages/AppBarSeparatorPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AppBarSeparatorPage.qml)

**Extends** `Control`.

## Example

```qml
CommandBar {
    AppBarButton { text: qsTr("Add"); symbol: FluentIcons.Add }
    AppBarSeparator { }
    AppBarButton { text: qsTr("Share"); symbol: FluentIcons.Share }
}
```

## Notes

Thin vertical/horizontal separator between AppBarButton items.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `thickness` | `real` | Donut ring thickness |
| `separatorColor` | `color` | Separator color |
| `margin` | `real` | Outer margin |

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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
