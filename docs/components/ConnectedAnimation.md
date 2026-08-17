# ConnectedAnimation

Shared-element style morph between two items (same window).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ConnectedAnimation.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ConnectedAnimation.qml)

**Category:** Media & platform · **Library:** v2.56

[← Component index](../components.md)

**Gallery:** `ConnectedAnimation` — [`src/gallery/pages/ConnectedAnimationPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ConnectedAnimationPage.qml)

**Extends** `Item`.

## Example

```qml
ConnectedAnimation {
    id: anim
    from: card
    to: detailHero
    onFinished: stack.push(detailPage)
}
anim.play()

// Or via key registry (list → detail):
ConnectedAnimationService.register("hero", listThumb)
ConnectedAnimationService.register("hero", detailHero)
ConnectedAnimationService.play("hero", () => stack.push(page))
```

## Notes

Animates a floating clone from `from` geometry to `to`. Honors Theme.reducedMotion.
Optional coordinateKey auto-registers with ConnectedAnimationService.
setSourceItem() can tint the ghost from a source item's size hint.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `from` | `Item` | — |
| `to` | `Item` | — |
| `coordinateKey` | `string` | — |
| `duration` | `int` | — |
| `running` | `bool` | — |
| `ghostColor` | `color` | — |

### Signals

| Signature | Description |
| --- | --- |
| `finished()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `play()` | — |
| `playBetween(fromItem, toItem)` | — |
| `prepare()` | — |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
