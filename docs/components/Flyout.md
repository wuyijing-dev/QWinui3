# Flyout

Light-dismiss popup anchored to a target.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Flyout.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Flyout.qml)

**Category:** Dialogs & flyouts · **Library:** v1.01

[← Component index](../components.md)

**Gallery:** `Flyout` — [`src/gallery/pages/FlyoutPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FlyoutPage.qml)

**Extends** `Popup`.

## Example

```qml
Flyout {
    id: flyout
    target: button
    Label { text: qsTr("Details") }
}

// --- API ---
// methods: showAt(item, place), show(), hide(), reposition()
// flyout.showAt(item, place)
// flyout.show()
// flyout.hide()
// flyout.reposition()
// inherits Popup (+ Qt Quick Controls base API)
```

## Notes

Light-dismiss Popup anchored to target (preferredPlacement / placement).
Call show() / showAt(item, place) / hide(); reposition() after layout changes.
Put body as children; optional title / subtitle chrome.
showMode: standard | transient | transientWithDismissOnPointerMoveAway (WinUI ShowMode).
shouldConstrainToRootBounds clamps to overlay / parent (default true).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `placement` | `int` | Popup / flyout placement |
| `preferredPlacement` | `alias` | Preferred flyout placement |
| `target` | `Item` | Anchor item for placement |
| `isLightDismissEnabled` | `bool` | Close on outside click / Esc |
| `isOpen` | `bool` | Open / visible state |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle under title |
| `showMode` | `string` | WinUI ShowMode: standard \| transient \| transientWithDismissOnPointerMoveAway |
| `shouldConstrainToRootBounds` | `bool` | WinUI ShouldConstrainToRootBounds — clamp to overlay / parent |
| `contentData` | `alias` | Default children / content slot |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `showAt(item, place)` | Show anchored at the given point or item |
| `show()` | Show the control |
| `hide()` | Hide the control |
| `reposition()` | Reposition the popup / flyout |

### Inherited from `Popup`

Also available (base type / Qt Quick Controls):

- `open()` / `close()`
- `opened()` / `closed()`
- `modal` / `focus`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
