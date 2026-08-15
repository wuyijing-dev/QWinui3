# Flyout

Light-dismiss popup anchored to a target.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Flyout.qml`](../../src/extras/QWinUI3/Extras/Flyout.qml)

[← Component index](../components.md)

## Usage

```qml
Flyout {
    target: button
    Label { text: qsTr("Details") }
}
```

## Properties

- `placement: int` — Popup / flyout placement
- `preferredPlacement: alias` — Preferred flyout placement
- `target: Item` — Anchor item for placement
- `isLightDismissEnabled: bool` — Close on outside click / Esc
- `isOpen: bool` — Open / visible state
- `title: string` — Primary title text
- `contentData: alias` — Default children / content slot

## Methods

- `showAt(item, place)` — Show At
- `show()` — Show
- `hide()` — Hide
- `reposition()` — Reposition

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
