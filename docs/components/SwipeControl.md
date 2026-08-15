# SwipeControl

Swipe-to-reveal actions on content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SwipeControl.qml`](../../src/extras/QWinUI3/Extras/SwipeControl.qml)

[← Component index](../components.md)

## Usage

```qml
SwipeControl {
    SwipeAction { text: qsTr("Delete") }
    ListTile { title: qsTr("Row") }
}
```

## Properties

- `closed: int` — Swipe content closed
- `leftOpen: int` — Left actions revealed
- `rightOpen: int` — Right actions revealed
- `content: alias` — Content slot / children host
- `leftActions: alias` — Actions on the left
- `rightActions: alias` — Actions on the right
- `actionWidth: real` — Width of each swipe action
- `revealThreshold: real` — Drag distance to snap open
- `isOpen: bool` — Open / visible state
- `openMode: int` — single | multiple reveal mode
- `maxLeftReveal: real` — Max Left Reveal
- `maxRightReveal: real` — Max Right Reveal

## Signals

- `opened(int mode)` — Emitted when opened
- `closed()` — Swipe content closed

## Methods

- `close()` — Close
- `openLeft()` — Open Left
- `openRight()` — Open Right

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
