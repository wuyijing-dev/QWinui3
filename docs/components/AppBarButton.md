# AppBarButton

CommandBar icon button with label position overrides.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AppBarButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AppBarButton.qml)

**Category:** Buttons & commands · **Library:** v1.11

[← Component index](../components.md)

**Gallery:** `AppBarButton` — [`src/gallery/pages/AppBarButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AppBarButtonPage.qml)

**Extends** `IconicButton`.

## Example

```qml
AppBarButton {
    text: qsTr("Add")
    symbol: FluentIcons.Add
}
```

## Notes

CommandBar icon+label button; symbol / labelPosition for layout.
isCompact collapses the label (WinUI IsCompact); keyboardAcceleratorText shows a shortcut hint.
barCompact (from CommandBar.compact) shrinks icon-only hit target toward ~40px (Edge-like).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `labelPosition` | `string` | Override CommandBar label position when set (bottom \| right \| collapsed) |
| `barLabelPosition` | `string` | Injected by CommandBar (do not parent-walk) |
| `barCompact` | `bool` | Injected by CommandBar.compact — denser icon-only sizing |
| `isCompact` | `bool` | WinUI IsCompact — hide label, icon-only |
| `keyboardAcceleratorText` | `string` | Shortcut hint shown under/beside the label (WinUI KeyboardAcceleratorText) |
| `effectiveLabelPosition` | `string` | Resolved label position |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
