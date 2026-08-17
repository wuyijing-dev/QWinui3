# SwipeControl

Swipe-to-reveal actions on content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SwipeControl.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SwipeControl.qml)

**Category:** Other · **Library:** v1.53

[← Component index](../components.md)

**Gallery:** `SwipeControl` — [`src/gallery/pages/SwipeControlPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SwipeControlPage.qml)

**Extends** `Control`.

## Example

```qml
SwipeControl {
    id: swipeControl
    SwipeAction { text: qsTr("Delete") }
    ListTile { title: qsTr("Row") }
}

// --- API ---
// signals: onOpened, onClosed
// methods: close(), openLeft(), openRight()
// swipeControl.close()
// swipeControl.openLeft()
// swipeControl.openRight()
```

## Notes

Content + left/right SwipeAction reveal; openLeft/openRight/close.
swipeMode: reveal | execute (WinUI SwipeMode).
Action rows are clipped to the revealed strip so they stay hidden when closed.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `modeClosed` | `int` | Open-mode constants (not named "closed" — that name is the signal below) |
| `leftOpen` | `int` | Left actions revealed |
| `rightOpen` | `int` | Right actions revealed |
| `content` | `alias` | Content slot / children host |
| `leftActions` | `alias` | Actions on the left |
| `rightActions` | `alias` | Actions on the right |
| `actionWidth` | `real` | Width of each swipe action |
| `revealThreshold` | `real` | Drag distance to snap open |
| `isOpen` | `bool` | Open / visible state |
| `openMode` | `int` | modeClosed \| leftOpen \| rightOpen |
| `swipeMode` | `string` | WinUI SwipeMode: reveal \| execute |
| `maxLeftReveal` | `real` | Max left swipe reveal width |
| `maxRightReveal` | `real` | Max right swipe reveal width |

### Signals

| Signature | Description |
| --- | --- |
| `opened(int mode)` | Emitted when opened |
| `closed()` | Swipe content closed |

### Methods

| Signature | Description |
| --- | --- |
| `close()` | Close / dismiss |
| `openLeft()` | Reveal left swipe actions |
| `openRight()` | Reveal right swipe actions |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
