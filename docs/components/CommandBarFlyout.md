# CommandBarFlyout

Popup CommandBar with primary + secondary commands.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandBarFlyout.qml`](../../src/extras/QWinUI3/Extras/CommandBarFlyout.qml)

[← Component index](../components.md)

## Usage

```qml
CommandBarFlyout {
    AppBarButton { text: qsTr("Share") }
}
```

## Properties

- `primaryCommands: alias` — Primary command host
- `secondaryCommands: alias` — Secondary command host
- `primaryData: alias` — Primary commands slot
- `secondaryData: alias` — Secondary commands slot
- `isOpen: bool` — Open / visible state
- `isLightDismissEnabled: bool` — Close on outside click / Esc
- `target: Item` — Anchor item for placement
- `placement: int` — Popup / flyout placement
- `preferredPlacement: alias` — Preferred flyout placement
- `showSecondary: bool` — Show secondary command list

## Methods

- `showAt(item, preferredPlacement)` — Show anchored at the given point or item
- `show()` — Show the control
- `hide()` — Hide the control
- `openFlyout()` — Open the flyout
- `closeFlyout()` — Dismiss the flyout

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
