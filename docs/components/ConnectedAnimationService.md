# ConnectedAnimationService

Register shared-element keys and play list→detail morphs.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ConnectedAnimationService.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ConnectedAnimationService.qml)

**Category:** Media & platform · **Library:** v2.58

[← Component index](../components.md)

**Extends** `QtObject`.

## Example

```qml
ConnectedAnimationService.register("mail.hero", rowThumb)
ConnectedAnimationService.register("mail.hero", detailHero)
ConnectedAnimationService.play("mail.hero", function () { stack.push(detail) })

// --- API ---
// register(key, item), unregister(key, item?), play(key, onFinished?),
// playBetween(fromItem, toItem, onFinished?), clear()
```

## Notes

Uses a single ConnectedAnimation ghost parented to Overlay.overlay.
Same key may be registered twice (from + to); play() morphs first→last.

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `register(key, item)` | — |
| `unregister(key, item)` | — |
| `clear()` | — |
| `play(key, onFinished)` | — |
| `playBetween(fromItem, toItem, onFinished)` | — |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
