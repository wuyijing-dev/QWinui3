# CommandBarFlyout

Popup CommandBar with primary + secondary commands.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandBarFlyout.qml`](../../src/extras/QWinUI3/Extras/CommandBarFlyout.qml)

[← Component index](../components.md)

**Extends** `Popup`.

## Example

```qml
CommandBarFlyout {
    id: commandBarFlyout
    AppBarButton { text: qsTr("Share") }
}

// --- API ---
// methods: showAt(item, preferredPlacement), show(), hide(), openFlyout(), closeFlyout()
// commandBarFlyout.showAt(item, preferredPlacement)
// commandBarFlyout.show()
// commandBarFlyout.hide()
// commandBarFlyout.openFlyout()
// inherits Popup (+ Qt Quick Controls base API)
```

## Notes

Popup CommandBar; open at a target like Flyout.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `primaryCommands` | `alias` | Primary command host |
| `secondaryCommands` | `alias` | Secondary command host |
| `primaryData` | `alias` | Primary commands slot |
| `secondaryData` | `alias` | Secondary commands slot |
| `isOpen` | `bool` | Open / visible state |
| `isLightDismissEnabled` | `bool` | Close on outside click / Esc |
| `target` | `Item` | Anchor item for placement |
| `placement` | `int` | Popup / flyout placement |
| `preferredPlacement` | `alias` | Preferred flyout placement |
| `shouldConstrainToRootBounds` | `bool` | WinUI ShouldConstrainToRootBounds — clamp into overlay when true |
| `showSecondary` | `bool` | Show secondary command list |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `showAt(item, preferredPlacement)` | Show anchored at the given point or item |
| `show()` | Show the control |
| `hide()` | Hide the control |
| `openFlyout()` | Open the flyout |
| `closeFlyout()` | Dismiss the flyout |

### Inherited from `Popup`

Also available (base type / Qt Quick Controls):

- `open()` / `close()`
- `opened()` / `closed()`
- `modal` / `focus`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
