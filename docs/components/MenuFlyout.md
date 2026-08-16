# MenuFlyout

Elevated Menu with showAt / isOpen helpers.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuFlyout.qml`](../../src/extras/QWinUI3/Extras/MenuFlyout.qml)

[← Component index](../components.md)

**Extends** `Menu`.

## Example

```qml
MenuFlyout {
    id: menuFlyout
    MenuFlyoutItem { text: qsTr("Copy"); symbol: FluentIcons.Copy }
}

// --- API ---
// methods: openMenu(), closeMenu(), showAt(targetItem, offsetX, offsetY), hide()
// menuFlyout.openMenu()
// menuFlyout.closeMenu()
// menuFlyout.showAt(targetItem, offsetX, offsetY)
// menuFlyout.hide()
// inherits Menu (+ Qt Quick Controls base API)
```

## Notes

Menu-styled Flyout; host MenuFlyoutItem / Separator / Header children.
contentMaxHeight (WinUI MenuFlyoutPresenter.MaxHeight) enables scroll when content is taller.
shouldConstrainToRootBounds clamps into the window overlay (default true).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `placement` | `int` | Popup / flyout placement |
| `preferredPlacement` | `alias` | Preferred flyout placement |
| `isLightDismissEnabled` | `bool` | Close on outside click / Esc |
| `isOpen` | `bool` | Open / visible state |
| `title` | `string` | Inherited from `Menu` (FINAL) — Accessible name |
| `contentMaxHeight` | `real` | WinUI MaxHeight clamp (not Popup.maxHeight) |
| `shouldConstrainToRootBounds` | `bool` | WinUI ShouldConstrainToRootBounds — clamp popup into window overlay |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `openMenu()` | Open the menu |
| `closeMenu()` | Dismiss the menu |
| `showAt(targetItem, offsetX, offsetY)` | Show anchored at the given point or item |
| `hide()` | Hide the control |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
