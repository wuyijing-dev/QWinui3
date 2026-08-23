# CommandBarFlyout

Popup CommandBar with primary + secondary commands.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandBarFlyout.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CommandBarFlyout.qml)

**Category:** Buttons & commands · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `CommandBarFlyout` — [`src/gallery/pages/CommandBarFlyoutPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CommandBarFlyoutPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Popup`.

## Example

```qml
CommandBarFlyout {
    id: commandBarFlyout
    AppBarButton { text: qsTr("Share") }
}

// --- API ---
// methods: showAt(item, preferredPlacement), show(), hide(), openFlyout(), closeFlyout(), reposition()
// commandBarFlyout.showAt(item, preferredPlacement)
// commandBarFlyout.show()
// commandBarFlyout.hide()
// commandBarFlyout.openFlyout()
// inherits Popup (+ Qt Quick Controls base API)
```

## Notes

Popup CommandBar; open at a target like Flyout.
showAt() opens then repositions after layout — first open must not use 0×0 size
(that clamped ShouldConstrainToRootBounds to the top-left).
On close, focus returns to the opener or target (1.85).

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
| `reposition()` | Reposition against target using current laid-out size |

### Inherited from `Popup`

Also available (base type / Qt Quick Controls):

- `open()` / `close()`
- `opened()` / `closed()`
- `modal` / `focus`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
