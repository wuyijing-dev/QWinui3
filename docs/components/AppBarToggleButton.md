# AppBarToggleButton

Checkable AppBarButton for CommandBar.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AppBarToggleButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AppBarToggleButton.qml)

**Category:** Buttons & commands · **Library:** v1.00

[← Component index](../components.md)

**Gallery:** `AppBarToggleButton` — [`src/gallery/pages/AppBarToggleButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AppBarToggleButtonPage.qml)

**Extends** `IconicButton`.

## Example

```qml
AppBarToggleButton {
    text: qsTr("Pin")
    checkable: true
}
```

## Notes

Checkable AppBarButton for CommandBar toggles.
isCompact + keyboardAcceleratorText mirror AppBarButton.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `labelPosition` | `string` | bottom \| right \| collapsed |
| `barLabelPosition` | `string` | Injected by CommandBar (do not parent-walk) |
| `barCompact` | `bool` | Injected by CommandBar.compact — denser icon-only sizing |
| `isCompact` | `bool` | WinUI IsCompact — hide label, icon-only |
| `keyboardAcceleratorText` | `string` | Shortcut hint (WinUI KeyboardAcceleratorText) |
| `effectiveLabelPosition` | `string` | Resolved label position |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
