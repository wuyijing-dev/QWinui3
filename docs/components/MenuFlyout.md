# MenuFlyout

Elevated Menu with showAt / isOpen helpers.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuFlyout.qml`](../../src/extras/QWinUI3/Extras/MenuFlyout.qml)

[← Component index](../components.md)

## Usage

```qml
MenuFlyout {
    MenuFlyoutItem { text: qsTr("Copy"); symbol: FluentIcons.Copy }
}
```

## Properties

- `placement: int` — Popup / flyout placement
- `preferredPlacement: alias` — Preferred flyout placement
- `isLightDismissEnabled: bool` — Close on outside click / Esc
- `isOpen: bool` — Open / visible state
- `title: string` — Primary title text

## Methods

- `openMenu()` — Open the menu
- `closeMenu()` — Dismiss the menu
- `showAt(targetItem, offsetX, offsetY)` — Show anchored at the given point or item
- `hide()` — Hide the control

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
