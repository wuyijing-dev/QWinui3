# StatusBar

Window status strip with progress and slots.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StatusBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/StatusBar.qml)

**Category:** Status & feedback · **Library:** v2.63

[← Component index](../components.md)

**Gallery:** `StatusBar` — [`src/gallery/pages/StatusBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/StatusBarPage.qml)

**Extends** `Control`.

## Example

```qml
StatusBar {
    text: qsTr("Ready")
    progress: 0.4
}
```

## Notes

Multi-segment status strip for MenuStatusWindow / shells.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `text` | `string` | Display / input text |
| `leftContent` | `alias` | Leading content slot |
| `centerContent` | `alias` | Center content slot |
| `content` | `alias` | Content slot / children host |
| `rightContent` | `alias` | Trailing content slot |
| `progress` | `real` | 0..1 shows determinate bar; <0 hides; NaN-safe. Set indeterminate for busy. |
| `progressIndeterminate` | `bool` | Show indeterminate progress |

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
